# Convert description to ID

Get the ID of a reference data record from the description column in the
DRP database.

## Usage

``` r
desc_to_id(
  description,
  ref_tbl,
  con,
  id_col = id,
  description_col = description,
  ignore_error = TRUE
)
```

## Arguments

- description:

  Character string to convert to ID

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

  Boolean indicating whether to ignore missing descriptions that lead to
  NAs

## Value

An integer
