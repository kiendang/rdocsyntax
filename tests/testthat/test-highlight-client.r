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
      lib_ <- xml_find_all(
        parsed,
        sprintf(".//script[@id=\"%s\"]", lib_script_id())
      ),
      1
    )

    lib <- lib_[[1]]
    expect_match(xml_attr(lib, "src"), "/rdocsyntax/lib.js")

    expect_length(
      main_ <- xml_find_all(
        parsed,
        sprintf(".//script[@id=\"%s\"]", main_script_id())
      ),
      1
    )

    main <- main_[[1]]
    expect_match(xml_attr(main, "src"), "/rdocsyntax/main.js")
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
      xml_find_all(
        parsed,
        sprintf(".//style[@id=\"%s\"]", theme_css_id())
      ),
      1
    )

    expect_length(
      xml_find_all(
        parsed,
        sprintf(
          ".//style[@id=\"%s\" and contains(concat(\" \", normalize-space(@class), \" \"), \" %s \")]",
          scheme_css_id(),
          dark_scheme_css_class()
        )
      ),
      1
    )
  }))
})
