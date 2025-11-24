# Select tibble columns from Postgres

Selects columns of a tibble based on the variables present in a given
Postgres table.

## Usage

``` r
select_from_pg(tbl, name, con)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) to
  select columns from

- name:

  Character string specifying the name of the Postgres table

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
selected columns
