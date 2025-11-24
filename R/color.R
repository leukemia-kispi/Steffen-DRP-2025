#' Make color lighter
#'
#' @description
#' Make colors lighter by a given factor.
#' @concept coloring
#'
#' @param colors Character vector of colors either as HEX codes or built-in color names
#' @param factor Numeric factor by which to lighten the colors.
#' @return Character vector of lightened colors
#' @export
lighten_color <- function(colors, factor = 0.75) {
  purrr::map_chr(colors, \(color) {
    col_rgb <- grDevices::col2rgb(color) / 255
    new_rgb <- col_rgb + (1 - col_rgb) * factor
    rgb(new_rgb[1], new_rgb[2], new_rgb[3])
  })
}

#' Make color darker
#'
#' @description
#' Make colors darker by a given factor.
#' @concept coloring
#'
#' @param colors Character vector of colors either as HEX codes or built-in color names
#' @param factor Numeric factor by which to darken the colors.
#' @return Character vector of darkened colors
#' @export
darken_color <- function(colors, factor = 0.75) {
  purrr::map_chr(colors, \(color) {
    col_rgb <- grDevices::col2rgb(color) / 255
    new_rgb <- col_rgb * (1 - factor)
    rgb(new_rgb[1], new_rgb[2], new_rgb[3])
  })
}

#' Custom color palettes
#'
#' @description
#' A list of custom color palettes each consisting of a character vector of HEX colors
#' @concept coloring
#'
#' @return list of named HEX color vectors
#' @export
custom_palettes <- function() {
  palettes <- list(
    orange_blue = c("#C25539", "#F0F0F0", "#3F7E9B"),
    orange_blue4 = c("#C25539", "#d5aba1", "#83abbd", "#3F7E9B"),
    orange_violet = c("#C25539", "#F0F0F0", "#694a82"),
    orange_violet4 = c("#C25539", "#d5aba1", "#B398C8", "#694a82"),
    purple_turquoise = c("#942A4E", "#F0F0F0", "#00687D"),
    green_blue = c("#A5CD91", "#37878D", "#2B3270"),
    blue_green_gray = c("#86a0c3", "#86c399", "gray"),
    ai = c("#e67db0", "#C77CFF", "#619CFF"),
    green_red = c("#8EE222", "#CAD518", "#EDB825", "#F65E15"),
    blue_gray = c("#1978B4", "#A6CEE3", "#BDBCBC", "#8A8182", "#605D5D"),
    harmony1 = c(
      "#c386a5",
      "#b386c3",
      "#8d86c3",
      "#86a0c3",
      "#86bdc3",
      "#86c399",
      "#afc386",
      "#c3bd86",
      "#c39b86",
      "#c38686"
    ),
    miller = c(
      "#4F6980",
      "#7DA099",
      "#A8BB98",
      "#CE9F61",
      "#C66B51",
      "#A72B55"
    ),
    miller_ext = c(
      "#4F6980",
      "#9CC5AB",
      "#D1C79D",
      "#DB964F",
      "#a72b55",
      "#7E756D"
    ),
    miller_bright = c(
      "#5B4082",
      "#1a6299",
      "#1a8699",
      "#1a9988",
      "#1a9957",
      "#59991a",
      "#cbd152",
      "#e8bb25",
      "#e88725",
      "#e82525",
      "#A72B55",
      "#a3a3a3"
    ),
    tol = c(
      "#332288FF",
      "#6699CCFF",
      "#88CCEEFF",
      "#44AA99FF",
      "#117733FF",
      "#999933FF",
      "#DDCC77FF",
      "#e89643",
      "#e85243",
      "#A72B55",
      "#a3a3a3"
    ),
    sunset = c("#1D457FFF", "#61599DFF", "#C36377FF", "#EB7F54FF", "#F2AF4AFF"),
    hue12 = scales::hue_pal()(12),
    hue12_gray = c("#a3a3a3", scales::hue_pal()(12)),
    hue15_dark_light_3 = as.vector(rbind(
      darken_color(scales::hue_pal()(5), 0.3),
      scales::hue_pal()(5),
      lighten_color(scales::hue_pal()(5), 0.6)
    )),
    hue12_dark_light_3 = as.vector(rbind(
      darken_color(scales::hue_pal()(4), 0.3),
      scales::hue_pal()(4),
      lighten_color(scales::hue_pal()(4), 0.6)
    )),
    hue12_dark_light_2 = as.vector(rbind(
      darken_color(scales::hue_pal()(6), 0.1),
      lighten_color(scales::hue_pal()(6), 0.5)
    )),
    hue14_dark_light_2 = as.vector(rbind(
      darken_color(scales::hue_pal()(7), 0.1),
      lighten_color(scales::hue_pal()(7), 0.5)
    ))
  )
  return(palettes)
}
palettes <- custom_palettes()


#' HEX color from a colormap
#'
#' @description
#' Extract HEX color codes from a named colormap.
#' @concept coloring
#'
#' @param name Character string specifying the colormap. Can be registered colormap from \link[RColorBrewer]{RColorBrewer}
#' or a palette fom the `palettes` list defined in the drpr package. Reverse the colormap by appending the suffix `_r` to the name.
#' @param n Number of colors to extract.
#' @param n_max Maximum number of colors to use from the colormap. If `NULL` defaults to all colors
#'
#' @return Character vector with HEX color codes
#' @export
#'
#' @examples
#' get_hex_colors("Set2")
#' get_hex_colors("orange_violet")
get_hex_colors <- function(name, n = 3, n_max = NULL) {
  if (startsWith(name[1], "#") || name[1] %in% grDevices::colors()) {
    palettes$tmp <- name
    name <- "tmp"
  }
  if (endsWith(name, "_r")) {
    original_name <- substr(name, 1, nchar(name) - 2)
    if (isTRUE(stringr::str_detect(name, "::"))) {
      name_split <- stringr::str_split_1(name, "::")
      maxcolors <- paletteer::palettes_d_names |>
        dplyr::filter(package == name_split[1], palette == name_split[2]) |>
        dplyr::pull(length) |>
        min(n_max)
      return(grDevices::colorRampPalette(paletteer::paletteer_d(
        original_name,
        maxcolors,
        direction = -1
      ))(n))
    }
    if (original_name %in% names(palettes)) {
      if (!is.null(n_max)) {
        return(rev(colorRampPalette(palettes[[original_name]][1:n_max])(n)))
      } else {
        return(rev(colorRampPalette(palettes[[original_name]])(n)))
      }
    } else if (name == "hue") {
      return(scales::hue_pal()(n))
    } else {
      maxcolors <- min(
        RColorBrewer::brewer.pal.info[original_name, "maxcolors"],
        n_max
      )
      return(grDevices::colorRampPalette(rev(RColorBrewer::brewer.pal(
        maxcolors,
        original_name
      )))(n))
    }
  } else {
    if (isTRUE(stringr::str_detect(name, "::"))) {
      name_split <- stringr::str_split_1(name, "::")
      maxcolors <- paletteer::palettes_d_names |>
        dplyr::filter(package == name_split[1], palette == name_split[2]) |>
        dplyr::pull(length) |>
        min(n_max)
      return(grDevices::colorRampPalette(paletteer::paletteer_d(
        name,
        maxcolors
      ))(n))
    }
    if (name %in% names(palettes)) {
      if (!is.null(n_max)) {
        return(colorRampPalette(palettes[[name]][1:n_max])(n))
      } else {
        return(colorRampPalette(palettes[[name]])(n))
      }
    } else if (name[1] %in% grDevices::colors()) {
      return(name)
    } else if (name == "hue") {
      return(scales::hue_pal()(n))
    } else {
      maxcolors <- min(RColorBrewer::brewer.pal.info[name, "maxcolors"], n_max)
      return(grDevices::colorRampPalette(RColorBrewer::brewer.pal(
        maxcolors,
        name
      ))(n))
    }
  }
}


#' Add custom color and fill scale
#'
#' @description
#' Add a custom color and/or fill scale depending on the type of input data
#' @concept coloring
#'
#' @param data \link[tibble]{tibble} of the dataset passed to \link[ggplot2]{ggplot}
#' @param color_fill <[`tidy-select`][dplyr_tidy_select]> color and/or fill aesthetics
#' @param aesthetics Character string or vector specifying the names of the aesthetics to use for the scale.
#' This is useful to a set the same color settings to multiple aesthetics simultaneously.
#' @param palette Color palette specified by either:
#' - a character string specifying a colormap from colorbrewer
#' - a character string from the global variable "palettes"
#' - a character string specifying a colormap from paletteer::paletteer_d()
#' - a character vector of HEX colors starting with "#"
#' - a character vector of built-in colors specifying
#' @param limits Numeric vector specifying the limits of the color scale
#' @param midpoint Numeric specifying the midpoint of colorscale
#' @param transform Character string specifying the transformation to be applied to the color scale, e.g. "log10"
#' @param color_fill_name Character string specifying the name of the color scale. If NULL use the name of the color_fill tidy-selection
#' @param show_na Boolean indicating whether to show NA in the legend
#' @param na.value Character indicating the color to use for NA values
#'
#' @return List of ggplot2 color and/or fill scale(s)
#' @export
scale_color_fill_custom <- function(
  data,
  color_fill,
  aesthetics = c("color", "fill"),
  palette = NULL,
  limits = NULL,
  midpoint = NULL,
  transform = "identity",
  color_fill_name = NULL,
  show_na = TRUE,
  na.value = "gray"
) {
  if (is.null(color_fill_name)) {
    color_fill_name <- try(
      {
        rlang::enquo(color_fill) |>
          rlang::as_name() |>
          stringr::str_replace_all("_", " ")
      },
      silent = TRUE
    )
  }

  scale_values <- tryCatch(
    {
      data |>
        dplyr::pull({{ color_fill }})
    },
    error = function(cond) {
      "non_numeric"
    }
  )
  lev <- data |>
    dplyr::pull({{ color_fill }}) |>
    as.factor() |>
    levels() # allows to syncronize the legend colors across multiple geoms

  if (is.numeric(scale_values) || inherits(scale_values, "difftime")) {
    cmap <- (if (!is.null(palette)) palette else "orange_blue") |>
      get_hex_colors()
    if (length(cmap) == 1) {
      cmap <- rep(cmap, 3)
    }
    if (is.null(limits)) {
      limits <- range(scale_values, na.rm = TRUE)
      if (
        limits[1] == limits[2] ||
          length(scale_values) == 0 ||
          is.infinite(limits[1])
      ) {
        limits <- c(0, 1)
      }
    }
    return(list(
      ggplot2::scale_color_gradientn(
        name = color_fill_name,
        trans = transform,
        colors = cmap,
        limits = limits,
        oob = scales::oob_squish,
        values = scales::rescale(c(
          limits[1],
          ifelse(is.null(midpoint), mean(limits), midpoint),
          limits[2]
        )),
        aesthetics = aesthetics,
        na.value = na.value,
      )
    ))
  } else {
    if (
      !is.null(palette) &&
        (startsWith(palette[1], "#") || palette[1] %in% grDevices::colors())
    ) {
      return(list(
        ggplot2::scale_color_manual(
          name = color_fill_name,
          values = palette,
          drop = FALSE,
          aesthetics = aesthetics,
          na.value = na.value,
          na.translate = show_na,
          limits = lev
        )
      ))
    } else if (!is.null(palette) && palette %in% names(palettes)) {
      return(list(
        ggplot2::scale_color_manual(
          name = color_fill_name,
          values = na.omit(get_hex_colors(palette, length(lev))),
          drop = FALSE,
          aesthetics = aesthetics,
          na.value = na.value,
          na.translate = show_na,
          limits = lev
        )
      ))
    } else if (
      !is.null(palette) && isTRUE(stringr::str_detect(palette, "::"))
    ) {
      if (aesthetics == "fill") {
        return(list(
          paletteer::scale_fill_paletteer_d(
            palette = ifelse(
              !is.null(palette),
              palette,
              "ggthemes::Miller_Stone"
            ),
            name = color_fill_name,
            na.value = na.value,
            na.translate = show_na,
            drop = FALSE,
            limits = lev
          )
        ))
      } else {
        return(list(
          paletteer::scale_color_paletteer_d(
            palette = ifelse(
              !is.null(palette),
              palette,
              "ggthemes::Miller_Stone"
            ),
            name = color_fill_name,
            na.value = na.value,
            na.translate = show_na,
            drop = FALSE,
            limits = lev
          )
        ))
      }
    } else if (is.null(palette) || palette == "hue") {
      return(list(
        ggplot2::scale_colour_hue(
          name = color_fill_name,
          drop = FALSE,
          aesthetics = aesthetics,
          na.value = na.value,
          na.translate = show_na,
          limits = lev
        )
      ))
    } else {
      return(list(
        ggplot2::scale_color_brewer(
          name = color_fill_name,
          palette = ifelse(!is.null(palette), palette, "Set2"),
          drop = FALSE,
          aesthetics = aesthetics,
          na.value = na.value,
          na.translate = show_na,
          limits = lev
        )
      ))
    }
  }
}
