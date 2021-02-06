const setTimeout = () => { }


const highlighter = require('highlight')
const defaultTheme = require('ace/theme/textmate')


const getThemeS = (theme) => {
  let t = null

  try {
    t = require(`ace/theme/${theme}`)
  } catch { t = defaultTheme }

  return t
}


const isString = (x) => (
  Object.prototype.toString.call(x) === '[object String]'
)


const getTheme = (theme) => {
  const t = theme ?? defaultTheme
  return isString(t) ? getThemeS(t) : t
}


const highlight = (s) => (
  highlighter.highlight(s, defaultTheme).html
)
