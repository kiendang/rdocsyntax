highlight_html_text_client <- function(html) {
  highlight_html_text_(html, highlight_html_client)
}


highlight_html_file_client <- function(html) {
  highlight_html_file_(html, highlight_html_client)
}


highlight_html_client <- function(doc) {
  xml_add_child(
    html_node(doc, "head"),
    xml_new_root(
      "script",
      lib_js,
      client_js
    )
  )
}


highlight_html_text_server <- function(html) {
  highlight_html_server(highlight_html_text_server_, highlight_html_text_client)(html)
}


highlight_html_file_server <- function(html) {
  highlight_html_server(highlight_html_file_server_, highlight_html_file_client)(html)
}


highlight_html_server <- function(highlight, fallback) {
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

    fallback
  } else function(html) highlight(html, call_js = call_js_())
}


highlight_html_text_server_ <- function(html, call_js = call_js_()) {
  highlight_html_text_(html,
    function(html) highlight_html_tree(html, call_js = call_js))
}


highlight_html_file_server_ <- function(html, call_js = call_js_()) {
  highlight_html_file_(html,
    function(html) highlight_html_tree(html, call_js = call_js))
}


highlight_html_text_ <- function(html, highlight) {
  Encoding(html) <- "UTF-8"

  doc <- read_html(html)
  apply_styling(doc)
  highlight(doc)

  out <- as.character(doc, options = c())
  if (.Platform$OS.type == "windows" && is_rstudio()) {
    Encoding(out) <- "unknown"
  }
  out
}


highlight_html_file_<- function(html, highlight) {
  if (!file.exists(html))
    stop(sprintf("file %s doesn't exists", html))

  doc <- read_html(html)
  apply_styling(doc)
  highlight(doc)

  out <- as.character(doc, options = c())
  if (.Platform$OS.type == "windows" && is_rstudio()) {
    Encoding(out) <- "unknown"
  }
  out
}


highlight_html_tree <- function(doc, call_js = call_js_()) {
  text_code_nodes <- xml_find_all(doc, ".//pre[count(*)=0]")
  html_code_nodes <- html_nodes(doc, "pre code.sourceCode.r")

  for (node in text_code_nodes) {
    highlight_text_node(node, call_js = call_js)
  }

  for (node in html_code_nodes) {
    highlight_html_node(node, call_js = call_js)
  }

  replace_theme_css_class(doc, ace_default_css_class(), ace_generic_css_class())
}


highlight_text <- function(s, call_js = call_js_()) {
  call_js("highlight", s)
}


apply_styling <- function(doc) {
  if (!is_rstudio()) {
    theme <- get_user_theme()
    add_css(doc, theme$cssText)
    add_css(doc, if (theme$isDark) dark_css else light_css)
    style_body(doc)
  }
}


get_user_theme <- function() {
  get_theme(getOption("rdocsyntax.theme"))
}


get_theme <- function(t) {
  if (
    length(t) &&
    is.character(t) &&
    !is.na(t) &&
    length(theme <- themes[[t]])
  ) theme else NULL
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
