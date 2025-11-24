# Calculate the drug sensitivity score (DSS)

`calculate_dss` computes the drug sensitivity score (DSS) from the
logAUC within the lower/upper integration limits

## Usage

``` r
calculate_dss(
  type,
  logAUC,
  t = 0.1,
  c_min = -1,
  c_max = 4,
  x1 = -1,
  x2 = 4,
  d = 1
)
```

## Arguments

- type:

  DSS type

- logAUC:

  Logarithmic area-under-the-curve

- t:

  Minimum activity treshold

- c_min:

  Logarithmic lowest tested concentration

- c_max:

  Logarithmic highest tested concentration

- x1:

  Logarithmic lower integration limit

- x2:

  Logarithmic lower integration limit

- d:

  Upper asymptote

## Value

Drug sensitivity score
