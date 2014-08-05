@importedCollections = new Meteor.Collection('importedCollections')

if Meteor.isClient

  createCollectionFromImport = (collection) ->
    Collections.create collection.collection
    for item in collection.data
      data = {}
      item.collection = collection.collection
      Collections[collection.collection].insert(item)
    console.log "IMPORT: imported #{collection.data.length} items from #{collection.source}"
	
  handle = importedCollections.find({})
  handle.observe
    added: (collection) ->
      createCollectionFromImport(collection)



if Meteor.isServer
	Fibers = Npm.require('fibers');
	fs = Npm.require 'fs'
	csvtojson = Npm.require 'csvtojson'
	YAML = Npm.require 'yamljs'


	Meteor.startup ->
		importedCollections.remove({})
		fs.exists '../client/app/data', (exists) ->
			if exists
				filenames = fs.readdirSync '../client/app/data'
				console.log "Preparing for import by client: " + filenames
				for filename in filenames
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
		fs.createReadStream("../client/app/data/" + filename.full).pipe csvConverter



	importYAML = (filename) ->
		Fibers(->
			jsonObjectWithKeys = YAML.load "../client/app/data/" + filename.full
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