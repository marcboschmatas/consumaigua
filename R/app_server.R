#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom DT renderDataTable
#' @importFrom broom glance
#' @importFrom broom tidy
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 labs
#' @importFrom ggplot2 theme
#' @importFrom ggplot2 element_text
#' @importFrom purrr map_lgl
#' @importFrom DT datatable
#' @importFrom DT formatRound
#' @importFrom ggplot2 ggplot
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 geom_histogram
#' @noRd
app_server <- function(input, output, session) {

  output$Corr <- renderPlot({
    consumaigua::make_corrplot(x = input$varind, y = input$vardep)
  })
  output$Maps <- renderPlot({consumaigua::make_plots(x = input$varind, y = input$vardep)})
  mod <- reactive({consumaigua::make_regression(x = input$varind, y = input$vardep, model = input$model)})
  output$Coefs <- DT::renderDataTable(DT::formatRound(DT::datatable(broom::tidy(mod())),
                                                      columns = 2:5, digits = 3))

  output$Glance <- DT::renderDataTable(DT::formatRound(DT::datatable(broom::glance(mod())),
                                                       columns = purrr::map_lgl(broom::glance(mod()), is.numeric), digits = 2))
  output$Diagnose <- renderPlot(consumaigua::diag_plot(mod()))




}
