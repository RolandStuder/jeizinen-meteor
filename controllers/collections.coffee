# Supercollection Collection will eat anything...
# warning will only work within templates...

# COLLECTION CONTROLLER
@Collections = new Meteor.Collection("Collection")
Session.set('_index','0');

# @newCollection = new Meteor.Collection('newCollection')
# newCollection.insert({description: "I don't get it!"})

# importing datasets from files

# options object of collection, limit, sort, create (int)
Collections.find = (options) ->
  options.create = 0 unless options.create
  Collections.initialize options.collection, options.create
  options.limit = 100 unless typeof options.limit != "undefined"
  options.limit = Number.parseInt(options.limit)
  sortInstruction = {}
  sortInstruction[options.sort] = 1
  unless options.sort
    sortInstruction.createdAt = -1

  filters = Session.get("filters")

  searchFilters = Session.get("searchFilters")
  if typeof filters != "undefined" #ugly stuff, can't I do it more elegantly?
    query = filters[options.collection]
  else
    query = {}

  if options.filter #filters repeat with query indicated by filter="key:value"
    query = {}
    options.filter = options.filter.split(':')
    query[options.filter[0]] = options.filter[1]

  if typeof searchFilters != "undefined"
    searchQuery = searchFilters[options.collection]
    queryArray = []
    # for key,values of searchQuery
    #   searchQuery[key] = new RegExp searchQuery[key], "gi"

    for key,value of searchQuery
      fields = key.split(",")
      for field in fields
        obj = {}
        obj[field] = new RegExp value, "i"
        queryArray.push obj
  else
    searchQuery = {}

  newSearchQuery = {}
  if typeof queryArray != "undefined"
    if queryArray.length > 0
      newSearchQuery['$or'] = queryArray
    else
      newSearchQuery = {}

  this.objectsArray          = Collections[options.collection].find({$and: [query, newSearchQuery]}, {sort: sortInstruction, limit: Number.parseInt(options.limit) })
  this.objectsArrayUnlimited = Collections[options.collection].find({$and: [query, newSearchQuery]})
  this.objectsArrayUnfiltered = Collections[options.collection].find({})

  Session.set 'collection.' + options.collection + '.visibleCount', this.objectsArray.count()
  Session.set 'collection.' + options.collection + '.filteredCount', this.objectsArrayUnlimited.count()
  Session.set 'collection.' + options.collection + '.totalCount', this.objectsArrayUnfiltered.count()

  if this.objectsArray.count() == 0
    this.empty = true
  else
    this.empty = false

  Session.get 'searchFilters'
  Session.get 'filters'

  return this.objectsArray

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
  currentIndex = Number.parseInt(Session.get '_index')
  insertIndex = insertIndex
  unless amount == 0
    for i in [1..amount]
      currentIndex++
      data["_index"] = currentIndex
      insertData = Collections.execObjectFunctions(data)
      Collections[collection].insert insertData
    Session.set('_index', currentIndex)

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
  textareas = form.find("textarea[name]")
  name = form.attr("data-collection")
  data = {collection: name}
  Collections.create name
  collection = Collections[name]
  inputs.each () ->
    data[ $(this).attr("name") ] = $(this).val()
  textareas.each () ->
    data[ $(this).attr("name") ] = $(this).val()
    console.log "submitted data ",  $(this).val()
  newDocument = Collections.insert name, data, 1 # needs amount 1 because Collections.insert defaults to 0


Collections.updateDoc = (document,form) -> #question: why does this not work anymore, when I assign a return value?
  data = getDataFromForm form
  if Collections[document.collection].findOne(document._id)
    Collections[document.collection].update document._id, $set: data

Collections.updateField = (document, field, value) ->
  if Collections[document.collection].findOne(document._id)
    data = {}
    data[field] = value
    Collections[document.collection].update document._id, $set: data;

Collections.increaseField = (document, field, delta) ->
  if doc = Collections[document.collection].findOne(document._id)
    data = {}
    current = doc[field]
    data[field] = Number.parseInt(current) + Number.parseInt(delta) || 0
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
