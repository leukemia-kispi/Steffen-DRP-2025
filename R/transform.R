#' Get reference data
#'
#' @description
#' Return the list of all reference tables in the DRP database.
#' @concept transforming
#'
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param with_synonyms Boolean indicating whether to include drug synonyms
#'
#' @returns A list with reference \link[tibble]{tibble}
#' @export
reference <- function(con, with_synonyms = TRUE) {
  ref_view <- pool::dbReadTable(con, "reference_view") |>
    dplyr::group_by(ref)
  group_names <- dplyr::group_keys(ref_view)
  ref_view_list <- ref_view |>
    dplyr::group_split(.keep = FALSE) |>
    rlang::set_names(group_names$ref)

  drug_preferred <- pool::dbReadTable(con, "drug") |>
    dplyr::select("drug_id", drug = "drug_name")
  drug_synonym <- pool::dbReadTable(con, "drug__synonym") |>
    dplyr::select("drug_id", drug = "synonym")

  code_tbls <- list(
    alteration = ref_view_list$alteration |>
      dplyr::select(alteration_id = "id", alteration = "description"),
    anticoagulant = ref_view_list$anticoagulant |>
      dplyr::select(anticoagulant_id = "id", anticoagulant = "description"),
    biological_process = ref_view_list$biological_process |>
      dplyr::select(
        biological_process_id = "id",
        biological_process = "description"
      ),
    chromosomal_aberration = ref_view_list$chromosomal_aberration |>
      dplyr::select(
        chromosomal_aberration_id = "id",
        chromosomal_aberration = "description"
      ),
    cell_isolation = ref_view_list$cell_isolation |>
      dplyr::select(cell_isolation_id = "id", cell_isolation = "description"),
    contaminated = ref_view_list$contaminated |>
      dplyr::select(contaminated_id = "id", contaminated = "description"),
    country = ref_view_list$country |>
      dplyr::select(country_id = "id", country = "description"),
    diagnosis = ref_view_list$diagnosis |>
      dplyr::select(diagnosis_id = "id", diagnosis = "description"),
    disease_stage = ref_view_list$disease_stage |>
      dplyr::select(disease_stage_id = "id", disease_stage = "description"),
    drp_hospital = ref_view_list$drp_hospital |>
      dplyr::select(drp_hospital_id = "id", drp_hospital = "description"),
    egil_fab = ref_view_list$egil_fab |>
      dplyr::select(egil_fab_id = "id", egil_fab = "description"),
    ethnicity = ref_view_list$ethnicity |>
      dplyr::select(ethnicity_id = "id", ethnicity = "description"),
    expression = ref_view_list$expression |>
      dplyr::select(expression_id = "id", expression = "description"),
    fitmodel = ref_view_list$fitmodel |>
      dplyr::select(fitmodel_id = "id", fitmodel = "description"),
    functional_class = ref_view_list$functional_class |>
      dplyr::select(
        functional_class_id = "id",
        functional_class = "description"
      ),
    gene = ref_view_list$gene |>
      dplyr::select(gene_id = "id", gene = "description"),
    layout_type = ref_view_list$layout_type |>
      dplyr::select(layout_type_id = "id", layout_type = "description"),
    lineage = ref_view_list$lineage |>
      dplyr::select(lineage_id = "id", lineage = "description"),
    localization = ref_view_list$localization |>
      dplyr::select(localization_id = "id", localization = "description"),
    marker = ref_view_list$marker |>
      dplyr::select(marker_id = "id", marker = "description"),
    marker_category = ref_view_list$marker_category |>
      dplyr::select(marker_category_id = "id", marker_category = "description"),
    medium = ref_view_list$medium |>
      dplyr::select(medium_id = "id", medium = "description"),
    msc_detached = ref_view_list$msc_detached |>
      dplyr::select(msc_detached_id = "id", msc_detached = "description"),
    origin = ref_view_list$origin |>
      dplyr::select(origin_id = "id", origin = "description"),
    plate_format = ref_view_list$plate_format |>
      dplyr::select(plate_format_id = "id", plate_format = "description"),
    readout = ref_view_list$readout |>
      dplyr::select(readout_id = "id", readout = "description"),
    response_assessment = ref_view_list$response_assessment |>
      dplyr::select(
        response_assessment_id = "id",
        response_assessment = "description"
      ),
    response_method = ref_view_list$response_method |>
      dplyr::select(response_method_id = "id", response_method = "description"),
    response_mrd = ref_view_list$response_mrd |>
      dplyr::select(response_mrd_id = "id", response_mrd = "description"),
    sending_hospital = ref_view_list$sending_hospital |>
      dplyr::select(
        sending_hospital_id = "id",
        sending_hospital = "description"
      ),
    sex = ref_view_list$sex |>
      dplyr::select(sex_id = "id", sex = "description"),
    subtype = ref_view_list$subtype |>
      dplyr::select(subtype_id = "id", subtype = "description"),
    relapse_time = ref_view_list$relapse_time |>
      dplyr::select(relapse_time_id = "id", relapse_time = "description"),
    tissue = ref_view_list$tissue |>
      dplyr::select(tissue_id = "id", tissue = "description"),
    unit = ref_view_list$unit |>
      dplyr::select(unit_id = "id", unit = "description"),
    treating_hospital = ref_view_list$treating_hospital |>
      dplyr::select(
        treating_hospital_id = "id",
        treating_hospital = "description"
      )
  )
  if (isTRUE(with_synonyms)) {
    code_tbls <- c(
      list(drug = dplyr::bind_rows(drug_preferred, drug_synonym)),
      code_tbls
    )
  } else {
    code_tbls <- c(list(drug = drug_preferred), code_tbls)
  }
  return(code_tbls)
}

#' Select tibble columns from Postgres
#'
#' @description
#' Selects columns of a tibble based on the variables present in a given Postgres table.
#' @concept transforming
#'
#' @param tbl A \link[tibble]{tibble} to select columns from
#' @param name Character string specifying the name of the Postgres table
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} with the selected columns
#' @export
select_from_pg <- function(tbl, name, con) {
  pg_vars <- pool::dbGetQuery(
    con,
    "SELECT column_name FROM information_schema.columns WHERE table_name = $1",
    param = name
  )$column_name
  tbl <- tbl |>
    dplyr::select(dplyr::any_of(pg_vars))
  return(tbl)
}


#' Encode feature columns
#'
#' @description
#' `encode` converts character columns to integers according to the definitions in the specified DRP database.
#' @concept transforming
#'
#' @param tbl A \link[tibble]{tibble} with character feature columns defined in the DRP database.
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} with encoded features (integer feature columns)
#' @seealso [decode()]
#' @export
encode <- function(tbl, con) {
  code_tbls <- reference(con)
  for (feature in names(code_tbls)) {
    if (feature %in% names(tbl)) {
      feature_id <- glue::glue("{feature}_id")
      if (feature_id %in% names(tbl)) {
        cli::cli_abort(
          "Columns \"{feature}\" and \"{feature_id}\" are present in the table. Please remove one of them."
        )
      }
      tbl <- dplyr::left_join(
        tbl,
        dplyr::distinct(
          code_tbls[[feature]],
          .data[[feature]],
          .keep_all = TRUE
        ),
        by = feature
      ) |>
        dplyr::relocate(
          dplyr::all_of(feature_id),
          .before = dplyr::all_of(feature)
        )

      missing <- setdiff(unique(tbl[[feature]]), code_tbls[[feature]][[2]]) |>
        paste(collapse = ", ")
      if (missing != "") {
        rlang::abort(
          glue::glue(
            "The following {feature}(s) are missing in the database: {missing}"
          ),
          "missing_feature"
        )
      } else {
        tbl <- tbl |> dplyr::select(!dplyr::all_of(feature))
      }
    }
  }
  return(tbl)
}


#' Decode feature columns
#'
#' @description
#' `encode` converts integer columns to character according to the definitions in the specified DRP database.
#' @concept transforming
#'
#' @param tbl A \link[tibble]{tibble} with integer feature columns defined in the DRP database.
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} with decoded features (character feature columns)
#' @seealso [encode()]
#' @export
decode <- function(tbl, con) {
  code_tbls <- reference(con, with_synonyms = FALSE)
  for (feature in names(code_tbls)) {
    feature_id <- glue::glue("{feature}_id")
    if (feature_id %in% names(tbl)) {
      tbl <- dplyr::left_join(tbl, code_tbls[[feature]], by = feature_id) |>
        dplyr::relocate(
          dplyr::all_of(feature),
          .before = dplyr::all_of(feature_id)
        )

      missing <- setdiff(
        unique(tbl[[feature_id]]),
        code_tbls[[feature]][[1]]
      ) |>
        paste(collapse = ", ")
      if (missing != "") {
        rlang::abort(
          glue::glue(
            "The following {feature_id}(s) are missing in the database: {missing}"
          ),
          "missing_feature"
        )
      } else {
        tbl <- tbl |> dplyr::select(!dplyr::all_of(feature_id))
      }
    }
  }
  return(tbl)
}


#' Encode comma-separated values
#'
#' @description
#' `encode_csv` converts a comma-separated string of characters values to a comma-separated string of integers
#' according to the definitions in the specified DRP database.
#' @concept transforming
#'
#' @param tbl A reference \link[tibble]{tibble} with the id-description mapping.
#' @param ref_tbl Character string of the table name in the DRP database or a reference \link[tibble]{tibble} with the id-description mapping
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A \link[tibble]{tibble} with encoded features (comma-delimited integer vector)
#' @seealso [encode()], [decode()]
#' @export
encode_csv <- function(tbl, ref_tbl, con) {
  if (is.character(ref_tbl)) {
    ref_tbl <- pool::dbReadTable(con, ref_tbl)
  }
  tbl <- tbl |>
    dplyr::rowwise() |>
    dplyr::mutate(dplyr::across(
      dplyr::ends_with("s") & !dplyr::ends_with("_ids"),
      ~ paste0(
        desc_to_id(
          unlist(purrr::map(stringr::str_split(.x, ","), trimws)),
          ref_tbl,
          con,
          ignore_error = FALSE
        ),
        collapse = ", "
      ),
      .names = "{paste0(stringr::str_remove(.col, 's$'), '_ids_tmp')}"
    )) |>
    dplyr::rename_with(
      ~ stringr::str_replace(.x, "_ids", "_ids_tmp"),
      dplyr::ends_with("_ids")
    ) |>
    dplyr::select(-dplyr::ends_with("s")) |>
    dplyr::rename_with(
      ~ stringr::str_replace(.x, "_ids_tmp", "_ids"),
      dplyr::ends_with("_ids_tmp")
    )
  return(tbl)
}


#' Convert ID to description
#'
#' @description
#' Get the description of a reference data record from the ID column in the DRP database.
#' @concept transforming
#'
#' @param id integer to convert to description
#' @param ref_tbl Character string of the table name in the DRP database or a reference \link[tibble]{tibble} with the id-description mapping
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param id_col <[`tidy-select`][dplyr_tidy_select]> name of the ID column in the table
#' @param description_col <[`tidy-select`][dplyr_tidy_select]> name of the description column in the table
#' @param ignore_error Boolean indicating whether to ignore missing IDs that lead to NAs
#'
#' @return A character string
#' @export
id_to_desc <- function(
  id,
  ref_tbl,
  con,
  id_col = id,
  description_col = description,
  ignore_error = TRUE
) {
  if (is.character(ref_tbl)) {
    ref_tbl <- pool::dbReadTable(con, ref_tbl)
  }
  descs <- tibble::tibble({{ id_col }} := {{ id }}) |>
    dplyr::left_join(ref_tbl, by = dplyr::join_by({{ id_col }})) |>
    dplyr::pull({{ description_col }})
  if (isFALSE(ignore_error) && any(is.na(descs))) {
    missing <- paste0(id[is.na(descs)], collapse = ", ")
    cli::cli_abort("The following ID(s) are missing in the database: {missing}")
  }
  return(descs)
}


#' Convert description to ID
#'
#' @description
#' Get the ID of a reference data record from the description column in the DRP database.
#' @concept transforming
#'
#' @param description Character string to convert to ID
#' @param ref_tbl Character string of the table name in the DRP database or a reference \link[tibble]{tibble} with the id-description mapping
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param id_col <[`tidy-select`][dplyr_tidy_select]> name of the ID column in the table
#' @param description_col <[`tidy-select`][dplyr_tidy_select]> name of the description column in the table
#' @param ignore_error Boolean indicating whether to ignore missing descriptions that lead to NAs
#'
#' @return An integer
#' @export
desc_to_id <- function(
  description,
  ref_tbl,
  con,
  id_col = id,
  description_col = description,
  ignore_error = TRUE
) {
  if (is.character(ref_tbl)) {
    ref_tbl <- pool::dbReadTable(con, ref_tbl)
  }
  ids <- tibble::tibble({{ description_col }} := {{ description }}) |>
    dplyr::left_join(ref_tbl, by = dplyr::join_by({{ description_col }})) |>
    dplyr::pull({{ id_col }})
  if (isFALSE(ignore_error) && any(is.na(ids))) {
    missing <- paste0(description[is.na(ids)], collapse = ", ")
    cli::cli_abort(
      "The following description(s) are missing in the database: {missing}"
    )
  }
  return(ids)
}


#' Calculate negative control statistics
#'
#' @description
#' Calculate the mean or median of the DRP negative control.
#' @concept transforming
#'
#' @param tbl A tibble with at least the following columns present:
#' - drug
#' - response
#' @param negative_control A string defining the substance to use as negative control
#' @param FUN An averaging function, i.e. mean or median
#'
#' @return A dbl of the average negative control response
#' @export
negative_control_stat <- function(tbl, negative_control = "DMSO", FUN = mean) {
  if ("sid" %in% names(tbl) && "assay_id" %in% names(tbl)) {
    grp <- rlang::quos(
      dplyr::across(dplyr::starts_with("readout")),
      sid,
      assay_id
    )
  } else {
    grp <- rlang::quos(dplyr::across(dplyr::starts_with("readout")))
  }
  dmso <- tbl |>
    dplyr::rename(dplyr::any_of(c(drug_name = "drug"))) |>
    dplyr::group_by(!!!grp) |>
    dplyr::filter(drug_name %in% negative_control & .data$exclude == FALSE) |>
    dplyr::summarise(neg_control_avg = FUN(response)) |>
    dplyr::ungroup()
  if (nrow(dmso) == 0) {
    cli::cli_abort(
      "{negative_control} wells cannot be identified on the plate. Possible causes:
        1. No DMSO labeled wells are present on the layout.
        2. No measurements are present for the wells labeled as DMSO on the layout.",
      class = "negative_control_not_found"
    )
  }
  return(dmso)
}


#' Normalize drug responses
#'
#' @description
#' `normalize_response` divides each readout observation by the mean DMSO response and adds a column `norm_response` to the tibble
#' @concept transforming

#' @param plate A tibble with at least the following columns:
#' - drug
#' - response
#' @param negative_control A character vector describing the treatment (drug) used as a negative control (e.g. DMSO)
#' @param negative_control_mean A manually pre-calculated, mean DMSO response (e.g. if no DMSO was measured on the current plate).
#' Overrules any DMSO observations present on the plate.
#' @param remove_control Boolean indicating whether to remove DMSO observations from the resulting tibble
#'
#' @return A \link[tibble]{tibble} with normalized responses added
#' @export
normalize_response <- function(
  plate,
  negative_control = "DMSO",
  negative_control_mean = NULL,
  remove_control = FALSE
) {
  if (is.null(negative_control_mean)) {
    negative_control_mean <- negative_control_stat(
      plate,
      negative_control,
      FUN = mean
    )
  }
  plate <- plate |>
    dplyr::left_join(
      negative_control_mean,
      by = names(plate)[names(plate) %in% names(negative_control_mean)]
    ) |>
    dplyr::mutate(
      norm_response = response / neg_control_avg,
      neg_control_avg = neg_control_avg
    ) |>
    dplyr::filter(
      if (remove_control == TRUE) {
        dplyr::across(dplyr::starts_with("drug")) != negative_control
      } else {
        TRUE
      }
    )
  return(plate)
}


#' Normalize measurements
#'
#' @description
#' Normalize measurements to the DMSO control.
#' @concept transforming
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param plate_id Numeric indicating which plate should be normalized.
#'
#' @export
normalize_measurements <- function(con, plate_id) {
  df <- pool::dbGetQuery(
    con,
    "SELECT * FROM plate_content_view WHERE plate_id = $1 ORDER BY plate_id, row, col, drug_id, readout_id",
    plate_id
  ) |>
    normalize_response(
      negative_control_mean = NULL,
      negative_control = c("DMSO", "DMSOcontrol")
    )

  pool::dbExecute(
    con,
    "DELETE FROM normalization_content WHERE measurement_id = $1",
    unique(df$measurement_id)
  )

  pool::dbWriteTable(
    con,
    "normalization_content",
    df |>
      dplyr::select(
        "measurement_id",
        "row",
        "col",
        "norm_response",
        "plate_id",
        "readout_id",
        "tenant_id",
        "user_id"
      ) |>
      dplyr::distinct(
        .data$measurement_id,
        .data$row,
        .data$col,
        .data$readout_id,
        .keep_all = TRUE
      ),
    append = TRUE
  )
}


#' Convert features into factors
#'
#' @description
#' Convert character features into unordered or ordered factors.
#' @concept transforming
#'
#' @param tbl A \link[tibble]{tibble} with character feature columns to be converted into factors
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#' @param drop_unused_levels Boolean indicating whether to drop unused levels
#'
#' @return A \link[tibble]{tibble} with factor features
#' @export
as_factor <- function(tbl, con, drop_unused_levels = FALSE) {
  ref_data <- pool::dbReadTable(con, "reference_view")
  fct_type <- pool::dbReadTable(con, "ref-ordered_feature")
  for (feature in colnames(tbl)) {
    if (feature %in% unique(ref_data$ref)) {
      levels <- ref_data |>
        dplyr::filter(.data$ref == feature) |>
        dplyr::arrange(.data$id) |>
        dplyr::pull(description)
      is_ordered <- dplyr::filter(fct_type, feature == {{ feature }})$is_ordered
      if (length(is_ordered) > 0) {
        tbl <- tbl |>
          dplyr::mutate(
            {{ feature }} := factor(
              !!rlang::ensym(feature),
              levels = levels, # NAs are not factor levels
              ordered = is_ordered
            )
          )
        if (isTRUE(drop_unused_levels)) {
          tbl <- tbl |>
            dplyr::mutate({{ feature }} := droplevels(!!rlang::ensym(feature)))
        }
      }
    }
  }
  return(tbl)
}
