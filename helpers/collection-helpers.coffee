# HANDLEBARS HELPERS


# options repeat with / collection / times
UI.registerHelper "repeat", () ->
  if this.collection
      this.objectsArray = Collections.find(this)
      new Template Template.jCollection.viewName, ->
        return Template.jCollection.renderFunction.apply this, arguments
  else if this.limit
    this.array = []
    this.array.push "" for [1..this.limit]
    return Template.jRepeat
  else if this.with
    this.array = this.with.split(",")
    return Template.jRepeat
  else
    this.error = "{{#repeat}} needs one of these attributes: times, limit or collection"
    return Template.jError


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
