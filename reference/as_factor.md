# Convert features into factors

Convert character features into unordered or ordered factors.

## Usage

``` r
as_factor(tbl, con, drop_unused_levels = FALSE)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
  character feature columns to be converted into factors

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- drop_unused_levels:

  Boolean indicating whether to drop unused levels

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
factor features
