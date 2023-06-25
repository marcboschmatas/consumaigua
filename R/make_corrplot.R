#' @title make_corrplot
#' @description makes a correlation plot from selected variables
#' @param x a character vector with all independent variables
#' @param y y a character vector with the dependent variable of interest
#' @examples
#' \dontrun{
#' make_corrplot(c("hotels_1000hab", "vab_relatiu_Agricultura", "renda_capita"), "consum_total")
#' }
#' @importFrom corrplot corrplot
#' @returns a correlation plot
#' @export
make_corrplot <- function(x, y){
  vars_to_select <- c(y, x)
  df <- sf::st_drop_geometry(consumaigua::munis_consum)[,vars_to_select]
  df <- df[,num_cols]
  ct <- cor(df)
  corrplot::corrplot(ct, method = "color", type = "lower", title = "Matriu de correlació")
}



