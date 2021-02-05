% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/rdocsyntax.r
\name{highlight_html_docs}
\alias{highlight_html_docs}
\title{Enable syntax highlighting in R HTML documentation}
\usage{
highlight_html_docs()
}
\description{
Enable syntax highlighting in R HTML documentation
}
\details{
R HTML help pages are rendered and served using the \link[tools::startDynamicHelp]{internal help server} (\code{httpd}).
This function replaces the original \code{httpd} with one that receives the response from
the original server, checks if the response body contains HTML, then finds and highlights portions of the HTML
that contains code, and finally sends the new response with the HTML highlighted.

To disable syntax highlighting and revert to the original help server, use \code{\link{unhighlight_html_docs}}.

In case RStudio is not running, \emph{e.g.} R console in a terminal is used instead,
either set option \code{help_type} to \code{"html"} \code{options(help_type = "html")}
to view all help pages in HTML mode by default. To view one single help page in HTML mode without
changing the \code{help_type} option globally, use the \code{help} function, \emph{e.g.}
\code{help(try, help_type = "html")}.
}
\examples{
\dontrun{
# Enable syntax highlighting
highlight_html_docs()

# Code in HTML documents is now highlighted
?try
# or if help pages are not displayed in HTML mode by default,
# e.g. when R is not running inside RStudio
help(try, help_type = "html")

# Disable syntax highlighting
unhighlight_html_docs()
}

}
\seealso{
\code{\link{unhighlight_html_docs}}
}