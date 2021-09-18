({
  baseUrl: ".",
  name: "node_modules/almond/almond.js",
  paths: {
    "ace": "ace/lib/ace"
  },
  include: [
    "ace/ext/static_highlight",
    "ace/mode/r",
    "ace/theme/textmate",
  ],
  optimize: "uglify",
  out: "inst/js/app.js"
})
