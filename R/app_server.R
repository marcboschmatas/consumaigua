#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom DT renderDataTable
#' @importFrom broom glance
#' @importFrom sjPlot plot_model
#' @importFrom ggplot2 theme_minimal
#' @importFrom ggplot2 labs
#' @noRd
app_server <- function(input, output, session) {

  output$Corr <- renderPlot({
    consumaigua::make_corrplot(x = input$varind, y = input$vardep)
  })

  mod <- reactive({consumaigua::make_regression(x = input$varind, y = input$vardep, model = input$model)})
  output$Coefs <- renderPlot(sjPlot::plot_model(mod(), # això ho tinc zero clar
                                                      show.values = TRUE,
                                                      show.intercept = TRUE,
                                                      vline.color = "black",
                                                      ci.lvl = .95) +
                                     ggplot2::theme_minimal() +
                                     ggplot2::labs(title = "Coeficients",
                                                 caption = "Interval de confiança 95%"))

  output$Glance <- DT::renderDataTable(broom::glance(mod()))

  # mapes <- reactive({consumaigua::make_plots(x = input$varind, y = input$vardep)})
  #
  # output$Mapes <- renderPlot(mapes)


}
