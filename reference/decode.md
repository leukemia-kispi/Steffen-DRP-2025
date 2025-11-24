# Decode feature columns

`encode` converts integer columns to character according to the
definitions in the specified DRP database.

## Usage

``` r
decode(tbl, con)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
  integer feature columns defined in the DRP database.

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
decoded features (character feature columns)

## See also

[`encode()`](encode.md)
