# # enableClickActions();
# Meteor.startup ->
#   Template.renderPage.events

#     "click [data-onClick-setTrue]": ->
#       Collection[@collection].update @_id,
#         $set:
#           isEdit: true

#     "click input[type=submit]": (event) ->
#       event.preventDefault()
#       updateEntry $(event.target).parent("form")
#       Collection[@collection].update @_id,
#         $set:
#           isEdit: false
#       updateEntry this
