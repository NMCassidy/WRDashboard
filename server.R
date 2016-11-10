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
        lP<-mapView(SpPolysLA) #%>%
       # addTiles()%>%
      #  addPolygons(smoothFactor = 1.3, weight = 1.5, fillOpacity = 0.7,
      #            fillColor = "grey", color = "black")
    })
    
  #Inputs for Local Authority Data Explorer Page
    output$laSubDomUI <- renderUI({
      LAdataset <- LAdta[LAdta$Domain %in% input$laDomain ,9]
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
    
  #Generate UIs for Data Zone Explorer Page
    output$dzdataSubDomUI <- renderUI({
      DZdataset <- mtaDZ[mtaDZ$Domain %in% input$dzdataDomain, 4]
      selectInput("dzdataSubDom", "Select Sub-Domain", unique(DZdataset), selected = NULL)
    })
    output$dzdataSubSubDomUI <- renderUI({
      DZdataset <- mtaDZ[mtaDZ$`Sub-domain` %in% input$dzdataSubDom, 5]
      selectInput("dzdataSubSubDom", "Select Sub-Domain", unique(DZdataset), selected = NULL)
    })
    output$dzdataIndicatorUI <- renderUI({
      DZdataset <- mtaDZ[mtaDZ$Topic %in% input$dzdataSubSubDom, 2]
      selectInput("dzdataIndicator", "Select Indicator", unique(DZdataset), selected = NULL)
    })
    output$dzdataYearUI <- renderUI({
      subVar <- mtaDZ[mtaDZ$Title %in% input$dzdataIndicator, 1]
      DZdataset <- DZdta[DZdta$Indicator %in% subVar, 4]
      selectInput("dzdataYear", "Select Time Series", unique(DZdataset), selected = NULL)
    })
    
    output$neighbourhoodPlot <- renderLeaflet({
        nP <- leaflet(SpPolysDF) %>%
        addTiles() %>%
    #    setView(lng = -4.226, lat = 56.791935, zoom =7) %>%
       addPolygons(smoothFactor = 1.3, weight = 1.5, fillOpacity = 0.7,
                      layerId = ~group, fillColor = "grey", color = "black")
      return(nP)
    })
    
    observeEvent(input$rerend, {
      rnddta <- data()
      leafletProxy("neighbourhoodPlot") %>%
        clearShapes() %>%
      addPolygons(smoothFactor = 1.3, weight = 1.5, fillOpacity = 0.7,
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
      subDta <- LAdta[LAdta$`Local Authority` %in% input$LA & LAdta$Date %in% input$laYear & LAdta$Title %in% input$laIndicator, c(1,3,6)]
    })
    output$LASummaryStats <- renderDataTable({
      dat <- LASubset()
      tpRow <- c("", "mean", "median", "min", "max", "Q1", "Q2")
      btRow <- data.frame("value", mean(dat$value), median(dat$value), min(dat$value), max(dat$value), 
                 quantile(dat$value, 0.25, names = FALSE),quantile(dat$value, 0.75, names = FALSE))
      colnames(btRow) <- tpRow
      datatable(btRow, rownames = FALSE,options =list(scrollX = TRUE, dom = "t"))
    })
    output$LABasicStats <- DT::renderDataTable({
      dat <- LASubset()[c(1,3,2)]
      tblOut <- datatable(dat, extensions = "Responsive", rownames = FALSE,
                          options = list(pageLength = 32, scrollY = 380, dom = "t"),
                          colnames = c("Local Authority", "Indicator", "Value"))
    })
    output$LABarGraph <- renderPlot({
      options(scipen = 1000)
      dat <- LASubset()
      pp <- ggplot(data = dat) +
        geom_bar(aes(x = reorder(`Local Authority`, `value`), y = `value`), fill = "black",stat = "identity") +
        geom_hline(yintercept = median(dat$value), colour = "red")+
        theme_bw()+
        xlab("")+
        theme(axis.text.x = element_text(angle = 90, hjust = 1))
      return(pp)
    })
    output$dzTable <- DT::renderDataTable({
      datatable(geoLk[,c(1,9, 3, 10)],extensions = "Scroller", rownames = FALSE, filter = "bottom",
                options = list(scrollY = 300, scroller = TRUE))
    })
    output$mtaDtaTxt <- renderText({
      dat <-LASubset()
      mtaDZ[mtaDZ$Title == input$dzdataIndicator,8]
    })
  }
)