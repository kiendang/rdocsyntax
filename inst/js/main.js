const setTimeout = () => { }


const highlighter = require('highlight')


const getThemeCSS = (t) => {
  if (!t) {
    return highlighter.defaultTheme
  }

  let theme = null

  try {
    theme = require(`ace/theme/${t}`)
  } catch { theme = highlighter.defaultTheme }

  return theme.cssText
}


const highlight = (s) => (
  highlighter.highlight(s).html
)
