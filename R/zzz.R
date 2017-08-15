#' Crash, an example to crash the rsession.
#'
#' \code{crash} crashes the rsession.
#'
#' @examples
#' \dontrun{
#' crash()
#' }
#'
#' @export
crash <- function(){
    .crash <- inline::cfunction(
        sig = c(),
        body = "
        return (SEXP)1;"
        )

    .crash()
}
