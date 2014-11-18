Meteor.startup ->
    UI.body.events #warning: due to the package gwendall:body-events@0.1.3, to have the object data availbe, it has to be passed to the map as a second argument.
        "click [data-animated]": (event,data) ->
            animation = $(event.currentTarget).attr('data-animated')
            target = $(event.currentTarget).closest(".jDocumentWrapper")
            $(target).addClass("animated #{animation}")
            window.setTimeout (->
                $(target).removeClass("animated #{animation}")
                return
            ), 1000

        "click a": (event,data) ->
            if data.collection
                Session.set('currentDocument.'+data.collection ,data)

        "click input[type=submit]": (event,data) ->
            event.preventDefault()
            console.log data
            Session.set('currentDocument.'+data.collection ,data)
            form = $(event.currentTarget).closest("form")
            if data._id
                Collections.updateDoc data, form
            else
                Collections.createDoc form
                form[0].reset()

        "click [data-toggle-boolean]": (event,data) ->
            field = $(event.currentTarget).attr('data-toggle-boolean')
            if data._id
                Collections.toggleBoolean data, field
            else 
                Session.toggle field

        "click [href]": (event,data) ->
            href = $(event.currentTarget).attr('href')
            Session.set("currentPage",href)

        "click [data-set-field]": (event,data) ->
            field = $(event.currentTarget).attr('data-set-field')
            collection = $(event.currentTarget).attr('data-set-collection')
            value = $(event.currentTarget).attr('data-set-value')
            Collections.setAll collection, field, value, data

        "click [data-set-field-boolean]": (event,data) ->
            field = $(event.currentTarget).attr('data-set-field-boolean')
            collection = $(event.currentTarget).attr('data-set-collection')
            value = $(event.currentTarget).attr('data-set-value')
            Collections.setAllBoolean collection, field, value, data

        "click [data-filter-for]": (event,data) ->
            collection = $(event.currentTarget).attr('data-filter-for')
            field = $(event.currentTarget).attr('data-filter-field')
            value = $(event.currentTarget).attr('data-filter-value')
            if value == ""
                value = undefined
            filters = Session.get "filters"
            if typeof filters == "undefined"
                filters = {}
                filters[collection] = {}  
            filters[collection][field] = value
            Session.set "filters", filters

        "keyup [data-live-search-for]": (event,data) ->
            collection = $(event.currentTarget).attr('data-live-search-for')
            field = $(event.currentTarget).attr('data-live-search-field')
            value = $(event.currentTarget).val()
            if value == ""
                value = undefined
            filters = Session.get "searchFilters"
            if typeof filters == "undefined"
                filters = {}
                filters[collection] = {}  
            filters[collection][field] = value
            Session.set "searchFilters", filters


    Session['toggle'] = (name) ->
        value = Session.get(name)
        if value == true
            Session.set(name, false)
        else
            Session.set(name, true)
