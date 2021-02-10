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
    theme <- get_user_theme()
    add_css(doc, theme$cssText)
    if (theme$isDark) {
      add_css(doc, dark_css)
    }
    style_body(doc)
  }

  replace_theme_css_class(doc, ace_default_css_class(), ace_generic_css_class())

  as.character(doc, options = c())
}


highlight_text <- function(s) {
  call_js("highlight", s)
}


get_user_theme <- function() {
  if (
    (!rstudioapi::isAvailable()) &&
    length(theme <- getOption("rdocsyntax.theme")) &&
    is.character(theme)
  ) {
    get_theme(theme[1])
  } else {
    get_theme()
  }
}


get_theme <- function(theme) {
  t <- if (missing(theme)) call_js("getTheme") else call_js("getTheme", theme)
  t$cssText <- gsub(t$cssClass, ace_generic_css_class(), t$cssText)
  t
}


add_css <- function(doc, css) {
  xml_add_child(xml_find_first(doc, "//head"), "style", css)
  doc
}


ace_generic_css_class <- function() { "ace_editor_theme" }
ace_default_css_class <- function() { "ace-tm" }


highlight_node <- function(node) {
  code <- html_text(node)
  highlighted <- html_node(
    read_html(highlight_text(code)),
    "body > div[class*=\"ace\"]"
  )
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


replace_theme_css_class <- function(doc, from, to) {
  nodes <- html_nodes(doc, paste0(".", from))

  for (node in nodes) {
    classes <- xml_node_classes(node)
    new_classes <- ifelse(classes == from, to, classes)
    xml_attr(node, "class") <- list_to_class(new_classes)
  }
}


remove_classes <- function(node, classes) {
  new_classes <-
    if (length(cls <- setdiff(xml_node_classes(node), classes))) {
      cls
    } else ""

  xml_attr(node, "class") <- list_to_class(new_classes)

  node
}


style_body <- function(doc) {
  body <- html_node(doc, "body")

  new_classes <- c(xml_node_classes(body), ace_generic_css_class())

  xml_attr(body, "class") <- list_to_class(new_classes)

  doc
}


xml_node_classes <- function(node) {
  split_space(xml_attr(node, "class"))[[1]]
}


list_to_class <- function(classes) {
  paste(Filter(Negate(is.na), classes), collapse = " ")
}
