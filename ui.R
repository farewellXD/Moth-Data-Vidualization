library(shiny)
library(shinythemes)
library(leaflet)
library(shinydashboard)

body <- dashboardBody(
  
  fluidRow(
     # Dynamic valueBoxes
     valueBoxOutput("num_spe"),
     valueBoxOutput("count"),
     valueBoxOutput("num_na")
   ),
  
   fluidRow(box(width = 12, leafletOutput('myMap'))),

  navbarPage('Result',
    tabPanel('Figure',
      fluidRow(
         box(
           title = "Body Length", width = 4, solidHeader = T, status = "success", 
           plotOutput("plot1")
        ),
        box(
          title = "Forewing Length", width = 4, solidHeader = T, status = "success",
           plotOutput("plot2")
        ),
        box(
          title = "Weight", width = 4, solidHeader = T, status = "success",
          plotOutput("plot3")
        )
      )
      ),
    tabPanel('Raw data',
      fluidRow(
       column(12, DT::dataTableOutput('x1'))
      )
  )
)
)


ui <- dashboardPage(skin = 'red',
  dashboardHeader(title = 'Moth Dashborad'),
  
  dashboardSidebar(
    #sidebarLayout(
    
    sidebarMenu(menuItem("Moth Range Size Dataset", tabName = "dashboard", icon = icon("dashboard"))
    ),
    selectInput("location", 
                label = "Choose the collect location",
                choices = list("Taiwan", 
                               "China",
                               "Malysia"),
                selected = "Taiwan")
   ),
  body
)


