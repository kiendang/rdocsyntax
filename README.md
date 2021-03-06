# Syntax highlighting for R HTML documentation


Overview
--------

This package enables syntax highlighting for R HTML documentation.

Syntax highlighting follows RStudio theme when running RStudio. When running outside RStudio, Textmate theme is applied by default and theme customization is supported. See [Themes](#themes) for more details.

The syntax highlighter comes from [Ace text editor](https://ace.c9.io/), the same editor underlying RStudio.

<img src="screenshots/before.png" alt="before" width=650px/><img src="screenshots/after.png" alt="after" width=650px/>


Installation
------------

```r
# install.packages("devtools")
devtools::install_github("kiendang/rdocsyntax")
```

*NOTE: The package depends on the `V8` R package which depends on `libv8`. If you are on Linux you need to either install `libv8` from the package manager of your distro, compile `libv8` yourself or run the following commands to automatically download a suitable static build of `libv8` during installation of the `V8` R package (`>= 3.4`)*

```r
Sys.setenv(DOWNLOAD_STATIC_LIBV8 = 1)
install.packages("V8")
```

*This is not required for MacOS or Windows since binary installation of `V8` (the R package) is available. See [`jeroen/V8`](https://github.com/jeroen/V8) for more details.*


Usage
-----

### Enable syntax highlighting

```r
rdocsyntax::highlight_html_docs()
```

*NOTE: To enable syntax highlighting automatically whenever you start R/Rstudio, put `rdocsyntax::highlight_html_docs()` in your `.Rprofile`. This will cause problems during upgrades/installations of packages that `V8` depends on, so if you update something like `curl` and run into issues just comment out that line.*

Code in HTML documents is now highlighted

```r
?try
```

If help pages are not displayed in HTML mode by default, *e.g.* when R is not running inside RStudio, set `help_type` option to `html`:

```r
help(try, help_type = "html")
```

or

```r
options(help_type = "html")
?try
```

### Disable syntax highlighting

```r
rdocsyntax::unhighlight_html_docs()
```


Extras
------

### Themes

When running inside RStudio, syntax highlighting always follows RStudio theme.

When running outside RStudio, theme can be changed by setting the `rdocsyntax.theme` option. Valid choices are:

  - Light themes: `chrome`, `clouds`, `crimson_editor`, `dawn`, `dreamweaver`, `eclipse`, `github`, `iplastic`, `katzenmilch`, `kuroir`, `solarized_light`, `sqlserver`, `textmate`, `tomorrow`, `xcode`
  - Dark themes: `ambiance`, `chaos`, `clouds_midnight`, `cobalt`, `dracula`, `gob`, `gruvbox`, `idle_fingers`, `kr_theme`, `merbivore`, `merbivore_soft`, `mono_industrial`, `monokai`, `nord_dark`, `pastel_on_dark`, `solarized_dark`, `terminal`, `tomorrow_night`, `tomorrow_night_blue`, `tomorrow_night_bright`, `tomorrow_night_eighties`, `twilight`, `vibrant_ink`

*e.g.* to switch to `dracula`:

```r
options(rdocsyntax.theme = "dracula")
```

The default theme is `textmate` in case `rdocsyntax.theme` is not set or set to an invalid value.

### Implementation details

R HTML help pages are rendered and served using the internal help server `httpd`. The package works by replacing the original `httpd` with one that receives the response from the original server, checks if the response body contains HTML, then finds and highlights portions of the HTML that contains code, and finally sends the new response with the HTML highlighted.

An alternative implementation that does not involve replacing the internal `httpd` can be found at [`kiendang/rdocsyntax.ex`](https://github.com/kiendang/rdocsyntax.ex).

Compared to `rdocsyntax.ex`, `rdocsyntax` is a cleaner implementation and integrates better with RStudio. Help pages are displayed inside the Help pane and functionalities such as search, forward, backward work out of the box. It also has the advantage of being faster and is the one that I personally use. However, it involves overwriting `tools:::httpd`. In most cases, overwriting an object, especially an unexported one, in another package's namespace, is considered an anti-pattern. `rdocsyntax.ex`, on the other hand, might be considered a "safer" (though there is nothing unsafe regarding `rdocsyntax`), but the implementation is a bit "clunky", and does not integrate as nicely with RStudio: help pages are displayed in the Viewer instead of Helper pane and those aforementioned extra functionalities are not readily available.

### Inline `## Not run`

This is currently only available for `v8` versions that support positive lookbehind regex (probably `>= 5.1.281`). See [#2](https://github.com/kiendang/rdocsyntax/issues/2).

<details>
  <summary><i>how to check your <code>v8</code> version</i></summary>

  ```r
  ctx <- V8::v8()
  ctx
  # <V8 engine 8.3.110.9>
  #  $assign(name, value, auto_unbox = TRUE, ...)
  #  $call(fun, ..., auto_unbox = TRUE)
  #  $console()
  #  $eval(src, serialize = FALSE)
  #  $get(name, ...)
  #  $reset()
  #  $source(file)
  #  $validate(src)
  ```

</details>

There are `## Not run` code examples that are single line. *e.g* in `?rstudioapi::highlightUi`

```r
## Not run: rstudioapi::highlightUi("#rstudio_workbench_panel_git")
```

The code will not be syntax-highlighted because the whole line is considered a comment.

The solution we use is to turn it into

```r
## Not run:
rstudioapi::highlightUi("#rstudio_workbench_panel_git")
```

in the generated html.

### Debug mode

For development, debugging purpose, to show errors from `rdocsyntax` `httpd` help server:

```r
options(rdocsyntax.dev = TRUE)
```
