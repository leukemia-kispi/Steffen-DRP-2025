# Identify duplicated rows

Return duplicated rows of a tibble based on a set of identifying columns

## Usage

``` r
duplicated_rows(tbl, id_cols)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html)

- id_cols:

  \<`tidy-select`\> Name of identifying column(s)

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) of
duplicated rows
