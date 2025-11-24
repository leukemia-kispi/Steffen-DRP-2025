# Relabel fit parameters columns

Create a copy of the default fit parameter columns (b,c,d,e) and make
their names interpretable as pertaining to an inhibition and viability
dose response model

- `b` is the inverse slope

- `c` is the lower asymptote corresponding to the minimum inhibition in
  an inhibition model or the minimum viability in an viability model

- `d` is the upper asymptote corresponding to the maximum inhibition in
  an inhibition model or the maximum viability in a viability model

- `e` is the EC50

## Usage

``` r
relabel_fit_parameters(tbl, data_type = "viability")
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
  columns b,c,d,e

- data_type:

  A character string describing if the
  [drm](https://rdrr.io/pkg/drc/man/drm.html) parameters are determined
  by fitting a "inhibition" or "viability" curve

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
EC50, inverse_slope (N_inv), min_inhibition (I_min), min_viability
(I_max), min_viability (V_min) and max_viability (V_max) columns added

## See also

`extract_fit_parameters()`
