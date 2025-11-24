# Calculate proliferation index

The proliferation capacity is assessed by comparing the number of cancer
cells at 96h and 18h (right before drug addition). A value above 1 means
that the cells have proliferated on average while a value below 1 means
there is loss of cells viability due to drug-independent cell death.

## Usage

``` r
calculate_proliferation(tbl, con, readout_id = c(1, 5))
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - sid

  - assay_id

  - readout_id (optional)

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- readout_id:

  Vector of integers specifying the readout IDs of which the
  proliferation index is calculated

## Value

Numeric specifying the proliferation ratio for all assays/samples

## Note

The response must be of the same `readout_id` at 18h and at the
endpoint.
