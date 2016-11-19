UI.registerHelper "hyphenate", (text) ->
  text.replace(/ +/g, '-').toLowerCase()

UI.registerHelper "modulo", (number, divider) ->
  number % divider
