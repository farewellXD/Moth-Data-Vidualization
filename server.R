library(shiny)
library(leaflet)
library(data.table)
library(DT)
library(googlesheets)


loc_url = 'https://docs.google.com/spreadsheets/d/1dBrz90STvY2elJVOawCpqxaMoQBrIDlEzmmVXry57WQ/edit?usp=sharing'
trait_url = 'https://docs.google.com/spreadsheets/d/1z8_GQu0L87w2x__A84KzMvzMsTGrabRsOaWayP0B414/edit?usp=sharing'
## Get data

getRaw <- function (x) {
  GTPtest <- gs_url(x)
  df<- gs_read(ss=GTPtest,skip=0)
  df<- as.data.table(df)
}


shinyServer(function(input, output) {
  
  map = getRaw(loc_url)
  data = getRaw(trait_url)
  df_select = data[Group == 'macromoth' & Species != ''] 
  num_spe = length(unique(df_select$Species))
  count = nrow(df_select)
  num_na = sum(is.na(df_select$W_length), is.na(df_select$B_length), is.na(df_select$Weight))
  df_display = df_select[,c('Coll_data', 'Family', 'Species', 'W_length', 'B_length', 'Weight', 'Weight_with_pin')]
  
  #output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    #x    <- faithful[, 2] 
    #bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    #hist(x, breaks = bins, col = 'darkgray', border = 'white')
  #}),
  #location <- reactive({map[map$country == input$location, ] })
  
  output$myMap = renderLeaflet(leaflet() %>% 
                               addTiles() %>% 
                               setView(lng = 111.185180, lat = 19.0880351, zoom = 3.5) %>%
                               addCircleMarkers(data = map, lng = map$Lontitude, lat = map$Latitude, 
                                                radius = 4, color = 'red', layerId = map$`Site name`,
                                                group = map$nation, labelOptions = map$`Site name`))
  
  output$num_spe <- renderValueBox({valueBox(paste0(num_spe), "Total species", icon = icon("bug"), color = "purple")})
  
  output$count <- renderValueBox({valueBox(paste0(count), "Total records", icon = icon("database"), color = "yellow")})
  
  output$num_na <- renderValueBox({valueBox(paste0(num_na), "NA record", icon = icon("align-left"), color = "blue")})
  
  
  output$x1 = DT::renderDataTable(df_display, class = 'cell-border stripe', filter = 'top')
  
  output$plot1 <- renderPlot({
    boxplot(data = df_select, df_select$B_length~df_select$Coll_data, ylab='Body length (mm)')
  })
  output$plot2 <- renderPlot({
    boxplot(data = df_select, df_select$W_length~df_select$Coll_data, ylab="Forewing length (mm)")
  })
  output$plot3 <- renderPlot({
    boxplot(data = df_select, df_select$Weight_with_pin~df_select$Coll_data, ylab="Weight (g)")
  })

  })
  

