var highlight = require('ace/ext/static_highlight');

var highlightCode = function highlightCode(codeBlocks) {
  codeBlocks.forEach(function (code) {
    highlight(code, {
      mode: 'ace/mode/r',
      showGutter: false,
      trim: true
    }, function (_highlighted) {
      var classes = code.querySelector(':scope > div.ace-tm').classList;
      classes.remove('ace-tm');
      classes.add('ace_editor_theme');
    });
  });
};

var runEverything = function runEverything() {
  highlightCode(document.querySelectorAll('pre'));
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', runEverything);
} else {
  runEverything();
}