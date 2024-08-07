% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/logger.R
\name{get_logger_definitions}
\alias{get_logger_definitions}
\title{Find the logger definition(s) specified for the current namespace
with a fallback to the global namespace}
\usage{
get_logger_definitions(namespace = NA_character_, .topenv = parent.frame())
}
\arguments{
\item{namespace}{override the default / auto-picked namespace with
a custom string}
}
\value{
list of function(s)
}
\description{
Find the logger definition(s) specified for the current namespace
with a fallback to the global namespace
}
\keyword{internal}
