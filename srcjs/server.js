const setTimeout = () => { }

const highlighter = require('ace/ext/static_highlight')
const rMode = require('ace/mode/r').Mode
const defaultTheme = require('ace/theme/textmate')

const highlightCode = s => (
  highlighter.renderSync(s, new rMode(), defaultTheme, null, true).html
)

let addLineBreakNotRun = (s) => s

try {
  const inlineNotRunRegex = new RegExp(
    '(?<=^[^\\S\\n\\r]*##[^\\S\\n\\r]+Not run:)[^\\S\\n\\r]*(?=\\S)',
    'gm'
  )
  addLineBreakNotRun = s => s.replace(inlineNotRunRegex, '\n')
} catch (e) {
  if (!e instanceof SyntaxError) {
    throw e
  }
}

const highlight = s => highlightCode(addLineBreakNotRun(s))
