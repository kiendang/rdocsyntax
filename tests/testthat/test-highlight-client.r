doc_path <- function(term, package = "base") {
  sprintf("/library/%s/html/%s.html", package, term)
}


test_that("Highlighting script is attached", {
  withr::with_options(list(rdocsyntax.server_side_highlighting = NULL), {
    path <- doc_path("lapply")

    original <- get_original_httpd()(path)$payload
    highlighted <- new_httpd()(path)$payload
    Encoding(highlighted) <- "UTF-8"

    parsed <- read_html(highlighted, options = c())

    expect_length(
      html_nodes(parsed, sprintf("script#%s", highlight_script_id())),
      1
    )
  })
})


test_that("Theme is applied when running outside RStudio", {
  withr::with_options(list(
    rdocsyntax.server_side_highlighting = NULL,
    rdocsyntax.theme = "dracula"
  ), withr::with_envvar(c("RSTUDIO" = NULL), {
    path <- doc_path("lapply")

    original <- get_original_httpd()(path)$payload
    highlighted <- new_httpd()(path)$payload
    Encoding(highlighted) <- "UTF-8"

    parsed <- read_html(highlighted, options = c())

    expect_length(
      html_nodes(
        parsed,
        sprintf(
          "style#%s",
          theme_css_id()
        )
      ),
      1
    )

    expect_length(
      html_nodes(
        parsed,
        sprintf(
          "style#%s.%s",
          scheme_css_id(),
          dark_scheme_css_class()
        )
      ),
      1
    )
  }))
})
