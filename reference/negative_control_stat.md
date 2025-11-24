# Calculate negative control statistics

Calculate the mean or median of the DRP negative control.

## Usage

``` r
negative_control_stat(tbl, negative_control = "DMSO", FUN = mean)
```

## Arguments

- tbl:

  A tibble with at least the following columns present:

  - drug

  - response

- negative_control:

  A string defining the substance to use as negative control

- FUN:

  An averaging function, i.e. mean or median

## Value

A dbl of the average negative control response
