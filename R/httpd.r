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
  fileRegexp <- "^/library/+([^/]*)/html/([^/]*)\\.html$"

  function(path, ...) {
    tryCatch({
      if (grepl("^/(doc|library)/", path)) {
        response <- httpd(path, ...)

        if (
          length(payload <- response[["payload"]]) &&
          is_html_payload(response) &&
          grepl(fileRegexp, path)
        ) {
          response[["payload"]] <-
            if (server_side_highlighting()) {
              if (!requireNamespace("V8", quietly = TRUE)) {
                if (debugging()) {
                  cat(
                    "Warning: rdocsyntax:",
                    "Package \"V8\" needed for server side highlighting to work.",
                    "Revert to client side highlighting for now.",
                    "Set to client side highlighting permanently with",
                    "\"options(rdocsyntax.server_side_highlighting = NULL)\""
                  )
                }

                highlight_html_client(payload)
              } else highlight_html(payload, call_js = call_js_())
            } else highlight_html_client(payload)
        } else if (
          length(file <- response[["file"]]) &&
          (tolower(file_ext(file)) == "html" || is_html_file(response)) &&
          enable_extra() &&
          server_side_highlighting()
        ) {
          if (!requireNamespace("V8", quietly = TRUE)) {
            if (debugging()) {
              cat(
                "Warning: rdocsyntax:",
                "Package \"V8\" needed for server side highlighting to work."
              )
            }
          } else {
            response[["file"]] <-
              highlight_html_file(file, call_js = call_js_())

            names(response) <-
              ifelse(names(response) == "file", "payload", names(response))
          }
        }

        response
      } else if (!server_side_highlighting()) {
        bundle_regexp <- "^/rdocsyntax/bundle.js$"

        if (grepl(bundle_regexp, path)) {
          response <- list(
            file = system.file("client", "js", "bundle.js", package = packageName()),
            "content-type" = "text/javascript"
          )
        }
      }
    }, error = function(e) {
      if (debugging()) {
        cat(sprintf("Error with rdocsyntax help server: %s", e))
      }
    })
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
