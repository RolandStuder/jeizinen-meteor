# wildcard router takes path in the form of layoutname/context1.context2.templateName

# Meteor.Router.add "public": ->

# Meteor.Router.beforeRouting = ->
#   filesImported = Session.get "filesImported"
#   unless filesImported?
#     Collections.importDataFromFiles() 
#   Session.set "filesImported", true

@path = {}
  
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
      Jeizinen.log "links pointing to #{path.sections} get the class active"
      
      this.router.layout path["layout"]
      this.render(path["page"])
      window.setTimeout (->
        addActiveClassToLinks path['sections']
        replaceImagePlaceholders()
        return
      ), 0 # for some reason, I does not work without a TimeOut, probably some concurrency issue.


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
  unless Template[page]
    Jeizinen.error "#{page}: no such template"
    page = "notFound"  
  layout = if path[path.length-2] then path[path.length-2] else "layout"
  unless Template[layout]
    Jeizinen.error "#{layout}: no such layout"
    layout = "jEmptyLayout" 
  page: page
  layout: layout
  sections: sections


addActiveClassToLinks = (currentSections) ->
  $(".nav > li").removeClass "active"
  $("a").removeClass("active").each ->
    if $(this).attr("href")
      sections = $(this).attr("href").split(".")
      target = sections[sections.length - 1].replace '/', ''
      if $.inArray(target, currentSections) >= 0
        $(this).addClass "active"
        $(this).parents(".nav > li").addClass "active"