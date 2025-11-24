# Calculate rank of fit parameters

Calculate the
[`dplyr::min_rank()`](https://dplyr.tidyverse.org/reference/row_number.html)
and
[`dplyr::percent_rank()`](https://dplyr.tidyverse.org/reference/percent_rank.html)
on the fitting parameters (logIC50, logAUC, etc.) excluding assays that
have failed QC.

- `min_rank()` gives every tie the same (smallest) value so that c(10,
  20, 20, 30) gets ranks c(1, 2, 2, 4). It's the way that ranks are
  usually computed in sports

- `percent_rank(x)` counts the total number of values less than x_i and
  divides it by the number of observations minus 1. E.g. a drug has a
  percent_rank = 0.9 for absolute EC50 means that 90% of all samples
  have lower absolute EC50 than the present sample.

- `cume_dist(x)` counts the total number of values less than or equal to
  x_i, and divides it by the number of observations. E.g. a drug has a
  cume_dist = 0.9 for absolute EC50 means that 90% of all samples have
  lower or equal absolute EC50 than the present sample. (missing values
  are ignored in the observation count)

## Usage

``` r
calculate_rank(tbl, ..., by = drug_id, suffix = "")
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - drug_id

  - and the metrics selected in ...

- ...:

  \<`tidy-select`\> Columns names of fitting parameters to calculate a
  rank of

- by:

  \<`tidy-select`\> Column to group by (e.g. drug_id)

- suffix:

  Character string to add to the rank column as a suffix

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) including
rank columns
