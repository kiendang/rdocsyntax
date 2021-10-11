const highlighter = require('ace/ext/static_highlight')

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

const replaceAceClass = code => {
  const classes = code.querySelector(':scope > div.ace-tm').classList

  classes.remove('ace-tm')
  classes.add('ace_editor_theme')
  classes.add('rdocsyntax-ace-container')
}

const removeIndentGuide = code => {
  code.querySelectorAll('.ace_indent-guide').forEach(node => {
    node.classList.remove('ace_indent-guide')
  })
}

const highlightCode = code => {
  highlighter(code, {
    mode: 'ace/mode/r',
    showGutter: false,
    trim: 'end'
  }, _highlighted => { })
}

const highlightDocCode = codeBlocks => {
  codeBlocks.forEach(code => {
    code.textContent = addLineBreakNotRun(code.textContent)
    highlightCode(code)
    removeIndentGuide(code)
    replaceAceClass(code)
  })
}

const runEverything = () => {
  highlightDocCode(document.querySelectorAll('pre'))
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', runEverything)
} else {
  runEverything()
}
