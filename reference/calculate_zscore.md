# Calculation z-score of fit parameters

Calculate z-scores of the fitting parameters (logIC50, logAUC, etc.).
The z-score is calculated based on the cohort in `tbl` excluding assays
that have failed QC.

## Usage

``` r
calculate_zscore(tbl, ..., by = drug_id)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - drug_id

  - and the metrics selected in ...

- ...:

  \<`tidy-select`\> Columns names of parameters to calculate a z-score
  of

- by:

  \<`tidy-select`\> Column to group by (e.g. drug_id or sid)

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
z-score columns
