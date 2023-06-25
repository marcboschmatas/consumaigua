#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom DT renderDataTable
#' @noRd
app_server <- function(input, output, session) {

  cormat <- reactive({
    consumaigua::make_corrplot(x = input$varind, y = input$vardep)
  })
  output$Correlacions <- renderPlot(cormat)

  mod <- reactive({consumaigua::make_regression(x = input$varind, y = input$vardep, model = input$model)})
  output$Coeficients <- renderPlot(mod$coef_plot)

  output$Stats <- DT::renderDataTable(mod$glance)

  # mapes <- reactive({consumaigua::make_plots(x = input$varind, y = input$vardep)})
  #
  # output$Mapes <- renderPlot(mapes)


}
