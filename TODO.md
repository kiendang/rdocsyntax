- Currently using a mix of `rvest` and `xml2`. Ideally we should only use `xml2`. The reasons why we need `rvest` in some places right now are:
  - Some function(s) from `xml2` remove whitespaces by default. Need to figure out which one(s) and whether there are options to disable this.
  - For certain queries CSS selector is much more straightforward than XPath, *e.g.* select nodes based on class.

- Figure out logging, *i.e.* log errors from `httpd` in dev/debug mode.

- Handle inline `## Not run:`, *i.e.* port over https://github.com/kiendang/rdocsyntax.ex#single-line--not-run
