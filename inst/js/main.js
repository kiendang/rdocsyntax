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
  return Object.prototype.toString.call(x) == '[object String]';
};

var getTheme = function getTheme(theme) {
  var t = theme !== null && theme !== void 0 ? theme : defaultTheme;
  return isString(t) ? getThemeS(t) : t;
};

var highlight = function highlight(s) {
  return highlighter.highlight(s, defaultTheme).html;
};