# Normalize drug responses

`normalize_response` divides each readout observation by the mean DMSO
response and adds a column `norm_response` to the tibble

## Usage

``` r
normalize_response(
  plate,
  negative_control = "DMSO",
  negative_control_mean = NULL,
  remove_control = FALSE
)
```

## Arguments

- plate:

  A tibble with at least the following columns:

  - drug

  - response

- negative_control:

  A character vector describing the treatment (drug) used as a negative
  control (e.g. DMSO)

- negative_control_mean:

  A manually pre-calculated, mean DMSO response (e.g. if no DMSO was
  measured on the current plate). Overrules any DMSO observations
  present on the plate.

- remove_control:

  Boolean indicating whether to remove DMSO observations from the
  resulting tibble

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
normalized responses added
