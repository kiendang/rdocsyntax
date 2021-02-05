# Syntax highlighting for R HTML documentation


Overview
--------

This package enables syntax highlighting for R HTML documentation.

Syntax highlighting follows RStudio theme when running RStudio, otherwise uses Textmate theme.

The syntax highlighter in use comes from the [Ace text editor](https://ace.c9.io/), the same editor which RStudio uses.

<img src="screenshots/before.png" alt="before" width=650px/><img src="screenshots/after.png" alt="after" width=650px/>


Installation
------------

*NOTE: The package depends on the `V8` R package which depends on `libv8`. If you are on Linux you need to either install `libv8` from the package manager of your distro or compile `libv8` yourself. This is not required for MacOS or Windows since binary installation of `V8` (the R package) is available. See [`jeroen/V8`](https://github.com/jeroen/V8) for more details.*

Install the package

```r
# install.packages("devtools")
devtools::install_github("kiendang/rdocsyntax")
```


Usage
-----

Enable syntax highlighting

```r
rdocsyntax::highlight_html_docs()
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
rdocsyntax::unhighlight_html_docs()
```


Extras
------
### Implementation details

R HTML help pages are rendered and served using the internal help server `httpd`. The package works by replacing the original `httpd` with one that receives the response from the original server, checks if the response body contains HTML, then finds and highlights portions of the HTML that contains code, and finally sends the new response with the HTML highlighted.

An alternative implementation that does not involve replacing the internal `httpd` can be found at [`kiendang/rdocsyntax.ex`](https://github.com/kiendang/rdocsyntax.ex)

Compared to `rdocsyntax.ex`, `rdocsyntax` is a cleaner implementation and integrates better with RStudio, *i.e.*, help pages are displayed inside the Help pane, other functionalities such as search, forward, backward work out of the box. It also has the advantage of being faster. It is also the one that I personally use. However, since it involves overwriting `tools:::httpd`, we might have difficulties submitting the package to CRAN later if we want to. `rdocsyntax.ex`, on the other hand, might be considered a "safer" (though there is nothing unsafe regarding `rdocsyntax`), but the implementation is a bit "clunky", and does not integrate as nicely with RStudio. Help pages are displayed in the Viewer instead of Helper pane and those aforementioned extra functionalities do not work.
