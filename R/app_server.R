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
  output$Coefs <- renderPlot(sjPlot::plot_model(mod(),
                                                      show.values = TRUE,
                                                      show.intercept = TRUE,
                                                      vline.color = "black",
                                                      ci.lvl = .95) +
                                     ggplot2::theme_minimal() +
                                     ggplot2::labs(title = "Coeficients",
                                                 caption = "Interval de confiança 95%\n***: p < .01, **: p < .05, *: p < .1") +
                               ggplot2::theme(axis.text.x = ggplot2::element_text(size = 11),
                                              axis.text.y = ggplot2::element_text(size = 11),
                                              axis.title.x = ggplot2::element_text(size = 12),
                                              axis.title.y = ggplot2::element_text(size = 12),
                                              plot.title = ggplot2::element_text(size = 16),
                                              plot.caption = ggplot2::element_text(size = 11)))

  output$Glance <- DT::renderDataTable(DT::formatRound(DT::datatable(broom::glance(mod())),
                                                       columns = purrr::map_lgl(broom::glance(mod()), is.numeric), digits = 2))
  output$Diagnose <- renderPlot(consumaigua::diag_plot(mod()))




}
