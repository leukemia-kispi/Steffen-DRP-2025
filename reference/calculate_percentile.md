# Calculate percentiles of fit parameters

Calculate percentile columns for the fitting parameters (logIC50,
logAUC, etc.) as well as boolean columns indicating whether the
observation is below the xxth-percentile. Percentiles are calculated
based on the cohort in `tbl` excluding assays that have failed QC.

## Usage

``` r
calculate_percentile(tbl, ..., probs = c(0.1, 0.33, 0.5, 0.66, 0.9))
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns

  - drug_id

  - and the metrics selected in ...

- ...:

  \<`tidy-select`\> Columns names of fitting parameters to calculate a
  percentile of

- probs:

  Numeric vector with probabilities to calculate percentiles for

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
percentile and corresponding boolean columns indicating whether the
observation is below the xxth-percentile.
