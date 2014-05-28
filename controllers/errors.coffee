@Jeizinen =
	error: (message) ->
	  console.error                     "JEIZINEN ERROR: " + message
	  FlashMessages.display "danger", "JEIZINEN ERROR: " + message
	  FlashMessages.send    "danger", "JEIZINEN ERROR: " + message
	log: (message) ->
	  console.log "JEIZINEN: #{message}"
