# rdocsyntax 0.6.1.9000

# rdocsyntax 0.6.1

## Changes

- Make `memoise` dependency optional ([#29](https://github.com/kiendang/rdocsyntax/pull/29))

# rdocsyntax 0.6.0

## Changes

- Highlighting is now done *client side*, *i.e.* the JavaScript highlighting code is executed by whatever browser that eventually displays the HTML docs, either RStudio or an external browser, instead of `V8`. This change allows us to drop the heavy `V8` dependency ([#25](https://github.com/kiendang/rdocsyntax/pull/25)).

# rdocsyntax 0.5.4

## Changes

- Remove `readr` dependency ([#23](https://github.com/kiendang/rdocsyntax/pull/23))

# rdocsyntax 0.5.3

## Changes

- Use the `RSTUDIO` environment variable to check for RStudio usage. This also removes `rstudioapi` dependency ([#21](https://github.com/kiendang/rdocsyntax/pull/21)).

## Bug fixes

- Finally (hopefully) fixed encoding on Windows ([#6](https://github.com/kiendang/rdocsyntax/issues/6)) ([#21](https://github.com/kiendang/rdocsyntax/pull/21))
