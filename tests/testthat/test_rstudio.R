context("Test for RStudio")

test_that("basic test", {
    expect_true(check_code_in_rstudio("1"))
    expect_false(check_code_in_rstudio("q()"))
    expect_false(check_code_in_rstudio("library(TestWithRStudio); crash()", 10))
})
