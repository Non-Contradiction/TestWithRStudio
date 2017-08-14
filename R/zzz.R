.crash <- new.env(parent = emptyenv())

#' Do initial setup for the TestWithRStudio package.
#'
#' \code{setup} does the initial setup for the TestWithRStudio package.
#'
#' @examples
#' crash <- setup()
#'
#' @export
setup <- function(){
    .crash$crash <- inline::cfunction(
        sig = c(),
        body = "
        return (SEXP)1;"
        )

    .crash
}
