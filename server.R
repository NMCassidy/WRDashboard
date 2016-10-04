shinyServer(
  function(input, output, session){
    clrs<-brewer.pal(10, "RdYlGn")
    pal<- colorNumeric(clrs, SpPolysDF@data$scsimd2012decile)
    
    #Subset data based on checkbox
    data <- reactive({
      desLA <- which(SpPolysDF@data$council %in% input$datazoneLA)
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
        nP <- leaflet(SpPolysDF) %>%
        addTiles() %>%
    #    setView(lng = -4.226, lat = 56.791935, zoom =7) %>%
       addPolygons(smoothFactor = 1.5, weight = 1.5, fillOpacity = 0.7,
                      layerId = ~group, fillColor = "grey", color = "black")
      return(nP)
    })
    
    observeEvent(input$rerend, {
      rnddta <- data()
      leafletProxy("neighbourhoodPlot") %>%
        clearShapes() %>%
      addPolygons(smoothFactor = 1.5, weight = 1.5, fillOpacity = 0.7,
                  layerId = ~group, fillColor = "grey", color = "black", data = rnddta)
    })
    
    observeEvent(
    eventExpr = input$selectAllDZ,
    handlerExpr = 
    {
        updateCheckboxGroupInput(session = session,
                                 inputId = "datazoneLA",
                                 selected = unique(SpPolysDF@data$council))
      }
    )
    observeEvent(
      eventExpr = input$deselectAllDZ,
      handlerExpr = 
      {
        updateCheckboxGroupInput(session = session,
                                 inputId = "datazoneLA",
                                 selected = NA)
      }
    )
    LASubset <- reactive({
      subDta <- LAdta[LAdta$`Local Authority` %in% input$LA & LAdta$Date %in% input$laYear & LAdta$Title %in% input$laIndicator, c(1,3)]
    })
    output$LABasicStats <- DT::renderDataTable({
      dat <- LASubset()
      tblOut <- datatable(dat)
    })
    output$LABarGraph <- renderPlot({
      dat <- LASubset()
      pp <- ggplot(data = dat) +
        geom_bar(aes(x = reorder(`Local Authority`, `value`), y = `value`), fill = "black",stat = "identity")
    })
  }
)