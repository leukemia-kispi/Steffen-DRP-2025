library(drpr)

rlang::check_installed(
  c("jsonlite", "keyring", "swagger"),
  reason = "to run the plumber API"
)

plumber::register_docs(
  name = "swagger_v5",
  index = function(version = "5") {
    swagger::swagger_spec(
      api_path = paste0(
        "window.location.origin + ",
        "window.location.pathname.replace(",
        "/\\(",
        "__swagger__\\\\/|",
        "__swagger__\\\\/",
        "index.html|",
        "__docs__\\\\/|",
        "__docs__\\\\/",
        "index.html",
        "\\)$/, ",
        "\"\"",
        ") + \"openapi.json\""
      ),
      version = version
    )
  },
  static = function(version = "5", ...) {
    swagger::swagger_path(version)
  }
)


#' Get logged in user
#'
#' @description
#' Returns a tibble with attributes of the currently logged in user.
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#'
#' @returns A \link[tibble]{tibble} with `user_id`, `role`, and `tenant_id`
#' @export
get_logged_in_user <- function(con) {
  session <- pool::dbGetQuery(
    con,
    "SELECT session_user AS managed_id,
            current_setting('app.user_id') AS user_id,
            current_user AS role;"
  )
  return(tibble::tibble(
    user_id = session$user_id,
    managed_id = session$managed_id,
    role = session$role,
    tenant_id = "DZ"
  ))
}


#' Read database record
#'
#' @description
#' Returns a filtered view of the database table
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param tbl Character string specifying the database table
#' @param pk <[`tidy-select`][dplyr_tidy_select]> specifying the primary key of the database table
#' @param id Integer specifying the ID of the entry to be updated
read_record <- function(con, tbl, pk, id, res) {
  pk_str <- rlang::as_name(rlang::quo({{ pk }}))
  read <- pool::dbReadTable(con, tbl) |>
    dplyr::arrange(dplyr::desc({{ pk }})) |>
    dplyr::filter({{ pk }} == {{ id }}) |>
    dplyr::mutate(dplyr::across(dplyr::where(is.character), split_and_convert))
  if (nrow(read) > 0) {
    validate_id(1, {{ pk_str }}, id, read, res)
  } else {
    validate_id(0, {{ pk_str }}, id, NULL, res)
  }
}


#' Write database record
#'
#' @description
#' Write a record to specified database table given an HTTP request body
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param tbl Character string specifying the database table
#' @param req HTTP request body object
#' @param res HTTP response object
#' @param silent Boolean indicating whether to hide HTTP response status and body
write_record <- function(con, tbl, body, res, silent = FALSE) {
  if (length(body) > 1) {
    tryCatch(
      {
        auth <- get_logged_in_user(con)
        req_tbl <- body |>
          purrr::map(~ dplyr::coalesce(.x, NA)) |>
          tibble::as_tibble() |>
          dplyr::mutate(
            user_id = auth$user_id,
            tenant_id = auth$tenant_id
          ) |>
          select_from_pg(tbl, con)
        pool::dbWriteTable(con, tbl, req_tbl, append = TRUE)
        if (isFALSE(silent)) {
          res$status <- 201
          res$body <- req_tbl
        }
      },
      error = \(e) {
        res$status <- 400
        res$body <- list(
          code = jsonlite::unbox("400 - Bad request"),
          message = jsonlite::unbox(e$message)
        )
      }
    )
  }
}


#' Delete database record
#'
#' @description
#' Delete a record on a specified database table
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param tbl Character string specifying the database table
#' @param pk <[`tidy-select`][dplyr_tidy_select]> specifying the primary key of the database table
#' @param id Integer specifying the ID of the entry to be deleted
delete_record <- function(con, tbl, pk, id, res) {
  tryCatch(
    {
      pk_str <- rlang::as_name(rlang::quo({{ pk }}))
      qry <- glue::glue("DELETE FROM {tbl} WHERE {pk_str} = $1")
      pool::dbExecute(con, qry, params = id) |>
        validate_id({{ pk_str }}, id, NULL, res)
    },
    error = \(e) {
      res$status <- 400
      res$body <- list(
        code = jsonlite::unbox("400 - Bad request"),
        message = jsonlite::unbox(e$message)
      )
    }
  )
}


#' Update database record
#'
#' @description
#' Update a record on a specified database given an HTTP request body
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param tbl Character string specifying the database table
#' @param pk <[`tidy-select`][dplyr_tidy_select]> specifying the primary key of the database table
#' @param id Integer specifying the ID of the entry to be updated
#' @param req HTTP request body object
update_record <- function(con, tbl, pk, id, body, res) {
  if (length(body) > 0) {
    body <- purrr::map(body, \(x) {
      if (is.character(x)) paste0("'", x, "'") else x
    })
    feat_str <- paste(names(body), body, sep = " = ", collapse = ", ")
    pk_str <- rlang::as_name(rlang::quo({{ pk }}))
    user_id <- get_logged_in_user(con)$user_id
    qry <- glue::glue(
      "UPDATE {tbl} SET {feat_str}, user_id = '{user_id}', tenant_id = 'DZ' WHERE {pk_str} = $1"
    )
    tryCatch(
      {
        pool::dbExecute(con, qry, params = id) |>
          validate_id({{ pk_str }}, id, NULL, res)
      },
      error = \(e) {
        res$status <- 400
        res$body <- list(
          code = jsonlite::unbox("400 - Bad request"),
          message = jsonlite::unbox(e$message)
        )
      }
    )
  }
}


#' ID Check
#'
#' @description
#' Checks if ID is present in the database
#'
#' @param dbStatus Integer specifying the return status of `pool::dbExecute()` call
#' @param pk <[`tidy-select`][dplyr_tidy_select]> specifying the primary key of the database table
#' @param id Integer specifying the ID of the entry to be updated
#' @param res HTTP response object
validate_id <- function(dbStatus, pk, id, body, res) {
  if (dbStatus > 0) {
    if (is.null(body)) {
      res$status <- 204
    } else {
      res$status <- 200
      res$body <- body
    }
  } else {
    pk_str <- rlang::as_name(rlang::quo({{ pk }}))
    res$status <- 404
    res$body <- list(
      code = jsonlite::unbox("404 - Not Found"),
      message = jsonlite::unbox(glue::glue("{pk_str} {id} not found"))
    )
  }
}


#' Write multipart form
#'
#' @description
#' Write a data from a multipart/form-datarequest body to the database
#'
#' @param con A \link[DBI]{DBIConnection-class} object, as returned by \link[DBI]{dbConnect}
#' @param tbl Character string specifying the database table
#' @param req HTTP request body object
#' @param res HTTP response object
write_multipart_form <- function(con, tbl, req, res) {
  auth <- get_logged_in_user(con)
  metadata <- purrr::map(
    req$body,
    ~ if (.x$name != "file") {
      x <- rawToChar(.x$value)
      x_num <- suppressWarnings(as.integer(x))
      x <- if (!is.na(x_num)) x_num else x
    } else {
      .x$file
    }
  ) |>
    tibble::as_tibble() |>
    dplyr::mutate(
      user_id = auth$user_id,
      tenant_id = auth$tenant_id
    ) |>
    dplyr::rename(name = "file")
  tryCatch(
    {
      content <- req$argsBody$file[[metadata$name]]
      if (tbl == "layout") {
        content <- content |>
          validate_layout() |>
          encode(con) |>
          dplyr::mutate(
            layout_id = metadata$layout_id,
            user_id = metadata$user_id,
            tenant_id = metadata$tenant_id
          )
      } else if (tbl == "measurement") {
        content <- content |>
          validate_measurement() |>
          encode_csv("ref-marker_view", con) |>
          encode(con) |>
          dplyr::mutate(
            measurement_id = metadata$measurement_id,
            user_id = metadata$user_id,
            tenant_id = metadata$tenant_id
          )
      } else {
        cli::cli_abort(
          "Table {tbl} is not supported. Please select either 'layout' or 'measurement'."
        )
      }
      pool::dbWriteTable(con, tbl, metadata, append = TRUE)
      pool::dbWriteTable(
        con,
        glue::glue("{tbl}_content"),
        content,
        append = TRUE
      )
      res$status <- 201
      res$body <- metadata
    },
    error = \(e) {
      res$status <- 400
      res$body <- list(
        code = jsonlite::unbox("400 - Bad request"),
        message = jsonlite::unbox(e$message)
      )
    }
  )
}


#' Split strings and convert type
#'
#' @description
#' Splits strings by comma and converts numeric strings to integers
#'
#' @param x A string
#'
#' @return A string if no comma was found or a list of strings or integers if elements are numeric
#' @export
split_and_convert <- function(x) {
  if (!identical(x, character(0))) {
    x <- if (any(grepl(",", x))) {
      stringr::str_split(stringr::str_replace_all(x, " ", ""), ",")
    } else {
      x
    }
    if (tidyr::replace_na(stringr::str_detect(x[[1]][1], "^[0-9]+$"), FALSE)) {
      x <- if (is.list(x)) purrr::map(x, as.integer) else as.integer(x)
    }
  }
  return(x)
}


#' Extract list elements
#'
#' @param lst A named list
#' @param ... <[`tidy-select`][dplyr_tidy_select]> One or more unquoted expressions separated by commas
#' referring to names of the list elements to be extracted, i.e. either as `feature_name` or `new_feature_name = feature_name`
#'
#' @return A named list with the extracted elements
#' Note: the extracted elements are popped from the original list (akin to the python's `pop()` function)
#' @export
#'
#' @examplesIf interactive()
#' list(drug_name = c("Cytarabine"), synonyms = c("Ara-C", "AraC")) |> extract_from_list(synonyms)
#' list(drug_name = c("Cytarabine"), synonyms = c("Ara-C", "AraC")) |> extract_from_list(synonym = synonyms)
extract_from_list <- function(lst, ...) {
  mapping <- sapply(rlang::enquos(...), rlang::as_name)
  idx <- which(names(lst) %in% mapping)
  if (!identical(idx, integer(0))) {
    suppressWarnings(assign(
      as.character(substitute(lst)),
      lst[-c(idx)],
      parent.frame()
    ))
    ext_lst <- lst[idx]
    new_names <- setNames(nm = names(ext_lst))
    new_names[mapping] <- names(mapping)
    new_names[new_names == ""] <- names(new_names)[new_names == ""]
    ext_lst <- setNames(ext_lst, new_names)
    return(ext_lst)
  }
}


#' Append list elements
#'
#' @description
#' Append (named) elements to an existing list
#'
#' @param lst A list
#' @param ... <[`tidy-select`][dplyr_tidy_select]> One or more unquoted expressions separated by commas
#' referring to elements that should be added to a list, i.e. either as `value` or `name = value`
#'
#' @return A list with new elements appended
#' @export
#'
#' @examplesIf interactive()
#' list(synonyms = c("Ara-C", "AraC")) |> append_to_list(drug_id = 6)
append_to_list <- function(lst, ...) {
  new_elements <- list(...)
  if (!is.null(lst)) {
    lst <- c(lst, new_elements)
  }
  return(lst)
}


#* @plumber
function(pr) {
  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- plumber::pr() |>
    plumber::pr_get("/patient/<id:int>", function(id, res) {
      read_record(con, "patient_view", pid, id, res)
    }) |>
    plumber::pr_put("/patient/<id:int>", function(id, req, res) {
      update_record(con, "patient", pid, id, req$body, res)
    }) |>
    plumber::pr_delete("/patient/<id:int>", function(id, res) {
      delete_record(con, "patient", pid, id, res)
    }) |>
    plumber::pr_get("/patient", function(pid = NA, patient_crossref = NA) {
      pids <- unlist(stringr::str_split(pid, ","))
      pool::dbReadTable(con, "patient_view") |>
        dplyr::arrange(dplyr::desc(pid)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ pid }})) ~ pid %in% {{ pids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !is.na({{ patient_crossref }}) ~ patient_crossref %in%
              {{ patient_crossref }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ pid }}), is.na({{ patient_crossref }})) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/patient", function(req, res) {
      write_record(con, "patient", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/stage/<id:int>", function(id, res) {
      read_record(con, "stage_view", stage_id, id, res)
    }) |>
    plumber::pr_put("/stage/<id:int>", function(id, req, res) {
      update_record(con, "stage", stage_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/stage/<id:int>", function(id, res) {
      delete_record(con, "stage", stage_id, id, res)
    }) |>
    plumber::pr_get(
      "/stage",
      function(stage_id = NA, pid = NA, patient_crossref = NA) {
        stage_ids <- unlist(stringr::str_split(stage_id, ","))
        pids <- unlist(stringr::str_split(pid, ","))
        pool::dbReadTable(con, "stage_view") |>
          dplyr::arrange(dplyr::desc(stage_id)) |>
          dplyr::filter(
            dplyr::case_when(
              !all(is.na({{ stage_id }})) ~ stage_id %in% {{ stage_ids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !all(is.na({{ pid }})) ~ pid %in% {{ pids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !is.na({{ patient_crossref }}) ~ patient_crossref %in%
                {{ patient_crossref }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              all(
                is.na({{ stage_id }}),
                all(is.na({{ pid }})),
                is.na({{ patient_crossref }})
              ) ~ FALSE,
              TRUE ~ TRUE
            )
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::where(is.character),
            split_and_convert
          ))
      }
    ) |>
    plumber::pr_post("/stage", function(req, res) {
      write_record(con, "stage", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/sample/<id:int>", function(id, res) {
      read_record(con, "sample_view", sid, id, res)
    }) |>
    plumber::pr_put("/sample/<id:int>", function(id, req, res) {
      sample <- req$body
      sample__classification <- extract_from_list(sample, classification_id) |>
        append_to_list(sid = id)
      update_record(con, "sample", pid, id, sample, res)
      if (!is.null(sample__classification)) {
        delete_record(con, "sample__classification", sid, id, res)
        write_record(
          con,
          "sample__classification",
          sample__classification,
          res,
          silent = TRUE
        )
      }
    }) |>
    plumber::pr_delete("/sample/<id:int>", function(id, res) {
      delete_record(con, "sample", sid, id, res)
    }) |>
    plumber::pr_get(
      "/sample",
      function(sid = NA, lknumber = NA, sample_crossref = NA, pid = NA) {
        sids <- unlist(stringr::str_split(sid, ","))
        lknumbers <- unlist(stringr::str_split(lknumber, ","))
        pool::dbReadTable(con, "sample_view") |>
          dplyr::arrange(dplyr::desc(sid)) |>
          dplyr::filter(
            dplyr::case_when(
              !all(is.na({{ sid }})) ~ sid %in% {{ sids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !all(is.na({{ lknumber }})) ~ lknumber %in% {{ lknumbers }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !is.na({{ sample_crossref }}) ~ sample_crossref %in%
                {{ sample_crossref }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(!is.na({{ pid }}) ~ pid == {{ pid }}, TRUE ~ TRUE),
            dplyr::case_when(
              all(
                is.na({{ sid }}),
                all(is.na({{ lknumber }})),
                is.na({{ sample_crossref }}),
                is.na({{ pid }})
              ) ~ FALSE,
              TRUE ~ TRUE
            )
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::where(is.character),
            split_and_convert
          ))
      }
    ) |>
    plumber::pr_post("/sample", function(req, res) {
      sample <- req$body
      sample__classification <- extract_from_list(sample, classification_id) |>
        append_to_list(sid = req$body$sid)
      write_record(con, "sample", sample, res)
      body <- res$body
      write_record(
        con,
        "sample__classification",
        sample__classification,
        res,
        silent = TRUE
      )
      res$body <- body
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/assay/<id:int>", function(id, res) {
      read_record(con, "assay_view", assay_id, id, res)
    }) |>
    plumber::pr_put("/assay/<id:int>", function(id, req, res) {
      update_record(con, "assay", assay_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/assay/<id:int>", function(id, res) {
      delete_record(con, "assay", assay_id, id, res)
    }) |>
    plumber::pr_get("/assay", function(assay_id = NA, sid = NA, lknumber = NA) {
      assay_ids <- unlist(stringr::str_split(assay_id, ","))
      sids <- unlist(stringr::str_split(sid, ","))
      lknumbers <- unlist(stringr::str_split(lknumber, ","))
      pool::dbReadTable(con, "assay_view") |>
        dplyr::arrange(dplyr::desc(assay_id)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ assay_id }})) ~ assay_id %in% {{ assay_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ sid }})) ~ sid %in% {{ sids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !is.na({{ lknumber }}) ~ lknumber %in% {{ lknumbers }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(
              is.na({{ assay_id }}),
              all(is.na({{ sid }})),
              all(is.na({{ lknumber }}))
            ) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/assay", function(req, res) {
      write_record(con, "assay", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/genetics/<id:int>", function(id, res) {
      read_record(con, "genetics_view", genetic_id, id, res)
    }) |>
    plumber::pr_put("/genetics/<id:int>", function(id, req, res) {
      update_record(con, "genetic", genetic_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/genetics/<id:int>", function(id, res) {
      delete_record(con, "genetics", genetic_id, id, res)
    }) |>
    plumber::pr_get("/genetics", function(genetic_id = NA, pid = NA) {
      genetic_ids <- unlist(stringr::str_split(genetic_id, ","))
      pids <- unlist(stringr::str_split(pid, ","))
      pool::dbReadTable(con, "genetics_view") |>
        dplyr::arrange(dplyr::desc(genetic_id)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ genetic_id }})) ~ genetic_id %in% {{ genetic_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ pid }})) ~ pid %in% {{ pids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ genetic_id }}), all(is.na({{ pid }}))) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/genetics", function(req, res) {
      write_record(con, "genetics", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/flow/<id:int>", function(id, res) {
      read_record(con, "flow_view", flow_id, id, res)
    }) |>
    plumber::pr_put("/flow/<id:int>", function(id, req, res) {
      if (is.null(req$body$marker_id)) {
        res$status <- 404
        msg <- list(
          code = jsonlite::unbox("404 - Not Found"),
          message = jsonlite::unbox(glue::glue("flow_id is not defined"))
        )
      } else if (is.null(req$body$pid)) {
        res$status <- 404
        msg <- list(
          code = jsonlite::unbox("404 - Not Found"),
          message = jsonlite::unbox(glue::glue("pid is not defined"))
        )
      } else {
        delete_record(con, "flow", flow_id, id, res)
        req$body$flow_id <- id
        write_record(con, "flow", req$body, res)
      }
    }) |>
    plumber::pr_delete("/flow/<id:int>", function(flow_id, res) {
      delete_record(con, "flow", flow_id, id, res)
    }) |>
    plumber::pr_get("/flow", function(id = NA, pid = NA) {
      flow_ids <- unlist(stringr::str_split(id, ","))
      pids <- unlist(stringr::str_split(pid, ","))
      pool::dbReadTable(con, "flow_view") |>
        dplyr::arrange(dplyr::desc(flow_id)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ flow_id }})) ~ flow_id %in% {{ flow_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ pid }})) ~ pid %in% {{ pids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ flow_id }}), all(is.na({{ pid }}))) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/flow", function(req, res) {
      write_record(con, "flow", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/cohort_description/<id:int>", function(id, res) {
      read_record(con, "cohort", cohort_id, id, res)
    }) |>
    plumber::pr_put("/cohort_description/<id:int>", function(id, req, res) {
      update_record(con, "cohort", cohort_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/cohort_description/<id:int>", function(id, res) {
      delete_record(con, "cohort", cohort_id, id, res)
    }) |>
    plumber::pr_get(
      "/cohort_description",
      function(cohort_id = NA, cohort_name = NA) {
        cohort_ids <- unlist(stringr::str_split(cohort_id, ","))
        pool::dbReadTable(con, "cohort") |>
          dplyr::arrange(dplyr::desc(cohort_id)) |>
          dplyr::filter(
            dplyr::case_when(
              !all(is.na({{ cohort_id }})) ~ cohort_id %in% {{ cohort_ids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !is.na({{ cohort_name }}) ~ cohort_name %in% {{ cohort_name }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              all(is.na({{ cohort_id }}), is.na({{ cohort_name }})) ~ FALSE,
              TRUE ~ TRUE
            )
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::where(is.character),
            split_and_convert
          ))
      }
    ) |>
    plumber::pr_post("/cohort_description", function(req, res) {
      write_record(con, "cohort", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/cohort/<id:int>", function(id, res) {
      resp <- read_record(con, "cohort__assay_sample_view", cohort_id, id, res)
    }) |>
    plumber::pr_delete(
      "/cohort/<cid:int>/<sid:int>/<aid:int>",
      function(cid, sid, aid, res) {
        qry <- glue::glue(
          "DELETE FROM cohort__assay_sample WHERE cohort_id = $1 AND sid = $2 AND assay_id = $3"
        )
        ids <- glue::glue("{cid}/{sid}/{aid}")
        pool::dbExecute(con, qry, params = c(cid, sid, aid)) |>
          validate_id("cohort_id/sid/assay_id", ids, NULL, res)
      }
    ) |>
    plumber::pr_get("/cohort", function(cohort_id = NA, cohort_name = NA) {
      cohort_ids <- unlist(stringr::str_split(cohort_id, ","))
      pool::dbReadTable(con, "cohort__assay_sample_view") |>
        dplyr::arrange(dplyr::desc(cohort_id)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ cohort_id }})) ~ cohort_id %in% {{ cohort_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !is.na({{ cohort_name }}) ~ cohort_name %in% {{ cohort_name }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ cohort_id }}), is.na({{ cohort_name }})) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/cohort", function(req, res) {
      write_record(con, "cohort__assay_sample", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/drug/<id:int>", function(id, res) {
      read_record(con, "drug_view", drug_id, id, res)
    }) |>
    plumber::pr_put("/drug/<id:int>", function(id, req, res) {
      req$body$kispi_id <- glue::glue(
        "KISPI-{sprintf('%04d', req$body$drug_id)}"
      )
      drug <- req$body
      drug__synonym <- extract_from_list(drug, synonym = synonyms) |>
        append_to_list(drug_id = id)
      drug__functional_class <- extract_from_list(
        drug,
        functional_class_id = functional_classes_id
      ) |>
        append_to_list(drug_id = id)
      drug__biological_process <- extract_from_list(
        drug,
        biological_process_id = biological_processes_id
      ) |>
        append_to_list(drug_id = id)
      update_record(con, "drug", drug_id, id, req$body, res)
      if (!is.null(drug__synonym)) {
        delete_record(con, "drug__synonym", drug_id, id, res)
        write_record(con, "drug__synonym", drug__synonym, res, silent = TRUE)
      }
      if (!is.null(drug__functional_class)) {
        delete_record(con, "drug__functional_class", drug_id, id, res)
        write_record(
          con,
          "drug__functional_class",
          drug__functional_class,
          res,
          silent = TRUE
        )
      }
      if (!is.null(drug__biological_process)) {
        delete_record(con, "drug__biological_process", drug_id, id, res)
        write_record(
          con,
          "drug__biological_process",
          drug__biological_process,
          res,
          silent = TRUE
        )
      }
    }) |>
    plumber::pr_delete("/drug/<id:int>", function(id, res) {
      delete_record(con, "drug", drug_id, id, res)
    }) |>
    plumber::pr_get("/drug", function(drug_id = NA, drug_name = NA) {
      drug_ids <- unlist(stringr::str_split(drug_id, ","))
      drug_names <- unlist(stringr::str_split(drug_name, ","))
      pool::dbReadTable(con, "drug_view") |>
        dplyr::arrange(dplyr::desc(drug_name)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ drug_id }})) ~ drug_id %in% {{ drug_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ drug_name }})) ~ drug_name %in% {{ drug_names }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ drug_id }}), all(is.na({{ drug_name }}))) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/drug", function(req, res) {
      req$body$kispi_id <- glue::glue(
        "KISPI-{sprintf('%04d', req$body$drug_id)}"
      )
      drug <- req$body
      drug__synonym <- extract_from_list(drug, synonym = synonyms) |>
        append_to_list(drug_id = req$body$drug_id)
      drug__functional_class <- extract_from_list(
        drug,
        functional_class_id = functional_classes_id
      ) |>
        append_to_list(drug_id = req$body$drug_id)
      drug__biological_process <- extract_from_list(
        drug,
        biological_process_id = biological_processes_id
      ) |>
        append_to_list(drug_id = req$body$drug_id)
      write_record(con, "drug", drug, res)
      write_record(con, "drug__synonym", drug__synonym, res, silent = TRUE)
      write_record(
        con,
        "drug__functional_class",
        drug__functional_class,
        res,
        silent = TRUE
      )
      write_record(
        con,
        "drug__biological_process",
        drug__biological_process,
        res,
        silent = TRUE
      )
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/material/<id:int>", function(id, res) {
      read_record(con, "material_view", material_id, id, res)
    }) |>
    plumber::pr_put("/material/<id:int>", function(id, req, res) {
      update_record(con, "material", material_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/material/<id:int>", function(id, res) {
      delete_record(con, "material", material_id, id, res)
    }) |>
    plumber::pr_get(
      "/material",
      function(
        material_id = NA,
        sid = NA,
        mouse_id = NA,
        transplantation_id = NA
      ) {
        material_ids <- unlist(stringr::str_split(material_id, ","))
        sids <- unlist(stringr::str_split(sid, ","))
        mouse_ids <- unlist(stringr::str_split(mouse_id, ","))
        transplantation_ids <- unlist(stringr::str_split(
          transplantation_id,
          ","
        ))
        pool::dbReadTable(con, "material_view") |>
          dplyr::arrange(dplyr::desc(sid)) |>
          dplyr::filter(
            dplyr::case_when(
              !all(is.na({{ material_id }})) ~ material_id %in%
                {{ material_ids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !all(is.na({{ sid }})) ~ sid %in% {{ sids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !all(is.na({{ mouse_id }})) ~ mouse_id %in% {{ mouse_ids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              !all(is.na({{ transplantation_id }})) ~ transplantation_id %in%
                {{ transplantation_ids }},
              TRUE ~ TRUE
            ),
            dplyr::case_when(
              all(
                is.na({{ material_id }}),
                all(is.na({{ sid }})),
                all(is.na({{ mouse_id }})),
                all(is.na({{ transplantation_id }}))
              ) ~ FALSE,
              TRUE ~ TRUE
            )
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::where(is.character),
            split_and_convert
          ))
      }
    ) |>
    plumber::pr_post("/material", function(req, res) {
      write_record(con, "material", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/kinetic/<id:int>", function(id, res) {
      read_record(con, "kinetic", kinetic_id, id, res)
    }) |>
    plumber::pr_put("/kinetic/<id:int>", function(id, req, res) {
      update_record(con, "kinetic", kinetic_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/kinetic/<id:int>", function(id, res) {
      delete_record(con, "kinetic", kinetic_id, id, res)
    }) |>
    plumber::pr_get("/kinetic", function(kinetic_id = NA, mouse_id = NA) {
      kinetic_ids <- unlist(stringr::str_split(kinetic_id, ","))
      mouse_ids <- unlist(stringr::str_split(mouse_id, ","))
      pool::dbReadTable(con, "kinetic") |>
        dplyr::arrange(dplyr::desc(mouse_id)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ kinetic_id }})) ~ kinetic_id %in% {{ kinetic_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ mouse_id }})) ~ mouse_id %in% {{ mouse_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(is.na({{ kinetic_id }}), all(is.na({{ mouse_id }}))) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/kinetic", function(req, res) {
      write_record(con, "kinetic", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/lot/<id:int>", function(id, res) {
      read_record(con, "lot_view", lot_id, id, res)
    }) |>
    plumber::pr_put("/lot/<id:int>", function(id, req, res) {
      update_record(con, "lot", lot_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/lot/<id:int>", function(id, res) {
      delete_record(con, "lot", lot_id, id, res)
    }) |>
    plumber::pr_get("/lot", function(lot_id = NA, lot = NA, drug_id = NA) {
      lot_ids <- unlist(stringr::str_split(lot_id, ","))
      lots <- unlist(stringr::str_split(lot, ","))
      drug_ids <- unlist(stringr::str_split(drug_id, ","))
      pool::dbReadTable(con, "lot_view") |>
        dplyr::arrange(dplyr::desc(sid)) |>
        dplyr::filter(
          dplyr::case_when(
            !all(is.na({{ lot_id }})) ~ lot_id %in% {{ lot_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ lot }})) ~ lot %in% {{ lots }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            !all(is.na({{ drug_id }})) ~ drug_id %in% {{ drug_ids }},
            TRUE ~ TRUE
          ),
          dplyr::case_when(
            all(
              is.na({{ lot_id }}),
              all(is.na({{ lot }})),
              all(is.na({{ drug_id }}))
            ) ~ FALSE,
            TRUE ~ TRUE
          )
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::where(is.character),
          split_and_convert
        ))
    }) |>
    plumber::pr_post("/lot", function(req, res) {
      write_record(con, "lot", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/layout/<id:int>", function(id, res) {
      read_record(con, "layout_view", layout_id, id, res)
    }) |>
    plumber::pr_put("/layout/<id:int>", function(id, req, res) {
      update_record(con, "layout", layout_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/layout/<id:int>", function(id, res) {
      delete_record(con, "layout", layout_id, id, res)
    }) |>
    plumber::pr_post(
      "/layout",
      function(req, res) {
        write_multipart_form(con, "layout", req, res)
      },
      parsers = list(
        "multi" = list(),
        "csv" = list(show_col_types = FALSE),
        "form" = list()
      )
    )

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/measurement/<id:int>", function(id, res) {
      read_record(con, "measurement_view", measurement_id, id, res)
    }) |>
    plumber::pr_put("/measurement/<id:int>", function(id, req, res) {
      update_record(con, "measurement", measurement_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/measurement/<id:int>", function(id, res) {
      delete_record(con, "measurement", measurement_id, id, res)
    }) |>
    plumber::pr_post(
      "/measurement",
      function(req, res) {
        write_multipart_form(con, "measurement", req, res)
      },
      parsers = list(
        "multi" = list(),
        "csv" = list(show_col_types = FALSE),
        "form" = list()
      )
    )

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/plate/<id:int>", function(id, res) {
      read_record(con, "plate_view", plate_id, id, res)
    }) |>
    plumber::pr_put("/plate/<id:int>", function(id, req, res) {
      update_record(con, "plate", plate_id, id, req$body, res)
    }) |>
    plumber::pr_delete("/plate/<id:int>", function(id, res) {
      delete_record(con, "plate", plate_id, id, res)
    }) |>
    plumber::pr_post("/plate", function(req, res) {
      write_record(con, "plate", req$body, res)
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_put("/normalize_measurement/<id:int>", function(id, req, res) {
      tryCatch(
        {
          normalize_measurements(con, id)
          res$status <- 200
          res$body <- "Plate normalized"
        },
        error = \(e) {
          res$status <- 400
          res$body <- list(
            code = jsonlite::unbox("400 - Bad request"),
            message = jsonlite::unbox(e$message)
          )
        }
      )
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get(
      "/plate_content",
      function(
        plate_id = NA,
        sid = NA,
        lknumber = NA,
        drug_name = NA,
        row = NA,
        col = NA
      ) {
        plate_ids <- unlist(stringr::str_split(plate_id, ","))
        sids <- unlist(stringr::str_split(sid, ","))
        lknumbers <- unlist(stringr::str_split(lknumber, ","))
        drug_names <- unlist(stringr::str_split(drug_name, ","))
        rows <- unlist(stringr::str_split(row, ","))
        cols <- unlist(stringr::str_split(col, ","))

        query <- dplyr::tbl(con, "plate_content_view")
        if (!all(is.na(plate_ids))) {
          query <- query |> dplyr::filter(plate_id %in% plate_ids)
        }
        if (!all(is.na(sids))) {
          query <- query |> dplyr::filter(sid %in% sids)
        }
        if (!all(is.na(lknumbers))) {
          query <- query |> dplyr::filter(lknumber %in% lknumbers)
        }
        if (!all(is.na(drug_names))) {
          query <- query |> dplyr::filter(drug_name %in% drug_names)
        }
        if (!all(is.na(row))) {
          query <- query |> dplyr::filter(row %in% rows)
        }
        if (!all(is.na(col))) {
          query <- query |> dplyr::filter(col %in% cols)
        }
        if (
          !all(
            all(is.na(plate_ids)),
            all(is.na(sids)),
            all(is.na(lknumbers)),
            all(is.na(drug_names)),
            all(is.na(row)),
            all(is.na(col))
          )
        ) {
          query |>
            dplyr::collect() |>
            dplyr::mutate(dplyr::across(
              dplyr::where(is.character),
              split_and_convert
            ))
        }
      }
    )

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_post("/fit_measurement", function(req, res) {
      defaults <- initialize_parameters()
      fixed <- req$body$fixed
      if (is.null(fixed)) {
        fixed <- defaults$LL.3$fixed
      }
      lowerl <- req$body$lowerl
      if (is.null(lowerl)) {
        lowerl <- defaults$LL.3$lowerl
      }
      upperl <- req$body$upperl
      if (is.null(upperl)) {
        upperl <- defaults$LL.3$upperl
      }
      start <- req$body$start
      if (is.null(start)) {
        start <- defaults$LL.3$start
      }
      if (length(req$body$dose_response_table) == 0) {
        res$status <- 404
        res$body <- list(
          code = jsonlite::unbox("404 - Not Found"),
          message = jsonlite::unbox(
            "Dose response table is empty. No curves were fitted."
          )
        )
      } else {
        tryCatch(
          {
            res$body <- cli_fit(
              req$body$dose_response_table,
              con,
              fixed,
              lowerl,
              upperl,
              start,
              show_coefficients = FALSE
            )
            res$status <- 200
            res$body <- "Curves fitted."
          },
          error = \(e) {
            res$status <- 400
            res$body <- list(
              code = jsonlite::unbox("400 - Bad request"),
              message = jsonlite::unbox(e$message)
            )
          }
        )
      }
    })

  #---------------------------------------------------------------------------------------------------------------------

  pr_v1 <- pr_v1 |>
    plumber::pr_get("/next/<tbl>", function(tbl, res) {
      tryCatch(
        {
          purrr::map(
            as.list(next_id(con, tbl, named = TRUE)),
            jsonlite::unbox
          )
        },
        error = \(e) {
          res$status <- 400
          res$body <- list(
            code = jsonlite::unbox("400 - Bad request"),
            message = jsonlite::unbox(e$message)
          )
        }
      )
    })

  #---------------------------------------------------------------------------------------------------------------------

  config_name <- Sys.getenv("R_CONFIG_ACTIVE")
  con <- connect_with_config(config_name)

  pr <- pr |>
    plumber::pr_set_docs(docs = "swagger_v5", version = "5") |>
    plumber::pr_set_api_spec(yaml::read_yaml("openapi.yaml")) |>
    plumber::pr_filter("auth", function(req, res) {
      if (config_name == "azure") {
        user_id <- tolower(req$HTTP_X_MS_CLIENT_PRINCIPAL_NAME)
      } else {
        config <- get_configuration(config_name)
        user_id <- config$dbuser
      }
      pool::dbExecute(
        con,
        glue::glue_sql("SET app.user_id = {user_id};", .con = con)
      )
      plumber::forward()
    }) |>
    plumber::pr_get(
      "/",
      function() {
        "<html><h1>DRP plumber API</h1></html>"
      },
      serializer = plumber::serializer_html()
    ) |>
    plumber::pr_mount("/v1", pr_v1) |>
    plumber::pr_get("/user", function(req) {
      get_logged_in_user(con)
    }) |>
    plumber::pr_filter("logger", function(req, res) {
      cat(
        as.character(Sys.time()),
        "-",
        req$REQUEST_METHOD,
        req$PATH_INFO,
        "-",
        req$HTTP_USER_AGENT,
        "@",
        req$REMOTE_ADDR,
        "\n"
      )
      plumber::forward()
    })
}
