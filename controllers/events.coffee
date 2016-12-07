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

        "click [action-set]": (event, data) ->
          field = $(event.currentTarget).attr('action-set-field')
          value = $(event.currentTarget).attr('action-set-value')
          if data?
            if data.collection?
              Collections.updateField data, field, value
          else
            Session.set(field, value)

        "click [update]": (event, data) ->
          action = $(event.currentTarget).attr('update')
          field = action.split(':')[0]
          value = action.split(':')[1]
          if data?
            if data.collection?
              Collections.updateField data, field, value
          else
            Session.set(field, value)


        "click [action-set-boolean]": (event, data) ->
          field = $(event.currentTarget).attr('action-set-boolean-field')
          value = $(event.currentTarget).attr('action-set-boolean-value')
          value = true if value == "true"
          value = false if value == "false"
          if data?
            if data.collection?
              if value == "toggle"
                currentValue = Collections[data.collection].findOne({_id: data._id})[field] || false
                value = !currentValue
              Collections.updateField data, field, value
          else
            if value == "toggle"
              currentValue = Session.get(field) || false
              value = !currentValue
            Session.set(field, value)

        "click [increment]": (event, data) -> # increment="field,increment"
          action = $(event.currentTarget).attr('increment')
          actionParts = action.split(',')
          field = actionParts[0]
          delta = actionParts[1]
          if data?
            if data.collection?
              Collections.increaseField(data, field, delta)
          else
            currentValue = Session.get field
            currentValue = 0 unless currentValue
            value = Number.parseInt(currentValue) + Number.parseInt(delta)
            Session.set(field, value)

        "click [increment-session]": (event,data) ->
          action = $(event.currentTarget).attr('increment-session')
          actionParts = action.split(',')
          field = actionParts[0]
          delta = actionParts[1]
          currentValue = Session.get field
          currentValue = 0 unless currentValue
          value = Number.parseInt(currentValue) + Number.parseInt(delta)
          Session.set(field, value)


        "click a": (event,data) ->
            if data?
                if data.collection?
                    Session.set('currentDocument.'+data.collection ,data)
            else
                true

        "submit form": (event,data) ->
            event.preventDefault()
            form = $(event.currentTarget).closest("form")
            target_collection = $(event.currentTarget).attr('data-collection')
            if target_collection
                Collections.createDoc form
                form[0].reset()
            else
              if data?
                  if data.collection?
                      Session.set('currentDocument.'+data.collection ,data)
                  if data._id
                      Collections.updateDoc data, form
              else
                  Collections.createDoc form
                  form[0].reset()
            if form.attr('href')?
              Session.set("currentPage",form.attr('href'))
            return true

        "click [toggle-boolean]": (event,data) ->
            field = $(event.currentTarget).attr('toggle-boolean')
            console.log data
            if data?
                if data._id?
                    Collections.toggleBoolean data, field
            else
                Session.toggle field

        "click [set-true]": (event,data) ->
            action = $(event.currentTarget).attr('set-true')
            actionParts = action.split(',')
            field = actionParts[0]
            if data?
                if data._id?
                    Collections.updateField data, field, true

        "click [set-false]": (event,data) ->
            action = $(event.currentTarget).attr('set-false')
            actionParts = action.split(',')
            field = actionParts[0]
            if data?
                if data._id?
                    Collections.updateField data, field, false



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
            console.log event
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
        name = element.name
        formName = $(form).attr('name')
        if isAutoupdate(event)
            if data
                Collections.updateField(data, name, value)
            else if form and (formName)
                Session.set formName + "." + name, value
            else
                Session.set name, value
