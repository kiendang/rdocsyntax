({
  baseUrl: ".",
  name: "node_modules/almond/almond.js",
  paths: {
    "ace": "ace/lib/ace",
    "highlight": "build/app"
  },
  include: [
    "ace/theme/chrome",
    "ace/theme/textmate",
    "highlight"
  ],
  optimize: "uglify",
  out: "inst/js/app.js"
})
