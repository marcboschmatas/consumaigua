#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinydashboard
#' @importFrom shinycssloaders withSpinner
#' @importFrom DT DTOutput
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    shinydashboard::dashboardPage(
      shinydashboard::dashboardHeader(title = "Determinants del consum d'aigua", dropdownMenuOutput("msgOutput")),
      shinydashboard::dashboardSidebar(
        out = h5("Blablablablablablabla")),

      shinydashboard::dashboardBody(
        fluidPage(
          box(
            selectInput(
              "varind",
              label = "Trieu variables:",
              choices = c("n_hotel", "n_piscines", "vab_relatiu_Agricultura",
                          "vab_relatiu_Indústria", "vab_relatiu_Construcció",
                          "vab_relatiu_Serveis", "vab_absolut_Agricultura",
                          "vab_absolut_Indústria", "vab_absolut_Construcció",
                          "vab_absolut_Serveis", "vab_absolut_Total", "poblacio",
                          "piscines_1000hab", "hotels_1000hab","su_cases_aillades",
                          "su_cases_agrupades", "area_muni", "pct_su_cases_aillades",
                          "pct_su_cases_agrupades"),
              multiple = TRUE,
              selected = c("n_hotel", "n_piscines", "vab_relatiu_Agricultura",
                           "vab_relatiu_Indústria", "vab_relatiu_Construcció",
                           "vab_relatiu_Serveis", "vab_absolut_Agricultura",
                           "vab_absolut_Indústria", "vab_absolut_Construcció",
                           "vab_absolut_Serveis", "vab_absolut_Total", "poblacio",
                           "piscines_1000hab", "hotels_1000hab","su_cases_aillades",
                           "su_cases_agrupades", "area_muni", "pct_su_cases_aillades",
                           "pct_su_cases_agrupades")
            ),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Variables independents"
          ),
          box(
            selectInput("vardep", label = "Trieu variable:",
                        choices = c("consum_total", "consum_primavera",
                                    "consum_hivern", "consum_estiu",
                                    "consum_tardor", "mes_400_total",
                                    "mes_400_hivern", "mes_400_estiu",
                                    "mes_400_primavera", "mes_400_tardor",
                                    "mes_250_total", "mes_250_estiu",
                                    "mes_250_hivern", "mes_250_primavera",
                                    "mes_250_tardor")),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Variable dependent"
          ),
          box(
            selectInput("model", label = "Trieu model:",
                        choices = c("linear", "logit")),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Model"
          )


        ),

        fluidPage(

          tabBox(
            id = "tabset1",
            height = "1000px",
            width = 12,

            tabPanel("Correlacions",
                     box(shinycssloaders::withSpinner(plotOutput(
                       "Corr"
                     )), width = 12)),
            tabPanel("Mapes",
                     box(shinycssloaders::withSpinner(plotOutput(
                       "Maps"
                     )), width = 12)),
            tabPanel("Coeficients",
                     box(shinycssloaders::withSpinner(plotOutput(
                       "Coefs"
                     )), width = 12)),
            #box(withSpinner(verbatimTextOutput("CorrMatrix")), width = 12),
          tabPanel("Stats",
                   box(shinycssloaders::withSpinner(DT::DTOutput(
                     "Glance"
                   )), width = 12))
            ),
            #textOutput("correlation_accuracy"),
          )
        )
      )
    )

}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "consumaigua"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
