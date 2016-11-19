UI.registerHelper "hyphenate", (text) ->
  text.replace(/ +/g, '-').toLowerCase()
