shinyServer(
  function(input, output, session){
    clrs<-brewer.pal(10, "RdYlGn")
    pal<- colorNumeric(clrs, SpPolysDF@data$scsimd2012decile)
    
    #Subset data based on checkbox
    data <- reactive({
      desLA <- which(SpPolysDF@data$council %in% input$LA)
      data <- SpPolysDF[desLA,]
    })
    output$LAplot<-renderMapview({
        lP<-mapView(SpPolysLA) #%>%
      #  addTiles()%>%
      #  addPolygons(smoothFactor = 1, weight = 1.5, fillOpacity = 0.7,
      #            fillColor = "grey", color = "black")
    })
    
    output$neighbourhoodPlot <- renderLeaflet({
      nP <- leaflet(data()) %>%
        addTiles() %>%
        addPolygons(smoothFactor = 1, weight = 1.5, fillOpacity = 0.7,
                    fillColor = "grey", color = "black")
    })
    
    
    observeEvent(
    eventExpr = input$selectAll,
    handlerExpr = 
    {
        updateCheckboxGroupInput(session = session,
                                 inputId = "LA",
                                 selected = unique(SpPolysDF@data$council))
      }
    )
    observeEvent(
      eventExpr = input$deselectAll,
      handlerExpr = 
      {
        updateCheckboxGroupInput(session = session,
                                 inputId = "LA",
                                 selected = NA)
      }
    )
  }
)