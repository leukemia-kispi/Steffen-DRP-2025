# Calculate derivate fit parameters

Calculate secondary, derivate fit parameters such as logAUC or
abs_logEC50

## Usage

``` r
derive_parameters(tbl, con)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - pid

  - sid

  - drug_id

  - fit parameter columns b,c,d,e

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
derivate fit parameters
