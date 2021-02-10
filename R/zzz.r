.onLoad <- function(libname, pkgname) {
  get_theme <<- memoise::memoise(get_theme)
}
