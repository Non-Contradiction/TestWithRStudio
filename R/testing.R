check_rsession <- function(){
    tt <- 'if pgrep -x "rsession" > /dev/null
           then
               echo "Running"
           else
               echo "Stopped"
           fi'

    system(tt, intern = TRUE) == "Running"
}

move <- function(from, dest){
    system(paste0("cp -R ", from, " ", dest))
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
#'
#' @examples
#' check_code_in_rstudio("1")
#'
#' @export
check_code_in_rstudio <- function(code){
    inject_into_rstudio(code)
    check_rsession()
}
