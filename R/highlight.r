highlight_text <- function(s) {
  call_js("highlight", s)
}


get_theme_css <- function(theme = NULL) {
  call_js("getThemeCSS", theme)
}


add_theme_css <- function(doc, theme = NULL) {
  xml_add_child(
    xml_find_first(doc, "//head"), "style", get_theme_css(theme)
  )
  doc
}


highlight_html <- function(html) {
  doc <- read_html(html)

  code_nodes <- html_nodes(doc, "pre")

  if (!length(code_nodes)) {
    return(html)
  }

  for (node in code_nodes) {
    highlight_node(node)
  }

  if (!rstudioapi::isAvailable()) {
    add_theme_css(doc)
  }

  as.character(doc, options = c())
}


highlight_node <- function(node) {
  code <- html_text(node)
  highlighted <- html_node(read_html(highlight_text(code)), ".ace-tm")
  remove_indent_guides(highlighted)
  xml_text(node) <- ""
  xml_add_child(node, highlighted)
}


remove_indent_guides <- function(doc) {
  nodes <- html_nodes(doc, ".ace_indent-guide")

  for (node in nodes) {
    remove_classes(node, "ace_indent-guide")
  }

  doc
}


remove_classes <- function(node, classes) {
  xml_attr(node, "class") <-
    if (length(cls <- setdiff(split_space(xml_attr(node, "class"))[[1]], classes))) {
      cls
    } else ""
  node
}
