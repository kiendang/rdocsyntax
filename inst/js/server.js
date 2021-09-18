var setTimeout = function setTimeout() {};

var highlighter = require('ace/ext/static_highlight');

var rMode = require('ace/mode/r').Mode;

var defaultTheme = require('ace/theme/textmate');

var highlightCode = function highlightCode(s) {
  return highlighter.renderSync(s, new rMode(), defaultTheme, null, true).html;
};

var addLineBreakNotRun = function addLineBreakNotRun(s) {
  return s;
};

try {
  var inlineNotRunRegex = new RegExp('(?<=^[^\\S\\n\\r]*##[^\\S\\n\\r]+Not run:)[^\\S\\n\\r]+', 'gm');

  addLineBreakNotRun = function addLineBreakNotRun(s) {
    return s.replace(inlineNotRunRegex, '\n');
  };
} catch (e) {
  if (!e instanceof SyntaxError) {
    throw e;
  }
}

var highlight = function highlight(s) {
  return highlightCode(addLineBreakNotRun(s));
};