# Plot drug distribution

Distribution dot plot of the best drugs as a function of an ex vivo
scoring metric (logEC50, logAUC, DSS). The dots can be colored by an
second independent metric (e.g. top 10% outliers, diagnosis, disease
stage etc.). The distribution plot can be combined with other geoms, see
examples.

## Usage

``` r
plot_distribution(
  con,
  .jitter_mask = TRUE,
  .point_mask = FALSE,
  .drug_mask = TRUE,
  x = drug_name,
  metric = norm_logAUC,
  color_fill = abs_logEC50,
  readout_id = c(1, 5),
  bg_readout_id = c(1, 5),
  sort_by = NULL,
  label = lknumber,
  selected_labels = NULL,
  palette = NULL,
  color_fill_name = NULL,
  add_boxplot = FALSE,
  add_line = FALSE,
  quantiles = FALSE,
  lower_quantile = p10,
  upper_quantile = p90,
  shape = 16,
  size = 2,
  alpha = 0.5,
  limits = NULL,
  midpoint = NULL,
  ylimits = NULL,
  lump_n = NULL,
  drop_l = NULL,
  na_as_other = FALSE,
  n_levels = NULL,
  x_var = 0,
  bg_x_var = 0.1,
  bg_color = NULL,
  seed = 123,
  comparisons = NULL,
  test = "wilcox.test",
  paired_test = FALSE,
  stat_compare_label = "p.signif",
  stat_compare_label.y = NULL,
  progressbar = TRUE,
  save = FALSE,
  filename = NULL,
  width = 8,
  height = 3.5
)
```

## Arguments

- con:

  [DBIConnection-class](https://dbi.r-dbi.org/reference/DBIConnection-class.html)
  object to a DRP database

- .jitter_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression to select the samples/assays for the `geom_jitter()`

- .point_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression to select the samples/assays for the `geom_point()`

- .drug_mask:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression to select the drugs

- x:

  \<`tidy-select`\> Name of the factor to use as the independent
  variable (x-axis)

- metric:

  \<`tidy-select`\> Name of the DRP metric (continuous) use as the
  dependent variable (y-axis)

- color_fill:

  \<`tidy-select`\> Name of the column to be used for color and fill

- readout_id:

  Integer or vector of integers specifying the id(s) of the readout in
  the point plot

- bg_readout_id:

  Integer or vector of integers specifying the id(s) of the readout in
  the jitter plot

- sort_by:

  \<`tidy-select`\> Name of the column to sort the x-axis by (e.g.
  `norm_logAUC`). Invert the order with `dplyr::desc(<sort_by>)`.

- label:

  \<`tidy-select`\> Name of a column to be used for labeling each drug
  curve

- selected_labels:

  \<[`data-masking`](https://rlang.r-lib.org/reference/args_data_masking.html)\>
  expression returning a logical vector and selecting the labels to be
  displayed. Example: for `label = sid` set for instance
  `selected_labels = sid %in% c(1, 2)` to exclusively label these two
  SIDs

- palette:

  Character vector specifying the color palette for color and fill
  (discrete or continuous)

- color_fill_name:

  Character string specifying an alternative name for the color/fill
  legend

- add_boxplot:

  Boolean specifying whether to add boxplots

- add_line:

  Boolean specifying whether to add lines connecting the `geom_point`

- quantiles:

  Boolean indicating whether to draw boxplot from quantiles of
  `cohort_stats`

- lower_quantile:

  \<`tidy-select`\> Name of the lower percentile column in the
  `cohort_stats` table specifying the min boxplot whisker. To hide
  whiskers set `lower_quantile = p25`

- upper_quantile:

  \<`tidy-select`\> Name of the upper percentile column in the
  `cohort_stats` table specifying the maximum boxplot whisker. To hide
  whiskers set `upper_quantile = p75`

- shape:

  Integer specifying the `geom_point` type

- size:

  Integer specifying the size of the jitter dots

- alpha:

  Numeric specifying the transparency of the jitter dots

- limits:

  Numeric vector of lower and upper limits of the color/fill scale

- midpoint:

  Numeric specifying the midpoint of colorscale

- ylimits:

  Numeric vector of the lower and upper limits on the y-axis

- lump_n:

  Named vector of integers specifying the maximum number of levels for
  each feature (including the lumped "Other" category), e.g. c(diagnosis
  = 3)

- drop_l:

  Named list of character vectors specifying the levels to drop for each
  feature

- na_as_other:

  Boolean indicating whether to lump NA values into the "Other" category

- n_levels:

  Integer indicating the maximum number of levels to display on the
  x-axis

- x_var:

  Numeric indicating the amount of random variation to add to the points
  on the x-axis

- bg_x_var:

  Numeric indicating the amount of random variation to add to the
  background jitter points on the x-axis

- bg_color:

  Character specifying a uniform color for the background jitter points

- seed:

  Integer specifying the seed for the random number generator

- comparisons:

  A list of length-2 vectors. The entries in the vector are either the
  names of two values on the x-axis or the two integers that correspond
  to the index of the groups of interest, to be compared.

- test:

  Character string describing the statistical test to use for the
  comparisons. Allowed values include "wilcox.test" (Wilcoxon rank sum
  test) and "t.test" (Student's t-test)

- paired_test:

  Boolean indicating whether to use a paired test

- stat_compare_label:

  Character string specifying label type. Allowed values include
  "p.signif" (shows the significance levels) and "p.format" (shows the
  formatted p-value)

- stat_compare_label.y:

  Numeric indicating the y-axis position of the p-value label

- progressbar:

  Boolean indicating whether to show a progressbar

- save:

  Boolean indicating whether to write the plot to disk

- filename:

  Character string specifying the filename

- width:

  Numeric specifying the width of the plot

- height:

  Numeric specifying the height of the plot

## Value

A [ggplot](https://ggplot2.tidyverse.org/reference/ggplot.html) object

## Examples

``` r
if (FALSE) { # interactive()
plot_distribution(con,
  .drug_mask = functional_class == "MEK inhibitor",
  color_fill = TP53,
  add_boxplot = TRUE
)
}
```
