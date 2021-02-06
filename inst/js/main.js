var setTimeout = function setTimeout() {};

var highlighter = require('highlight');

var getThemeS = function getThemeS(theme) {
  var t = null;

  try {
    t = require("ace/theme/".concat(theme));
  } catch (_unused) {
    t = highlighter.defaultTheme;
  }

  return t;
};

var isString = function isString(x) {
  return Object.prototype.toString.call(x) == '[object String]';
};

var getTheme = function getTheme(theme) {
  var t = theme !== null && theme !== void 0 ? theme : highlighter.defaultTheme;
  return isString(t) ? getThemeS(t) : t;
};

var getThemeCSS = function getThemeCSS() {
  var theme = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : highlighter.defaultTheme;
  return getTheme(theme).cssText;
};

var highlight = function highlight(s) {
  var theme = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : highlighter.defaultTheme;
  return highlighter.highlight(s, getTheme(theme)).html;
};