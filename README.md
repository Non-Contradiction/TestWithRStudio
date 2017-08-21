
<!-- README.md is generated from README.Rmd. Please edit that file -->
TestWithRStudio for Testing your R Package with RStudio in Continuous Integration
=================================================================================

[![Travis-CI Build Status](https://travis-ci.org/Non-Contradiction/TestWithRStudio.svg?branch=master)](https://travis-ci.org/Non-Contradiction/TestWithRStudio)

Why do we need `TestWithRStudio`?
---------------------------------

As an R package developer, have you met the situation that your package passes `R CMD check` but crashes RStudio? `TestWithRStudio` can help you deal with this situation by testing your R package with RStudio using continuous integration like Travis CI.

Installation
------------

You can get `TestWithRStudio` by

``` r
devtools::install_github("Non-Contradiction/TestWithRStudio")
```

Basic Usage
-----------

``` r
library(TestWithRStudio)

check_rstudio()
#> Start a new RStudio process with pid = 36777
#> The rsession has pid = 36787
#> [1] TRUE

detailed_check_in_rstudio("1")
#> Start a new RStudio process with pid = 36814
#> The rsession has pid = 36824
#> $crashed
#> [1] FALSE
#> 
#> $finished
#> [1] TRUE
#> 
#> $errmsg
#> character(0)

detailed_check_in_rstudio("q()")
#> Start a new RStudio process with pid = 36853
#> The rsession has pid = 36863
#> Warning: 运行命令'kill -s 0 36863 2>/dev/null'的状态是1
#> $crashed
#> [1] TRUE
#> 
#> $finished
#> [1] FALSE
#> 
#> $errmsg
#> character(0)

detailed_check_in_rstudio("stop('This is an error!!')")
#> Start a new RStudio process with pid = 36891
#> The rsession has pid = 36901
#> $crashed
#> [1] FALSE
#> 
#> $finished
#> [1] FALSE
#> 
#> $errmsg
#> [1] "错误: This is an error!!" ""

detailed_check_in_rstudio("doesntexist()")
#> Start a new RStudio process with pid = 36928
#> The rsession has pid = 36938
#> $crashed
#> [1] FALSE
#> 
#> $finished
#> [1] FALSE
#> 
#> $errmsg
#> [1] "Error in doesntexist() : 没有\"doesntexist\"这个函数"
#> [2] ""

detailed_check_in_rstudio("library(TestWithRStudio); crash()")
#> Start a new RStudio process with pid = 36965
#> The rsession has pid = 36975
#> Warning: 运行命令'kill -s 0 36975 2>/dev/null'的状态是1
#> $crashed
#> [1] TRUE
#> 
#> $finished
#> [1] FALSE
#> 
#> $errmsg
#> character(0)
```

TestWithRStudio for R Package Developers
----------------------------------------

Suggestion and Issue Reporting
------------------------------

`TestWithRStudio` is under active development now. Any suggestion or issue reporting is welcome! You may report it using the link: <https://github.com/Non-Contradiction/TestWithRStudio/issues/new>. Or email me at <lch34677@gmail.com> or <cxl508@psu.edu>.
