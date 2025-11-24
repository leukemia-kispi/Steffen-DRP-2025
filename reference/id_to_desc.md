# Convert ID to description

Get the description of a reference data record from the ID column in the
DRP database.

## Usage

``` r
id_to_desc(
  id,
  ref_tbl,
  con,
  id_col = id,
  description_col = description,
  ignore_error = TRUE
)
```

## Arguments

- id:

  integer to convert to description

- ref_tbl:

  Character string of the table name in the DRP database or a reference
  [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
  id-description mapping

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- id_col:

  \<`tidy-select`\> name of the ID column in the table

- description_col:

  \<`tidy-select`\> name of the description column in the table

- ignore_error:

  Boolean indicating whether to ignore missing IDs that lead to NAs

## Value

A character string
