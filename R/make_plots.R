#' @title make_plots
#' @description makes choropleth maps with all variables of interest
#' @param x a character vector with all independent variables
#' @param y y a character vector with the dependent variable of interest
#' @importFrom tmap tm_shape
#' @importFrom tmap tm_borders
#' @importFrom tmap tm_layout
#' @importFrom tmap tm_polygons
#' @importFrom tmap tm_facets
#' @importFrom dplyr select
#' @importFrom tidyselect all_of
#' @importFrom tidyr pivot_longer
#' @returns a faceted choropleth map
#' @export
make_plots <- function(x, y){
  vars_to_select <- c(y, x)
  long_plot <- consumaigua::munis_consum |>
    dplyr::select(nom_muni, tidyselect::all_of(vars_to_select)) |>
    tidyr::pivot_longer(-c(nom_muni, geom),
                        names_to = "var",
                        values_to = "value")
  tmap::tm_shape(consumaigua::cat) +
    tmap::tm_borders() +
    tmap::tm_shape(long_plot) +
    tmap::tm_polygons("value",
                      style = "quantile",
                      palette = "viridis",
                      title = "") +
    tmap::tm_facets(by = "var",
                    free.scales.fill = TRUE,
                    free.coords = FALSE) +
    tmap::tm_layout(legend.outside = FALSE)
}


