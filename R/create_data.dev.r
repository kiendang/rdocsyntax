app_js <- readr::read_file(file.path("inst", "server", "js", "app.js"))
main_js <- readr::read_file(file.path("inst", "server", "js", "main.js"))
dark_css <- readr::read_file(file.path("inst", "server", "dark.css"))
light_css <- readr::read_file(file.path("inst", "server", "light.css"))

bundle_js <- readr::read_file(file.path("inst", "client", "js", "bundle.js"))


usethis::use_data(
  app_js, main_js, dark_css, light_css, bundle_js,
  internal = TRUE, overwrite = TRUE
)
