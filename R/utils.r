# Create a temp file preloaded with content and return the file path.
tempf <- function(content, ...) {
  tmp <- tempfile(...)
  cat(content, file = tmp)
  tmp
}


call_js_ <- function() {
  ctx <- v8()
  ctx$eval(app_js)
  ctx$eval(main_js)

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

native_encoding <- function() {
  l10n <- l10n_info()

  if (l10n$`UTF-8`) {
    "UTF-8"
  } else if (l10n$`Latin-1`) {
    "latin1"
  } else ""
}

is_rstudio <- function() {
  Sys.getenv("RSTUDIO") == "1"
}
