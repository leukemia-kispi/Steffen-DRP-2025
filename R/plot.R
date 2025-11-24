#' Draw a multi-well plate
#' @concept plotting
#'
#' @param plate A \link[tibble]{tibble} with at least the following columns:
#' - row
#' - col
#' and usually either
#' - drug
#' - concentration
#' or
#' - response/norm_response
#'
#' @param color <[`tidy-select`][dplyr_tidy_select]> Name of the column to map the color
#' @param alpha <[`tidy-select`][dplyr_tidy_select]> Name of the column to map the opacity
#' @param n_wells Integer specifying the number of wells of the plate, if `NULL` derive the well number from `plate`
#' @param row <[`tidy-select`][dplyr_tidy_select]> Name of the column to identify the plate rows
#' @param col <[`tidy-select`][dplyr_tidy_select]> Name of the column to identify the plate columns
#' @param label <[`tidy-select`][dplyr_tidy_select]> Name of a column to be used for labeling the well
#' @param label_size Integer specifying the size of the label
#' @param text Name of the column to be used for labeling the tooltips in the interactive plot
#' @param palette A character vector specifying the color palette (discrete or continuous)
#' @param limits A numeric vector of lower and upper limits of the color/fill scale
#' @param midpoint Numeric specifying the midpoint of colorscale
#' @param transform For continuous scales the name of the transformation object (e.g. "log10") or the object itself ("identity")
#' @param show_legend Boolean indicating whether to show the legend
#' @param save Boolean indicating whether to write the plot to disk
#' @param filename Character string specifying the filename
#' @param width Numeric specifying the width of the plot
#' @param height Numeric specifying the height of the plot
#' @return A \link[ggplot2]{ggplot} object
#'
#' @export
plot_plate <- function(
  plate,
  color,
  alpha,
  n_wells = NULL,
  row = row,
  col = col,
  label = NULL,
  label_size = 2,
  text = NULL,
  palette = "hue12",
  limits = NULL,
  midpoint = NULL,
  transform = "identity",
  show_legend = TRUE,
  save = FALSE,
  filename = NULL,
  width = 6,
  height = 4
) {
  if (is.null(n_wells)) {
    n_wells <- plate |>
      dplyr::distinct({{ row }}, {{ col }}) |>
      nrow()
  }
  if (n_wells == 96) {
    shape <- 16 # shape 21 needs fill and does not work with ggplotly (https://github.com/plotly/plotly.R/issues/1234)
    size <- 9
    x_breaks <- seq(1, 12)
    x_limits <- c(1, 12)
    y_breaks <- rev(LETTERS[1:8])
  } else if (n_wells == 384) {
    shape <- 15 # shape 22 needs fill and does not work with ggplotly (https://github.com/plotly/plotly.R/issues/1234)
    size <- 4
    x_breaks <- seq(1, 24)
    x_limits <- c(1, 24)
    y_breaks <- rev(LETTERS[1:16])
  } else if (n_wells == 1536) {
    shape <- 15 # shape 22 needs fill and does not work with ggplotly (https://github.com/plotly/plotly.R/issues/1234)
    size <- 2
    x_breaks <- seq(1, 48)
    x_limits <- c(1, 48)
    y_breaks <- rev(c(LETTERS, "AA", "AB", "AC", "AD", "AE", "AF"))
  } else {
    stop("Number of wells needs to be 96, 384 or 1536", call. = FALSE)
  }
  g <- ggplot2::ggplot(plate, ggplot2::aes(x = {{ col }}, y = {{ row }})) +
    ggplot2::geom_point(
      ggplot2::aes(color = {{ color }}, alpha = {{ alpha }}, text = {{ text }}),
      shape = shape,
      size = size
    ) +
    ggplot2::geom_hline(
      yintercept = seq(15) + 0.5,
      color = "grey92",
      size = 0.1
    ) +
    {
      if (!rlang::quo_is_null(rlang::enquo(label))) {
        ggplot2::geom_text(ggplot2::aes(label = {{ label }}), size = label_size)
      }
    } +
    ggplot2::scale_x_continuous(
      position = "top",
      breaks = x_breaks,
      limits = x_limits
    ) +
    scale_color_fill_custom(
      plate,
      {{ color }},
      "color",
      palette,
      limits,
      midpoint,
      transform
    ) +
    ggplot2::scale_y_discrete(limits = y_breaks) +
    ggplot2::scale_alpha_continuous(guide = "none") +
    {
      if (isFALSE(show_legend)) {
        ggplot2::guides(color = "none")
      }
    } +
    ggplot2::coord_fixed() +
    ggplot2::xlab("") +
    ggplot2::ylab("") +
    ggplot2::theme_bw() +
    ggplot2::theme(panel.grid.major = ggplot2::element_blank())

  if (save == TRUE) {
    if (is.null(filename)) {
      filename <- "plate_plot.png"
    }
    ggplot2::ggsave(
      filename,
      width = width,
      height = height,
      dpi = 1200
    )
  }
  return(g)
}


#' Plot drug response profiles
#'
#' @description
#' Plotting drug responses as a function of concentration.
#' @concept plotting
#'
#' @param con \link[DBI]{DBIConnection-class} object to a DRP database
#' @param .drug_mask <[`data-masking`][rlang::args_data_masking]> expression returning a logical vector and selecting the drugs to be displayed
#' @param .fg_sample_mask <[`data-masking`][rlang::args_data_masking]> expression returning a logical vector and
#' selecting the samples displayed in the foreground based on the columns in plate_content_view
#' @param .bg_cohort_mask <[`data-masking`][rlang::args_data_masking]> expression to select the samples displayed in the background
#' @param color_fill <[`tidy-select`][dplyr_tidy_select]> Name of the column to be used for color and fill
#' @param label <[`tidy-select`][dplyr_tidy_select]> Name of a column to be used for labeling each drug curve
#' @param size Numeric specifying the line size
#' @param readout_id Integer or vector of integers specifying the id(s) of the readout in the foreground
#' @param bg_readout_id Integer or vector of integers specifying the id(s) of the readout in the background
#' @param transform For continuous scales the name of the transformation object (e.g. "log10") or the object itself ("identity")
#' @param palette A character vector specifying the color palette (discrete or continuous)
#' @param limits A numeric vector of lower and upper limits of the color/fill scale
#' @param midpoint Numeric specifying the midpoint of colorscale
#' @param quantiles Boolean indicating whether to draw a percentile interval instead of individual background curves
#' @param lower_quantile <[`tidy-select`][dplyr_tidy_select]> Name of the lower percentile column in the `cohort_stats` table
#' @param upper_quantile <[`tidy-select`][dplyr_tidy_select]> Name of the upper percentile column in the `cohort_stats` table
#' @param sort_by <[`tidy-select`][dplyr_tidy_select]> Name of the column to be used for sorting facets
#' @param n_drugs Integer specifying the maximal number of drugs
#' @param lump_n Named vector of integers specifying the maximum number of levels for each feature (including the lumped "Other" category),
#' e.g. c(diagnosis = 3)
#' @param drop_l Named list of character vectors specifying the levels to drop for each feature
#' @param na_as_other Boolean indicating whether to lump NA values into the "Other" category
#' @param drop_missing_drugs Boolean indicating whether to drop drugs that are missing in the `.fg_sample_mask`
#' @param ylimits Numeric vector of specifying the y-axis limits
#' @param xlimits Numeric vector specifying the x-axis limits
#' @param save Boolean indicating whether to write the plot to disk
#' @param filename Character string specifying the filename
#' @param color_fill_name Character string specifying an alternative name for the color/fill legend
#' @param bg_color Character specifying a uniform color for the background fit lines
#' @param show_na Boolean indicating whether to translate NA values
#' @param progressbar Boolean indicating whether to show a progressbar
#' @param facet_samples Boolean indicating whether to separate samples into individual facets
#' @param nrow Integer indicating the number of rows to use for facetting
#' @param ncol Integer indicating the number of columns to use for facetting
#' @param width Numeric specifying the width of the plot
#' @param height Numeric specifying the height of the plot
#'
#' @return \link[ggplot2]{ggplot} object
#' @export
#' @examplesIf interactive()
#' plot_profile(con,
#'   .drug_mask = drug_name %in% c("Venetoclax", "Navitoclax"),
#'   .fg_sample_mask = lknumber == "LK2000.001",
#'   color_fill = norm_logAUC,
#'   palette = "orange_blue",
#'   color_fill_name = "logAUC"
#' )
plot_profile <- function(
  con,
  .drug_mask,
  .fg_sample_mask = FALSE,
  .bg_cohort_mask = TRUE,
  color_fill = abs_logEC50,
  label = lknumber,
  size = NULL,
  readout_id = c(1, 5),
  bg_readout_id = c(1, 5),
  transform = "identity",
  palette = NULL,
  limits = NULL,
  midpoint = NULL,
  quantiles = FALSE,
  lower_quantile = p10,
  upper_quantile = p90,
  sort_by = NULL,
  n_drugs = NULL,
  drop_missing_drugs = FALSE,
  lump_n = NULL,
  drop_l = NULL,
  na_as_other = FALSE,
  ylimits = c(0, 1.05),
  xlimits = NULL,
  save = FALSE,
  filename = NULL,
  color_fill_name = NULL,
  bg_color = NULL,
  show_na = TRUE,
  progressbar = TRUE,
  facet_samples = TRUE,
  nrow = NULL,
  ncol = NULL,
  width = 3.6,
  height = 2.5
) {
  if (isTRUE(progressbar)) {
    cli::cli_progress_bar(total = 1, name = "Plot profile(s)")
    n <- 4
  }

  readout_id <- as.numeric(readout_id)
  drug_ids <- pool::dbReadTable(con, "drug_view_long") |>
    dplyr::filter({{ .drug_mask }}) |>
    dplyr::distinct(drug_id, drug_name) |>
    dplyr::pull(drug_id, drug_name)

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }

  bg <- pool::dbReadTable(con, "cohort_psa_view") |>
    #dplyr::left_join(therapy, by = c("pid")) |>
    #assign_subtype(con) |>
    dplyr::filter({{ .bg_cohort_mask }}, assay_failed == FALSE)

  if (nrow(bg) == 0) {
    bg_assay_ids <- -1
    bg_sids <- -1
  } else {
    bg_assay_ids <- unique(bg$assay_id)
    bg_sids <- unique(bg$sid)
  }

  fg <- pool::dbReadTable(con, "psa_view") |>
    #assign_subtype(con) |>
    #assign_alteration(con, common_alterations()) |>
    dplyr::filter({{ .fg_sample_mask }})

  if (nrow(fg) == 0) {
    fg_assay_ids <- -1
    fg_sids <- -1
  } else {
    fg_assay_ids <- unique(fg$assay_id)
    fg_sids <- unique(fg$sid)
  }

  if (any(!(fg_assay_ids %in% bg$assay_id))) {
    fg <- fg |>
      dplyr::mutate(
        sid_assay = paste0("sid: ", .data$sid, " - assay_id: ", .data$assay_id)
      )
    cli::cli_alert_info(glue::glue(
      "The following sid(s) - assay_id(s) is/are not in the selected cohort: ",
      glue::glue_collapse(
        fg$sid_assay[which(!fg$assay_id %in% bg$assay_id)],
        sep = "; "
      ),
      "!"
    ))
  }

  features <- R.cache::evalWithMemoization(
    {
      pool::dbGetQuery(
        con,
        glue::glue_sql(
          "SELECT * FROM feature_view WHERE drug_id IN ({drug_ids*})
                                           AND (readout_id IN ({readout_id*}) OR readout_id IN ({bg_readout_id*})) AND ((assay_id IN ({bg_assay_ids*})
                                           AND sid IN ({bg_sids*})) OR (assay_id IN ({fg_assay_ids*}) AND sid IN ({fg_sids*})))",
          .con = con
        )
      )
    },
    key = c(drug_ids, readout_id, bg_assay_ids, fg_assay_ids, bg_sids, fg_sids),
  )

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }
  features <- features |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), as.factor)) |>
    dplyr::filter(
      assay_failed == FALSE | (assay_id %in% fg_assay_ids & sid %in% fg_sids)
    ) |>
    derive_fit_features(con)

  if (isTRUE(quantiles)) {
    features <- features |>
      calculate_zscore_from_stats(con, cohort_id = 1, logAUC, abs_logEC50)
  }

  features <- features |>
    as_factor(con)

  plate_ids <- features |>
    dplyr::distinct(plate_id) |>
    dplyr::pull(plate_id)

  if (nrow(features) == 0) {
    cli::cli_warn("No assays found for the specified drugs")
  }

  fg_measured <- R.cache::evalWithMemoization(
    {
      pool::dbGetQuery(
        con,
        glue::glue_sql(
          "SELECT * FROM plate_content_view WHERE drug_id IN ({drug_ids*})
                                           AND assay_id IN ({fg_assay_ids*}) AND sid IN ({fg_sids*})
                                           AND readout_id IN ({readout_id*}) AND exclude = FALSE",
          .con = con
        )
      )
    },
    key = c(readout_id, drug_ids, fg_assay_ids, fg_sids)
  )

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }

  fg_measured <- fg_measured |>
    tidyr::drop_na(drug_id) |>
    dplyr::select(-c(assay_description)) |>
    dplyr::left_join(
      features,
      by = dplyr::join_by(
        plate_id,
        assay_id,
        drug_id,
        drug_name,
        sid,
        lknumber,
        readout_id,
        readout
      )
    ) |>
    tibble::as_tibble() |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), as.factor)) |>
    tidyr::unite(composite, c(sid, lknumber), sep = " - ", remove = FALSE)

  fg_measured <- fg_measured |>
    dplyr::mutate(
      drug_name = if (!rlang::is_null({{ sort_by }})) {
        forcats::fct_reorder(drug_name, {{ sort_by }}, .na_rm = FALSE)
      } else {
        drug_name
      }
    )

  predicted <- R.cache::evalWithMemoization(
    {
      pool::dbGetQuery(
        con,
        glue::glue_sql(
          "SELECT * FROM drc_prediction_view WHERE drug_id IN ({drug_ids*})
                                           AND (readout_id IN ({readout_id*}) OR readout_id IN ({bg_readout_id*})) AND plate_id IN ({plate_ids*})
                                           AND (sid IN ({bg_sids*}) OR sid IN ({fg_sids*}))",
          .con = con
        )
      )
    },
    key = c(drug_ids, readout_id, bg_readout_id, plate_ids, bg_sids, fg_sids)
  )

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }
  predicted <- predicted |>
    dplyr::left_join(
      features |> dplyr::select(-c(sid, lknumber)),
      by = dplyr::join_by(plate_id, drug_id, readout_id)
    ) |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), as.factor)) |>
    dplyr::mutate(
      drug_name = if (!rlang::is_null({{ sort_by }})) {
        forcats::fct_reorder(drug_name, {{ sort_by }}, .na_rm = FALSE)
      } else {
        drug_name
      }
    )

  if (nrow(predicted) == 0) {
    cli::cli_abort("There is no data available in the cohort")
  }

  if (!is.null(n_drugs)) {
    lev <- levels(droplevels(dplyr::pull(predicted, drug_name)))[1:n_drugs]
    predicted <- predicted |> dplyr::filter(drug_name %in% lev)
    if (nrow(fg_measured) > 0) {
      fg_measured <- fg_measured |> dplyr::filter(drug_name %in% lev)
    }
  }
  predicted <- predicted |>
    tidyr::drop_na(drug_name)

  if (isTRUE(drop_missing_drugs)) {
    drugs_with_fg <- fg_measured |>
      dplyr::distinct(drug_name) |>
      dplyr::pull(drug_name)
    predicted <- predicted |> dplyr::filter(drug_name %in% drugs_with_fg)
  }

  if (isTRUE(quantiles)) {
    tryCatch(
      {
        cohort_id <- pool::dbReadTable(con, "cohort") |>
          dplyr::filter({{ .bg_cohort_mask }}) |>
          dplyr::pull(cohort_id)
      },
      error = function(e) {
        cli::cli_abort("The selected cohort does not exist.")
      }
    )
    if (length(cohort_id) > 1) {
      cohort_id <- 1
      cohort_name <- id_to_desc(
        {{ cohort_id }},
        "cohort",
        con,
        id_col = cohort_id,
        cohort_name
      )
      cli::cli_warn(
        "Cohort not unambigously specified. Defaulting to \"{cohort_name}\""
      )
    } else {
      cohort_name <- id_to_desc(
        {{ cohort_id }},
        "cohort",
        con,
        id_col = cohort_id,
        cohort_name
      )
    }
    cohort_stats <- pool::dbReadTable(con, "cohort_stats") |>
      dplyr::filter(drug_id %in% drug_ids, cohort_id == {{ cohort_id }})
    if (nrow(cohort_stats) == 0) {
      cli::cli_warn(
        "Cohort stats are not available for cohort \"{cohort_name}\""
      )
    } else {
      drug_range <- pool::dbReadTable(con, "drug_view") |>
        dplyr::filter(drug_id %in% drug_ids) |>
        dplyr::summarise(
          min_conc = min_assay_conc,
          max_conc = max_assay_conc,
          .by = drug_id
        ) |>
        dplyr::mutate(
          concentration = purrr::map2(min_conc, max_conc, \(cmin, cmax) {
            drpr::logspace(cmin, cmax, 30)
          }),
        ) |>
        tidyr::unnest(concentration)

      bg_predicted <- cohort_stats |>
        dplyr::left_join(
          pool::dbReadTable(con, "drug") |>
            dplyr::select(drug_id, drug_name),
          by = "drug_id"
        ) |>
        tidyr::pivot_longer(
          cols = c(min, max, mean, {{ lower_quantile }}, {{ upper_quantile }}),
          names_to = "percentile"
        ) |>
        tidyr::pivot_wider(
          id_cols = c(drug_id, drug_name, percentile),
          names_from = metric,
          values_from = value
        ) |>
        dplyr::group_by(drug_id) |>
        dplyr::mutate(b_mean = b[percentile == "mean"])

      if (!rlang::quo_is_null(rlang::enquo(sort_by))) {
        sort_by_name <- rlang::as_label(rlang::enquo(sort_by))
        if (!sort_by_name %in% colnames(bg_predicted)) {
          cli::cli_warn(
            "Variable {sort_by_name} is not present in cohort statistics. Cannot sort the profiles."
          )
        }
      } else {
        sort_by_name <- NULL
      }
      tryCatch(
        {
          cohort_stats_pred <- drug_range |>
            dplyr::left_join(
              bg_predicted |>
                dplyr::filter(
                  percentile %in%
                    c("p5", "p10", "p25", "p75", "p90", "p95", "min", "max")
                ),
              by = dplyr::join_by(drug_id)
            ) |>
            dplyr::mutate(
              norm_response = ll4(
                log10(concentration),
                b_mean,
                0,
                1,
                abs_logEC50
              )
            ) |>
            dplyr::mutate(
              drug_name = if (
                sort_by_name %in%
                  colnames(bg_predicted) &&
                  !is.null({{ sort_by }})
              ) {
                forcats::fct_reorder(drug_name, {{ sort_by }}, .na_rm = FALSE)
              } else {
                drug_name
              }
            ) |>
            tidyr::pivot_wider(
              id_cols = c(drug_id, drug_name, concentration),
              names_from = percentile,
              values_from = norm_response
            )
        },
        error = function(e) {
          cli::cli_abort(
            "The background quantiles cannot be calculated due to missing parameters in the cohort."
          )
        }
      )
    }
  } else {
    bg_predicted <- predicted |>
      dplyr::filter(assay_id %in% bg_assay_ids, readout_id %in% bg_readout_id)
  }

  unit <- predicted |>
    dplyr::distinct(unit) |>
    dplyr::pull(unit)

  fg_predicted <- predicted |>
    tidyr::unite(composite, c(sid, lknumber), sep = " - ", remove = FALSE) |>
    dplyr::filter(assay_id %in% fg_assay_ids)

  n_pages <- 1
  i <- 1
  drug_name <- "drug"
  if (is.null(filename)) {
    filename <- "profiles.png"
  }

  custom_limits <- function() {
    limits <- c(1, 100)
    # limits <- x_limits[[as.character(group)]]
    ggplot2::scale_x_continuous(limits = limits)
  }

  if (
    !is.null(bg_color) && is.factor(dplyr::pull(fg_measured, {{ color_fill }}))
  ) {
    data_for_legend <- fg_measured |>
      dplyr::mutate("{{color_fill}}" := forcats::fct_drop({{ color_fill }}))
  } else {
    data_for_legend <- predicted
  }

  g <- list()
  while (i <= n_pages) {
    g[[i]] <- ggplot2::ggplot(
      mapping = ggplot2::aes(concentration, norm_response, label = {{ label }}),
      data = fg_measured
    ) +
      ggplot2::geom_blank(
        mapping = ggplot2::aes(fill = {{ color_fill }}),
        data = predicted
      ) +
      {
        if (isTRUE(quantiles)) {
          if (nrow(cohort_stats) > 0) {
            ggplot2::geom_ribbon(
              ggplot2::aes(
                x = concentration,
                ymin = {{ lower_quantile }},
                ymax = {{ upper_quantile }}
              ),
              fill = "#dedede",
              data = cohort_stats_pred,
              inherit.aes = FALSE
            )
          }
        } else if (!is.null(bg_color)) {
          ggplot2::geom_line(
            mapping = ggplot2::aes(
              group = interaction(assay_id, readout_id, plate_id)
            ),
            data = bg_predicted,
            size = size,
            show.legend = TRUE,
            color = bg_color
          )
        } else {
          ggplot2::geom_line(
            mapping = ggplot2::aes(
              color = {{ color_fill }},
              group = interaction(assay_id, readout_id, plate_id)
            ),
            data = bg_predicted,
            size = size,
            show.legend = TRUE
          )
        }
      } +
      {
        if (nrow(fg_predicted) > 0) {
          ggplot2::geom_line(
            mapping = ggplot2::aes(
              color = {{ color_fill }},
              group = interaction(assay_id, readout_id, plate_id)
            ),
            data = fg_predicted,
            linetype = "dashed",
            size = 1,
            color = "black",
            show.legend = FALSE
          )
        }
      } +
      {
        if (nrow(fg_measured) > 0) {
          ggplot2::geom_point(
            mapping = ggplot2::aes(fill = {{ color_fill }}),
            data = fg_measured,
            size = 3.5,
            shape = 21,
            stroke = 0.75,
            color = "black",
            show.legend = TRUE
          )
        }
      } +
      {
        if (
          length(fg_sids) > 1 && length(drug_ids) > 1 && isTRUE(facet_samples)
        ) {
          ggforce::facet_grid_paginate(
            drug_name ~ composite,
            scales = "free_x",
            nrow = nrow,
            ncol = ncol,
            page = i
          )
        }
      } +
      {
        if (length(fg_sids) <= 1 && length(drug_ids) > 1) {
          lknumber <- names(fg_sids)
          if (is.null(filename)) {
            if (!is.null(lknumber)) {
              filename <- glue::glue("{lknumber}_profiles.png")
            } else {
              filename <- glue::glue("SID{fg_sids}_profiles.png")
            }
          }
          ggforce::facet_wrap_paginate(
            ggplot2::vars(drug_name),
            scales = "free_x",
            nrow = nrow,
            ncol = ncol,
            page = i,
          )
        }
      } +
      {
        if (
          length(fg_sids) > 1 && length(drug_ids) == 1 && isTRUE(facet_samples)
        ) {
          drug_name <- names(drug_ids)
          if (is.null(filename)) {
            filename <- glue::glue("{drug_name}_profiles.png")
          }
          ggforce::facet_wrap_paginate(
            ggplot2::vars(composite),
            scales = "free_x",
            nrow = nrow,
            ncol = ncol,
            page = i
          )
        }
      }
    if (length(drug_ids) == 1) {
      drug_name <- names(drug_ids)
    }

    g[[i]] <- g[[i]] +
      {
        if (isTRUE(quantiles)) {
          # for quantiles the legend depends on the fill (needs to be plotted first)
          scale_color_fill_custom(
            data_for_legend,
            {{ color_fill }},
            "fill",
            palette,
            limits,
            midpoint,
            transform,
            color_fill_name,
            show_na = show_na
          ) # separation needed for ggplotly
        } else {
          # for all lines the legend depends on the color (needs to be plotted first)
          scale_color_fill_custom(
            data_for_legend,
            {{ color_fill }},
            "color",
            palette,
            limits,
            midpoint,
            transform,
            color_fill_name,
            show_na = show_na
          )
        }
      } +
      {
        if (isTRUE(quantiles)) {
          scale_color_fill_custom(
            data_for_legend,
            {{ color_fill }},
            "color",
            palette,
            limits,
            midpoint,
            transform,
            color_fill_name,
            show_na = show_na
          )
        } else {
          scale_color_fill_custom(
            data_for_legend,
            {{ color_fill }},
            "fill",
            palette,
            limits,
            midpoint,
            transform,
            color_fill_name,
            show_na = show_na
          ) # separation needed for ggplotly
        }
      } +
      ggplot2::scale_x_continuous(trans = "log10", limits = xlimits) +
      ggplot2::coord_cartesian(ylim = ylimits) +
      ggplot2::ylab("viability") +
      ggplot2::xlab(glue::glue("{drug_name} ({unit})")) +
      theme_drpr()

    # Page settings
    if (!is.null(nrow) && !is.null(ncol)) {
      if (length(fg_sids) <= 1 && length(drug_ids) > 1) {
        width <- ncol * 2.4 + 1.5
        height <- nrow * 2.2 + 0.3
      } else {
        width <- ncol * 2.55 + 1
        height <- nrow * 1.7 + 0.75
      }
    }
    if (save == TRUE) {
      if (n_pages > 1) {
        tmp_filename <- paste0(
          tools::file_path_sans_ext(filename),
          i,
          ".",
          tools::file_ext(filename)
        )
      } else {
        tmp_filename <- filename
      }
      ggplot2::ggsave(
        filename = tmp_filename,
        width = width,
        height = height,
        dpi = 600
      )
    }
    n_pages <- ggforce::n_pages(g[[i]])
    if (is.null(n_pages)) {
      n_pages <- 1
    }
    i <- i + 1
  }
  if (n_pages == 1) {
    return(g[[1]])
  } else {
    return(g)
  }
}


#' Plot drug distribution
#'
#' @description
#' Distribution dot plot of the best drugs as a function of an ex vivo scoring metric (logEC50, logAUC, DSS).
#' The dots can be colored by an second independent metric (e.g. top 10% outliers, diagnosis, disease stage etc.).
#' The distribution plot can be combined with other geoms, see examples.
#' @concept plotting
#'
#' @param con \link[DBI]{DBIConnection-class} object to a DRP database
#' @param .jitter_mask <[`data-masking`][rlang::args_data_masking]> expression to select the samples/assays for the `geom_jitter()`
#' @param .point_mask <[`data-masking`][rlang::args_data_masking]> expression to select the samples/assays for the `geom_point()`
#' @param .drug_mask <[`data-masking`][rlang::args_data_masking]> expression to select the drugs
#' @param x <[`tidy-select`][dplyr_tidy_select]> Name of the factor to use as the independent variable (x-axis)
#' @param metric <[`tidy-select`][dplyr_tidy_select]> Name of the DRP metric (continuous) use as the dependent variable (y-axis)
#' @param color_fill <[`tidy-select`][dplyr_tidy_select]> Name of the column to be used for color and fill
#' @param readout_id Integer or vector of integers specifying the id(s) of the readout in the point plot
#' @param bg_readout_id Integer or vector of integers specifying the id(s) of the readout in the jitter plot
#' @param sort_by <[`tidy-select`][dplyr_tidy_select]> Name of the column to sort the x-axis by (e.g. `norm_logAUC`). Invert the order with `dplyr::desc(<sort_by>)`.
#' @param label <[`tidy-select`][dplyr_tidy_select]> Name of a column to be used for labeling each drug curve
#' @param selected_labels <[`data-masking`][rlang::args_data_masking]> expression returning a logical vector and selecting the labels to be displayed.
#' Example: for `label = sid` set for instance `selected_labels = sid %in% c(1, 2)` to exclusively label these two SIDs
#' @param palette Character vector specifying the color palette for color and fill (discrete or continuous)
#' @param color_fill_name Character string specifying an alternative name for the color/fill legend
#' @param add_boxplot Boolean specifying whether to add boxplots
#' @param add_line Boolean specifying whether to add lines connecting the `geom_point`
#' @param quantiles Boolean indicating whether to draw boxplot from quantiles of `cohort_stats`
#' @param lower_quantile <[`tidy-select`][dplyr_tidy_select]> Name of the lower percentile column in the `cohort_stats` table specifying the min boxplot whisker. To hide whiskers set `lower_quantile = p25`
#' @param upper_quantile <[`tidy-select`][dplyr_tidy_select]> Name of the upper percentile column in the `cohort_stats` table specifying the maximum boxplot whisker. To hide whiskers set `upper_quantile = p75`
#' @param shape Integer specifying the `geom_point` type
#' @param size Integer specifying the size of the jitter dots
#' @param alpha Numeric specifying the transparency of the jitter dots
#' @param limits Numeric vector of lower and upper limits of the color/fill scale
#' @param midpoint Numeric specifying the midpoint of colorscale
#' @param ylimits Numeric vector of the lower and upper limits on the y-axis
#' @param lump_n Named vector of integers specifying the maximum number of levels for each feature (including the lumped "Other" category),
#' e.g. c(diagnosis = 3)
#' @param drop_l Named list of character vectors specifying the levels to drop for each feature
#' @param na_as_other Boolean indicating whether to lump NA values into the "Other" category
#' @param n_levels Integer indicating the maximum number of levels to display on the x-axis
#' @param x_var Numeric indicating the amount of random variation to add to the points on the x-axis
#' @param bg_x_var Numeric indicating the amount of random variation to add to the background jitter points on the x-axis
#' @param bg_color Character specifying a uniform color for the background jitter points
#' @param seed Integer specifying the seed for the random number generator
#' @param comparisons A list of length-2 vectors. The entries in the vector are either the names of two values on the x-axis or the two integers that correspond to the index of the groups of interest, to be compared.
#' @param test Character string describing the statistical test to use for the comparisons. Allowed values include "wilcox.test" (Wilcoxon rank sum test) and "t.test" (Student's t-test)
#' @param paired_test Boolean indicating whether to use a paired test
#' @param stat_compare_label Character string specifying label type. Allowed values include "p.signif" (shows the significance levels) and "p.format" (shows the formatted p-value)
#' @param stat_compare_label.y Numeric indicating the y-axis position of the p-value label
#' @param progressbar Boolean indicating whether to show a progressbar
#' @param save Boolean indicating whether to write the plot to disk
#' @param filename Character string specifying the filename
#' @param width Numeric specifying the width of the plot
#' @param height Numeric specifying the height of the plot
#'
#' @return A \link[ggplot2]{ggplot} object
#' @export
#'
#' @examplesIf interactive()
#' plot_distribution(con,
#'   .drug_mask = functional_class == "MEK inhibitor",
#'   color_fill = TP53,
#'   add_boxplot = TRUE
#' )
plot_distribution <- function(
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
) {
  if (isTRUE(progressbar)) {
    cli::cli_progress_bar(total = 1, name = "Plot distribution(s)")
    n <- 3
  }

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }

  cohort <- pool::dbReadTable(con, "cohort_psa_view") |>
    dplyr::filter({{ .jitter_mask }}, assay_failed == FALSE)

  if (nrow(cohort) == 0) {
    cohort_assay_ids <- -1
    cohort_sids <- -1
  } else {
    cohort_assay_ids <- unique(cohort$assay_id)
    cohort_sids <- unique(cohort$sid)
  }

  drug_ids <- pool::dbReadTable(con, "drug_view_long") |>
    dplyr::filter({{ .drug_mask }}) |>
    dplyr::distinct(drug_id, drug_name) |>
    dplyr::pull(drug_id, drug_name)

  points <- pool::dbReadTable(con, "psa_view") |>
    dplyr::filter({{ .point_mask }})

  if (nrow(points) == 0) {
    points_assay_ids <- -1
    points_sids <- -1
  } else {
    points_assay_ids <- unique(points$assay_id)
    points_sids <- unique(points$sid)
  }

  features <- R.cache::evalWithMemoization(
    {
      pool::dbGetQuery(
        con,
        glue::glue_sql(
          "SELECT * FROM feature_view WHERE drug_id IN ({drug_ids*})
                                           AND (readout_id IN ({readout_id*}) OR readout_id IN ({bg_readout_id*})) AND (((assay_id IN ({cohort_assay_ids*}))
                                           AND (sid IN ({cohort_sids*}))) OR ((assay_id IN ({points_assay_ids*}))
                                           AND (sid IN ({points_sids*}))))",
          .con = con
        )
      )
    },
    key = c(
      drug_ids,
      readout_id,
      bg_readout_id,
      points_sids,
      points_assay_ids,
      cohort_assay_ids,
      cohort_sids
    ),
  )

  if (isTRUE(progressbar)) {
    cli::cli_progress_update(1 / n)
  }

  features <- features |>
    dplyr::mutate(dplyr::across(tidyselect::where(is.character), as.factor)) |>
    dplyr::filter(
      (assay_id %in% cohort_assay_ids & sid %in% cohort_sids) |
        (assay_id %in% points_assay_ids & sid %in% points_sids)
    ) |>
    derive_fit_features(con)

  if (nrow(features) == 0) {
    cli::cli_abort("There is no data available")
  }

  features <- features |>
    average_response(
      {{ metric }},
      FUN = stats::median,
    ) # averages selected metric over plates but not over assays

  if (isTRUE(quantiles)) {
    features <- features |>
      calculate_zscore_from_stats(con, cohort_id = 1, logAUC, abs_logEC50)
  }
  features <- features |>
    dplyr::arrange(dplyr::desc(is.na({{ color_fill }}))) |> # move color/fill jitter points to the front
    as_factor(con)

  try(
    {
      # only works with numeric sort_by (e.g. norm_logAUC but not alphabetically)
      features <- features |>
        dplyr::mutate(
          {{ x }} := forcats::fct_reorder(
            {{ x }},
            {{ sort_by }},
            stats::median,
            .na_rm = TRUE
          )
        )
    },
    silent = TRUE
  )

  if (!is.null(n_levels)) {
    lev <- levels(droplevels(dplyr::pull(features, {{ x }})))[1:n_levels]
  }

  features_sel <- features |>
    dplyr::filter(readout_id %in% {{ readout_id }}, {{ .point_mask }})

  if (nrow(features_sel) > 0) {
    drug_ids_sel <- features_sel |> dplyr::pull(drug_id)
    features <- features |> dplyr::filter(drug_id %in% drug_ids_sel)
    try(
      {
        features_sel <- features_sel |>
          dplyr::mutate(
            {{ x }} := forcats::fct_reorder(
              {{ x }},
              {{ sort_by }},
              stats::median,
              .na_rm = TRUE
            )
          )
      },
      silent = TRUE
    )
    if (!is.null(n_levels)) {
      lev <- levels(droplevels(dplyr::pull(features_sel, {{ x }})))[1:n_levels]
    }
  }

  if (!is.null(n_levels)) {
    features <- features |> dplyr::filter({{ x }} %in% lev)
    features_sel <- features_sel |> dplyr::filter({{ x }} %in% lev)
  }

  features <- features |>
    dplyr::filter(readout_id %in% {{ bg_readout_id }}, !{{ .point_mask }})

  if (!rlang::quo_is_null(rlang::enquo(selected_labels))) {
    features_sel <- features_sel |>
      dplyr::mutate(
        {{ label }} := dplyr::case_when(
          {{ selected_labels }} ~ {{ label }},
          TRUE ~ ""
        ),
      )
    features <- features |>
      dplyr::mutate(
        {{ label }} := NA
      )
  }

  set.seed(seed)

  if (
    !is.null(bg_color) && is.factor(dplyr::pull(features_sel, {{ color_fill }}))
  ) {
    data_for_legend <- features_sel |>
      dplyr::mutate("{{color_fill}}" := forcats::fct_drop({{ color_fill }}))
  } else {
    data_for_legend <- features
  }

  if (isTRUE(quantiles)) {
    tryCatch(
      {
        cohort_id <- pool::dbReadTable(con, "cohort") |>
          dplyr::filter({{ .jitter_mask }}) |>
          dplyr::pull(cohort_id)
      },
      error = function(e) {
        cli::cli_abort("The selected cohort does not exist.")
      }
    )
    if (length(cohort_id) > 1) {
      cohort_id <- 1
      cohort_name <- id_to_desc(
        {{ cohort_id }},
        "cohort",
        con,
        id_col = cohort_id,
        cohort_name
      )
      cli::cli_warn(
        "Cohort not unambigously specified. Defaulting to \"{cohort_name}\""
      )
    } else {
      cohort_name <- id_to_desc(
        {{ cohort_id }},
        "cohort",
        con,
        id_col = cohort_id,
        cohort_name
      )
    }
    drugs <- pool::dbReadTable(con, "drug") |>
      dplyr::select(drug_id, drug_name)
    metric_name <- rlang::as_name(rlang::enquo(metric))
    cohort_stats <- pool::dbReadTable(con, "cohort_stats") |>
      dplyr::filter(
        drug_id %in% drug_ids_sel,
        cohort_id == {{ cohort_id }},
        metric == metric_name
      ) |>
      dplyr::left_join(drugs, by = "drug_id")
    if (nrow(cohort_stats) == 0) {
      cli::cli_warn(
        "Cohort stats are not available for cohort \"{cohort_name}\""
      )
    }
  }

  g <- ggplot2::ggplot(
    data = features,
    ggplot2::aes(x = {{ x }}),
  ) +
    {
      if (nrow(features_sel) > 0) {
        ggplot2::geom_point(
          ggplot2::aes({{ x }}, {{ metric }}, group = interaction(assay_id)),
          data = features_sel,
          size = 0,
          color = "white"
        )
      }
    } +
    {
      if (isTRUE(add_boxplot)) {
        if (
          isTRUE(quantiles) && rlang::as_name(rlang::enquo(x)) == "drug_name"
        ) {
          ggplot2::geom_boxplot(
            ggplot2::aes(
              x = drug_name,
              ymin = {{ lower_quantile }},
              ymax = {{ upper_quantile }},
              lower = p25,
              upper = p75,
              middle = median,
              group = drug_name
            ),
            stat = "identity",
            alpha = alpha,
            width = 0.5,
            show.legend = FALSE,
            data = cohort_stats,
            outliers = FALSE,
            fill = "#f5f3f2"
          )
        } else {
          ggplot2::geom_boxplot(
            ggplot2::aes({{ x }}, {{ metric }}),
            alpha = alpha,
            width = 0.5,
            show.legend = FALSE,
            data = features,
            outliers = FALSE,
            coef = 0,
            fill = "#f5f3f2"
          )
        }
      }
    } +
    {
      if (!is.null(bg_color)) {
        ggplot2::geom_jitter(
          ggplot2::aes({{ x }}, {{ metric }}),
          size = size,
          fill = bg_color,
          color = bg_color,
          alpha = alpha,
          width = bg_x_var,
          height = 0,
          shape = shape,
          show.legend = FALSE,
          data = features
        )
      } else if (shape == 21) {
        ggplot2::geom_jitter(
          ggplot2::aes(
            {{ x }},
            {{ metric }},
            fill = {{ color_fill }}
          ),
          size = size,
          alpha = alpha,
          width = bg_x_var,
          height = 0,
          color = "black",
          shape = shape,
          show.legend = TRUE,
          data = features
        )
      } else {
        ggplot2::geom_jitter(
          ggplot2::aes(
            {{ x }},
            {{ metric }},
            color = {{ color_fill }},
            fill = {{ color_fill }}
          ),
          size = size,
          alpha = alpha,
          width = bg_x_var,
          height = 0,
          shape = shape,
          show.legend = TRUE,
          data = features
        )
      }
    } +
    {
      if (is.null(bg_color)) {
        if (shape > 20) {
          ggplot2::guides(color = "none")
        } else {
          ggplot2::guides(fill = "none")
        }
      }
    } +
    {
      if (nrow(features_sel) > 0 && isTRUE(add_line)) {
        ggplot2::geom_line(
          ggplot2::aes({{ x }}, {{ metric }}, group = interaction(assay_id)),
          data = features_sel
        )
      }
    } +
    {
      if (nrow(features_sel) == 0 && isTRUE(add_line)) {
        ggplot2::geom_line(
          ggplot2::aes({{ x }}, {{ metric }}, group = interaction(assay_id)),
          data = features |> dplyr::filter(!is.na({{ color_fill }}))
        )
      }
    } +
    {
      if (nrow(features_sel) > 0) {
        ggplot2::geom_jitter(
          ggplot2::aes({{ x }}, {{ metric }}, fill = {{ color_fill }}),
          data = features_sel,
          shape = 21,
          size = 4,
          color = "black",
          stroke = 0.75,
          width = x_var,
          height = 0,
          show.legend = ifelse(is.null(bg_color), FALSE, TRUE),
        )
      }
    } +
    ggplot2::scale_size_manual(values = c(2.5, 3.5)) +
    scale_color_fill_custom(
      data_for_legend,
      {{ color_fill }},
      "color",
      palette,
      limits,
      midpoint,
      color_fill_name = color_fill_name
    ) +
    scale_color_fill_custom(
      data_for_legend,
      {{ color_fill }},
      "fill",
      palette,
      limits,
      midpoint,
      color_fill_name = color_fill_name
    ) +
    ggplot2::coord_cartesian(ylim = ylimits) +
    ggplot2::xlab("") +
    ggplot2::ylab(stringr::str_replace_all(
      rlang::as_name(rlang::enquo(metric)),
      "_",
      " "
    )) +
    {
      if (!rlang::quo_is_null(rlang::enquo(selected_labels))) {
        ggrepel::geom_text_repel(
          mapping = ggplot2::aes(
            {{ x }},
            {{ metric }},
            label = {{ label }}
          ),
          data = features_sel,
          min.segment.length = 0,
          show.legend = FALSE,
          max.overlaps = Inf,
          point.padding = 0,
          force = 100
        )
      }
    } +
    {
      if (!is.null(comparisons)) {
        x_var <- rlang::as_name(rlang::ensym(x))
        y_var <- rlang::as_name(rlang::ensym(metric))
        ggsignif::stat_signif(
          mapping = ggplot2::aes(x = {{ x }}, y = {{ metric }}),
          data = features,
          paired = paired_test,
          comparisons = comparisons,
          test = test,
          map_signif_level = function(p) {
            dplyr::case_when(
              p < 0.001 ~ "***",
              p < 0.01 ~ "**",
              p < 0.05 ~ "*",
              TRUE ~ "ns"
            )
          },
          textsize = 4,
          y_position = stat_compare_label.y
        )
      }
    } +
    theme_drpr() +
    ggplot2::theme(legend.position = "right") +
    ggpubr::rotate_x_text(90)

  if (save == TRUE) {
    if (is.null(filename)) {
      filename <- "dist_plot.png"
    }
    ggplot2::ggsave(
      filename,
      width = width,
      height = height,
      dpi = 1200
    )
  }
  return(g)
}


#' Add drpr plot theme to ggplot
#'
#' @description
#' Theme based on \link[ggpubr]{theme_pubr} with rectangular borders and legend positioned on the right.
#' @concept plotting

#' @export
theme_drpr <- function() {
  ggpubr::theme_pubr() +
    ggplot2::theme(
      panel.border = ggplot2::element_rect(fill = NA, linewidth = 1),
      axis.line = ggplot2::element_line(linewidth = 0),
      legend.position = "right",
    )
}
