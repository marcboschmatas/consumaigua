#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {

  cormat <- reactive({
    consumaigua::make_corrplot(x = input$varind, y = input$vardep)
  })
  output$Corr <-
    renderPlot(cormat
    )


  #Code section for Linear Regression-----------------------------------------------------------------------------

  f <- reactive({
    as.formula(paste(input$SelectY, "~."))
  })


  Linear_Model <- reactive({
    lm(f(), data = trainingData())
  })

  output$Model <- renderPrint(summary(Linear_Model()))
  output$Model_new <-
    renderPrint(
      stargazer(
        Linear_Model(),
        type = "text",
        title = "Model Results",
        digits = 1,
        out = "table1.txt"
      )
    )

  Importance <- reactive({
    varImp(Linear_Model(), scale = FALSE)
  })

  tmpImp <- reactive({

    imp <- as.data.frame(varImp(Linear_Model()))
    imp <- data.frame(overall = imp$Overall,
                      names   = rownames(imp))
    imp[order(imp$overall, decreasing = T),]

  })

  output$ImpVar <- renderPrint(tmpImp())

  price_predict <- reactive({
    predict(Linear_Model(), testData())
  })

  tmp <- reactive({
    tmp1 <- testData()
    tmp1[, c(input$SelectY)]
  })


  actuals_preds <-
    reactive({
      data.frame(cbind(actuals = tmp(), predicted = price_predict()))
    })

  Fit <-
    reactive({
      (
        plot(
          actuals_preds()$actuals,
          actuals_preds()$predicted,
          pch = 16,
          cex = 1.3,
          col = "blue",
          main = "Best Fit Line",
          xlab = "Actual",
          ylab = "Predicted"
        )
      )
    })

  output$Prediction <- renderPlot(Fit())

  output$residualPlots <- renderPlot({
    par(mfrow = c(2, 2)) # Change the panel layout to 2 x 2
    plot(Linear_Model())
    par(mfrow = c(1, 1)) # Change back to 1 x 1

  })

  output$digest <- renderExplorer({

    explorer(data = dd$data, demo = F)

  })

})
}
