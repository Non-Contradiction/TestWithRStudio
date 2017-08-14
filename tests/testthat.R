Sys.setenv("R_TESTS" = "")
library(testthat)
library(TestWithRStudio)

test_check("TestWithRStudio")
