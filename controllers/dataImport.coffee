@importedCollections = new Meteor.Collection('importedCollections')

if Meteor.isClient
  insertBulk = (collection, documents, collectionName) ->
    if collection
      _.compact _.map(documents, (item) ->
        if _.isObject(item)
          _id = collection._makeNewID()
          item.collection = collectionName

          # insert with reactivity only on the last item
          if _.last(documents) is item
            _id = collection.insert(item)

          # insert without reactivity
          else
            item._id = _id
            collection._collection._docs._map[_id] = item
          _id
      )

  createCollectionFromImport = (collection) ->
    Collections.create collection.collection
    insertBulk Collections[collection.collection], collection.data, collection.collection
    console.log "IMPORT: imported #{collection.data.length} items from #{collection.source}"

  handle = importedCollections.find({})
  handle.observe
    added: (collection) ->
      createCollectionFromImport(collection)
      console.log "import now"

if Meteor.isServer
	Fibers = Npm.require('fibers');
	fs = Npm.require 'fs'
	csvtojson = Npm.require 'csvtojson'
	YAML = Npm.require 'yamljs'

	dataFolder = process.env.PWD + '/public/data/'

	Meteor.startup ->
		importedCollections.remove({})
		fs.exists dataFolder, (exists) ->
			if exists
				console.log fs.readdirSync dataFolder
			if exists
				filenames = fs.readdirSync dataFolder
				console.log "Preparing for import by client: " + filenames
				for filename in filenames
					console.log filename
					do (filename) ->
						filename = splitFileName(filename)
						if filename.extension is "csv"
							importCSV filename
						else if filename.extension is "yaml" or filename.extension is "yml"
							importYAML filename
						else
							console.error "Filetype ." + filename.extension + " is not supported. Supported types: csv, yaml, yml"

	importCSV = (filename) ->
		csvConverter = new csvtojson.core.Converter()
		csvConverter.on "end_parsed", (jsonArray) ->
			Fibers(->
				importedCollections.insert({collection: filename.name, source: filename.full, data: jsonArray})
			).run()
		fs.createReadStream(dataFolder + filename.full).pipe csvConverter



	importYAML = (filename) ->
		Fibers(->
			jsonObjectWithKeys = YAML.load dataFolder + filename.full
			jsonArray = []
			for key of jsonObjectWithKeys
				item = jsonObjectWithKeys[key]
				item.importedKey = key
				jsonArray.push item
			importedCollections.insert({collection: filename.name, source: filename.full, data: jsonArray})

		).run()

splitFileName = (filename) ->
	#splits filename into name and extension
	result = {}
	result['name'] = filename.substr(0, filename.lastIndexOf('.')) || filename
	result['extension'] = filename.split('.').pop()
	result['full'] = filename
	return result
