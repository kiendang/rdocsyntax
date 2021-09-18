local({
  app_js <- readr::read_file(file.path("inst", "js", "app.js"))
  main_js <- readr::read_file(file.path("inst", "js", "main.js"))
  client_js <- readr::read_file(file.path("inst", "js", "index.js"))
  dark_css <- readr::read_file(file.path("inst", "dark.css"))
  light_css <- readr::read_file(file.path("inst", "light.css"))


  theme_names <- c(
    "ambiance",
    "chaos",
    "chrome",
    "clouds",
    "clouds_midnight",
    "cobalt",
    "crimson_editor",
    "dawn",
    "dracula",
    "dreamweaver",
    "eclipse",
    "github",
    "gob",
    "gruvbox",
    "idle_fingers",
    "iplastic",
    "katzenmilch",
    "kr_theme",
    "kuroir",
    "merbivore",
    "merbivore_soft",
    "mono_industrial",
    "monokai",
    "nord_dark",
    "pastel_on_dark",
    "solarized_dark",
    "solarized_light",
    "sqlserver",
    "terminal",
    "textmate",
    "tomorrow",
    "tomorrow_night",
    "tomorrow_night_blue",
    "tomorrow_night_bright",
    "tomorrow_night_eighties",
    "twilight",
    "vibrant_ink",
    "xcode"
  )

  theme_files <-
    file.path("ace", "build", "src-min", sprintf("theme-%s.js", theme_names))

  ctx <- V8::v8(global = "window")
  ctx$source(file.path("ace", "build", "src-min", "ace.js"))

  for (f in theme_files) {
    ctx$source(f)
  }

  ctx$eval(paste(
    "const getTheme = (theme) => ",
    "(({ isDark, cssClass, cssText }) => ({ isDark, cssClass, cssText }))",
    "(require(`ace/theme/${theme}`))",
    collapse = ""
  ))

  ace_generic_css_class <- "ace_editor_theme"

  themes <- sapply(theme_names, function(t) {
    theme <- ctx$call("getTheme", t)
    theme$cssText <- gsub(theme$cssClass, ace_generic_css_class, theme$cssText)
    theme
  }, simplify = FALSE, USE.NAMES = TRUE)

  for (t in theme_names) {
    testthat::expect_true(
      length(theme <- themes[[t]]) &&
        is.logical(isDark <- theme$isDark) &&
        !is.na(isDark) && (isDark || TRUE) &&
        is.character(css <- theme$cssText) &&
        !is.na(css) && grepl(ace_generic_css_class, css),
      label = t
    )
  }


  usethis::use_data(
    app_js, main_js, client_js, dark_css, light_css, themes,
    internal = TRUE, overwrite = TRUE
  )
})
