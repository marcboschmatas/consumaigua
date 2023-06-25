#' @title make_plots
#' @description retorna dos mapes coropleta un per cada variable i el gràfic de dispersió
#' @param var1 variable 1 que es vol estudiar
#' @param var2 variable 2 que es vol estudiar
#' @importFrom tmap tm_shape
#' @importFrom tmap tm_rgb
#' @importFrom tmap tm_borders
#' @importFrom tmap tm_layout
#' @importFrom tmap tmap_grob
#' @importFrom tmap tm_polygons
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_point
#' @importFrom ggplot2 geom_smooth
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 labs
#' @importFrom dplyr select
#' @importFrom dplyr rename
#' @importFrom tidyselect all_of
#' @importFrom cowplot plot_grid
#' @returns a plot grid with two maps and a scatterplot
#' @export
make_plots <- function(var1, var2){
  p1 <- tmap::tm_shape(consumaigua::basemap) +
    tmap::tm_rgb() +
    tmap::tm_shape(consumaigua::cat) +
    tmap::tm_borders() +
    tmap::tm_shape(consumaigua::munis_consum) +
    tmap::tm_polygons(var1,
                      palette = "viridis",
                      style = "quantile") +
    tmap::tm_layout(frame = FALSE,
                    legend.position = c("right", "bottom"),
                    legend.text.size = .75)
  p2 <- tmap::tm_shape(consumaigua::basemap) +
    tmap::tm_rgb() +
    tmap::tm_shape(consumaigua::cat) +
    tmap::tm_borders() +
    tmap::tm_shape(consumaigua::munis_consum) +
    tmap::tm_polygons(var2,
                      palette = "viridis",
                      style = "quantile") +
    tmap::tm_layout(frame = FALSE,
                    legend.position = c("right", "bottom"),
                    legend.text.size = .75)
  p3 <- consumaigua::munis_consum |>
    dplyr::select(tidyselect::all_of(c(var1, var2))) |>
    dplyr::rename("x" = var1,
                  "y" = var2) |>
    ggplot2::ggplot(ggplot2::aes(x, y)) +
    ggplot2::geom_point() +
    ggplot2::geom_smooth(method = "lm") +
    ggplot2::theme_minimal() +
    ggplot2::labs(x = var1,
                  y = var2)

  cowplot::plot_grid(tmap::tmap_grob(p1), tmap::tmap_grob(p2), p3, nrow =2)
}
