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
        lP<-mapView(SpPolysLA, homebutton = FALSE) #%>%
      #  addTiles()%>%
      #  addPolygons(smoothFactor = 1, weight = 1.5, fillOpacity = 0.7,
      #            fillColor = "grey", color = "black")
    })
    
    #Inputs
    output$laSubDomUI <- renderUI({
      LAdataset <- LAdta[LAdta$Domain %in% input$laDomain,9]
      selectInput("laSubDom", "Select Sub-Domain", unique(LAdataset), selected = NULL)
    })
    output$laIndicatorUI <- renderUI({
      LAdataset<- LAdta[LAdta$Topic %in% input$laSubDom, 6]
      selectInput("laIndicator", "Select Indicator", unique(LAdataset), selected = NULL)
       })
    output$laYearUI <- renderUI({
      LAdataset<- LAdta[LAdta$Title %in% input$laIndicator, 5]
     selectInput("laYear", "Select Time Series", unique(LAdataset), selected = NULL)
    })
    
    output$neighbourhoodPlot <- renderLeaflet({
      nP <- leaflet(data())  %>%
        addTiles() %>%
       addPolygons(smoothFactor = 1, weight = 1.5, fillOpacity = 0.7,
                    fillColor = "grey", color = "black")
    })
    
    observeEvent(input$rerend, {
      data <- data()
      leafletProxy("neighbourhoodPlot") %>%
      addPolygons(smoothFactor = 1, weight = 1.5, fillOpacity = 0.7,
                  fillColor = "grey", color = "black", data = data)
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