# Convert tibble into flextable

Convert a tibble into a flextable with custom formatting.

## Usage

``` r
as_flextable(tbl, autofit_part = "header", save = FALSE, filename = NULL)
```

## Arguments

- tbl:

  A [tibble](https://tibble.tidyverse.org/reference/tibble.html)

- autofit_part:

  Character string specifying how to fit column widths ("all", "body",
  "header" or "footer")

- save:

  Boolean indicating whether to save the flextable

- filename:

  Character string specifying the filename

## Value

A
[flextable](https://davidgohel.github.io/flextable/reference/flextable.html)
