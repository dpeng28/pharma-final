library(shiny)
library(shinydashboard)
library(R.matlab)
library(ggplot2)
library(plotly)

# Define UI for application that draws a histogram
shinyUI(
    dashboardPage(
        skin='yellow',
        
        dashboardHeader(
            title = "Metformin Simulator"
        ),
        dashboardSidebar(
            numericInput("yourWeight", label = h3("What's your weight - kg"), value = 89),
            numericInput("yourAge", label = h3("What's your age"), value = 50),
            numericInput("dailyGlucoseInput", label = h3("Glucose input per meal - g"), value = 50),
            
            
            sliderInput("meal1", label = h3("1st Meal Time"), min = -1, max = 24, value = 7),
            sliderInput("meal2", label = h3("2nd Meal Time"), min = -1, max = 24, value = 12),
            sliderInput("meal3", label = h3("3rd Meal Time"), min = -1, max = 24, value = 19),
            
            
            numericInput("dailyMetforminInput", label = h3("Metformin input per meal - mg"), min = 0, max = 500, value = 250),
            
            sliderInput("met1", label = h3("1st Metformin Time"), min = -1, max = 24, value = 7),
            sliderInput("met2", label = h3("2nd Metformin Time"), min = -1, max = 24, value = 12),
            sliderInput("met3", label = h3("3rd Metformin Time"), min = -1, max = 24, value = 19)
            
        ),
        dashboardBody(
            # Output: bunch of tabsetpanel ----
            tabsetPanel(type = "tabs",
                        tabPanel(h4("Introduction"),
                                 br(),
                                 fluidRow(
                                     box(
                                         title = "Here is a short introduction...", 
                                         status = "info", 
                                         solidHeader = TRUE, 
                                         width = 12,
                                         
                                         slickROutput("slickr", height = "800")
                                     )
                                 )
                        
                                 ),
                        # Model Exploration tab ----
                        tabPanel(h4("Single Dose"),
                                 br(),
                                 fluidRow(
                                     box(
                                         title = "PK plots", 
                                         
                                         tabsetPanel(type = 'tabs', 
                                                     tabPanel(
                                                         h4("1.Metformin Amount TimeSeries"),
                                                         plotlyOutput("metTimeSeries", height = 600)

                                                     ), 
         
                                                     tabPanel(
                                                         h4("2.Blood Glucose Concentration w/ diet"), 
                                                         plotlyOutput("bloodGluWDiet", height = 600)
                                                     ), 
                                                     tabPanel(
                                                         h4("3.Blood Glucose Change w/o diet"), 
                                                         plotlyOutput("bloodGluWODiet", height = 600)
                                                     )
                                                     
                                         ), 

                                         status = "primary", 
                                         solidHeader = TRUE, 
                                         width = 8
                                     ),
                                     
                                     box(
                                         title = "Adjust parameter",
                                         status = "warning", 
                                         solidHeader = TRUE,
                                         width = 4, 
                                         
                                         tabsetPanel(
                                             type = "tabs", 
                                             
                                             tabPanel(
                                                 h5("1"),
                                                 sliderInput("sliderMetConc", label = h3("[Metformin] Range"), min = 0, max = 700, value = c(0, 700)),
                                                 sliderInput("sliderTime", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             ), 
                                             tabPanel(
                                                 h5("2"),
                                                 sliderInput("sliderGluDiet", label = h3("Glucose Concentration Range"), min = 40, max = 240, value = c(40, 240)),
                                                 sliderInput("sliderGluDietTime", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             ),
                                             tabPanel(
                                                 h5("3"),
                                                 sliderInput("sliderGluNoDiet", label = h3("Glucose Concentration Range"), min = 40, max = 200, value = c(40, 200)),
                                                 sliderInput("sliderGluNoDietTime", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             )
                                                     
                                         )

                                     )
                                 )
                        ),
                        # Multiple Dose tab ----
                        tabPanel(h4("Multiple Dose"), 
                                 br(),
                                 fluidRow(
                                     box(
                                         title = "PK plots - Multiple Dose", 
                                         
                                         tabsetPanel(type = 'tabs', 
                                                     tabPanel(
                                                         h4("1.Metformin Amount TimeSeries"),
                                                         plotlyOutput("metTimeSeries-MD", height = 600)
                                                         
                                                     ), 
                                                     
                                                     tabPanel(
                                                         h4("2.Blood Glucose Concentration w/ Diet"), 
                                                         plotlyOutput("bloodGluWdiet-MD", height = 600)
                                                     ), 
                                                     
                                                     tabPanel(
                                                         h4("3.Blood Glucose Change wo/ Diet"), 
                                                         plotlyOutput("bloodGluWOdiet-MD", height = 600)
                                                     )
                                                     
                                         ), 
                                         
                                         status = "primary", 
                                         solidHeader = TRUE, 
                                         width = 8
                                     ),
                                     
                                     box(
                                         title = "Adjust parameter",
                                         status = "warning", 
                                         solidHeader = TRUE,
                                         width = 4, 
                                         
                                         tabsetPanel(
                                             type = "tabs", 
                                             
                                             tabPanel(
                                                 h5("1"),
                                                 sliderInput("sliderMetConc-MD", label = h3("[Metformin] Range"), min = 0, max = 700, value = c(0, 700)),
                                                 sliderInput("sliderTime-MD", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             ), 
                                             tabPanel(
                                                 h5("2"),
                                                 sliderInput("sliderGluDiet-MD", label = h3("Glucose Concentration Range"), min = 50, max = 200, value = c(50, 200)),
                                                 sliderInput("sliderGluDietTime-MD", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             ),
                                             tabPanel(
                                                 h5("3"),
                                                 sliderInput("sliderGluNoDiet-MD", label = h3("Glucose Concentration Range"), min = 50, max = 200, value = c(50, 200)),
                                                 sliderInput("sliderGluNoDietTime-MD", label = h3("Time Range"), min = 0, max = 1000, value = c(0, 1000))
                                             )
                                             
                                         )
                                         
                                     )
                                 )  
                        ),
                        # Sensitivity analysis tab ----
                        tabPanel(
                            h4("Sensitivity Analysis"), 
                            br(),
                            box(
                                title = "Sensitivity", 
                    
                                tabsetPanel(type = 'tabs', 
                                            tabPanel(
                                                h4("Young Population"),
                                                plotlyOutput("youngSens", height = 600)
                                                
                                            ), 
                                            
                                            tabPanel(
                                                h4("Mid age Population"), 
                                                plotlyOutput("midSens", height = 600)
                                            ), 
                                            
                                            tabPanel(
                                                h4("Old Population"), 
                                                plotlyOutput("oldSens", height = 600)
                                            )
                                            
                                ), 
                                
                                status = "primary", 
                                solidHeader = TRUE, 
                                width = 12
                            )
                            
                                 
                        ),
                        # Population Studies tab ----
                        tabPanel(h4("Population Pharmacokinetics/dynamics"), 
                                 br(), 
                                 fluidRow(
                                     box(
                                         title = "Population Studies", 
                                         status = "primary", 
                                         solidHeader = TRUE, 
                                         width = 8,
                                         plotlyOutput("popBoxPlot", height = 600)
                                         
                                     ),
                                     
                                     box(
                                         title = "Adjust parameter",
                                         status = "warning", 
                                         solidHeader = TRUE,
                                         width = 4, 
                                         selectInput("selectPopParameters", label = h3("Select Parameters"), 
                                                     choices = list("Weight - kg" = 1, 
                                                                    "Height - cm" = 2, 
                                                                    "kh0 - min-1" = 3, 
                                                                    "kgg - min-1" = 4, 
                                                                    "kgl - min-1" = 5, 
                                                                    "kls - min-1" = 6, 
                                                                    "ksl - min-1" = 7, 
                                                                    "ksg - min-1" = 8, 
                                                                    "ks0 - min-1" = 9, 
                                                                    "kin - mg/dl/min" = 10, 
                                                                    "Ctrough drug - mg/dl" = 11, 
                                                                    "Ctrough glucose - mg/dl" = 12, 
                                                                    "AUC drug - mg/dl * t" = 13), 
                                                     selected = 11)
                                         
                                     )
                                 )  
   
                        ),
                        # Personalized Dosing Scheme tab ----
                        tabPanel(h4("Personalized Dosing Scheme"), 
                                 br(), 
                                 dataTableOutput("placeHolderTable"),
                                 
                                 br(),
                                 fluidRow(
                                     box(
                                         title = "Personalized Medicine", 
                                         
                                         tabsetPanel(type = 'tabs', 
                                                     tabPanel(
                                                         h4("1.Metformin Amount TimeSeries"),
                                                         plotlyOutput("metTimeSeries-PM", height = 600)
                                                         
                                                     ), 
                                                     
                                                     tabPanel(
                                                         h4("2.Blood Glucose Concentration w/ Diet"), 
                                                         plotlyOutput("bloodGluWdiet-PM", height = 600)
                                                     )
                                                     
                                         ), 
                                         
                                         status = "primary", 
                                         solidHeader = TRUE, 
                                         width = 12
                                     )
                                 )  
                        )
            )
        )
    )
)
