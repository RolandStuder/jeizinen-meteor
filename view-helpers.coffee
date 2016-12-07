UI.registerHelper "action", () ->
  "Action is a reserved word for helpers"

# ALL ACTIONS SHOULD BE NAMESPACED SO THERE ARE NO CONFLICTS

UI.registerHelper "actionSet", (field, value) ->
  attr = {
    field: field
  , value: value
  }
  return nameSpaceObj("action-set", attr)

UI.registerHelper "actionSetBoolean", (field, value) ->
  value = "toggle" unless value? # defaults to toggle
  value = true if (value == "true" || value == "TRUE")
  value = false if (value == "false" || value == "FALSE")
  attr = {
    field: field
  , value: value
  }
  return nameSpaceObj("action-set-boolean", attr)

UI.registerHelper "actionIncrement", (field, delta) ->
  attr = {
    field: field
  , delta: delta
  }
  return nameSpaceObj("action-increment", attr)


@nameSpaceObj = (namespace, obj) -> #takes an action name an namesspaces the attribute
  nameSpacedObj = {}
  nameSpacedObj[namespace] = true
  for key, value of obj
    nameSpacedObj[namespace + "-" + key] = value
  return nameSpacedObj

UI.registerHelper "faker", () ->
  "hello"

UI.registerHelper "filter", (options) ->
  attributes  =
    "data-filter-for": options.hash["collection"]
    "data-filter-field": options.hash["field"]
    "data-filter-value": options.hash["value"]
  return attributes

UI.registerHelper "liveSearch", (options) ->
  attributes =
    "data-live-search-for": options.hash["collection"]
    "data-live-search-field": options.hash["field"]
  return attributes

UI.registerHelper "animate", (animation) ->
  return "style=\"#{animation}\""

UI.registerHelper "session", (input, defaultValue) ->
  if typeof Session.get != "undefined"
    return Session.get input
  else
    return defaultValue

UI.registerHelper "simpleFormat", (text, options) ->
  text = text.replace /\n/g, "<br />";
  return new Spacebars.SafeString text


  # inputArray = input.split(".") #I don't remember or see, why I did this.
  # if inputArray.length > 1
  #   output = Session.get inputArray[0]
  #   inputArray.shift()
  #   for part in inputArray
  #     if typeof output != "undefined"
  #       output = output[part]
  #     else
  #       return defaultValue
  #   return output
  # else
  #   if typeof Session.get != "undefined"
  #     return Session.get input
  #   else
  #     return defaultValue

UI.registerHelper "setTrue", (attr, id) ->
  "data-onClick-setTrue=\"" + attr + "\" data-id=\"" + id + "\""

UI.registerHelper "bootstrapInput", (fieldName, options) ->
  ctx = {}
  ctx.fieldValue = this[fieldName]
  ctx.fieldName = fieldName
  if options.hash["label"]
    ctx.label = options.hash["label"]
  else
    ctx.label = fieldName

  if options.hash["labelWidth"]
    ctx.labelWidth = options.hash["labelWidth"]
  else
    ctx.labelWidth = 3
  ctx.inputWidth = 12-ctx.labelWidth
  return new Spacebars.SafeString toHTMLWithData Template.bootstrapInput, ctx

UI.registerHelper "bootstrapSelect", (fieldName, options) ->
  ctx = {}
  ctx.fieldValue = this[fieldName]
  ctx.fieldName = fieldName
  if options.hash["options"]
    optionsArray = options.hash["options"].split(",")
    ctx.options = []
    for option in optionsArray
      if option is this[fieldName]
        ctx.options.push {value: option, selected: "selected"}
      else
        ctx.options.push {value: option}
  if options.hash["label"]
    ctx.label = options.hash["label"]
  else
    ctx.label = fieldName

  if options.hash["labelWidth"]
    ctx.labelWidth = options.hash["labelWidth"]
  else
    ctx.labelWidth = 3
  ctx.inputWidth = 12-ctx.labelWidth
  console.log ctx
  return new Spacebars.SafeString toHTMLWithData Template.bootstrapSelect, ctx


@toHTMLWithData = (kind, data) -> #a temporary fix for not bein able to get strings from manually rendered templates. May break soon. https://github.com/meteor/meteor/issues/2007
  UI.toHTML kind.extend(data: ->
    data
  )
