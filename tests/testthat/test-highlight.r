test_unmodified_text_after_highlight <- function(code) {
  highlighted <- call_js_()("highlightCode", code)
  parsed <- read_xml(highlighted, options = c())
  after_text <- xml_text(parsed)
  expect_identical(trimws(code), trimws(after_text))
}


test_cases <- c(
# from ?lapply
'
require(stats); require(graphics)

x <- list(a = 1:10, beta = exp(-3:3), logic = c(TRUE,FALSE,FALSE,TRUE))
# compute the list mean for each list element
lapply(x, mean)
# median and quartiles for each list element
lapply(x, quantile, probs = 1:3/4)
sapply(x, quantile)
i39 <- sapply(3:9, seq) # list of vectors
sapply(i39, fivenum)
vapply(i39, fivenum,
       c(Min. = 0, "1st Qu." = 0, Median = 0, "3rd Qu." = 0, Max. = 0))

## sapply(*, "array") -- artificial example
(v <- structure(10*(5:8), names = LETTERS[1:4]))
f2 <- function(x, y) outer(rep(x, length.out = 3), y)
(a2 <- sapply(v, f2, y = 2*(1:5), simplify = "array"))
a.2 <- vapply(v, f2, outer(1:3, 1:5), y = 2*(1:5))
stopifnot(dim(a2) == c(3,5,4), all.equal(a2, a.2),
          identical(dimnames(a2), list(NULL,NULL,LETTERS[1:4])))

hist(replicate(100, mean(rexp(10))))

## use of replicate() with parameters:
foo <- function(x = 1, y = 2) c(x, y)
# does not work: bar <- function(n, ...) replicate(n, foo(...))
bar <- function(n, x) replicate(n, foo(x = x))
bar(5, x = 3)
',
"f <- function(x) x * 2'",
"x",
"",
" ",
"x <- "
)


test_that("test code is unmodified after syntax highlighting", {
  for (code in test_cases) {
    test_unmodified_text_after_highlight(code)
  }
})


test_newline_inline_notrun <- function(code, expected) {
  highlighted <- call_js_()("highlight", code)
  parsed <- read_xml(highlighted, options = c())
  after_text <- xml_text(parsed)
  expect_identical(trimws(after_text), trimws(expected))
}


inline_notrun_test_cases <- list(
# from ?rstudioapi::highlightUi
c(
'## Not run: rstudioapi::highlightUi(
  list(
    list(
      query="#rstudio_workbench_panel_git",
      callback="rstudioapi::highlightUi(\'\')"
    )
  )
)
## End(Not run)',
'## Not run:
rstudioapi::highlightUi(
  list(
    list(
      query="#rstudio_workbench_panel_git",
      callback="rstudioapi::highlightUi(\'\')"
    )
  )
)
## End(Not run)'
),
c(
'## Not run: rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")',
'## Not run:
rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")'
),
c(
'## Not run:
rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")',
'## Not run:
rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")'
),
c(
'rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")',
'rstudioapi::highlightUi(".rstudio_chunk_setup .rstudio_run_chunk")'
)
)


test_that("Test inserting newline for inline Not run", {
  for (case in inline_notrun_test_cases) {
    test_newline_inline_notrun(case[1], case[2])
  }
})


test_highlight_node <- function(code) {
  node <- html_element(read_html(sprintf("<pre>%s</pre>", code)), "pre")
  highlighted <- highlight_node(node)
  expect_true(ace_default_css_class() %in% xml_node_classes(highlighted))
}


test_that("Test highlighted text by css class", {
  for (case in test_cases) {
    if (trimws(case) != "") test_highlight_node(case)
  }
})
