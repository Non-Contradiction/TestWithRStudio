no_of_rsession <- function(){
    eval(parse(text = system("pgrep rsession| wc -l", intern = TRUE)[1]))
}

create_proj <- function(folder){
    dir.create(paste0(folder, "/Rproj"), recursive = TRUE)
    file.create(paste0(folder, "/Rproj/Rproj.Rproj"))
    writeLines("Version: 1.0", paste0(folder, "/Rproj/Rproj.Rproj"))
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
    inject_code(code, paste0(folder, "/Rproj/.Rprofile"))
    start_and_get_pid(paste0("rstudio ", paste0(folder, "/Rproj/Rproj.Rproj")))
}

#' Check whether the code crash RStudio or not.
#'
#' \code{check_code_in_rstudio} checks whether the code crash RStudio or not.
#'
#' @param code the code you want to test in RStudio
#' @param time the time for the testing
#'
#' @examples
#' testthat::expect_true(check_code_in_rstudio("1"))
#' testthat::expect_false(check_code_in_rstudio("q()"))
#' testthat::expect_false(check_code_in_rstudio("library(TestWithRStudio); crash()"))
#'
#' @export
check_code_in_rstudio <- function(code, time = 10){
    before <- no_of_rsession()
    pid <- start_rstudio_and_inject_code(code)
    stopifnot(length(pid) == 1)
    # print(pid)
    Sys.sleep(time)
    after <- no_of_rsession()
    system(paste0("kill ", pid))
    after > before
}

#' Check whether RStudio is available or not.
#'
#' \code{check__rstudio} checks whether RStudio is available or not.
#'
#' @examples
#' testthat::expect_true(check_rstudio())
#'
#' @export
check_rstudio <- function(){
    pid <- start_rstudio_and_inject_code("")
    Sys.sleep(1)
    r <- no_of_rsession() > 0
    # print(pid)
    system(paste0("kill ", pid))
    r
}

