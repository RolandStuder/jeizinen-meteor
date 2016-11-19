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
  amount = 0 unless amount
  data["collection"] = collection
  data["createdAt"] = new Date().getTime()
  unless amount == 0
    for i in [1..amount]
      console.log "i am here"
      insertData = Collections.execObjectFunctions(data)
      Collections[collection].insert insertData

Collections.initialize = (name,amount,context) ->
  amount = 0 unless amount
  if name
    Collections.create name
    if Collections[name].find().count() is 0
      Collections.insert name, {context: context}, amount
      if amount == 1
        Session.set('currentDocument.'+name, Collections[name].findOne())


Collections.createDoc = (form) -> # creates a doc from submitted jquery form
  inputs = form.find("input[name]")
  name = form.attr("data-collection")
  data = {collection: name}
  Collections.create name
  collection = Collections[name]
  inputs.each () ->
    data[ $(this).attr("name") ] = $(this).val()
  newDocument = Collections.insert name, data
  console.log name,data


Collections.updateDoc = (document,form) -> #question: why does this not work anymore, when I assign a return value?
  data = getDataFromForm form
  if Collections[document.collection].findOne(document._id)
    Collections[document.collection].update document._id, $set: data

Collections.updateField = (document, field, value) ->
  if Collections[document.collection].findOne(document._id)
    data = {}
    data[field] = value
    Collections[document.collection].update document._id, $set: data;

Collections.getDocument = (collectionName) ->
  currentDocument = Session.get('currentDocument.'+collectionName)
  name = collectionName
  object = currentDocument
  if currentDocument
    if currentDocument.context
      currentDocument.parent = Collections[currentDocument.context.collection].findOne(currentDocument.context._id)
  else
    Collections.initialize name, 1
    object = Collections[name].findOne()
    console.log "getDocument" + object
  return object



getDataFromForm = (form) ->
  getIdOrName = (element) ->
    return element.id or element.name

  data = {}
  inputs = {}
  inputs.text = $(form).find("input[type=text]")
  inputs.text.each () ->
    data[ getIdOrName(this) ] = this.value
  inputs.selects = $(form).find("select[name]")
  inputs.selects.each () ->
    data[ getIdOrName(this) ] = $(this).find(":selected").text()
  inputs.textareas = $(form).find("textarea[name]")
  inputs.textareas.each () ->
    data[ getIdOrName(this) ] = $(this).val()
  inputs.checkboxes = $(form).find("input[type=checkbox]")
  inputs.checkboxes.each () ->
    data[ getIdOrName(this) ] = $(this)[0].checked
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

UI.registerHelper "collection", () ->
  Collections.initialize this.name, this.create
  this.limit = 100 unless typeof this.limit != "undefined"
  this.limit = Number.parseInt(this.limit)
  sortInstruction = {}
  sortInstruction[this.sort] = 1
  filters = Session.get("filters")
  searchFilters = Session.get("searchFilters")
  if typeof filters != "undefined" #ugly stuff, can't I do it more elegantly?
    query = filters[this.name]
  else
    query = {}


  if typeof searchFilters != "undefined"
    searchQuery = searchFilters[this.name]
    queryArray = []
    # for key,values of searchQuery
    #   searchQuery[key] = new RegExp searchQuery[key], "gi"

    for key,value of searchQuery
      fields = key.split(",")
      for field in fields
        obj = {}
        obj[field] = new RegExp value, "i"
        queryArray.push obj
        console.log obj
  else
    searchQuery = {}

  newSearchQuery = {}
  if typeof queryArray != "undefined"
    if queryArray.length > 0
      newSearchQuery['$or'] = queryArray
      console.log JSON.stringify newSearchQuery
      console.log JSON.stringify query
    else
      newSearchQuery = {}

  this.objectsArray          = Collections[this.name].find({$and: [query, newSearchQuery]}, {sort: {createdAt: -1}, limit: Number.parseInt(this.limit) })
  this.objectsArrayUnlimited = Collections[this.name].find({$and: [query, newSearchQuery]})
  this.objectsArrayUnfiltered = Collections[this.name].find({})


  Session.set 'collection.' + this.name + '.visibleCount', this.objectsArray.count()
  Session.set 'collection.' + this.name + '.filteredCount', this.objectsArrayUnlimited.count()
  Session.set 'collection.' + this.name + '.totalCount', this.objectsArrayUnfiltered.count()

  if this.objectsArray.count() == 0
    this.empty = true
  else
    this.empty = false

  Session.get 'searchFilters'
  Session.get 'filters'

  # return Template.jCollection
  console.log "collection: ", this.name
  console.log this
  console.log this.objectsArray.collection._docs._map
  console.log this.count


  new Template Template.jCollection.viewName, ->
    Session.get 'searchFilters'
    Session.get 'filters'
    return Template.jCollection.renderFunction.apply this, arguments


UI.registerHelper "document", () -> #BUG: does not rerender on documentChange, needs the same mechanism, as the collection helper
  Collections.initialize this.collection, 1
  currentDocument = Session.get("currentDocument."+this.collection)
  if currentDocument?
    this.objectsArray = Collections[this.collection].find({"_id": currentDocument._id})
  new Template Template.jCollection.viewName, ->
    Session.get 'searchFilters'
    Session.get 'filters'
    return Template.jCollection.renderFunction.apply this, arguments

UI.registerHelper "field", (field, options) ->
  name = this.collection
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

# UI.registerHelper "count", (collection, field, value) -> #counts ocurrances in subcollection that match a certain criteria
#   if Collections[collection]
#     query = {}
#     query[field] = value
#     # query['context._id'] = this._id
#     Collections[collection].find(query).count()
#   else
#     0

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
