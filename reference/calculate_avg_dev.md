# Calculate the average replicate deviation

Calculate the average deviation of the replicates across the dilutions
series.

## Usage

``` r
calculate_avg_dev(con, .sample_drug_mask = TRUE, readout_id = c(1, 5))
```

## Arguments

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- .sample_drug_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression returning a logical vector and selecting the samples/assays
  and drugs

- readout_id:

  Vector of integers specifying the readout IDs of which the average
  deviation is calculated

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
averaged replicate deviations for all assays/samples
