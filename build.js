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
  preserveLicenseComments: false,
  optimize: "uglify",
  out: "inst/js/lib.js"
})
