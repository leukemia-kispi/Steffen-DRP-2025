# Encode comma-separated values

`encode_csv` converts a comma-separated string of characters values to a
comma-separated string of integers according to the definitions in the
specified DRP database.

## Usage

``` r
encode_csv(tbl, ref_tbl, con)
```

## Arguments

- tbl:

  A reference
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
  id-description mapping.

- ref_tbl:

  Character string of the table name in the DRP database or a reference
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
  id-description mapping

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
encoded features (comma-delimited integer vector)

## See also

[`encode()`](encode.md), [`decode()`](decode.md)
