#' @importFrom utils assignInMyNamespace packageName
#' @importFrom tools file_ext HTMLheader
#' @import xml2
NULL


#' Toggle syntax highlighting in R HTML help pages
#'
#' @return Called for side effects. No return value.
#'
#' @details
#' R HTML help pages are rendered and served by the \link[tools:startDynamicHelp]{internal help server}
#' \code{httpd}. \code{highlight_html_docs()} enables syntax highlighting for them by replacing
#' the built-in \code{httpd} with one that receives the original HTML doc, add syntax highlighting to
#' the code examples inside, then serves the modified HTML.
#'
#' The syntax highlighter in use comes from the \href{https://ace.c9.io/}{Ace text editor},
#' the same editor which \href{https://www.rstudio.com/products/rstudio/}{Rstudio} uses.
#'
#' To disable syntax highlighting and revert to the original help server, use
#' \code{unhighlight_html_docs()}.
#'
#' In case RStudio is not running, \emph{e.g.} R console in a terminal is used instead,
#' either set option \code{help_type} to \code{"html"} \code{options(help_type = "html")}
#' to view all help pages in HTML mode by default. To view one single help page in HTML mode
#' without changing the \code{help_type} option globally, use \code{\link[utils:help]{help()}},
#' \emph{e.g.} \code{help(try, help_type = "html")}.
#'
#' @section Themes:
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
#' \item Dark themes: \code{ambiance}, \code{chaos}, \code{clouds_midnight},
#' \code{cobalt}, \code{dracula}, \code{gob}, \code{gruvbox}, \code{idle_fingers},
#' \code{kr_theme}, \code{merbivore}, \code{merbivore_soft}, \code{mono_industrial},
#' \code{monokai}, \code{nord_dark}, \code{one_dark}, \code{pastel_on_dark},
#' \code{solarized_dark}, \code{terminal}, \code{tomorrow_night}, \code{tomorrow_night_blue},
#' \code{tomorrow_night_bright}, \code{tomorrow_night_eighties}, \code{twilight},
#' \code{vibrant_ink}
#' }
#'
#' The default theme is \code{textmate} in case \code{rdocsyntax.theme} is not set or
#' set to an invalid value.
#'
#' @section Syntax highlighting for vignettes:
#' Due to security reasons, by default only code in object documentation, as accessed by
#' \code{\link[utils:Question]{?}} or \code{\link[utils:help]{help()}}, is syntax highlighted.
#' Syntax highlighting for other pages served by the dynamic help server \code{httpd}
#' including vignettes can be enabled by setting \code{options(rdocsyntax.extra = TRUE)}.
#'
#' Code in most vignettes has already been highlighted by default without the need for
#' \code{rdocsyntax}. However one might still want to enable \code{rdocsyntax} for them
#' anyway so that the color scheme matches that of RStudio. This is particularly useful
#' when RStudio is set to a dark theme since most vignettes highlight their code with
#' the \code{textmate} color scheme, which is a light theme and not dark mode friendly.
#'
#' Setting \code{rdocsyntax.extra = TRUE} does not affect user defined \code{httpd}
#' endpoints under \code{/custom/}, only those under \code{/doc/} and \code{/library/}.
#'
#' @section Client side and server side highlighting:
#' The code that does the highlighting is written in JavaScript since it depends on the
#' \href{Ace static highlighter}{https://github.com/ajaxorg/ace/blob/v1.4.13/lib/ace/ext/static_highlight.js}.
#' Previously, up to \code{v0.5.x}, highlighting was done \emph{server side}, \emph{i.e.}
#' \code{rdocsyntax} used \code{V8} to execute the JavaScript code and finished highlighting
#' the HTML doc before returning it through \code{httpd}.
#'
#' Starting from \code{v0.6.0}, highlighting has instead been done \emph{client side}.
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
#' # Switch to dracula theme (only takes effect outside of RStudio)
#' options(rdocsyntax.theme = "dracula")
#'
#' # Disable syntax highlighting
#' unhighlight_html_docs()}
#'
#' @export
highlight_html_docs <- function() {
  replace_httpd()
}


#' @rdname highlight_html_docs
#'
#' @export
unhighlight_html_docs <- function() {
  restore_httpd()
  assignInMyNamespace("original_httpd", NULL)
}
