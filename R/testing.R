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

#' Start a new RStudio process and "inject" some codes into it.
#'
#' \code{inject_into_rstudio} start a new RStudio process and "inject" some codes into it.
#'
#' @param code the code you want to inject into RStudio
#'
#' @examples
#' inject_into_rstudio("1")
#'
#' @export
inject_into_rstudio <- function(code){
    folder = "/tmp"
    create_proj(folder)
    inject(code, folder)
    system(paste0("rstudio ", paste0(folder, "/Rproj/Rproj.Rproj")), wait = FALSE)
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
check_code_in_rstudio <- function(code, time = 60){
    before <- no_of_rsession()
    inject_into_rstudio(code)
    Sys.sleep(time)
    after <- no_of_rsession()
    after > before
}
