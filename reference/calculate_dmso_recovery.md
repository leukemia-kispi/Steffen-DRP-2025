# Calculate DMSO recovery

The DMSO recovery describes the ratio of cancer cells recovered after
96h (72h of drug incubation) in the DMSO negative control identified by
CyQuant with respect to the number of originally seeded cells assessed
by Trypan blue as specified in the DRP database in
`assay->cancer_seeded`.

## Usage

``` r
calculate_dmso_recovery(tbl, con, readout_id = c(1, 5))
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with at
  least the following columns:

  - sid

  - assay_id

  - readout_id (optional)

  - drug_id

  - exclude

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- readout_id:

  Vector of integers specifying the readout IDs of which the DMSO
  recovery is calculated

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with the
plate averaged recoveries for all assays/samples
