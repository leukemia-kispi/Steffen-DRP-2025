# Expand an alphanumeric range into a tibble

Expand a tibble with row and col from an alphanumeric range with the `:`
notation, e.g. A1:A3

## Usage

``` r
alphanumeric_tbl(alphanumeric_range)
```

## Arguments

- alphanumeric_range:

  A character string specifying an alphanumeric range using `:` notation

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with row,
col

## Examples

``` r
alphanumeric_tbl("A1:C3")
#> Error in letter_seq(paste0(stringr::str_extract_all(alphanumeric_range,     "[A-Z]+")[[1]], collapse = ":")): could not find function "letter_seq"
```
