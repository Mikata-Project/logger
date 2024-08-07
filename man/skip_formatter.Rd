% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formatters.R
\name{skip_formatter}
\alias{skip_formatter}
\title{Skip the formatter function}
\usage{
skip_formatter(message, ...)
}
\arguments{
\item{message}{character vector directly passed to the appender
function in \code{\link[=logger]{logger()}}}

\item{...}{should be never set}
}
\value{
character vector with \code{skip_formatter} attribute set to
\code{TRUE}
}
\description{
Adds the \code{skip_formatter} attribute to an object so that logger
will skip calling the formatter function(s). This is useful if you
want to preprocess the log message with a custom function instead
of the active formatter function(s). Note that the \code{message} should
be a string, and \code{skip_formatter} should be the only input for the
logging function to make this work.
}
