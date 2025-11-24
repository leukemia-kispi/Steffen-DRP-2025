# Normalize measurements

Normalize measurements to the DMSO control.

## Usage

``` r
normalize_measurements(con, plate_id)
```

## Arguments

- con:

  A
  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object, as returned by
  [dbConnect](https://dbi.r-dbi.org/reference/dbConnect.html)

- plate_id:

  Numeric indicating which plate should be normalized.
