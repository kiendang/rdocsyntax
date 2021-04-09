var setTimeout = function setTimeout() {};

var highlighter = require('highlight');

var defaultTheme = require('ace/theme/textmate');

var getThemeS = function getThemeS(theme) {
  var t = null;

  try {
    t = require("ace/theme/".concat(theme));
  } catch (_unused) {
    t = defaultTheme;
  }

  return t;
};

var isString = function isString(x) {
  return Object.prototype.toString.call(x) === '[object String]';
};

var getTheme = function getTheme(theme) {
  var t = theme !== null && theme !== void 0 ? theme : defaultTheme;
  var result = isString(t) ? getThemeS(t) : t;
  return function (_ref) {
    var isDark = _ref.isDark,
        cssClass = _ref.cssClass,
        cssText = _ref.cssText;
    return {
      isDark: isDark,
      cssClass: cssClass,
      cssText: cssText
    };
  }(result);
};

var highlightCode = function highlightCode(s) {
  return highlighter.highlight(s, defaultTheme).html;
}; // const inlineNotRunRegex = /(?<=^[^\S\n\r]*##[^\S\n\r]+Not run:)[^\S\n\r]+/gm
// const addLineBreakNotRun = (s) => s.replace(inlineNotRunRegex, '\n')
// const highlight = (s) => highlightCode(addLineBreakNotRun(s))


var highlight = highlightCode;