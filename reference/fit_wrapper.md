# Curve fitting wrapper

Wrapper around the [fit](fit.md) function for carrying out logistic
curve fits, extract parameters and predicted curves. The results are
then written to the DRP Postgres database.

## Usage

``` r
fit_wrapper(
  tbl,
  con,
  cur,
  drug_id,
  plate_id,
  mdl_name,
  fixed,
  lowerl,
  upperl,
  start,
  readout_id,
  sid
)
```

## Arguments

- tbl:

  A tibble with at least the columns:

  - sid

  - drug_id

  - plate_id

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- cur:

  A named vector with user_id and tenant_id

- drug_id:

  Integer identifying the drug

- plate_id:

  Integer identifying the plate

- mdl_name:

  Name of the fitting model

- fixed:

  A numeric vector specifying the values of the parameters (b, c, d, e,
  f; in this order) that should be fixed in the drc model. Variable
  parameters should be specified as NA.

- lowerl:

  Lower boundaries of the variable parameters

- upperl:

  Upper boundaries of the variable parameters

- start:

  Starting values of the variable parameters (if NULL the model chooses
  starting values automatically)

- readout_id:

  Integer specifying the readout (e.g. 1 = Viable leukemia cells)

- sid:

  Integer specifying the sample ID
