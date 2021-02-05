function setTimeout() { }


var highlighter = require("highlight");


function getThemeCSS(t) {
  if (!t) {
    return highlighter.defaultTheme;
  }

  var theme = null;

  try {
    theme = require("ace/theme/" + t);
  } catch { theme = highlighter.defaultTheme; }

  return theme.cssText;
}


function highlight(s) {
  return highlighter.highlight(s).html;
}
