#' Validate layout
#'
#' @description
#' Validate headers of a layout tibble for completeness
#' @concept io
#'
#' @param layout A \link[tibble]{tibble} to be checked for compliance with the layout header requirements
#'
#' @return Boolean
#' @export
validate_layout <- function(layout) {
  layout <- layout |>
    dplyr::rename(dplyr::any_of(c(
      `concentration` = "conc_nM",
      `concentration` = "destination_conc",
      `row` = "destination_row",
      `row` = "Destination Row",
      `col` = "destination_col",
      `col` = "Destination Column"
    )))
  compatible <-
    all(
      all(tibble::has_name(
        layout,
        c("row", "col", "concentration")
      )),
      any(tibble::has_name(layout, c("drug_id", "drug", "drug_name"))),
      any(tibble::has_name(layout, c("unit_id", "unit"))),
      !any(duplicated(layout))
    )
  if (compatible) {
    return(layout)
  } else {
    rlang::abort(
      glue::glue(
        "Invalid layout table, please verify the table headers and check for duplicated rows"
      ),
      "invalid_layout"
    )
  }
}


#' Validate measurement
#'
#' @description
#' Validate headers of a measurement tibble for completeness
#' @concept io
#'
#' @param measurement A \link[tibble]{tibble} to be checked for compliance with the measurement header requirements
#'
#' @return Boolean
#' @export
validate_measurement <- function(measurement) {
  compatible <-
    all(tibble::has_name(
      measurement,
      c("row", "col", "response")
    ))

  if (!any(tibble::has_name(measurement, c("readout_id", "readout")))) {
    rlang::abort(
      "Neither column readout nor readout_id is present. Please specify one of them.",
      class = "missing_readout"
    )
  }

  validate_marker_ids <- function(x) {
    x <- as.integer(x)
    if (any(is.na(x))) {
      rlang::abort(
        "Invalid element in the marker_ids column. Please check the marker_ids format.",
        class = "invalid_marker_ids"
      )
    } else {
      return(x)
    }
  }

  if (tibble::has_name(measurement, "marker_ids")) {
    measurement <- measurement |>
      dplyr::rowwise() |>
      dplyr::mutate(
        marker_ids = stringr::str_split(.data$marker_ids, ",")[[1]] |>
          trimws() |>
          validate_marker_ids() |>
          sort() |>
          paste(collapse = ", ")
      )
  }

  if (!tibble::has_name(measurement, "exclude")) {
    measurement <- measurement |> tibble::add_column(exclude = FALSE)
  }
  if (compatible) {
    return(measurement)
  } else {
    rlang::abort(
      glue::glue(
        "Invalid measurement table, please verify the table headers"
      ),
      class = "invalid_measurement"
    )
  }
}
