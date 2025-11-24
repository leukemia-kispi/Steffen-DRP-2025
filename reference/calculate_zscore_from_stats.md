# Calculation z-score with cohort statistics

Calculate z-scores of the fitting parameters (logIC50, logAUC, etc.).
The z-score is calculated based on the `cohort_stats` table

## Usage

``` r
calculate_zscore_from_stats(tbl, con, cohort_id, ...)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - drug_id

  - and the metrics selected in ...

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- cohort_id:

  Integer specifying the cohort_id to use for the z-score calculation

- ...:

  \<`tidy-select`\> Columns names of parameters to calculate a z-score
  of

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
z-score columns
