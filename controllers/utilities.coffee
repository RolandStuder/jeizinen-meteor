UI.registerHelper "hyphenate", (text) ->
  text.replace(/ +/g, '-').toLowerCase()

UI.registerHelper "modulo", (number, divider) ->
  number % divider

UI.registerHelper "truncate", (text, chars) ->
  text.substring(0,chars) + "…"
