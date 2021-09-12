import 'ace-builds/src-min-noconflict/ace'
import 'ace-builds/src-min-noconflict/mode-r'
import 'ace-builds/src-min-noconflict/ext-static_highlight'


const highlight = ace.require('ace/ext/static_highlight')

const highlightCode = codeBlocks => {
  codeBlocks.forEach(code => {
    highlight(code, {
      mode: 'ace/mode/r',
      showGutter: false,
      trim: true
    }, _highlighted => {
      const classes = code.querySelector(':scope > div.ace-tm').classList

      classes.remove('ace-tm')
      classes.add('ace_editor_theme')
    })
  })
}

const runEverything = () => {
  highlightCode(document.querySelectorAll('pre'))
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', runEverything)
} else {
  runEverything()
}
