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
  const result = isString(t) ? getThemeS(t) : t
  return (({ isDark, cssClass, cssText }) => ({ isDark, cssClass, cssText }))(result)
}


const inlineNotRunRegex = /(?<=^[^\S\n\r]*##[^\S\n\r]+Not run:)[^\S\n\r]+/gm


const addLineBreakNotRun = (s) => s.replace(inlineNotRunRegex, '\n')


const highlight = (s) => (
  highlighter.highlight(addLineBreakNotRun(s), defaultTheme).html
)
