# Supercollection Collection will eat anything...
# warning will only work within templates...

# COLLECTION CONTROLLER
@Collections = new Meteor.Collection("Collection")

# @newCollection = new Meteor.Collection('newCollection')
# newCollection.insert({description: "I don't get it!"})

# importing datasets from files


Collections.create = (name) ->
  newCollection = {}
  if name
    unless Collections[name]  
      newCollection[name] = new Meteor.Collection(null)  unless Collections[name]
      _.extend Collections, newCollection
      # console.log "created: " + name

Collections.insert = (collection, data, amount) -> # use custom insert so mock helper, knows which collection the item belongs to
  Collections.create collection unless Collections[collection]
  amount = 1 unless amount
  data["collection"] = collection
  data["createdAt"] = new Date().getTime()
  for i in [1..amount]
    insertData = Collections.execObjectFunctions(data)
    Collections[collection].insert insertData

Collections.initialize = (name,amount,context) ->
  amount = 0 unless amount
  if name
    Collections.create name
    if Collections[name].find().count() is 0
      Collections.insert name, {context: context}, amount
    # if Collections[name].find({'context._id': context._id}).count() is 0
    #   Collections.insert name, {context: context}, amount 

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


Collections.updateDoc = (document,form) ->
  data = getDataFromForm form
  if Collections[document.collection].findOne(document._id)
    Collections[document.collection].update document._id, $set: data
# Session.set 'currentDocument', Collections[document.collection].findOne(document._id)

getDataFromForm = (form) ->
  data = {}
  inputs = $(form).find("input[name]")
  inputs.each () ->
    data[ $(this).attr("name") ] = $(this).val()
  selects = $(form).find("select[name]")
  selects.each () ->
    data[$(this).attr("name")] = $(this).find(":selected").text()
  return data



Collections.toggleBoolean = (document, field) ->
  data = {}
  if document[field] is true
    data[field] = false
  else 
    data[field] = true
  Collections[document.collection].update(document._id, $set: data)

Collections.setAll = (collection, field, value, context) ->
  data = {}
  data[field] = value
  ids = []
  Collections[collection].find({'context._id': context._id}).forEach (item) ->
    ids.push(item._id)
  Collections[collection].update({_id: {$in: ids}}, $set: data, {multi:true});

Collections.setAllBoolean = (collection, field, value, context) ->
  data = {}
  if value is "true" then value = true else value = false 
  data[field] = value
  ids = []
  Collections[collection].find({'context._id': context._id}).forEach (item) ->
    ids.push(item._id)
  Collections[collection].update({_id: {$in: ids}}, $set: data, {multi:true});


Collections.delayedUpdate = (name,id,data) ->
  window.setTimeout (->
    Collections[name].update id, {$set: data}
    return
  ), 0 
  # I have to delay the update, because otherwise somehow I trouble with the template
  # this creates new problems as the forms actually create their own data, so there is a conflict 


# HELPER METHODS


Collections.execObjectFunctions = (obj) -> 
  returnObj = {}
  for key, value of obj
      if _.isFunction value
        value = eval("obj."+key+"()")
      returnObj[key] = value
  returnObj


# HANDLEBARS HELPERS


UI.registerHelper "collection", (options) ->
  Collections.initialize this.name, this.create
  if this._id #if there is a surrounding context, only find elements with that context
    parent = Collections[this.collection].findOne(this._id)
    this.objectsArray = Collections[this.name].find({},sort: name: 1)
  else 
    this.objectsArray = Collections[this.name].find({},sort: name: 1)

  
  
  return Template.jCollection
  # Collections.initialize this.name, this.create, this.object #todo: this does not refer to the current object anymore, so where to i get the context?
  # result = ""
  # result

UI.registerHelper "document", () -> #BUG: does not rerender on documentChange, maybe because Session is dynamic...
  currentDocument = Session.get('currentDocument.'+this.collection)
  name = this.collection
  object = currentDocument
  Collections.initialize this.collection, this.create, this
  if currentDocument
    if currentDocument.context
      currentDocument.parent = Collections[currentDocument.context.collection].findOne(currentDocument.context._id)
  else
    object = Collections[name].findOne()

  this.object = object
  return Template.jDocument

UI.registerHelper "field", (options) ->
  field = options.hash.name
  name = this.collection
  # if @_id #i don't remeber what this is for..., but with the update @_id is no longer defined
  data = {}
  if this[field]
    data[field] = this[field]
  else if options.hash['random']
    data[field] = random(options.hash['random'],options.hash)
    Collections.delayedUpdate name, @_id,data
  else if options.hash['pick'] 
    data[field] = pick options.hash['pick']
    Collections.delayedUpdate name, @_id,data
  data[field]

UI.registerHelper "count", (collection, field) -> #counts ocurrances in subcollection
  if Collections[collection]
    query = {}
    query[field] = true 
    query['context._id'] = this._id
    Collections[collection].find(query).count()
  else
    0

UI.registerHelper "equal", (a,b) ->
  if a is b then true else false

UI.registerHelper "setAll", (collection, field, value) ->
  result = ' data-set-field=' + field
  result += ' data-set-collection=' + collection
  result += ' data-set-value=' + value

UI.registerHelper "setAllBoolean", (collection, field, value) ->
  result = ' data-set-field-boolean=' + field
  result += ' data-set-collection=' + collection
  result += ' data-set-value=' + value

