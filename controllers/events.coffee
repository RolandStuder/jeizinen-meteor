Meteor.startup ->

    Template.renderLayout.events

        "click a": (event) ->
            Session.set('currentDocument.'+this.collection ,this)
            console.log this

        "click input[type=submit]": (event) ->
            event.preventDefault()
            form = $(event.currentTarget).parent()
            if this._id
                Collections.updateDoc this, form
            else
                Collections.createDoc form
                form[0].reset()

        "click [data-toggle-boolean]": (event) ->
            field = $(event.currentTarget).attr('data-toggle-boolean')
            if this._id
                Collections.toggleBoolean this, field
            else 
                Session.toggle field

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
