# Encode feature columns

`encode` converts character columns to integers according to the
definitions in the specified DRP database.

## Usage

``` r
encode(tbl, con)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
  character feature columns defined in the DRP database.

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
encoded features (integer feature columns)

## See also

[`decode()`](decode.md)
