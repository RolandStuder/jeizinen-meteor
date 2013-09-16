# # enableClickActions();
# Meteor.startup ->
#   Template.renderPage.events

#     "click [data-onClick-setTrue]": ->
#       Collection[@collection].update @_id,
#         $set:
#           isEdit: true

    # "click input[type=submit]": (event) ->
    #   event.preventDefault()
    #   updateEntry this, $(event.target).parent("form")
    #   Collection[@collection].update @_id,
    #     $set:
    #       isEdit: false
    #   updateEntry this

Meteor.startup ->

    Template.renderLayout.events
        "click a": (event) ->
            Session.set('currentDocument',this)

    Template.renderLayout.events
        "click input[type=submit]": (event) ->
            event.preventDefault()
            if this._id
                Collections.updateDoc this, $(event.target).parent("form")
            else
                Collections.createDoc $(event.target).parent("form")
