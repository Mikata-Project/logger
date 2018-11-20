#' Concatenate strings via \code{paste}
#' @param ... passed to \code{paste}
#' @return character vector
#' @export
formatter_paste <- function(...) {
    paste(...)
}


#' Apply \code{sprintf}
#' @param fmt passed to \code{sprintf}
#' @param ... passed to \code{sprintf}
#' @return character vector
#' @export
formatter_sprintf <- function(fmt, ...) {
    sprintf(fmt, ...)
}


#' Apply \code{glue}
#' @param ... passed to \code{glue} for the text interpolation
#' @return character vector
#' @export
formatter_glue <- function(...) {
    as.character(glue(..., .envir = parent.frame()))
}


#' Apply \code{glue} and \code{sprintf}
#'
#' The best of both words: using both formatter functions in your log messages, which can be useful eg if you are migrating from \code{sprintf} formatted log messages to \code{glue} or similar.
#'
#' Note that this function tries to be smart when passing arguments to \code{glue} and \code{sprintf}, but might fail with some edge cases, and returns an unformatted string.
#' @param msg passed to \code{sprintf} as \code{fmt} or handled as part of \code{...} in \code{glue}
#' @param ... passed to \code{glue} for the text interpolation
#' @return character vector
#' @export
#' @examples \dontrun{
#' formatter_glue_or_sprinf("{a} + {b} = %s", a = 2, b = 3, 5)
#' formatter_glue_or_sprinf("{pi} * {2} = %s", pi*2)
#' formatter_glue_or_sprinf("{pi} * {2} = {pi*2}")
#'
#' formatter_glue_or_sprinf("Hi ", "{c('foo', 'bar')}, did you know that 2*4={2*4}")
#' formatter_glue_or_sprinf("Hi {c('foo', 'bar')}, did you know that 2*4={2*4}")
#' formatter_glue_or_sprinf("Hi {c('foo', 'bar')}, did you know that 2*4=%s", 2*4)
#' formatter_glue_or_sprinf("Hi %s, did you know that 2*4={2*4}", c('foo', 'bar'))
#' formatter_glue_or_sprinf("Hi %s, did you know that 2*4=%s", c('foo', 'bar'), 2*4)
#' }
formatter_glue_or_sprinf <- function(msg, ...) {

    params <- list(...)

    ## params without a name are potential sprintf params
    sprintfparams <- which(names(params) == '')
    if (length(params) > 0 & length(sprintfparams) == 0) {
        sprintfparams <- seq_along(params)
    }

    ## but some unnamed params might belong to glue actually, so
    ## let's look for the max number of first unnamed params sprintf expects
    sprintftags <- regmatches(msg, gregexpr('%[0-9.+0]*[aAdifeEgGosxX]', msg))[[1]]
    sprintfparams <- sprintfparams[seq_len(min(length(sprintftags), length(sprintfparams)))]

    ## get the actual params instead of indexes
    glueparams    <- params[setdiff(seq_along(params), sprintfparams)]
    sprintfparams <- params[sprintfparams]

    ## first try to apply sprintf
    if (length(sprintfparams) > 0) {
        sprintfparams[vapply(sprintfparams, is.null, logical(1))] <- 'NULL'
        msg <- tryCatch(
            do.call(sprintf, c(msg, sprintfparams)),
            error = function(e) msg)
    }

    ## then try to glue
    msg <- tryCatch(
        as.character(sapply(msg, function(msg) {
            do.call(glue, c(msg, glueparams))
        }, USE.NAMES = FALSE)),
        error = function(e) msg)

    ## return
    msg

}