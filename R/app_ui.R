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
      shinydashboard::dashboardHeader(title = "Determinants del consum d'aigua a les conques internes",titleWidth = 600),
      shinydashboard::dashboardSidebar(disable = TRUE),

      shinydashboard::dashboardBody(
        shiny::fluidPage(
          shinydashboard::box(
            shiny::selectInput(
              "varind",
              label = "Trieu variables:",
              choices = c("n_hotel", "n_piscines", "vab_relatiu_Agricultura",
                          "vab_relatiu_Indústria", "vab_relatiu_Construcció",
                          "vab_relatiu_Serveis", "vab_absolut_Agricultura",
                          "vab_absolut_Indústria", "vab_absolut_Construcció",
                          "vab_absolut_Serveis", "vab_absolut_Total", "poblacio", "renda_capita",
                          "piscines_1000hab", "hotels_1000hab","su_cases_aillades",
                          "su_cases_agrupades", "area_muni", "pct_su_cases_aillades",
                          "pct_su_cases_agrupades"),
              multiple = TRUE
            ),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Variables independents"
          ),
          shinydashboard::box(
            shiny::selectInput("vardep", label = "Trieu variable:",
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
          shinydashboard::box(
            shiny::selectInput("model", label = "Trieu model:",
                        choices = c("linear", "logit")),
            solidHeader = TRUE,
            width = "3",
            status = "primary",
            title = "Model"
          )


        ),

        shiny::fluidPage(
          shinydashboard::tabBox(
            id = "tabset1",
            height = "2000px",
            width = 12,
            shiny::tabPanel("Introducció",
                                     shinydashboard::box(
                                     shiny::h5("Aquesta aplicació permet crear models de regressió per a explicar el consum d'aigua als municipis de les conques internes en situació de prealerta, alerta o excepcionalitat per sequera.\n
                            Per a fer-ho, s'utilitzen variables vinculades a la renda, l'activitat econòmica, l'urbanisme o l'activitat turística"),
                         shiny::hr(),
                         shiny::a(href = "https://github.com/marcboschmatas/consumaigua",
                                  "Podeu trobar una descripció més detallada de les variables al repositori GitHub de l'app"),
                         shiny::h5("Així, el model permet seleccionar una sèrie de variables dependents, una variable independent i un tipus de model: lineal o logístic (aquest darrer només funcionarà en cas que la variable independent tingui valors únics 0 i 1)"),
                         shiny::hr(),
                         shiny::h5("La pestanya Correlacions presenta un gràfic de correlació entre totes les variables seleccionades. La pestanya Mapes presenta un mapa coropleta per a tots els municipis amb dades i cada variable. La pestanya Ccoeficients presenta els coeficients del model de forma gràfica. La pestanya Resum model, els principals estadístics i els gràfics de diagnòstic"))),
            shinydashboard::tabPanel("Correlacions",
                                     shinydashboard::box(shinycssloaders::withSpinner(shiny::plotOutput("Corr")))),
            shinydashboard::tabPanel("Mapes",
                                     shinydashboard::box(shinycssloaders::withSpinner(shiny::plotOutput(
                        "Maps"
                      )), width = 12)),
            shinydashboard::tabPanel("Coeficients",
                                     shinydashboard::box(shinycssloaders::withSpinner(DT::DTOutput(
                       "Coefs"
                     )), width = 12,
                     height = 12)),
            #box(withSpinner(verbatimTextOutput("CorrMatrix")), width = 12),
            shinydashboard::tabPanel("Resum model",
                                     shinydashboard::box(shinycssloaders::withSpinner(DT::DTOutput(
                     "Glance"
                   )), width = 12),
                   shiny::hr(),
                   shinydashboard::box(shinycssloaders::withSpinner(plotOutput("Diagnose"))))
            ),
          shiny::textOutput("correlation_accuracy"),
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
