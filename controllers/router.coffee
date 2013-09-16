# wildcard router takes path in the form of layoutname/context1.context2.templateName

Meteor.Router.add "*": ->
  path = parse(@pathname)
  paramsToSession()

  FlashMessages.clear()
  FlashMessages.load()

  Session.set "currentPage", path["page"]
  Session.set "currentLayout", path["layout"]
  Session.set "currentSections", path["sections"]

paramsToSession = ->
  for param in window.location.search.substring(1).split('&')
    param = param.split('=')
    Session.set param[0], param[1]


parse = (path) -> 
  path = path.split("/") 
  path.shift()

  sections  = if path[path.length-1] then path[path.length-1] else "index"
  sections = sections.split(".")

  page = sections[sections.length - 1]
  page = "notFound"  unless Template[page]
  
  layout = if path[path.length-2] then path[path.length-2] else "renderPage"
  layout = "renderPage" unless Template[layout]

  page: page
  layout: layout
  sections: sections


error = (message) ->
  console.log                     "JEIZINEN ERROR: " + message
  FlashMessages.display "danger", "JEIZINEN ERROR: " + message
  FlashMessages.send    "danger", "JEIZINEN ERROR: " + message

# Jeizinen provides two empty templates that can render any layout/template
Meteor.startup ->
  Template.renderLayout.content = ->
    new Handlebars.SafeString(Template[Session.get("currentLayout")]())

  Template.renderPage.content = ->
    new Handlebars.SafeString(Template[Session.get("currentPage")]())

  Template.renderPage.rendered = ->
    addActiveClassToLinks()
    replaceImagePlaceholders()

addActiveClassToLinks = ->
  $(".nav > li").removeClass "active"
  $("a").removeClass("active").each ->
    sections = $(this).attr("href").split(".")
    target = sections[sections.length - 1].replace '/', ''
    if $.inArray(target, Session.get("currentSections")) >= 0
      $(this).addClass "active"
      $(this).parents(".nav > li").addClass "active"