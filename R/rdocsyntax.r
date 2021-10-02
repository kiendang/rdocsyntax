#' @importFrom utils assignInMyNamespace packageName
#' @importFrom tools file_ext HTMLheader
#' @import xml2
#' @import rvest
NULL


#' Enable syntax highlighting in R HTML documentation
#'
#' @return Called for side effects. No return value.
#'
#' @details
#' R HTML help pages are rendered and served using the \link[tools:startDynamicHelp]{internal help server}
#' (\code{httpd}). This function enables syntax highlighting by replacing the original \code{httpd} with
#' one that receives the original HTML doc, makes changes to the HTML so that parts of the doc that
#' contains code would be highlighted, then serves the modified HTML.
#'
#' The syntax highlighter in use comes from the \href{https://ace.c9.io/}{Ace text editor},
#' the same editor which \href{https://www.rstudio.com/}{Rstudio} uses.
#'
#' To disable syntax highlighting and revert to the original help server, use \code{\link{unhighlight_html_docs}}.
#'
#' In case RStudio is not running, \emph{e.g.} R console in a terminal is used instead,
#' either set option \code{help_type} to \code{"html"} \code{options(help_type = "html")}
#' to view all help pages in HTML mode by default. To view one single help page in HTML mode without
#' changing the \code{help_type} option globally, use the \code{help} function, \emph{e.g.}
#' \code{help(try, help_type = "html")}.
#'
#' @section Theme:
#' When running inside RStudio, syntax highlighting always follows RStudio theme.
#'
#' When running outside RStudio, theme can be changed by setting the \code{rdocsyntax.theme}
#' option. Valid choices are:
#'
#' \itemize{
#' \item Light themes: \code{chrome}, \code{clouds}, \code{crimson_editor}, \code{dawn},
#' \code{dreamweaver}, \code{eclipse}, \code{github}, \code{iplastic}, \code{katzenmilch},
#' \code{kuroir}, \code{solarized_light}, \code{sqlserver}, \code{textmate}, \code{tomorrow},
#' \code{xcode}
#'
#' \item Dark themes: \code{ambiance}, \code{chaos}, \code{clouds_midnight}, \code{cobalt},
#' \code{dracula}, \code{gob}, \code{gruvbox}, \code{idle_fingers}, \code{kr_theme},
#' \code{merbivore}, \code{merbivore_soft}, \code{mono_industrial}, \code{monokai},
#' \code{nord_dark}, \code{pastel_on_dark}, \code{solarized_dark}, \code{terminal},
#' \code{tomorrow_night}, \code{tomorrow_night_blue}, \code{tomorrow_night_bright},
#' \code{tomorrow_night_eighties}, \code{twilight}, \code{vibrant_ink}
#' }
#'
#' The default theme is \code{textmate} in case \code{rdocsyntax.theme} is not set or
#' set to an invalid value.
#'
#' @section Client side and server side highlighting:
#' The code that does the highlighting is written in JavaScript since it depends on the
#' \href{Ace static highlighter}{https://github.com/ajaxorg/ace/blob/v1.4.12/lib/ace/ext/static_highlight.js}.
#' Previously, up to \code{v5.x}, highlighting was done \emph{server side}, \emph{i.e.}
#' \code{rdocsyntax} used \code{V8} to execute the JavaScript code and finished highlighting
#' the HTML doc before returning it through \code{httpd}.
#'
#' Starting from \code{v6.0}, highlighting has instead been done \emph{client side}.
#' The JavaScript highlighting code is injected into the original HTML doc in a \code{script} tag
#' and then executed by whatever browser that eventually displays the doc, either RStudio or
#' an external browser. Compared to server side highlighting, this is more efficient since
#' \code{rdocsyntax} no longer has to run its own JavaScript engine.
#' As a result, the heavy dependency on \code{V8} has been dropped.
#'
#' Legacy server side highlighting is still available on an opt-in basis by setting
#' \code{options(rdocsyntax.server_side_highlighting = TRUE)}.
#' \code{V8} needs to be installed for this to work.
#'
#'
#' @seealso \code{\link{unhighlight_html_docs}}
#'
#' @examples
#'
#' \dontrun{
#' # Enable syntax highlighting
#' highlight_html_docs()
#'
#' # Code in HTML documents is now highlighted
#' ?try
#' # or if help pages are not displayed in HTML mode by default,
#' # e.g. when R is not running inside RStudio
#' help(try, help_type = "html")
#'
#' # Disable syntax highlighting
#' unhighlight_html_docs()
#'
#' # Switch to dracula theme (only takes effect outside of RStudio)
#' options(rdocsyntax.theme = "dracula")}
#'
#' @export
highlight_html_docs <- function() {
  replace_httpd()
}


#' Disable HTML documentation syntax highlighting
#'
#' @description
#' Revert to the original help server for handling HTML documentation.
#'
#' @return Called for side effects. No return value.
#'
#' @seealso \code{\link{highlight_html_docs}}
#'
#' @export
unhighlight_html_docs <- function() {
  restore_httpd()
  assignInMyNamespace("original_httpd", NULL)
}
