// require("amd-loader")

// require("ace/lib/ace/ace")
// const highlighter = require("ace/lib/ace/ext/static_highlight")

define(function (require, exports, module) {
  "use strict";

  var highlighter = require("ace/ext/static_highlight");
  var rMode = require("ace/mode/r").Mode;
  var theme = require("ace/theme/textmate");

  var highlight = function (s) {
    return highlighter.renderSync(s, new rMode(), theme, null, true);
  }

  module.exports = highlight
})
