original_httpd <- NULL


get_original_httpd <- function() {
  if (is.null(original_httpd)) {
    assignInMyNamespace("original_httpd", get_httpd())
  }

  original_httpd
}


get_httpd <- function() { get("httpd", envir = asNamespace("tools")) }


new_httpd <- function() {
  httpd <- get_original_httpd()

  function(...) {
    response <- httpd(...)

    file <- response[["file"]]
    payload <- response[["payload"]]
    if (!is.null(file)) {
      response[["file"]] <- system.file("lapply.html", package = packageName())
    }

    if (!is.null(payload) && check_html_payload(response)) {
      response[["payload"]] <-
        read_file(system.file("lapply.html", package = packageName()))
    }

    response
  }
}


assign_httpd <- function(httpd) {
  ns <- asNamespace("tools")

  unlockBinding("httpd", ns)
  assign("httpd", httpd, envir = ns)
  lockBinding("httpd", ns)
}


replace_httpd <- function() {
  assign_httpd(new_httpd())
}


restore_httpd <- function() {
  assign_httpd(get_original_httpd())
}


check_html_payload <- function(response) {
  content_type <- response[["content-type"]]
  status <- response[["status code"]]

  is.null(content_type) && is.null(status) ||
    content_type == 'text/html' && status >= 200L && status <= 299L
}


start_dynamic_help <- function() {
  try(tools::startDynamicHelp(TRUE), silent = FALSE)
}
