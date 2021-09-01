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

  function(path, ...) {
    response <- httpd(path, ...)

    if (grepl("^/(doc|library)/", path)) {
      tryCatch({
        if (length(payload <- response[["payload"]]) && is_html_payload(response)) {
          fileRegexp <- "^/library/+([^/]*)/html/([^/]*)\\.html$"

          encoding <-
            if (grepl(fileRegexp, path) && {
              pkg <- sub(fileRegexp, "\\1", path)
              length(enc <- packageDescription(pkg)[["Encoding"]])
            } && enc == "UTF-8") "UTF-8" else native_encoding()

          response[["payload"]] <-
            highlight_html(payload, encoding = encoding, call_js = call_js_())
        } else if (
          length(file <- response[["file"]]) &&
          (tolower(file_ext(file)) == "html" || is_html_file(response))
        ) {
          response[["file"]] <-
            highlight_html(read_file(file), native_encoding(), call_js = call_js_())
          names(response) <-
            ifelse(names(response) == "file", "payload", names(response))
        }
      }, error = function(e) {
        if (debugging()) {
          print(sprintf("Error with rdocsyntax help server: %s", e))
        }
      })
    }

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

  (is.null(content_type) && is.null(status)) ||
    (content_type == "text/html" && status >= 200L && status <= 299L)
}


is_html_file <- function(response) {
  length(content_type <- response[["content-type"]]) &&
    tolower(content_type) == "text/html"
}
