#' Calculate average drug response
#'
#' @description
#' Calculate the average (mean or median) response across grouping variables (e.g. Idarubicin responses present on multiple plates) .
#' By default computes the mean response for each patient, sample, assays and drug across all plates.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the columns
#' - pid
#' - sid
#' - drug_name
#' - assay_failed
#' - and the metrics selected in ...
#' @param ... Tidyselect columns (metrics) to average over
#' @param by Variables to use for grouping
#' @param FUN Function to use calculate_zscore_from_stats for averaging
#' @param exclude_failed Boolean indicating whether to exclude assays that have failed QC (if `TRUE` then only `assay_failed=FALSE/NA`)
#'
#' @return A \link[tibble]{tibble} with individual drug responses replaced by the averaged drug response
#' @export
average_response <- function(
  tbl,
  ...,
  by = c("drug_id", "assay_id", "sid", "pid"),
  FUN = mean,
  exclude_failed = FALSE
) {
  metrics <- rlang::quos(...)
  if (is.null(metrics)) {
    cli::cli_alert_warning("No metric has been selected")
  }
  tbl <- tbl |>
    dplyr::group_by(dplyr::across(dplyr::all_of(by))) |>
    dplyr::mutate(
      dplyr::across(
        .cols = dplyr::all_of(purrr::map_chr(metrics, rlang::as_name)) &
          where(is.numeric),
        .fns = ~ {
          mask <- ifelse(
            isTRUE(exclude_failed),
            assay_failed == FALSE | is.na(assay_failed),
            TRUE
          )
          FUN(.x[mask], na.rm = TRUE)
        },
        .names = "{.col}"
      )
    ) |>
    dplyr::ungroup()

  tbl <- tbl |>
    dplyr::distinct(dplyr::across(dplyr::all_of(by)), .keep_all = TRUE)
  return(tbl)
}


#' Calculation z-score of fit parameters
#'
#' @description
#' Calculate z-scores of the fitting parameters (logIC50, logAUC, etc.).
#' The z-score is calculated based on the cohort in `tbl` excluding assays that have failed QC.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - drug_id
#' - and the metrics selected in ...
#' @param ... <[`tidy-select`][dplyr_tidy_select]> Columns names of parameters to calculate a z-score of
#' @param by <[`tidy-select`][dplyr_tidy_select]> Column to group by (e.g. drug_id or sid)
#'
#' @return A \link[tibble]{tibble} including z-score columns
#' @export
calculate_zscore <- function(tbl, ..., by = drug_id) {
  for (q in rlang::quos(...)) {
    tbl <- tbl |>
      dplyr::group_by({{ by }}) |>
      dplyr::mutate(
        "mean_{{q}}" := mean({{ q }}, na.rm = TRUE),
        "sd_{{q}}" := sd({{ q }}, na.rm = TRUE),
        "z{{q}}" := ({{ q }} - mean({{ q }}, na.rm = TRUE)) /
          sd({{ q }}, na.rm = TRUE),
        "d{{q}}" := ({{ q }} - mean({{ q }}, na.rm = TRUE))
      ) |>
      dplyr::ungroup()
  }
  return(tbl)
}


#' Calculation z-score with cohort statistics
#'
#' @description
#' Calculate z-scores of the fitting parameters (logIC50, logAUC, etc.).
#' The z-score is calculated based on the `cohort_stats` table
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - drug_id
#' - and the metrics selected in ...
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param cohort_id Integer specifying the cohort_id to use for the z-score calculation
#' @param ... <[`tidy-select`][dplyr_tidy_select]> Columns names of parameters to calculate a z-score of
#'
#' @return A \link[tibble]{tibble} including z-score columns
#' @export
calculate_zscore_from_stats <- function(tbl, con, cohort_id, ...) {
  if (nrow(tbl) == 0) {
    cli::cli_warn("No samples / assays match the given selection criteria.")
    return(tbl)
  }
  cohort_stats <- pool::dbReadTable(con, "cohort_stats")
  for (q in rlang::quos(...)) {
    cohort_stats_filtered <- cohort_stats |>
      dplyr::filter(
        cohort_id == {{ cohort_id }},
        metric == rlang::as_label(q)
      ) |>
      dplyr::select(drug_id, mean, sd)

    tbl <- tbl |>
      dplyr::left_join(cohort_stats_filtered, by = "drug_id") |>
      dplyr::group_by(drug_id) |>
      dplyr::mutate(
        "z{{q}}_stats" := (.data[[{{ q }}]] - .data$mean) / .data$sd,
      ) |>
      dplyr::rename(
        "mean_{{q}}_stats" := mean,
        "sd_{{q}}_stats" := sd
      ) |>
      dplyr::ungroup() |>
      # dplyr::mutate(
      #   "z{{q}}" := dplyr::coalesce(
      #     !!rlang::sym(glue::glue("z{rlang::as_name(q)}")),
      #     !!rlang::sym(glue::glue("z{rlang::as_name(q)}_stats"))
      #   )
      # )
      dplyr::mutate(
        "z{{q}}" := !!rlang::sym(glue::glue("z{rlang::as_name(q)}_stats"))
      )
  }
  return(tbl)
}


#' Calculate rank of fit parameters
#'
#' @description
#' Calculate the `dplyr::min_rank()` and `dplyr::percent_rank()` on the fitting parameters (logIC50, logAUC, etc.)
#' excluding assays that have failed QC.
#' - `min_rank()` gives every tie the same (smallest) value so that c(10, 20, 20, 30) gets ranks c(1, 2, 2, 4).
#' It's the way that ranks are usually computed in sports
#' - `percent_rank(x)` counts the total number of values less than x_i and divides it by the number of observations minus 1. E.g. a drug has a percent_rank = 0.9 for absolute EC50 means that 90% of all samples have lower absolute EC50 than the present sample.
#'
#' - `cume_dist(x)` counts the total number of values less than or equal to x_i, and divides it by the number of observations. E.g. a drug has a cume_dist = 0.9 for absolute EC50 means that 90% of all samples have lower or equal absolute EC50 than the present sample.
#' (missing values are ignored in the observation count)
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - drug_id
#' - and the metrics selected in ...
#' @param ... <[`tidy-select`][dplyr_tidy_select]> Columns names of fitting parameters to calculate a rank of
#' @param by <[`tidy-select`][dplyr_tidy_select]> Column to group by (e.g. drug_id)
#' @param suffix Character string to add to the rank column as a suffix
#'
#' @return A \link[tibble]{tibble} including rank columns
#' @export
calculate_rank <- function(tbl, ..., by = drug_id, suffix = "") {
  for (q in rlang::quos(...)) {
    qs <- stringr::str_extract(
      rlang::quo_name(q),
      "(?<=(dplyr::)?(desc)?\\().*(?=\\))"
    )
    qs <- dplyr::case_when(
      is.na(qs) ~ rlang::quo_name(q),
      TRUE ~ qs
    )
    tbl <- tbl |>
      dplyr::mutate(
        susceptibility = dplyr::case_when(
          !!q < max(tbl[, qs], na.rm = TRUE) ~ "susceptible",
          TRUE ~ "resistant"
        )
      ) |>
      dplyr::group_by({{ by }}, susceptibility) |>
      dplyr::mutate(
        q_tmp = {{ q }},
        "rank_{qs}{suffix}" := dplyr::cume_dist(q_tmp)
      ) |>
      dplyr::ungroup() |>
      dplyr::select(-c(susceptibility)) |>
      dplyr::group_by({{ by }}) |>
      dplyr::mutate(
        "cume_dist_{qs}{suffix}" := dplyr::cume_dist(q_tmp)
      ) |>
      dplyr::select(-c(q_tmp)) |>
      dplyr::ungroup()
  }
  return(tbl)
}


#' Calculate percentiles of fit parameters
#'
#' @description
#' Calculate percentile columns for the fitting parameters (logIC50, logAUC, etc.) as well as boolean columns
#' indicating whether the observation is below the xxth-percentile. Percentiles are calculated based on the cohort in `tbl`
#' excluding assays that have failed QC.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns
#' - drug_id
#' - and the metrics selected in ...
#' @param ... <[`tidy-select`][dplyr_tidy_select]> Columns names of fitting parameters to calculate a percentile of
#' @param probs Numeric vector with probabilities to calculate percentiles for
#'
#' @return A \link[tibble]{tibble} including percentile and corresponding boolean columns indicating
#' whether the observation is below the xxth-percentile.
#' @export
calculate_percentile <- function(
  tbl,
  ...,
  probs = c(0.10, 0.33, 0.5, 0.66, 0.9)
) {
  for (q in rlang::quos(...)) {
    for (p in probs) {
      pp <- p * 100
      tbl <- tbl |>
        dplyr::group_by(drug_id) |>
        dplyr::mutate(
          "P{{pp}}_{{q}}" := quantile({{ q }}, p, na.rm = TRUE, names = FALSE),
          "<P{{pp}}_{{q}}" := !!q <
            !!rlang::sym(glue::glue("P{pp}_{rlang::as_name(q)}"))
        ) |>
        dplyr::ungroup()
    }
  }
  for (q in rlang::quos(...)) {
    tbl <- tbl |>
      dplyr::mutate(
        "pctl_{{q}}" := dplyr::case_when(
          !!rlang::sym(glue::glue("cume_dist_{rlang::as_name(q)}")) < 0.1 ~
            "<P10",
          !!rlang::sym(glue::glue("cume_dist_{rlang::as_name(q)}")) < 0.33 ~
            "<P33",
          !!rlang::sym(glue::glue("cume_dist_{rlang::as_name(q)}")) > 0.9 ~
            ">P90",
          !!rlang::sym(glue::glue("cume_dist_{rlang::as_name(q)}")) > 0.6 ~
            ">P66",
          TRUE ~ NA
        )
      )
  }
  return(tbl)
}


#' Patient fingerprint variance score
#'
#' @description
#' Computes a patient sensitivity score by weighting the drug fingerprint with
#' the cohort variance of the drug.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with `assay_id`, `sid` and `sd_<metrics>` columns
#' @param ... <[`tidy-select`][dplyr_tidy_select]> Columns names of fitting parameters to calculate a percentile of
#' @return A \link[tibble]{tibble} including additional columns `var_rank_<metric>` for each metric
#' @export
calculate_variance_score <- function(tbl, ...) {
  for (q in rlang::quos(...)) {
    tbl <- tbl |>
      dplyr::group_by(assay_id, sid) |>
      dplyr::mutate(
        weights = tidyr::replace_na(
          (!!rlang::sym(glue::glue("sd_{rlang::as_name(q)}")))^2,
          0
        ),
        "var_rank_{{q}}" := weighted.mean(
          !!rlang::sym(glue::glue("rank_{rlang::as_name(q)}")),
          w = weights,
          na.rm = TRUE
        ),
      ) |>
      dplyr::ungroup()
  }
  return(tbl)
}


#' Calculate the logarithmic area-under-curve (logAUC)
#'
#' @description
#' `calculate_logAUC` computes the area-under-the-curve for the ll.2, ll.3 and ll.4 model
#' An analytical solution for the ll.5 model is currently not implemented.
#' @concept scoring
#'
#' @param b Inverse slope parameter
#' @param c Lower asymptote
#' @param d Upper asymptote
#' @param logEC50 Logarithmic half-maximum effective concentration (relative EC50)
#' @param x1 Numeric indicating the minimal tested logarithmic concentration (lower integration limit)
#' @param x2 Numeric indicating the maximal tested logarithmic concentration (upper integration limit)
#'
#' @return Area under the logarithmic dose response curve
#' @export
calculate_logAUC <- function(b, c, d, logEC50, x1, x2) {
  logAUC <- (((c - d) * log(10^(b * (x2 - logEC50)) + 1)) /
    (b * log(10)) +
    d * x2) -
    (((c - d) * log(10^(b * (x1 - logEC50)) + 1)) / (b * log(10)) + d * x1)
  return(logAUC)
}


#' Calculate the normalized area-under-curve (norm. logAUC)
#'
#' @description
#' `calculate_norm_logAUC` computes the normalized AUC from the logAUC within the lower/upper integration limits
#' @concept scoring
#'
#' @param logAUC Logarithmic area-under-the-curve
#' @param x1 Numeric indicating the minimal tested logarithmic concentration (lower integration limit)
#' @param x2 Numeric indicating the maximal tested logarithmic concentration (upper integration limit)
#'
#' @return Normalized area under the logarithmic dose response curve
#' @export
calculate_norm_logAUC <- function(logAUC, x1, x2) {
  norm_logAUC <- logAUC / (x2 - x1)
  return(norm_logAUC)
}


#' Calculate the normalized logEC50
#'
#' @description
#' `calculate_norm_logEC50()` computes the normalized (feature scaled) logEC50.
#' The minimal logEC50 is defined as `x1 - log_extra` and the maximal logEC50 as `x2 + log_extra`,
#' where `x1` and `x2` are the lowest and highest tested logarithmic concentration.
#' @concept scoring
#'
#' @param logEC50 Logarithmic area-under-the-curve
#' @param x1 Numeric indicating the minimal tested logarithmic concentration
#' @param x2 Numeric indicating the maximal tested logarithmic concentration
#' @param log_extra Integer indicating the extra log orders around the measured concentration range beyond which the logEC50 is clipped
#'
#' @return Normalized EC50 for the logarithmic dose response curve
#' @export
calculate_norm_logEC50 <- function(logEC50, x1, x2, log_extra) {
  norm_logEC50 <- (logEC50 - x1 + log_extra) / (x2 - x1 + 2 * log_extra)
  return(norm_logEC50)
}


#' Calculate the drug sensitivity score (DSS)
#'
#' @description
#' `calculate_dss` computes the drug sensitivity score (DSS) from the logAUC within the lower/upper integration limits
#' @concept scoring
#'
#' @param type DSS type
#' @param logAUC Logarithmic area-under-the-curve
#' @param t Minimum activity treshold
#' @param x1 Logarithmic lower integration limit
#' @param x2 Logarithmic lower integration limit
#' @param c_min Logarithmic lowest tested concentration
#' @param c_max Logarithmic highest tested concentration
#' @param d Upper asymptote
#'
#' @return Drug sensitivity score
#' @export
calculate_dss <- function(
  type,
  logAUC,
  t = 0.1,
  c_min = -1,
  c_max = 4,
  x1 = -1,
  x2 = 4,
  d = 1
) {
  tested_area <- (1 - t) * (c_max - c_min)
  area_under_min_activity <- t * (x2 - x1)
  dss1 <- pmax((logAUC - area_under_min_activity) / tested_area * 100, 0)
  dss2 <- pmax(dss1 / log10(d * 100), 0)
  dss3 <- pmax(dss2 * (x2 - x1) / (c_max - c_min), 0)
  if (type == 1) {
    return(dss1)
  } else if (type == 2) {
    return(dss2)
  } else if (type == 3) {
    return(dss3)
  } else {
    stop("Type must be an integer between 1 and 3.")
  }
}


#' Calculate absolute logEC50
#'
#' @description
#' `calculate_absolute_logEC` computes the absolute effect concentration (e.g. absolute logEC50 or logEC20) for the LL.2, LL.3 or LL.4 model.
#' The absolute logEC50 is the concentration where the four-parameter log-logistic function crosses the 50% effect treshold.
#' Note: logEC20 -> 20% effect = 20% inhibition = 80% viability
#' @concept scoring
#'
#' @param effect Percent absolute effect (e.g. 50 or 20)
#' @param b Slope parameter
#' @param c Lower asymptote
#' @param d Upper asymptote
#' @param logEC50 Logarithmic half-maximum effective concentration (relative EC50)
#'
#' @note This is equivalent to `drc::ED(mdl, effect/100, type="absolute")` where `mdl` is a `drc::drm()` object
#' @return Concentration at which the given response is observed
#' @export
calculate_absolute_logEC <- function(effect, b, c, d, logEC50) {
  frc <- ifelse(b < 0, effect / 100, 1 - effect / 100)
  return(inverse_ll4(frc, b, c, d, logEC50))
}


#' Calculate relative logEC
#'
#' @description
#' `calculate_relative_logEC` computes the relative effect concentration (e.g. relative logEC50 or logEC20) for the LL.2, LL.3 or LL.4 model.
#' The relative logEC50 is the concentration at which the effect is half-maximal relative to the
#' maximal effect (Emax). The Emax relates to a residual cell population not affected by the drug.
#' Note: logEC20 -> 20% relative effect = 20% relative inhibition = 80% relative viability
#' @concept scoring
#'
#' @param effect Percent relative effect (e.g. 50 or 20)
#' @param b Slope parameter
#' @param c Lower asymptote
#' @param d Upper asymptote
#' @param logEC50 Logarithmic half-maximum effective concentration (relative EC50)
#'
#' @note This is equivalent to `drc::ED(mdl, effect/100, type="relative")` where `mdl` is a `drc::drm()` object
#' @return Concentration at which the given response is observed
#' @export
calculate_relative_logEC <- function(effect, b, c, d, logEC50) {
  frc <- ifelse(b < 0, effect / 100, 1 - effect / 100)
  return(inverse_ll4(frc * (1 - c) + c, b, c, d, logEC50))
}


#' Calculate derivate fit parameters
#'
#' @description
#' Calculate secondary, derivate fit parameters such as logAUC or abs_logEC50
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - pid
#' - sid
#' - drug_id
#' - fit parameter columns b,c,d,e
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} including derivate fit parameters
#' @export
derive_parameters <- function(tbl, con) {
  log_extra <- 2 # extra log orders around the measured concentration range to clip abs_logEC50
  drug_doses <- pool::dbReadTable(con, "drug_view") |>
    dplyr::mutate(
      x1 = log10(min_assay_conc),
      x2 = log10(max_assay_conc)
    ) |>
    dplyr::select(drug_id, x1, x2)

  tbl <- tbl |>
    dplyr::left_join(drug_doses, by = "drug_id") |>
    relabel_fit_parameters(data_type = "viability") |>
    dplyr::mutate(
      logEC50 = log10(EC50),
      logAUC = calculate_logAUC(b, c, d, logEC50, x1, x2),
      norm_logAUC = calculate_norm_logAUC(logAUC, x1, x2),
      logAUC_inh = x2 - x1 - logAUC,
      norm_logAUC_inh = calculate_norm_logAUC(logAUC_inh, x1, x2),
      DSS1 = calculate_dss(1, logAUC_inh),
      DSS2 = calculate_dss(2, logAUC_inh),
      DSS3 = calculate_dss(3, logAUC_inh),
      abs_logEC50 = calculate_absolute_logEC(50, b, c, d, logEC50),
      V_res = ll4(x2, b, c, d, logEC50) # residual viability at highest measured drug concentration
    ) |>
    dplyr::mutate(
      abs_logEC50 = dplyr::case_when(
        abs_logEC50 > x2 + log_extra ~ x2 + log_extra,
        abs_logEC50 < x1 - log_extra ~ x1 - log_extra,
        TRUE ~ abs_logEC50
      ),
      abs_EC50 = 10^abs_logEC50,
      norm_abs_EC50 = calculate_norm_logEC50(abs_logEC50, x1, x2, log_extra)
    )
  return(tbl)
}


#' Calculate cohort scores
#'
#' @description
#' Calculate z-scores, (percent)-ranks.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - pid
#' - sid
#' - drug_id
#' - fit parameter columns b,c,d,e
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} including derivate fit parameters
#' @export
derive_fit_features <- function(tbl, con) {
  if (!"assay_failed" %in% colnames(tbl)) {
    tbl <- tbl |>
      dplyr::mutate(assay_failed = FALSE)
  }

  if (nrow(tbl) == 0) {
    cli::cli_warn("No samples / assays match the given selection criteria.")
    return(tbl)
  }
  tbl <- tbl |>
    derive_parameters(con) |>
    calculate_rank(
      EC50,
      abs_EC50,
      logEC50,
      abs_logEC50,
      logAUC,
      norm_logAUC,
      dplyr::desc(DSS2),
      V_res
    ) |>
    calculate_percentile(
      EC50,
      abs_EC50,
      abs_logEC50,
      logAUC,
      norm_logAUC,
      DSS2,
      V_res
    ) |>
    calculate_zscore(
      logEC50,
      abs_logEC50,
      logAUC,
      norm_logAUC,
      DSS2,
      V_res,
      rank_norm_logAUC
    ) |>
    calculate_variance_score(norm_logAUC)
  return(tbl)
}


#' Calculate the differential drug sensitivity score (DSS)
#'
#' @description
#' Reference the DSS to the mean of a (healthy) control cohort
#' @concept scoring
#'
#' @param dss Drug sensitivity score
#' @param mean_dss_ctrl Average drug sensitivity score of the control cohort
#'
#' @return Differential drug sensitivity score
#' @export
calculate_sdss <- function(dss, mean_dss_ctrl) {
  return(dss - mean_dss_ctrl)
}


#' Calculate the average replicate deviation
#'
#' @description
#' Calculate the average deviation of the replicates across the dilutions series.
#' @concept scoring
#'
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param .sample_drug_mask <[`data-masking`][rlang::args_data_masking]> expression returning a logical vector and selecting the samples/assays and drugs
#' @param readout_id Vector of integers specifying the readout IDs of which the average deviation is calculated
#'
#' @return A \link[tibble]{tibble} with the averaged replicate deviations for all assays/samples
#' @export
calculate_avg_dev <- function(
  con,
  .sample_drug_mask = TRUE,
  readout_id = c(1, 5)
) {
  response_deviation_per_drug <- dplyr::tbl(con, "plate_content_view") |>
    dplyr::filter(
      {{ .sample_drug_mask }},
      .data$readout_id %in% {{ readout_id }},
      !is.na(.data$drug_id)
    ) |>
    dplyr::group_by(
      .data$plate_id,
      .data$assay_id,
      .data$sid,
      .data$readout_id,
      .data$drug_id,
      .data$drug_name,
      .data$concentration
    ) |>
    dplyr::summarise(
      sd_norm_response = sd(.data$norm_response, na.rm = TRUE),
      n = dplyr::n(),
    ) |>
    dplyr::ungroup() |>
    dplyr::filter(n > 1) |> # remove measurements with only one replicate
    dplyr::group_by(
      .data$assay_id,
      .data$sid,
      .data$readout_id,
      .data$drug_id,
      .data$drug_name
    ) |>
    dplyr::summarise(
      mean_dev_sd = mean(.data$sd_norm_response, na.rm = TRUE)
    ) |>
    dplyr::ungroup() |>
    dplyr::collect()
  return(response_deviation_per_drug)
}


#' Calculate DMSO recovery
#'
#' @description
#' The DMSO recovery describes the ratio of cancer cells recovered after 96h (72h of drug incubation)
#' in the DMSO negative control identified by CyQuant with respect to the number of originally seeded cells
#' assessed by Trypan blue as specified in the DRP database in `assay->cancer_seeded`.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - sid
#' - assay_id
#' - readout_id (optional)
#' - drug_id
#' - exclude
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param readout_id Vector of integers specifying the readout IDs of which the DMSO recovery is calculated
#'
#' @return A \link[tibble]{tibble} with the plate averaged recoveries for all assays/samples
#' @export
calculate_dmso_recovery <- function(
  tbl,
  con,
  readout_id = c(1, 5)
) {
  # average over wells for each plate
  dmso_response_per_plate <- dplyr::tbl(con, "plate_content_view") |>
    dplyr::filter(
      sid %in% tbl$sid,
      assay_id %in% tbl$assay_id,
      .data$readout_id %in% {{ readout_id }},
      drug_id == 0,
      exclude == FALSE
    ) |>
    dplyr::group_by(assay_id, plate_id, markers) |>
    dplyr::summarise(
      mean_dmso_response_per_plate = mean(response, na.rm = TRUE),
      sd_dmso_response_per_plate = sd(response, na.rm = TRUE)
    ) |>
    dplyr::ungroup()

  img_well_coverage <- dplyr::tbl(con, "plate_view") |>
    dplyr::select(plate_id, img_well_coverage, cancer_seeded)

  dmso_rec <- dmso_response_per_plate |>
    dplyr::left_join(img_well_coverage, by = dplyr::join_by(plate_id)) |>
    dplyr::mutate(
      mean_dmso_recovery_per_plate = mean_dmso_response_per_plate /
        (cancer_seeded * img_well_coverage)
    ) # recovery reported as a fraction

  dmso_rec <- dmso_rec |>
    dplyr::group_by(assay_id, markers) |>
    dplyr::summarise(
      mean_dmso_response = mean(mean_dmso_response_per_plate, na.rm = TRUE),
      sd_dmso_response = sd(mean_dmso_response_per_plate, na.rm = TRUE),
      mean_dmso_recovery = mean(mean_dmso_recovery_per_plate, na.rm = TRUE),
      sd_dmso_recovery = sd(mean_dmso_recovery_per_plate, na.rm = TRUE),
    ) |>
    dplyr::ungroup() |>
    dplyr::collect()

  tbl <- tbl |>
    dplyr::left_join(dmso_rec, by = "assay_id")
  return(tbl)
}


#' Calculate proliferation index
#'
#' @description
#' The proliferation capacity is assessed by comparing the number of cancer cells at 96h and 18h (right before drug addition).
#' A value above 1 means that the cells have proliferated on average while a value below 1 means there is loss of cells viability due to drug-independent cell death.
#' @concept scoring
#'
#' @param tbl A \link[tibble]{tibble} with at least the following columns:
#' - sid
#' - assay_id
#' - readout_id (optional)
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param readout_id Vector of integers specifying the readout IDs of which the proliferation index is calculated
#'
#' @note
#' The response must be of the same `readout_id` at 18h and at the endpoint.
#'
#' @return Numeric specifying the proliferation ratio for all assays/samples
#' @export
calculate_proliferation <- function(tbl, con, readout_id = c(1, 5)) {
  # Get untreated control wells (without DMSO) at 96h
  wells_96h <- pool::dbReadTable(con, "plate_view") |>
    tidyr::pivot_longer(
      cols = c(control_wells_t96, control_wells_t18),
      names_to = "timepoint",
      names_prefix = "control_wells_",
      values_to = "control_wells"
    ) |>
    dplyr::filter(timepoint == "t96") |>
    tidyr::separate_longer_delim(control_wells, "/") |>
    tidyr::separate(col = control_wells, into = c("row", "col"), sep = 1) |>
    dplyr::mutate(col = readr::parse_number(col)) |>
    dplyr::select(measurement_id, assay_id, sid, row, col, img_well_coverage) |>
    tidyr::drop_na(row, col)

  # Response from untreated control wells (without DMSO) at 18h
  cell_count_t18 <- pool::dbReadTable(con, "assay") |>
    dplyr::mutate(mean_response_pp_t18 = cancer_18h / coverage_18h) |>
    dplyr::select(assay_id, mean_response_pp_t18)

  # Combine cell counts
  cell_counts <- dplyr::tbl(con, "measurement_content") |>
    dplyr::filter(
      measurement_id %in%
        wells_96h$measurement_id &&
        col %in% wells_96h$col &&
        row %in% wells_96h$row &&
        .data$readout_id %in% {{ readout_id }}
    ) |>
    dplyr::collect() |>
    dplyr::right_join(
      wells_96h,
      by = dplyr::join_by(measurement_id, col, row)
    ) |>
    dplyr::mutate(response = response / img_well_coverage) |>
    dplyr::group_by(measurement_id, assay_id, sid, readout_id) |>
    dplyr::summarise(
      mean_response_pp_t96 = mean(response, na.rm = TRUE),
      sd_response_pp_t96 = sd(response, na.rm = TRUE),
    ) |>
    dplyr::ungroup() |>
    dplyr::left_join(cell_count_t18, by = dplyr::join_by(assay_id))

  proliferation_index <- cell_counts |>
    dplyr::mutate(
      proliferation_index = mean_response_pp_t96 / mean_response_pp_t18,
      proliferation_index_sd = (sd_response_pp_t96 / mean_response_pp_t96) *
        proliferation_index
    ) |>
    dplyr::mutate(across(where(is.numeric), ~ dplyr::na_if(., NaN)))

  if ("readout_id" %in% colnames(tbl)) {
    join_cols <- c("sid", "assay_id", "readout_id")
  } else {
    join_cols <- c("sid", "assay_id")
  }
  tbl <- tbl |>
    dplyr::left_join(proliferation_index, by = join_cols)
  return(tbl)
}


#' Correlation p-value
#'
#' @description
#' Compute the matrix of correlation p-values
#'
#' @concept scoring
#'
#' @param tbl A numeric matrix or tibble
#' @param ... Additional arguments to be passed to cor.test.
#' @export
cor_pmat <- function(tbl, ...) {
  mat <- as.matrix(tbl)
  n <- ncol(mat)
  p.mat <- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- stats::cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  return(p.mat)
}
