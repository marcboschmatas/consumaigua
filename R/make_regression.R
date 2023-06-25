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
#' @export
make_regression <- function(x, y, model = "linear"){
  stopifnot(model %in% c("linear", "logit"))
  if(model == "logit") stopifnot(sort(unique(consumaigua::munis_consum[[y]]) == c(0,1)))
  f <- as.formula(paste(y, "~",paste(x, collapse="+")))
  if(model == "linear") mod <- lm(f, data = consumaigua::munis_consum)
  else mod <- glm(f, data = consumaigua::munis_consum, family = binomial(link = "logit"))
  return(mod)
}




