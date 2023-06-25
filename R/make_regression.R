#' @title make_regression
#' @description makes a regression model from a series of independent variables and one dependent
#' @param x a character vector with all independent variables
#' @param y a character vector with the dependent variable of interest
#' @param model choice of model to implement, either linear or logit
#' @returns a list with a ```broom::glance``` table and estimates plot
#' @examples
#' \dontrun{
#' make_regression(x = c("hotels_1000hab", "vab_relatiu_Agricultura", "piscines_1000hab"), y = "consum_total")
#' }
#' @import ggplot2 theme_minimal
#' @import broom glance
#' @import sjPlot plot_model
#' @import ggplot2 labs
#' @export
make_regression <- function(x, y, model = "linear"){
  stopifnot(model %in% c("linear", "logit"))
  if(model == "logit") stopifnot(sort(unique(consumaigua::munis_consum[[y]]) == c(0,1)))
  f <- as.formula(paste(y, "~",paste(x, collapse="+")))
  if(model == "linear") mod <- lm(f, data = consumaigua::munis_consum)
  else mod <- glm(f, data = consumaigua::munis_consum, family = binomial(link = "logit"))
  gl <- broom::glance(mod)
  pl <- sjPlot::plot_model(mod,
                           show.values = TRUE,
                           show.intercept = TRUE,
                           vline.color = "black",
                           ci.lvl = .95) +
    ggplot2::theme_minimal()
    ggplot2::labs(title = "Coeficients",
                  caption = "Interval de confiança 95%")
  return(list(glance = gl, coef_plot = pl))
}




