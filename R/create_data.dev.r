app_js <- readr::read_file(file.path("inst", "js", "app.js"))
main_js <- readr::read_file(file.path("inst", "js", "main.js"))
dark_css <- readr::read_file(file.path("inst", "dark.css"))

usethis::use_data(app_js, main_js, dark_css, internal = TRUE, overwrite = TRUE)
