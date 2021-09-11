// require('amd-loader')

// require('ace/lib/ace/ace')
// const highlighter = require('ace/lib/ace/ext/static_highlight')

define(function (require, exports, module) {
  const highlighter = require('ace/ext/static_highlight')
  const rMode = require('ace/mode/r').Mode

  const highlight = (s, theme) => (
    highlighter.renderSync(s, new rMode(), theme, null, true)
  )

  module.exports = {
    highlight: highlight
  }
})
