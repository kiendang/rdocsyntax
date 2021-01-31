({
  baseUrl: ".",
  name: "node_modules/almond/almond.js",
  paths: {
    "ace": "ace/lib/ace",
    "highlight": "srcjs/main"
  },
  include: [
    "highlight"
  ],
  optimize: "uglify",
  out: "inst/js/main.js"
})
