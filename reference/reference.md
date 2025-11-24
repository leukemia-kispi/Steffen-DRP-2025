# Get reference data

Return the list of all reference tables in the DRP database.

## Usage

``` r
reference(con, with_synonyms = TRUE)
```

## Arguments

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- with_synonyms:

  Boolean indicating whether to include drug synonyms

## Value

A list with reference
[tibble](https://tibble.tidyverse.org/reference/tibble.html)
