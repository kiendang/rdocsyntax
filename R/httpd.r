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

  bundle_regexp <- "^/rdocsyntax/bundle.js$"

  not_found <- error_page("URL not found", 404L)

  function(path, ...) {
    highlight_html_text <- if (server_side_highlighting()) {
      highlight_html_text_server
    } else highlight_html_text_client

    highlight_html_file <- if (server_side_highlighting()) {
      highlight_html_file_server
    } else highlight_html_file_client

    tryCatch({
      if (grepl("^/rdocsyntax/", path) && !server_side_highlighting()) {
        if (grepl(bundle_regexp, path)) {
          list(
            file = system.file("js", "index.js", package = packageName()),
            "content-type" = "text/javascript"
          )
        } else not_found
      } else {
        response <- httpd(path, ...)

        if (grepl("^/(doc|library)/", path)) {
          if (
            length(payload <- response[["payload"]]) &&
            is_html_payload(response)
          ) {
            response[["payload"]] <- highlight_html_text(payload)
          } else if (
            length(file <- response[["file"]]) &&
            (tolower(file_ext(file)) == "html" || is_html_file(response)) &&
            enable_extra()
          ) {
            response[["file"]] <- highlight_html_file(file)

            names(response) <-
              ifelse(names(response) == "file", "payload", names(response))
          } else if (!server_side_highlighting()) {
            if (grepl(bundle_regexp, path)) {
              response <- list(
                file = system.file("client", "js", "bundle.js", package = packageName()),
                "content-type" = "text/javascript"
              )
            }
          }

          response
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


response_page <- function(title, msg, code) {
  list(
    payload = paste(c(HTMLheader(title), msg, "</div></body></html>"), collapse = "\n"),
    "content-type" = "text/html",
    "status code" = code
  )
}


error_page <- function(msg, code) {
  response_page("httpd error", msg, code)
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
