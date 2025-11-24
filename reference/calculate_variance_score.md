# Patient fingerprint variance score

Computes a patient sensitivity score by weighting the drug fingerprint
with the cohort variance of the drug.

## Usage

``` r
calculate_variance_score(tbl, ...)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
  `assay_id`, `sid` and `sd_<metrics>` columns

- ...:

  \<`tidy-select`\> Columns names of fitting parameters to calculate a
  percentile of

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
additional columns `var_rank_<metric>` for each metric
