# Create a temp file preloaded with content and return the file path.
tempf <- function(content, ...) {
  tmp <- tempfile(...)
  cat(content, file = tmp)
  tmp
}


read_text <- function(f) {
  readChar(f, file.info(f)$size)
}


call_js_ <- function() {
  ctx <- V8::v8()
  ctx$eval(lib_js)
  ctx$eval(server_js)

  function(f, ...) ctx$call(f, ...)
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
  length(v <- getOption(opt)) && !is.na(v) && v
}


debugging <- function() {
  bool_option("rdocsyntax.dev")
}


enable_extra <- function() {
  bool_option("rdocsyntax.extra")
}


server_side_highlighting <- function() {
  bool_option("rdocsyntax.server_side_highlighting")
}


is_rstudio <- function() {
  Sys.getenv("RSTUDIO") == "1"
}
