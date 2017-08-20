check_running <- function(pid){
    r <- system(paste0("kill -s 0 ", pid), intern = TRUE)
    length(attr(r, "status")) == 0
}

create_proj <- function(folder){
    dir.create(file.path(folder, "/Rproj"), recursive = TRUE)
    file.create(file.path(folder, "/Rproj/Rproj.Rproj"))
    writeLines("Version: 1.0", file.path(folder, "/Rproj/Rproj.Rproj"))
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
    # folder <- tempdir()
    folder <- "/tmp"
    create_proj(folder)
    rsession_pidfile <- tempfile()
    file.create(rsession_pidfile)
    rerror_file <- tempfile()
    file.create(rerror_file)
    rfinish_file <- tempfile()
    file.create(rfinish_file)
    finish_writing <- paste0("writeLines('Succeed', '", rfinish_file, "')")
    block <- paste0(code, "; ", finish_writing)
    code <- paste0("writeLines(deparse(Sys.getpid()+0), '", rsession_pidfile, "');
                   options(error = function(){writeLines(geterrmessage(), '", rerror_file, "')});
                   library(tcltk2);
                   tclTaskSchedule(3000,
                                   rstudioapi::sendToConsole(\"", block, "\"))")
    inject_code(code, file.path(folder, "/Rproj/.Rprofile"))
    rstudio_pid <- start_and_get_pid(paste0("rstudio ", file.path(folder, "/Rproj/Rproj.Rproj")))

    message(paste0("Start a new RStudio process with pid = ", rstudio_pid))

    Sys.sleep(1) ## wait for the content to write into the pidfile
    rsession_pid <- readLines(rsession_pidfile)

    message(paste0("The rsession has pid = ", rsession_pid))

    stopifnot(length(rstudio_pid) == 1)
    stopifnot(length(rsession_pid) == 1)

    list(rstudio = rstudio_pid, rsession = rsession_pid,
         rerror = rerror_file, rfinish = rfinish_file)
}

#' Check the code in RStudio.
#'
#' \code{detailed_check_in_rstudio} checks the code in RStudio.
#'
#' @param code the code you want to test in RStudio
#' @param time the time for the testing
#'
#' @return a list,
#'     the component crashed means whether rsession is crashed,
#'     the component finished means whether the code runs to the end successfully,
#'     the component errmsg is the error message of the code (if any).
#'
#' @examples
#' \dontrun{
#' detailed_check_in_rstudio("1")
#' }
#'
#' @export
detailed_check_in_rstudio <- function(code, time = 20){
    r <- start_rstudio_and_inject_code(code)
    rstudio_pid <- r$rstudio
    rsession_pid <- r$rsession

    Sys.sleep(time)

    crashed <- !check_running(rsession_pid)
    system(paste0("kill ", rstudio_pid))
    finished <- length(readLines(r$rfinish)) == 1 && readLines(r$rfinish) == "Succeed"
    errmsg <- readLines(r$rerror)

    list(crashed = crashed, finished = finished, errmsg = errmsg)
}

#' Check the code in RStudio.
#'
#' \code{check_in_rstudio} checks the code in RStudio.
#'
#' @param code the code you want to test in RStudio
#' @param time the time for the testing
#'
#' @return whether or not the code runs in RStudio successfully.
#'
#' @examples
#' \dontrun{
#' check_in_rstudio("1")
#' }
#'
#' @export
check_in_rstudio <- function(code, time = 20){
    r <- detailed_check_in_rstudio(code, time)

    if (length(r$errmsg) > 0) {
        warning(r$errmsg)
    }

    if (r$crashed) {
        warning("The rsession is crashed by your code.")
    }

    if (!r$finished) {
        warning("The code didn't finish running.")
    }

    length(r$errmsg) == 0 && !r$crashed && r$finished
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
check_rstudio <- function(){
    check_in_rstudio("1")
}
