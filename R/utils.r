# Create a temp file preloaded with content and return the file path.
tempf <- function(content, ...) {
  tmp <- tempfile(...)
  cat(content, file = tmp)
  tmp
}


call_js <- function(f, ...) {
  ctx <- v8()
  ctx$source(system.file("js", "app.js", package = packageName()))
  ctx$source(system.file("js", "main.js", package = packageName()))
  ctx$call(f, ...)
}


split_space <- function(s) {
  strsplit(s, "\\s+", fixed = FALSE)
}
