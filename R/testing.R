check_running <- function(pid){
    r <- system(paste0("kill -s 0 ", pid), intern = TRUE)
    length(attr(r, "status")) == 0
}

create_proj <- function(folder){
    dir.create(file.path(folder, "/Rproj"), recursive = TRUE)
    file.create(file.path(folder, "/Rproj/Rproj.Rproj"))
    writeLines("Version: 0.99", file.path(folder, "/Rproj/Rproj.Rproj"))
}

inject_code <- function(code, Rprofile){
    file.create(Rprofile)
    writeLines(code, Rprofile)
}

start_and_get_pid <- function(cmd){
    pidfile <- tempfile()
    # print(pidfile)
    system(paste0(cmd, " & echo $! > ", pidfile), wait = FALSE)
    Sys.sleep(1) ## wait for the content to write into the pidfile
    readLines(pidfile)
}

start_rstudio_and_inject_code <- function(code){
    folder <- tempdir()
    create_proj(folder)
    rsession_pidfile <- tempfile()
    # file.create(rsession_pidfile)
    code <- paste0("writeLines(deparse(Sys.getpid()+0), '", rsession_pidfile, "'); ", code)
    inject_code(code, file.path(folder, "/Rproj/.Rprofile"))
    rstudio_pid <- start_and_get_pid(paste0("rstudio ", file.path(folder, "/Rproj/Rproj.Rproj")))

    message(paste0("Start a new RStudio process with pid = ", rstudio_pid))

    Sys.sleep(1) ## wait for the content to write into the pidfile
    rsession_pid <- readLines(rsession_pidfile)

    message(paste0("The rsession has pid = ", rsession_pid))

    stopifnot(length(rstudio_pid) == 1)
    stopifnot(length(rsession_pid) == 1)

    list(rstudio = rstudio_pid, rsession = rsession_pid)
}

#' Check whether the code crash RStudio or not.
#'
#' \code{check_code_in_rstudio} checks whether the code crash RStudio or not.
#'
#' @param code the code you want to test in RStudio
#' @param time the time for the testing
#'
#' @examples
#' \dontrun{
#' check_code_in_rstudio("1")
#' }
#'
#' @export
check_code_in_rstudio <- function(code, time = 30){
    Sys.sleep(time)
    r <- start_rstudio_and_inject_code(code)
    rstudio_pid <- r$rstudio
    rsession_pid <- r$rsession

    Sys.sleep(time)
    r <- check_running(rsession_pid)
    system(paste0("kill ", rstudio_pid))
    r
}

#' Check whether RStudio is available or not.
#'
#' \code{check_rstudio} checks whether RStudio is available or not.
#'
#' @examples
#' \dontrun{
#' check_rstudio()
#' }
#'
#' @export
check_rstudio <- function() check_code_in_rstudio("")
