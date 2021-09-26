.onLoad <- function(libname, pkgname) {
  if (requireNamespace("memoise", quietly = TRUE)) {
    get_theme <<- memoise::memoise(get_theme)
  }
}
