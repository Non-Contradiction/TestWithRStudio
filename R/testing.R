no_of_rsession <- function(){
    eval(parse(text = system("pgrep rsession| wc -l", intern = TRUE)[1]))
}

create_proj <- function(folder){
    file.copy(from = system.file("Rproj", package = "TestWithRStudio"), to = folder,
              recursive = TRUE)
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
    folder <- "/tmp"
    create_proj(folder)
    inject_code(code, paste0(folder, "/Rproj/.Rprofile"))
    start_and_get_pid(paste0("rstudio ", paste0(folder, "/Rproj/Rproj.Rproj")))
}

#' Check whether the code crash RStudio or not.
#'
#' \code{check_code-in_rstudio} checks whether the code crash RStudio or not.
#'
#' @param code the code you want to test in RStudio
#' @param time the time for the testing
#'
#' @examples
#' check_code_in_rstudio("1")
#'
#' @export
check_code_in_rstudio <- function(code, time = 20){
    before <- no_of_rsession()
    pid <- start_rstudio_and_inject_code(code)
    stopifnot(length(pid) == 1)
    # print(pid)
    Sys.sleep(time)
    after <- no_of_rsession()
    system(paste0("kill ", pid))
    after > before
}
