Meteor.startup ->

    Template.renderLayout.events

        "click a": (event) ->
            Session.set('currentDocument.'+this.collection ,this)

        "click input[type=submit]": (event) ->
            event.preventDefault()
            form = $(event.target).parent()
            if this._id
                Collections.updateDoc this, form
            else
                Collections.createDoc form
                form[0].reset()

        "click [data-toggle-boolean]": (event) ->
            field = $(event.target).attr('data-toggle-boolean')
            if this._id
                Collections.toggleBoolean this, field
            else 
                Session.toggle field

        "click [data-set-field]": (event) ->
            field = $(event.target).attr('data-set-field')
            collection = $(event.target).attr('data-set-collection')
            value = $(event.target).attr('data-set-value')
            Collections.setAll collection, field, value, this
