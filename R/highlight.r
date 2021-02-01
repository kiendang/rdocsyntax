highlight <- function(s) {
  ctx <- v8()
  ctx$source(system.file("js", "main.js", package = packageName()))
  ctx$source(system.file("js", "app.js", package = packageName()))
  ctx$call("highlight", s)
}


highlight_html <- function(html) {

}
