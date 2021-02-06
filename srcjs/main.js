const setTimeout = () => { }


const highlighter = require('highlight')


const getThemeS = (theme) => {
  let t = null

  try {
    t = require(`ace/theme/${theme}`)
  } catch { t = highlighter.defaultTheme }

  return t
}


const isString = (x) => (
  Object.prototype.toString.call(x) == '[object String]'
)


const getTheme = (theme) => {
  const t = theme ?? highlighter.defaultTheme
  return isString(t) ? getThemeS(t) : t
}


const highlight = (s, theme = highlighter.defaultTheme) => (
  highlighter.highlight(s, getTheme(theme)).html
)
