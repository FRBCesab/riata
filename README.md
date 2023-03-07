
<!-- README.md is generated from README.Rmd. Please edit that file -->

# riati <img src="man/figures/package-sticker.png" align="right" style="float:right; height:120px;"/>

<!-- badges: start -->

[![R CMD
Check](https://github.com/frbcesab/riati/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/frbcesab/riati/actions/workflows/R-CMD-check.yaml)
[![Website](https://github.com/frbcesab/riati/actions/workflows/pkgdown.yaml/badge.svg)](https://github.com/frbcesab/riati/actions/workflows/pkgdown.yaml)
[![License: GPL (\>=
2)](https://img.shields.io/badge/License-GPL%20%28%3E%3D%202%29-blue.svg)](https://choosealicense.com/licenses/gpl-2.0/)
<!-- badges: end -->

This R package is an interface for the [IATI Datastore
API](https://iatistandard.org/en/iati-tools-and-resources/iati-datastore/).
This package is freely released by the
[FRB-CESAB](https://www.fondationbiodiversite.fr/en/about-the-foundation/le-cesab/).

## Requirements

This package uses the IATI Datastore API to retrieve data on **{{ ADD A
DESCRIPTION }}**.

You must first have obtained a Personal API Token. Follow [these
instructions](https://iatistandard.org/en/iati-tools-and-resources/api-gateway/).

Then you must store this token as an R Environment variable (i.e. a
name-value pairs). Use the function `usethis::edit_r_environ()` to
create/open the `~/.Renviron` file and add this line (by replacing
z999zzz… with your token):

    IATI_KEY='z999zzz9zzz999999z9z99zz999zz999'

Save the file and restart R.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("frbcesab/riati")
```

Then you can attach the package `riati`:

``` r
library("riati")
```

## Overview

The general workflow is the following:

- Use the function `riati::get_number_of_records()` to get the total
  number of records that match the query.
- Use the function `riati::get_records()` to download the records.

## Citation

Please cite this package as:

> Casajus N. (2023) riati: An R Client for the IATI Datastore API. R
> package version 0.0.0.9000.

## Code of Conduct

Please note that the `riati` project is released with a [Contributor
Code of
Conduct](https://contributor-covenant.org/version/2/0/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
