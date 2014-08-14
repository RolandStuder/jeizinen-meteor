# wildcard router takes path in the form of layoutname/context1.context2.templateName

# Meteor.Router.add "public": ->

# Meteor.Router.beforeRouting = ->
#   filesImported = Session.get "filesImported"
#   unless filesImported?
#     Collections.importDataFromFiles() 
#   Session.set "filesImported", true

@path = {}


console.log "test"

Router.map ->
  this.route 'allRoutes',
    path: '*'
    layoutTemplate: 'layout'
    action: ->
      path = parse(this.path)
      paramsToSession()

      FlashMessages.clear()
      FlashMessages.load()

      Jeizinen.log "Navigation: showing template '#{path["page"]}' with layout '#{path["layout"]}'"
      Jeizinen.log "links pointing to '#{path.sections}' get the class active"
      
      this.router.layout path["layout"]
      this.render(path["page"])
      window.setTimeout (->
        addActiveClassToLinks path['sections'], path['page']
        replaceImagePlaceholders()
        return
      ), 0 # for some reason, I does not work without a TimeOut, probably some concurrency issue.
    waiton: ->
      Meteor.subscribe("importedCollections")


paramsToSession = ->
  for param in window.location.search.substring(1).split('&')
    param = param.split('=')
    Session.set param[0], param[1]


parse = (path) -> 
  path = path.split("/") 
  path.shift()
  sections = if path[path.length-1] then path[path.length-1] else "index"
  sections = sections.split(".")
  page = sections[sections.length - 1]
  sections.pop()
  unless Template[page]
    Jeizinen.log "#{page}: no such template"
    page = "notFound"  
  layout = if path[path.length-2] then path[path.length-2] else "layout"
  unless Template[layout]
    Jeizinen.log "#{layout}: no such layout"
    layout = "jEmptyLayout" 
  page: page
  layout: layout
  sections: sections


addActiveClassToLinks = (currentSections, currentPage) ->
  $(".nav > li").removeClass "active"
  $("a").removeClass("active").each ->
    href = $(this).attr("href")
    if href
      if shouldBeActive href, currentSections, currentPage
        $(this).addClass "active"
        $(this).parents(".nav > li").addClass "active"

shouldBeActive = (href, currentSections, currentPage) ->
  sections = href.split(".")
  targetPage = sections[sections.length-1].replace '/', ''
  sections.pop()
  if targetPage == currentPage
    return true
  else if sections.length > 0
    for section in sections
      matchingSection = $.inArray(section, currentSections)
      if matchingSection >= 0
        if section == targetPage
          return false
  else if $.inArray(targetPage, currentSections) >= 0
    return true
