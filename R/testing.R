no_of_rsession <- function(){
    eval(parse(text = system("pgrep rsession| wc -l", intern = TRUE)[1]))
}

create_proj <- function(folder){
    file.copy(from = system.file("Rproj", package = "TestWithRStudio"), to = folder,
              recursive = TRUE)
}

inject <- function(code, folder){
    file.create(paste0(folder, "/Rproj/.Rprofile"))
    writeLines(code, paste0(folder, "/Rproj/.Rprofile"))
}

start_and_get_pid <- function(cmd){
    pidfile <- tempfile()
    system(paste0(cmd, " & echo $! > ", pidfile), wait = FALSE)
    readLines(pidfile)
}

#' Start a new RStudio process and "inject" some codes into it.
#'
#' \code{inject_into_rstudio} start a new RStudio process and "inject" some codes into it.
#'
#' @param code the code you want to inject into RStudio
#'
#' @examples
#' pid <- inject_into_rstudio("1")
#'
#' @export
inject_into_rstudio <- function(code){
    folder = tempdir()
    create_proj(folder)
    inject(code, folder)
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
check_code_in_rstudio <- function(code, time = 30){
    before <- no_of_rsession()
    pid <- inject_into_rstudio(code)
    Sys.sleep(time)
    after <- no_of_rsession()
    system(paste0("kill ", pid))
    after > before
}
