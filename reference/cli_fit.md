# CLI for curve fitting

A command line interface (CLI) for fitting dose response curves. The CLI
internally calls [fit_wrapper](fit_wrapper.md) to fit, extract
parameters and predict dose response curves using the
[drm](https://rdrr.io/pkg/drc/man/drm.html) package. The parameters and
fitted curves are then written to the DRP Postgres database.

## Usage

``` r
cli_fit(
  tbl,
  con,
  fixed = c(NA, NA, 1, NA, 1),
  lowerl = c(0.01, 0, 1e-04),
  upperl = c(2.5, 1, 1e+06),
  start = NULL,
  show_coefficients = FALSE
)
```

## Arguments

- tbl:

  A tibble with at least the columns:

  - plate_id

  - sid

  - drug_id

  - concentration

  - readout_id

  - norm_response

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- fixed:

  A numeric vector specifying the values of the parameters (b, c, d,
  e, f) that should be fixed in the drc model. Variable parameters
  should be specified as NA.

- lowerl:

  Lower boundaries of the variable parameters

- upperl:

  Upper boundaries of the variable parameters

- start:

  Starting values of the variable parameters (if NULL the model chooses
  starting values automatically)

- show_coefficients:

  Boolean indicating whether to print out fit coefficients

## See also

[fit_wrapper](fit_wrapper.md) and [fit](fit.md)

## Examples

``` r
tbl <- tibble::tribble(
  ~sid, ~plate_id, ~drug_id, ~concentration, ~norm_response, ~readout_id,
  1, 1, 1, 0.4, 1, 1,
  1, 1, 1, 1.3, 0.75, 1,
  1, 1, 1, 4.5, 0.3, 1,
  1, 1, 1, 15, 0.1, 1,
  1, 1, 1, 50, 0, 1
)
# cli_fit(tbl, con)
```
