# Create a temp file preloaded with content and return the file path.
tempf <- function(content, ...) {
  tmp <- tempfile(...)
  cat(content, file = tmp)
  tmp
}


# Read a file into a string character.
# Similar to \code{readr::read_file}.
read_text <- function(f) {
  readChar(f, file.info(f)$size)
}


call_js <- function(f, ...) {
  ctx <- v8()
  ctx$eval(app_js)
  ctx$eval(main_js)
  ctx$call(f, ...)
}


split_space <- function(s) {
  strsplit(s, "\\s+", fixed = FALSE)
}


assign_in_namespace <- function(x, value, ns) {
  namespace <- if (is.character(ns)) asNamespace(ns) else ns

  .BaseNamespaceEnv$unlockBinding(x, namespace)
  on.exit(.BaseNamespaceEnv$lockBinding(x, namespace))
  assign(x, value, envir = namespace)
}

bool_option <- function(opt) {
  length(v <- getOption(opt)) && v
}

debugging <- function() {
  bool_option("rdocsyntax.dev")
}
