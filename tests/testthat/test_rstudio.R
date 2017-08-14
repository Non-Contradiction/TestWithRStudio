context("RStudio Test")

test_that("test whether the package works in RStudio or not", {
    system("rstudio", wait = FALSE)
    Sys.sleep(20)
    expect_true(rstudioapi::isAvailable())
    rstudioapi::sendToConsole("library('TestWithRStudio'); crash <- setup()")
    Sys.sleep(20)
    expect_true(rstudioapi::isAvailable())

    #rstudioapi::sendToConsole("crash$crash()")
    #Sys.sleep(20)
    #expect_false(rstudioapi::isAvailable())
})
