var highlight = require('ace/ext/static_highlight');

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

var replaceAceClass = function replaceAceClass(code) {
  var classes = code.querySelector(':scope > div.ace-tm').classList;
  classes.remove('ace-tm');
  classes.add('ace_editor_theme');
};

var removeIndentGuide = function removeIndentGuide(code) {
  code.querySelectorAll('.ace_indent-guide').forEach(function (node) {
    node.classList.remove('ace_indent-guide');
  });
};

var highlightCode = function highlightCode(code) {
  highlight(code, {
    mode: 'ace/mode/r',
    showGutter: false,
    trim: true
  }, function (_highlighted) {});
};

var highlightDocCode = function highlightDocCode(codeBlocks) {
  codeBlocks.forEach(function (code) {
    code.textContent = addLineBreakNotRun(code.textContent);
    highlightCode(code);
    removeIndentGuide(code);
    replaceAceClass(code);
  });
};

var highlightVignetteCode = function highlightVignetteCode(codeBlocks) {
  codeBlocks.forEach(function (code) {
    code.innerHTML = code.textContent;
    highlightCode(code);
    removeIndentGuide(code);
    replaceAceClass(code);
  });
};

var runEverything = function runEverything() {
  highlightDocCode(document.querySelectorAll('pre'));
  highlightVignetteCode(document.querySelectorAll('pre code.sourceCode.r'));
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', runEverything);
} else {
  runEverything();
}