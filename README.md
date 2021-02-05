# Syntax highlighting for R HTML documentation


Overview
--------

This package enables syntax highlighting for R HTML documentation.

Syntax highlighting follows RStudio theme when running RStudio, otherwise uses Textmate theme.


Getting Started
---------------

Install the package

```r
# install.packages("devtools")
devtools::install_github("kiendang/rdocsyntax")
```

Enable syntax highlighting

```r
highlight_html_docs()
```

Code in HTML documents is now highlighted

```r
?try
```

or if help pages are not displayed in HTML mode by default, *e.g.* when R is not running inside RStudio

```r
help(try, help_type = "html")
```

Disable syntax highlighting

```r
unhighlight_html_docs()
```


Extras
------

### Implementation details

R HTML help pages are rendered and served using the internal help server `httpd`. The package works by replacing the original `httpd` with one that receives the response from the original server, checks if the response body contains HTML, then finds and highlights portions of the HTML that contains code, and finally sends the new response with the HTML highlighted.

An alternative implementation that does not involve replacing the internal `httpd` can be found at [`kiendang/rdocsyntax.ex`](https://github.com/kiendang/rdocsyntax.ex)

Compared to `rdocsyntax.ex`, `rdocsyntax` is a cleaner implementation and integrates better with RStudio, *i.e.*, help pages are displayed inside the Help pane, other functionalities such as search, forward, backward work out of the box. It also has the advantage of being faster. It is also the one that I personally use. However, since it involves overwriting `tools:::httpd`, we might have difficulties submitting the package to CRAN later if we want to. `rdocsyntax.ex`, on the other hand, might be considered a "safer" (though there is nothing unsafe regarding `rdocsyntax`), but the implementation is a bit "clunky", and does not integrate as nicely with RStudio. Help pages are displayed in the Viewer instead of Helper pane and those aforementioned extra functionalities do not work.
