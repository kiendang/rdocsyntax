original_httpd <- NULL


get_original_httpd <- function() {
  if (is.null(original_httpd)) {
    assignInMyNamespace("original_httpd", get_httpd())
  }

  original_httpd
}


get_httpd <- function() {
  get("httpd", envir = asNamespace("tools"))
}


new_httpd <- function() {
  httpd <- get_original_httpd()

  function(...) {
    response <- httpd(...)

    try({
      payload <- response[["payload"]]

      if (!is.null(payload) && is_html_payload(response)) {
        response[["payload"]] <- highlight_html(payload)
      }
    })

    response
  }
}


assign_httpd <- function(httpd) {
  assign_in_namespace("httpd", httpd, asNamespace("tools"))
}


replace_httpd <- function() {
  assign_httpd(new_httpd())
}


restore_httpd <- function() {
  assign_httpd(get_original_httpd())
}


is_html_payload <- function(response) {
  content_type <- response[["content-type"]]
  status <- response[["status code"]]

  is.null(content_type) && is.null(status) ||
    content_type == "text/html" && status >= 200L && status <= 299L
}
