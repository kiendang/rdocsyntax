#' @importFrom V8 v8
#' @importFrom utils assignInMyNamespace packageName
#' @import xml2
#' @import rvest
NULL


#' @export
enable_html_doc_highlight <- function() {
  replace_httpd()
  start_dynamic_help()
}


#' @export
restore_original_html_doc <- function() {
  restore_httpd()
  assignInMyNamespace("original_httpd", NULL)
}
