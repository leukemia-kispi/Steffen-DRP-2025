# HEX color from a colormap

Extract HEX color codes from a named colormap.

## Usage

``` r
get_hex_colors(name, n = 3, n_max = NULL)
```

## Arguments

- name:

  Character string specifying the colormap. Can be registered colormap
  from
  [RColorBrewer](https://rdrr.io/pkg/RColorBrewer/man/ColorBrewer.html)
  or a palette fom the `palettes` list defined in the drpr package.
  Reverse the colormap by appending the suffix `_r` to the name.

- n:

  Number of colors to extract.

- n_max:

  Maximum number of colors to use from the colormap. If `NULL` defaults
  to all colors

## Value

Character vector with HEX color codes

## Examples

``` r
get_hex_colors("Set2")
#> [1] "#66C2A5" "#C6B18B" "#B3B3B3"
get_hex_colors("orange_violet")
#> [1] "#C25539" "#F0F0F0" "#694A82"
```
