Meteor.startup ->

    Template.layout.events #does not work yet with UI.body due to new implementation with blaze, workaround could be to have a wrapper around the layout, but I don't know how to do that with iron-router
        "click [data-animated]": (event) ->
            animation = $(event.currentTarget).attr('data-animated')
            target = $(event.currentTarget).closest(".jDocumentWrapper")
            console.log target
            $(target).addClass("animated #{animation}")
            window.setTimeout (->
                $(target).removeClass("animated #{animation}")
                return
            ), 1000

        "click a": (event) ->
            # console.log 'current document for ' +  this.collection$
            console.log this
            if this.collection
                Session.set('currentDocument.'+this.collection ,this)

        "click input[type=submit]": (event) ->
            event.preventDefault()
            Session.set('currentDocument.'+this.collection ,this)
            form = $(event.currentTarget).closest("form")
            if this._id
                Collections.updateDoc this, form
            else
                Collections.createDoc form
                form[0].reset()

        "click [data-toggle-boolean]": (event) ->
            field = $(event.currentTarget).attr('data-toggle-boolean')
            # console.log this
            if this._id
                Collections.toggleBoolean this, field
            else 
                Session.toggle field

        "click [href]": (event) ->
            href = $(event.currentTarget).attr('href')
            Session.set("currentPage",href)

        "click [data-set-field]": (event) ->
            field = $(event.currentTarget).attr('data-set-field')
            collection = $(event.currentTarget).attr('data-set-collection')
            value = $(event.currentTarget).attr('data-set-value')
            Collections.setAll collection, field, value, this

        "click [data-set-field-boolean]": (event) ->
            field = $(event.currentTarget).attr('data-set-field-boolean')
            collection = $(event.currentTarget).attr('data-set-collection')
            value = $(event.currentTarget).attr('data-set-value')
            Collections.setAllBoolean collection, field, value, this

        "click [data-filter-for]": (event) ->
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

        "keyup [data-live-search-for]": (event) ->
            collection = $(event.currentTarget).attr('data-live-search-for')
            field = $(event.currentTarget).attr('data-live-search-field')
            value = $(event.currentTarget).val()
            console.log value
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
