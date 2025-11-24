PKG_NAME = "drpr"

#' Establish a connection to a DBMS
#'
#' @description
#' `connect` is a wrapper around \link[pool]{dbPool} to connect to a SQLite or Postgres database using the specified driver and
#' additional authentication parameters (`host`, `user` and `password`).
#' @concept connecting
#'
#' @param dbname Name of the database
#' @param driver Database driver to use, either `RSQLite::SQLite()` or `RPostgres::Postgres()`
#' @param pool Boolean indicating whether the package 'pool' (TRUE) or 'DBI' (FALSE) should be used for database connection
#' @param ... Additional arguments to pass to \link[pool]{dbPool}, i.e. host, user, password, sslmode
#'
#' @return A \link[DBI]{DBIConnection-class} object to a DRP database
#' @export
connect <-
  function(dbname = "drp", driver = RPostgres::Postgres(), pool = TRUE, ...) {
    args <- list(...)
    if (isTRUE(pool)) {
      con <- pool::dbPool(
        drv = driver,
        dbname = dbname,
        host = args$host,
        user = args$user,
        port = args$port,
        password = args$password,
        sslmode = args$sslmode,
        connect_timeout = 5
      )
    } else {
      con <- DBI::dbConnect(
        drv = driver,
        dbname = dbname,
        host = args$host,
        user = args$user,
        port = args$port,
        password = args$password,
        sslmode = args$sslmode,
        connect_timeout = 5
      )
    }
    return(con)
  }


#' Connect to DB using a configuration file
#'
#' @description `connect_with_config` uses connection variables defined in a configuration file to
#' establish a connection to a DBMS.
#' @concept connecting
#'
#' @param config_name Name of the configuration definition
#' @param user_file Name of the user configuration file (default: config.user.yml; base configurations are present in config.yml)
#' @param driver Database driver to use
#' @param cache Boolean indicating whether to use caching with `R.cache``
#' @param pool Boolean indicating whether the package 'pool' (TRUE) or 'DBI' (FALSE) should be used for database connection
#'
#' @return A \link[DBI]{DBIConnection-class} object to a DRP database
#' @export
connect_with_config <- function(
  config_name = "default",
  user_file = system.file("config.user.yml", package = PKG_NAME),
  driver = RPostgres::Postgres(),
  cache = FALSE,
  pool = TRUE
) {
  if (isTRUE(cache)) {
    activateCache()
  } else {
    deactivateCache()
  }
  tryCatch(
    {
      config <- get_configuration(config_name, user_file)
      if (isTRUE(pool)) {
        con <- pool::dbPool(
          drv = driver,
          dbname = config$dbname,
          host = config$dbhost,
          port = config$dbport,
          user = config$dbuser,
          password = config$dbpass,
          sslmode = config$dbssl,
          connect_timeout = 5
        )
      } else {
        con <- DBI::dbConnect(
          drv = driver,
          dbname = config$dbname,
          host = config$dbhost,
          port = config$dbport,
          user = config$dbuser,
          password = config$dbpass,
          sslmode = config$dbssl,
          connect_timeout = 5
        )
      }
      return(con)
    },
    error = function(e) {
      Sys.setenv(R_CONFIG_ACTIVE = "")
      message("Cannot connect to the specified database due to ", e)
    }
  )
}


#' Get info on database connection
#'
#' @description
#' `dbGetInfo` returns the name of the database, host and logged in user.
#' @concept connecting
#'
#' @param con A \link[DBI]{DBIConnection-class} object to a DRP database
#'
#' @return A named list with `dbname`, `username`, `host`, `port` and `db.version`
#' as returned by `DBI::dbGetInfo()` on a fetched connection
#' @export
dbGetInfo <- function(con) {
  con_info <- pool::poolCheckout(con) |>
    pool::dbGetInfo()
  return(con_info)
}


#' Run Plumber API
#'
#' @description
#' Run a local Plumber API server with a predefined configuration to connect to a local or remote Postgres database.
#' @concept connecting
#'
#' @param config_name Character string referring to the name of the configuration definition
#' @param port Integer indicating the port of the API
#' @param background Boolean indicating whether to run the Shiny app in the background and free the R console.
#' @param pkg_path A character string specifying the (relative) path to the package
#'
#' @export
runAPI <- function(
  config_name = "default",
  port = 3840,
  background = FALSE,
  pkg_path = "."
) {
  Sys.setenv(R_CONFIG_ACTIVE = config_name)

  if (isTRUE(background)) {
    utils::install.packages(
      pkg_path,
      repos = NULL,
      type = "source",
      quiet = TRUE
    )
    r_proc <- callr::r_bg(
      func = \(port, pkg_path) {
        pkg <- pkgdown::as_pkgdown(pkg = pkg_path)
        try(pkgload::unload(pkg$package), silent = TRUE)
        plumber::plumb(system.file(
          "api/api.R",
          package = PKG_NAME
        )) |>
          plumber::pr_run(port = port)
      },
      args = list(port = {{ port }}, pkg_path = {{ pkg_path }}),
      supervise = TRUE,
      package = TRUE
    )

    cli::cli_alert_success("API server has initialized in the background.")
    cli::cli_div(theme = list(span.emph = list(color = "orange")))
    cli::cli_alert_info(
      'Open the API docs with {.emph browseURL("http://127.0.0.1:{port}/__docs__/")}.'
    )
    cli::cli_alert_info(
      "Run {.emph kill()} on the returned callr::r_process object to close the tunnel."
    )
    cli::cli_end()

    # check if r_proc is alive
    Sys.sleep(0.5)
    if (isFALSE(r_proc$is_alive())) {
      cli::cli_alert_danger(r_proc$read_error())
      cli::cli_alert(
        "Did you specify the correct path to {.emph PKG_NAME} in pkg_path?"
      )
      return(NULL)
    } else {
      return(r_proc)
    }
  } else {
    plumber::plumb(system.file("api/api.R", package = PKG_NAME)) |>
      plumber::pr_run(port = port)
  }
}


#' Generate an OAuth client
#'
#' @description
#' Read OAuth client ID, secret, and token/authentication URL from a (user) config file
#' and return a \link[httr2]{oauth_client}.
#' @concept connecting
#'
#' @param config_name Character string referring to the name of the configuration definition
#'
#' @return A list with a \link[httr2]{oauth_client}, the auth_url, the redirect_uri and the scope
#' @export
oauth <- function(config_name = "api") {
  rlang::check_installed(
    "httr2",
    reason = glue::glue("to use the {PKG_NAME} API`")
  )
  config <- config::get(
    config = config_name,
    file = system.file("config.yml", package = PKG_NAME)
  )
  user_file <- system.file("config.user.yml", package = PKG_NAME)
  if (file.exists(user_file)) {
    config_user <- yaml::yaml.load_file(user_file, eval.expr = TRUE)[[
      config_name
    ]]
    if (!is.null(config_user)) {
      cli::cli_alert_info("User configuration exists for \"{config_name}\"")
      config <- config_user
    }
  }
  client <- httr2::oauth_client(
    id = config$client_id,
    secret = config$client_secret,
    token_url = config$token_url,
    name = config_name
  )
  return(
    list(
      client = client,
      auth_url = config$auth_url,
      redirect_uri = config$redirect_uri,
      scope = config$scope
    )
  )
}


#' Authenticate to API
#'
#' @description
#' `authenticate` is a wrapper around \link[httr2]{req_oauth_auth_code}.
#' It receives a \link[httr2]{request} and a OAuth list, returning a modified request.
#' @concept connecting
#'
#' @param req A \link[httr2]{request}
#' @param oal An OAuth list return by [oauth()] with a \link[httr2]{oauth_client}, the auth_url, the redirect_uri and the scope
#'
#' @return A modified HTTP \link[httr2]{request} that will use OAuth;
#' @export
authenticate <- function(req, oal = NULL) {
  rlang::check_installed(
    "httr2",
    reason = glue::glue("to use the {PKG_NAME} API`")
  )
  if (is.null(oal)) {
    return(req)
  } else {
    return(httr2::req_oauth_auth_code(
      req,
      client = oal$client,
      scope = oal$scope,
      redirect_uri = oal$redirect_uri,
      auth_url = oal$auth_url
    ))
  }
}


#' Get configuration settings
#'
#' @description
#' Load configuration settings from `inst/config.yml"` file and
#' optionally from a user-defined configuration file (by default `inst/config.user.yml`).
#' @concept connecting
#'
#' @param config_name String specifying the configuration name
#' @param user_file Path to a user defined configuration file (default: config.user.yml located under /inst)
#'
#' @return A list with the configuration settings
#' @export
get_configuration <- function(
  config_name = "default",
  user_file = system.file("config.user.yml", package = PKG_NAME)
) {
  config <- config::get(
    config = config_name,
    file = system.file("config.yml", package = PKG_NAME)
  )
  if (file.exists(user_file)) {
    config_user <- yaml::yaml.load_file(user_file, eval.expr = FALSE)[[
      config_name
    ]] # check if config_name is present in config.user.yml (without evaluating)
    if (!is.null(config_user)) {
      config_user <- yaml::yaml.load_file(user_file, eval.expr = TRUE)[[
        config_name
      ]] # read with evaluation
      cli::cli_alert_info("User configuration exists for \"{config_name}\"")
      config <- config_user
    }
  }
  return(config)
}


#' Httr2 request wrapper
#'
#' @description
#' A helper function to send a \link[httr2]{httr2} request to the DRP API.
#' @concept connecting
#'
#' @param uri A string specifying the URI endpoint. Supports \link[glue]{glue} syntax.
#' @param method A string specifying the HTTP method ("post" or "put")
#' @param body A list or \link[tibble]{tibble} to send as the body
#' @param oa An OAuth list return by [oauth()] with a \link[httr2]{oauth_client}, the auth_url, the redirect_uri and the scope
#'
#' @returns An atomic vector, list or `NULL`
#' @export
request <- function(uri, method = "get", body = NULL, oa = NULL) {
  resp <- tryCatch(
    {
      if (
        tolower(method) == "post" &&
          (stringr::str_detect(uri, "layout") ||
            stringr::str_detect(uri, "measurement"))
      ) {
        httr2::request(glue::glue(uri)) |>
          authenticate(oa) |>
          (\(req) {
            parts <- purrr::imap(as.list(body), function(val, nm) {
              if (nm == "file") curl::form_file(val) else as.character(val)
            })
            do.call(httr2::req_body_multipart, c(list(req), parts))
          })() |>
          httr2::req_perform()
      } else {
        httr2::request(glue::glue(uri)) |>
          authenticate(oa) |>
          httr2::req_method(method) |>
          httr2::req_body_json(body) |>
          httr2::req_perform()
      }
    },
    error = \(e) {
      if (is.null(httr2::last_response())) {
        cli::cli_alert_danger("No HTTP response. Is the API server running?")
      } else {
        msg <- httr2::last_response() |>
          httr2::resp_body_json() |>
          purrr::pluck("message")
        cli::cli_alert_danger("{e$message}")
        if (!is.null(msg)) {
          cli::cli_alert("{msg}")
        }
      }
    },
    finally = {
      status <- httr2::last_response()$status_code
    }
  )
  if (!is.null(httr2::last_response()) && status < 400 && status != 204) {
    resp <- resp |>
      httr2::resp_body_json()
    resp <- tryCatch(
      {
        resp <- resp |>
          dplyr::bind_rows()
      },
      error = \(e) cli::cli_alert_info(resp[[1]])
    )
    resp <- tryCatch(
      {
        resp |>
          tidyr::unnest_longer(where(is.list))
      },
      error = \(e) resp
    )
    return(resp)
  }
}
