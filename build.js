({
  baseUrl: ".",
  name: "node_modules/almond/almond.js",
  paths: {
    "ace": "ace/lib/ace",
    "highlight": "srcjs/app"
  },
  include: [
    "highlight"
  ],
  optimize: "uglify",
  out: "inst/js/app.js"
})
