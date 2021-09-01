highlight_html <- function(html, encoding = "", call_js = call_js_()) {
  doc <- read_html(html)

  if (!rstudioapi::isAvailable()) {
    theme <- get_user_theme(call_js = call_js)
    add_css(doc, theme$cssText)
    add_css(doc, if (theme$isDark) dark_css else light_css)
    style_body(doc)
  }

  text_code_nodes <- xml_find_all(doc, ".//pre[count(*)=0]")
  html_code_nodes <- html_nodes(doc, "pre code.sourceCode.r")

  for (node in text_code_nodes) {
    highlight_text_node(node, call_js = call_js)
  }

  for (node in html_code_nodes) {
    highlight_html_node(node, call_js = call_js)
  }

  replace_theme_css_class(doc, ace_default_css_class(), ace_generic_css_class())

  iconv(
    as.character(doc, options = c(), encoding = encoding),
    from = encoding,
    to = ""
  )
}


highlight_text <- function(s, call_js = call_js_()) {
  call_js("highlight", s)
}


get_user_theme <- function(call_js = call_js_()) {
  if (
    (!rstudioapi::isAvailable()) &&
    length(theme <- getOption("rdocsyntax.theme")) &&
    is.character(theme)
  ) {
    get_theme(theme[1], call_js = call_js)
  } else {
    get_theme(call_js = call_js)
  }
}


get_theme <- function(theme, call_js = call_js_()) {
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


highlight_node <- function(node, call_js = call_js_()) {
  if (!length(code <- html_text(node)) || { code <- trimws(code) } == "") {
    return(node)
  }

  highlighted <- html_node(
    read_html(highlight_text(code, call_js = call_js)),
    "body > div[class*=\"ace\"]"
  )
  remove_indent_guides(highlighted)

  highlighted
}


highlight_text_node <- function(node, call_js = call_js_()) {
  highlighted <- highlight_node(node, call_js = call_js)

  xml_text(node) <- ""

  xml_add_child(node, highlighted)
}


highlight_html_node <- function(node, call_js = call_js_()) {
  highlighted <- highlight_node(node, call_js = call_js)
  remove_classes(highlighted, ace_default_css_class())

  texts <- xml_find_all(node, ".//text()")
  xml_text(texts) <- ""

  for (child in xml_children(node)) {
    xml_remove(child)
  }

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
  body <- html_nodes(doc, "body")

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
