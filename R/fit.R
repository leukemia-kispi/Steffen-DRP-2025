# initialization parameters

#' Initialize fit parameters
#'
#' @description
#' Provides default start parameters and boundaries for the LL.2, LL.3, LL.4 and LL.5 models.
#' @concept fitting
#'
#' @return List of fit parameters for the different models
#' @export
initialize_parameters <- function() {
  PARAM_init <- list(
    LL.2 = list(
      fixed = c(b = NA, c = 0, d = 1, e = NA, f = 1),
      lowerl = c(b = 0.01, c = NA, d = NA, e = 0.0001, f = NA),
      upperl = c(b = 2.5, c = NA, d = NA, e = 1000000, f = NA),
      start = c(b = 1, c = NA, d = NA, e = 100, f = NA)
    ),
    LL.3 = list(
      fixed = c(b = NA, c = NA, d = 1, e = NA, f = 1),
      lowerl = c(b = 0.01, c = 0, d = NA, e = 0.0001, f = NA),
      upperl = c(b = 2.5, c = 1, d = NA, e = 1000000, f = NA),
      start = c(b = 1, c = 0, d = NA, e = 100, f = NA)
    ),
    LL.4 = list(
      fixed = c(b = NA, c = NA, d = NA, e = NA, f = 1),
      lowerl = c(b = 0.01, c = 0, d = 0, e = 0.0001, f = NA),
      upperl = c(b = 2.5, c = 1, d = 2, e = 1000000, f = NA),
      start = c(b = 1, c = 0, d = 1, e = 100, f = NA)
    ),
    LL.5 = list(
      fixed = c(b = NA, c = NA, d = NA, e = NA, f = NA),
      lowerl = c(b = 0.01, c = 0, d = 0, e = 0.0001, f = 0),
      upperl = c(b = 2.5, c = 1, d = 2, e = 1000000, f = 1),
      start = c(b = 1, c = 0, d = 1, e = 100, f = 1)
    )
  )
  return(PARAM_init)
}

#' Fit a drug response model
#'
#' @description
#' Fit a dose-response model using a \link[drc]{drm} package.
#' @concept fitting
#'
#' @param tbl A tibble with the columns:
#' - concentration
#' - norm_response
#' @param fixed A numeric vector specifying the values of the parameters (b, c, d, e, f) that should be fixed in the drc model. Variable parameters should be specified as NA.
#' @param lowerl Lower boundaries of the variable parameters
#' @param upperl Upper boundaries of the variable parameters
#' @param start Starting values of the variable parameters (if NULL the model chooses starting values automatically)
#'
#' @return A \link[drc]{drm} model
#' @export
fit <- function(
  tbl,
  fixed = c(NA, NA, 1, NA, 1),
  lowerl = c(0.01, 0, 0.0001),
  upperl = c(2.5, 1, 1000000),
  start = c(1, 0, 100)
) {
  if (is.null(start)) {
    mdl <-
      suppressWarnings(drc::drm(
        norm_response ~ log10(concentration),
        data = tbl,
        fct = drc::LL.5(fixed = fixed),
        lowerl = na.omit(lowerl),
        upperl = na.omit(upperl),
        robust = "median",
        type = "continuous",
        logDose = 10,
        bcVal = 1
      ))
  } else {
    mdl <-
      suppressWarnings(drc::drm(
        norm_response ~ log10(concentration),
        data = tbl,
        fct = drc::LL.5(fixed = fixed),
        lowerl = na.omit(lowerl),
        upperl = na.omit(upperl),
        start = na.omit(start),
        robust = "median",
        type = "continuous",
        logDose = 10,
        bcVal = 1
      ))
  }
  return(mdl)
}


#' CLI for curve fitting
#'
#' @description
#' A command line interface (CLI) for fitting dose response curves. The CLI internally calls \link{fit_wrapper} to fit, extract parameters
#' and predict dose response curves using the \link[drc]{drm} package. The parameters and fitted curves are then written to the DRP Postgres database.
#' @concept fitting
#'
#' @param tbl A tibble with at least the columns:
#' - plate_id
#' - sid
#' - drug_id
#' - concentration
#' - readout_id
#' - norm_response
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param fixed A numeric vector specifying the values of the parameters (b, c, d, e, f) that should be fixed in the drc model. Variable parameters should be specified as NA.
#' @param lowerl Lower boundaries of the variable parameters
#' @param upperl Upper boundaries of the variable parameters
#' @param start Starting values of the variable parameters (if NULL the model chooses starting values automatically)
#' @param show_coefficients Boolean indicating whether to print out fit coefficients
#'
#' @export
#' @seealso \link{fit_wrapper} and \link{fit}
#'
#' @examples
#' tbl <- tibble::tribble(
#'   ~sid, ~plate_id, ~drug_id, ~concentration, ~norm_response, ~readout_id,
#'   1, 1, 1, 0.4, 1, 1,
#'   1, 1, 1, 1.3, 0.75, 1,
#'   1, 1, 1, 4.5, 0.3, 1,
#'   1, 1, 1, 15, 0.1, 1,
#'   1, 1, 1, 50, 0, 1
#' )
#' # cli_fit(tbl, con)
cli_fit <- function(
  tbl,
  con,
  fixed = c(NA, NA, 1, NA, 1),
  lowerl = c(0.01, 0, 0.0001),
  upperl = c(2.5, 1, 1000000),
  start = NULL,
  show_coefficients = FALSE
) {
  cli::cli_h1("Curve fitting")
  PARAM_init <- initialize_parameters()
  mdl_name <- id_to_desc(sum(is.na(fixed)) - 1, "ref-fitmodel", con)
  cli::cli_alert_info("Using model {mdl_name}")
  uniq <- tbl |>
    tidyr::drop_na(drug_id) |>
    dplyr::filter(drug_id != 0) |>
    dplyr::distinct(sid, plate_id, drug_id, readout_id, .keep_all = TRUE) |>
    dplyr::arrange(plate_id, drug_id) |>
    dplyr::mutate(
      sid_lknumber = dplyr::if_else(
        is.na(lknumber),
        as.character(sid),
        glue::glue("{sid} ({lknumber})")
      )
    )
  cli::cli_progress_bar("Fitting drug", total = nrow(uniq))
  for (i in seq_len(nrow(uniq))) {
    sid <- uniq[[i, "sid"]]
    sid_lknumber <- uniq[[i, "sid_lknumber"]]
    plate_id <- uniq[[i, "plate_id"]]
    drug_id <- uniq[[i, "drug_id"]]
    readout_id <- uniq[[i, "readout_id"]]
    tryCatch(
      {
        cli::cli_progress_update(
          status = glue::glue("Sample: {sid_lknumber}) | Plate: {plate_id}")
        )
        tbl |>
          dplyr::filter(
            drug_id == {{ drug_id }},
            plate_id == {{ plate_id }},
            readout_id == {{ readout_id }},
            sid == {{ sid }},
            exclude == FALSE
          ) |>
          fit_wrapper(
            con,
            NULL,
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
      },
      error = function(e) {
        tryCatch(
          {
            tbl |>
              dplyr::filter(
                drug_id == {{ drug_id }},
                plate_id == {{ plate_id }},
                readout_id == {{ readout_id }},
                sid == {{ sid }},
                exclude == FALSE
              ) |>
              drpr::fit_wrapper(
                con,
                NULL,
                drug_id,
                plate_id,
                mdl_name,
                PARAM_init[[mdl_name]]$fixed,
                PARAM_init[[mdl_name]]$lowerl,
                PARAM_init[[mdl_name]]$upperl,
                PARAM_init[[mdl_name]]$start,
                readout_id,
                sid
              )
          },
          error = function(e) {
            drug_name <- id_to_desc(
              {{ drug_id }},
              "drug",
              con,
              drug_id,
              drug_name
            )
            cli::cli_alert_danger(
              "Error fitting {drug_name} from sample {sid_lknumber} on plate {plate_id}."
            )
            cli::cli_alert(conditionMessage(e))
          }
        )
      }
    )
  }
  cli::cli_alert_success("Finished fitting curves.")
  if (isTRUE(show_coefficients)) {
    coef <- uniq |>
      dplyr::select(-lknumber) |>
      dplyr::left_join(
        pool::dbReadTable(con, "parameter_view"),
        by = dplyr::join_by(plate_id, drug_id, readout_id, sid)
      ) |>
      dplyr::select(
        "sid",
        "plate_id",
        "drug_name",
        "readout",
        "b",
        "c",
        "d",
        "e",
        "f",
        "rse"
      ) |>
      flextable::flextable() |>
      flextable::bold(bold = TRUE, part = "header") |>
      flextable::bg(bg = "#EFEFEF", part = "header") |>
      flextable::colformat_double(digits = 0) |>
      flextable::colformat_double(j = c(5, 6, 7, 9, 10), digits = 2)
    return(coef)
  }
}


#' Curve fitting wrapper
#'
#' @description
#' Wrapper around the \link{fit} function for carrying out logistic curve fits, extract parameters and predicted curves.
#' The results are then written to the DRP Postgres database.
#' @concept fitting
#'
#' @param tbl A tibble with at least the columns:
#' - sid
#' - drug_id
#' - plate_id
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param cur A named vector with user_id and tenant_id
#' @param drug_id Integer identifying the drug
#' @param plate_id Integer identifying the plate
#' @param mdl_name Name of the fitting model
#' @param fixed A numeric vector specifying the values of the parameters (b, c, d, e, f; in this order) that should be fixed in the drc model. Variable parameters should be specified as NA.
#' @param lowerl Lower boundaries of the variable parameters
#' @param upperl Upper boundaries of the variable parameters
#' @param start Starting values of the variable parameters (if NULL the model chooses starting values automatically)
#' @param readout_id Integer specifying the readout (e.g. 1 = Viable leukemia cells)
#' @param sid Integer specifying the sample ID
#'
#' @export
fit_wrapper <- function(
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
) {
  conc <- dose_range(drug_id, con)

  # fitting
  mdl <- tbl |> drpr::fit(fixed, lowerl, upperl, start)

  # post-fit regularization for slope = 0
  if (coef(mdl)[["b:(Intercept)"]] == 0) {
    start <- c(b = 1, c = 0, d = 1, e = 10000, f = 1)
    start[!is.na(fixed)] <- NA
    mdl <- tbl |> drpr::fit(fixed, lowerl, upperl, start)
  }

  names(fixed) <- c("b", "c", "d", "e", "f")
  fixed_param <- fixed[!is.na(fixed)] |>
    tibble::enframe() |>
    tidyr::pivot_wider()

  # extract parameters
  coefficients <- coef(mdl) |>
    tibble::enframe() |>
    dplyr::mutate(name = stringr::str_extract(name, "[b-f]")) |>
    tidyr::pivot_wider()

  if (mdl_name != "LL.2") {
    # post-fit regularization for Vmin = 1 = Vmax
    coefficients <- coefficients |>
      dplyr::mutate(
        e = dplyr::case_when(
          c == 1 ~ 10^6,
          TRUE ~ e
        ),
        b = dplyr::case_when(
          c == 1 ~ 1,
          TRUE ~ b
        )
      )
  }

  # write model to DB
  # drpr::write_mdl(con, plate_id, drug_id, mdl)
  # write parameters to DB
  pool::dbExecute(
    con,
    "DELETE FROM parameter WHERE plate_id=$1 AND drug_id=$2 AND readout_id=$3 AND sid=$4;",
    c(plate_id, drug_id, readout_id, sid)
  )
  rse <- suppressWarnings(sqrt(sum(residuals(mdl)^2) / summary(mdl)$rseMat[2]))
  rse <- ifelse(is.infinite(rse), as.numeric(NA), rse)

  pool::dbWriteTable(
    con,
    name = "parameter",
    cbind(
      tibble::tibble(
        plate_id = plate_id,
        drug_id = drug_id,
        user_id = NA,
        tenant_id = NA,
        readout_id = readout_id,
        sid = sid
      ),
      fitmodel = mdl_name,
      coefficients,
      fixed_param,
      # rse = suppressWarnings(summary(mdl)$rseMat[1])
      rse = rse
    ),
    append = TRUE,
    copy = FALSE
  )

  # make prediction
  pred <-
    mdl |>
    drpr::predict_drc(
      conc[["min_assay_conc"]],
      conc[["max_assay_conc"]]
    )

  # write prediction to DB
  pool::dbExecute(
    con,
    "DELETE FROM drc_prediction WHERE plate_id=$1 AND drug_id=$2 AND readout_id=$3 AND sid=$4;",
    c(plate_id, drug_id, readout_id, sid)
  )
  pool::dbWriteTable(
    con,
    name = "drc_prediction",
    tibble::tibble(
      plate_id = plate_id,
      drug_id = drug_id,
      concentration = pred[["Concentration"]],
      unit_id = conc[["unit_id"]],
      readout_id = readout_id,
      sid = sid,
      norm_response = pred[["Prediction"]],
      norm_response_lower = pred[["Lower"]],
      norm_response_upper = pred[["Upper"]],
      user_id = NA,
      tenant_id = NA
    ),
    append = TRUE,
    copy = FALSE
  )
}


#' Get preferred drug dose range
#'
#' @description
#' Get preferred minimum and maximum dose of a specific drug
#' @concept fitting
#'
#' @param drug Drug name or drug ID
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A named list of the minimum and maximum doses
#' @export
dose_range <- function(drug, con) {
  doses <- pool::dbReadTable(con, "drug_view") |>
    dplyr::filter(drug_name == drug | drug_id == drug) |>
    dplyr::select(min_assay_conc, max_assay_conc, unit_id, unit)
  if (any(is.na(doses[1:2]))) {
    stop(glue::glue(
      "Preferred doses are not defined in the database for drug (ID) {drug}"
    ))
  } else {
    return(doses)
  }
}


#' Predict drug responses
#'
#' @description
#' Predict drug responses for a n-series of evenly spaced concentrations on a logarithmic scale given a minimum and maximum dose.
#' @concept fitting
#'
#' @param mdl A model of the \link[drc]{drm} class
#' @param min The minimum drug concentration
#' @param max The maximum drug concentration
#' @param n Integer specifying the number of data points to predict
#' @param interval The 95% confidence intervals around the mean (interval = "confidence") or the 95% prediction interval (interval = "prediction").
#'
#' @return A \link[tibble]{tibble} with predictions and confidence intervals in the following columns:
#' - Concentration
#' - Prediction
#' - Lower
#' - Upper
#' @export
predict_drc <- function(mdl, min, max, n = 25, interval = "confidence") {
  data <-
    log10(expand.grid(
      Concentration = exp(seq(
        log(min),
        log(max),
        length = n
      ))
    ))
  pred <-
    suppressWarnings(predict(mdl, newdata = data, interval = interval)) |>
    tibble::as_tibble()
  pred <- pred |> tibble::add_column(10**data, .before = 1)
  return(pred)
}


#' Relabel fit parameters columns
#'
#' @description
#' Create a copy of the default fit parameter columns (b,c,d,e) and make their names interpretable as pertaining to an inhibition and viability dose response model
#'
#' - `b` is the inverse slope
#' - `c` is the lower asymptote corresponding to the minimum inhibition in an inhibition model or the minimum viability in an viability model
#' - `d` is the upper asymptote corresponding to the maximum inhibition in an inhibition model or the maximum viability in a viability model
#' - `e` is the EC50
#' @concept fitting
#'
#' @param tbl A \link[tibble]{tibble} with columns b,c,d,e
#' @param data_type A character string describing if the \link[drc]{drm} parameters are determined by fitting a "inhibition" or "viability" curve
#'
#' @return A \link[tibble]{tibble} with EC50, inverse_slope (N_inv), min_inhibition (I_min), min_viability (I_max), min_viability (V_min) and max_viability (V_max) columns added
#' @seealso [extract_fit_parameters()]
#' @export
relabel_fit_parameters <- function(tbl, data_type = "viability") {
  if (data_type == "inhibition") {
    tbl <- tbl |> dplyr::mutate(EC50 = e, I_min = c, I_max = d, N_inv = b)
  } else if (data_type == "viability") {
    tbl <- tbl |> dplyr::mutate(EC50 = e, V_min = c, V_max = d, N_inv = b)
  } else {
    stop("The data type must be either \"viability\" or \"inhibition\"")
  }
  return(tbl)
}


#' Four-parameter log-Logistic model
#'
#' @description The log-logistic four-parameter model (ll.4) as implemented by the \link[drc]{drm} package
#' and decribed from Ritz et al. PLOS ONE 2015.
#' @concept fitting
#'
#' @param x Logarithmic concentration
#' @param b Inverse slope parameter
#' @param c Lower asymptote
#' @param d Upper asymptote
#' @param logEC50 Logarithmic half-maximum effective concentration (relative EC50)
#'
#' @return Predicted effect
#' @export
ll4 <- function(x, b, c, d, logEC50) {
  y <- c + (d - c) / (1 + 10^(b * (x - logEC50)))
  return(y)
}


#' Invert the log-logistic curve
#'
#' @description
#' `inverse_ll4` calculates the concentration (x) for a given (absolute) response (y)
#' by solving the four-parameter log-logistic function for x.
#' @concept fitting
#'
#' @param y Drug response
#' @param b Slope parameter
#' @param c Lower asymptote
#' @param d Upper asymptote
#' @param logEC50 Logarithmic half-maximum effective concentration (relative EC50)
#'
#' @seealso [calculate_absolute_logEC()]
#' @return Concentration at which the given response is observed
#' @export
inverse_ll4 <- function(y, b, c, d, logEC50) {
  x <- dplyr::case_when(
    d - y < 0 ~ -Inf,
    y - c < 0 ~ Inf,
    TRUE ~ suppressWarnings(logEC50 + ((log10(d - y) - log10(y - c)) / b))
  )
  return(x)
}
