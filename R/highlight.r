highlight <- function(s) {
  ctx <- v8()
  ctx$source(system.file("js", "main.js", package = packageName()))
  ctx$source(system.file("js", "app.js", package = packageName()))
  ctx$call("highlight", s)
}


highlight_html <- function(html) {
  doc <- read_html(html)

  code_nodes <- html_nodes(doc, "pre")

  for (node in code_nodes) {
    highlight_node(node)
  }

  as.character(doc, options = c())
}


highlight_node <- function(node) {
  code <- html_text(node)
  highlighted <- html_node(read_html(highlight(code)), ".ace-tm")
  remove_indent_guides(highlighted)
  xml_text(node) <- ""
  xml_add_child(node, highlighted)
}


remove_indent_guides <- function(doc) {
  nodes <- html_nodes(doc, ".ace_indent-guide")
  for (node in nodes) {
    xml_attr(node, "class") <-
      if (length(cls <- Filter(function(x) x != "ace_indent-guide", xml_attr(node, "class")))) {
        cls
      } else ""
  }
  doc
}
