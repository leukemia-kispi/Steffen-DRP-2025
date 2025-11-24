# Predict drug responses

Predict drug responses for a n-series of evenly spaced concentrations on
a logarithmic scale given a minimum and maximum dose.

## Usage

``` r
predict_drc(mdl, min, max, n = 25, interval = "confidence")
```

## Arguments

- mdl:

  A model of the [drm](https://rdrr.io/pkg/drc/man/drm.html) class

- min:

  The minimum drug concentration

- max:

  The maximum drug concentration

- n:

  Integer specifying the number of data points to predict

- interval:

  The 95% confidence intervals around the mean (interval = "confidence")
  or the 95% prediction interval (interval = "prediction").

## Value

A [tibble](https://tibble.tidyverse.org/reference/tibble.html) with
predictions and confidence intervals in the following columns:

- Concentration

- Prediction

- Lower

- Upper
