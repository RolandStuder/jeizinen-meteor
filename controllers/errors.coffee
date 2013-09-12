error = (message) ->
  console.log                     "JEIZINEN ERROR: " + message
  FlashMessages.display "danger", "JEIZINEN ERROR: " + message
  FlashMessages.send    "danger", "JEIZINEN ERROR: " + message
