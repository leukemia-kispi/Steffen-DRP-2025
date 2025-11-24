# Calculate average drug response

Calculate the average (mean or median) response across grouping
variables (e.g. Idarubicin responses present on multiple plates) . By
default computes the mean response for each patient, sample, assays and
drug across all plates.

## Usage

``` r
average_response(
  tbl,
  ...,
  by = c("drug_id", "assay_id", "sid", "pid"),
  FUN = mean,
  exclude_failed = FALSE
)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the columns

  - pid

  - sid

  - drug_name

  - assay_failed

  - and the metrics selected in ...

- ...:

  Tidyselect columns (metrics) to average over

- by:

  Variables to use for grouping

- FUN:

  Function to use calculate_zscore_from_stats for averaging

- exclude_failed:

  Boolean indicating whether to exclude assays that have failed QC (if
  `TRUE` then only `assay_failed=FALSE/NA`)

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
individual drug responses replaced by the averaged drug response
