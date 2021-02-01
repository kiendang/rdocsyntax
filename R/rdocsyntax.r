#' @importFrom V8 v8
#' @importFrom readr read_file
#' @import xml2
#' @import rvest


#' @export
enable_html_doc_highlight <- function() {
  replace_httpd()
  start_dynamic_help()
}


#' @export
restore_original_html_doc <- function() {
  restore_httpd()
}
