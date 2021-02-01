#' @importFrom V8 v8
#' @importFrom readr read_file
#' @importFrom xml2 read_html xml_find_all xml_text xml_text<-


#' @export
enable_doc_syntax_highlight <- function() {
  replace_httpd()
  start_dynamic_help()
}


#' @export
restore_original_doc <- function() {
  restore_httpd()
}
