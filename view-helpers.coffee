UI.registerHelper "repeat", (n, block) ->
  accum = ""
  i = 0
  while i < n
    accum += block.fn(i)
    ++i
  accum

UI.registerHelper "filter", (options) ->
  attributes  =
    "data-filter-for": options.hash["collection"]
    "data-filter-field": options.hash["field"]
    "data-filter-value": options.hash["value"]
  return attributes
    

UI.registerHelper "animate", (animation) ->
  return "style=\"#{animation}\""

UI.registerHelper "session", (input) ->
  Session.get input

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
