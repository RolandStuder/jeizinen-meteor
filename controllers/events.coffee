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
            if data?
                if data.collection?
                    Session.set('currentDocument.'+data.collection ,data)
            else
                true

        "click input[type=submit]": (event,data) ->
            event.preventDefault()
            form = $(event.currentTarget).closest("form")
            console.log data
            if data?
                if data.collection?
                    Session.set('currentDocument.'+data.collection ,data)

            if data._id
                Collections.updateDoc data, form
            else
                Collections.createDoc form
                form[0].reset()
            return true

        "click [data-toggle-boolean]": (event,data) ->
            field = $(event.currentTarget).attr('data-toggle-boolean')
            console.log data
            if data?
                if data._id?
                    Collections.toggleBoolean data, field
            else 
                Session.toggle field

        "click [href]": (event,data) ->
            href = $(event.currentTarget).attr('href')
            goToAnchor event #how is this supposed to work when I change path name?
            Session.set("currentPage",href) #weird, what did I do here?
            #location.pathname = href

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
        
        # Autoupdates from forms

        "change input[type=checkbox]": (event,data) ->
            value = event.currentTarget.checked
            autoPickUpdateType(event, data, value)
        
        "change select": (event,data) ->
            select = event.currentTarget
            value = select.options[select.selectedIndex].value
            autoPickUpdateType(event, data, value)

        "keyup input:not([type]), keyup input[type=text]": (event,data) ->
            value = event.currentTarget.value
            autoPickUpdateType(event, data, value)

        "keyup input[type=password]": (event,data) -> #for some reason, it does not work with password fields, everything is passed nicely to the autoPickUpdateType as far as I could tell, but it does not update in case autoPickUpdateType is document.
            value = event.currentTarget.value
            console.log "can't update from password if it is a document"
            autoPickUpdateType(event, data, value)

        "keyup textarea": (event,data) ->
            value = event.currentTarget.value
            autoPickUpdateType(event, data, value)



    Session['toggle'] = (name) ->
        value = Session.get(name)
        if value == true
            Session.set(name, false)
        else
            Session.set(name, true)

    goToAnchor = (event) ->
        hash = event.currentTarget.hash
        Meteor.defer -> 
            hash = hash.replace("#","")
            target = $("[name=\"#{hash}\"]")
            if typeof target.offset() != "undefined"
              $(document.body).scrollTop target.offset().top
            else
              $(document.body).scrollTop 0

    isAutoupdate = (event) ->
        form = $(event.currentTarget).closest("form")[0]
        if form and form.getAttribute("no-auto-update") == ""
            console.log "Auto update prevented"
            return false
        else
            return true

    autoPickUpdateType = (event, data, value) ->
        element = event.currentTarget
        form = $(element).closest("form")[0]
        name = element.id or element.name
        console.log element.value, form, name, value, data
        if isAutoupdate(event)
            if data
                Collections.updateField(data, name, value)
            else if form and (form.id or form.name )
                formName = form.id or form.name
                Session.set formName + "." + name, value
            else
                Session.set name, value
            
             
