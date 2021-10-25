# rdocsyntax 0.6.2

## Bug fixes and improvements

- Fix vignette code background for client side highlighting ([#32](https://github.com/kiendang/rdocsyntax/pull/32))
- Fix inline `## Notrun` regex ([#34](https://github.com/kiendang/rdocsyntax/pull/34))
- Update `ace` to `v1.4.13` ([#33](https://github.com/kiendang/rdocsyntax/pull/33))
- Drop `rvest` dependency ([#31](https://github.com/kiendang/rdocsyntax/pull/31))
- No longer trim leading whitespaces from code chunk ([#35](https://github.com/kiendang/rdocsyntax/pull/35))

# rdocsyntax 0.6.1

## Bug fixes and improvements

- Make `memoise` dependency optional ([#29](https://github.com/kiendang/rdocsyntax/pull/29))

# rdocsyntax 0.6.0

## Changes

- Highlighting is now done *client side*, *i.e.* the JavaScript highlighting code is executed by whatever browser that eventually displays the HTML docs, either RStudio or an external browser, instead of `V8`. This change allows us to drop the heavy `V8` dependency ([#25](https://github.com/kiendang/rdocsyntax/pull/25)).

# rdocsyntax 0.5.4

## Bug fixes and improvements

- Remove `readr` dependency ([#23](https://github.com/kiendang/rdocsyntax/pull/23))

# rdocsyntax 0.5.3

## Bug fixes and improvements

- Finally (hopefully) fixed encoding on Windows ([#6](https://github.com/kiendang/rdocsyntax/issues/6)) ([#21](https://github.com/kiendang/rdocsyntax/pull/21))
- Use the `RSTUDIO` environment variable to check for RStudio usage. This also removes `rstudioapi` dependency ([#21](https://github.com/kiendang/rdocsyntax/pull/21)).
