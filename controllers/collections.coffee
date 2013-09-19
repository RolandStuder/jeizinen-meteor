# Supercollection Collection will eat anything...
# warning will only work within templates...

# COLLECTION CONTROLLER


@Collections = new Meteor.Collection("Collection")

Collections.create = (name) ->
  newCollection = {}
  if name
    unless Collections[name]  
      newCollection[name] = new Meteor.Collection(null)  unless Collections[name]
      _.extend Collections, newCollection
      console.log "created: " + name

Collections.insert = (collection, data, amount) -> # use custom insert so mock helper, knows which collection the item belongs to
  Collections.create collection  unless Collections[collection]
  amount = 1 unless amount
  data["collection"] = collection
  data["createdAt"] = new Date().getTime()
  for i in [1..amount]
    insertData = Collections.execObjectFunctions(data)
    Collections[collection].insert insertData

Collections.initialize = (name,amount,context) ->
  amount = 1 unless amount
  if name
    Collections.create name
    if Collections[name].find().count() is 0
      Collections.insert name, {context: context}, amount
    if Collections[name].find({'context._id': context._id}).count() is 0
      Collections.insert name, {context: context}, amount 

Collections.updateDoc = (document,form) ->
  inputs = $(form).find("input[name]")
  data = {}
  Collections.create document.collection
  collection = Collections[document.collection]
  inputs.each () ->
    data[ $(this).attr("name") ] = $(this).val()
  if collection.findOne(document._id)
    collection.update document._id, $set: data
  # Session.set 'currentDocument', Collections[document.collection].findOne(document._id)

Collections.toggleBoolean = (document, field) ->
  data = {}
  if document[field] == true
    data[field] = false
  else 
    data[field] = true
  Collections[document.collection].update(document._id, $set: data)

Collections.createDoc = (form) ->
  inputs = $(form).find("input[name]")
  name = $(form).attr("data-collection")
  data = {collection: name}
  Collections.create name
  collection = Collections[name]
  inputs.each () ->
    data[ $(this).attr("name") ] = $(this).val()
  newDocument = Collections.insert name, data
  # Session.set 'currentDocument', Collections[name].findOne(newDocument)

# HELPER METHODS


Collections.execObjectFunctions = (obj) -> 
  returnObj = {}
  for key, value of obj
      if _.isFunction value
        value = eval("obj."+key+"()")
      returnObj[key] = value
  
  returnObj


# HANDLEBARS HELPERS



if Meteor.isClient
  Handlebars.registerHelper "collection", (options) ->
    name = options.hash['name']
    Collections.initialize name, options.hash['create'], this
    result = ""
    context = {_id: this._id}
    context = this._id
    console.log "count"
    if this._id
      Collections[name].find({'context._id': context}).forEach (item) ->
        result += options.fn(item)
    else 
      Collections[name].find({},sort: createdAt: -1).forEach (item) ->
        result += options.fn(item)
    result

  Handlebars.registerHelper "document", (options) ->
    currentDocument = Session.get('currentDocument')
    name = options.hash['collection']
    Collections.initialize options.hash['collection'],options.hash['create'], this
    if currentDocument
      if currentDocument.collection == name
        options.fn(currentDocument)
    else
      options.fn(Collections[name].findOne())

  Handlebars.registerHelper "field", (field, options) ->
    if @_id
      name = this.collection
      data = {}
      if this[field]
        data[field] = this[field]
      else if options.hash['random']
        data[field] = random(options.hash['random'],options.hash)
        Collections[name].update @_id,{$set: data}
      else if options.hash['pick'] 
        data[field] = pick options.hash['pick']
        Collections[name].update @_id,{$set: data}
      else
        data[field] = random(field)
        Collections[name].update @_id,{$set: data}
      data[field]

  Handlebars.registerHelper "count", (collection, field) -> #counts ocurrances in subcollection
    if Collections[collection]
      query = {}
      query[field] = true 
      query['context._id'] = this._id
      Collections[collection].find(query).count()
    else
      0




# enableClickActions = function() {
#   $('body').on('click', '[data-onClick-setTrue]', function(e){
#     _id = $(this).attr('data-id');
#     Collection['people'].update(_id, {$set: {isEdit: true}}) // problem seems to by, that add time of binding, these things are not defined

#     // console.log(this)
#     // replaceTemplate = $(this).attr('data-replace-with-template');
#     // id = $(this).attr('data-target');
#     // replaceTemplate = Template['people-edit']();
#     // selector = "#"+id.to_s;
#     // $(selector).replaceWith('test');
#   })
# }

# experimental

