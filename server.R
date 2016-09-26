shinyServer(
  function(input, output, session){
    clrs<-brewer.pal(10, "RdYlGn")
    pal<- colorNumeric(clrs, SpPolysDF@data$scsimd2012decile)
    
    data <- reactive({
      desLA <- which(SpPolysLA@data$NAME %in% input$LA)
      data <- SpPolysLA[desLA,]
    })
    output$newplot<-renderLeaflet({
      if(!is.null(input$LA)){
        p<-leaflet(data())%>%
        addTiles()%>%
        addPolygons(smoothFactor = 0.5, weight = 1.5, fillOpacity = 0.7,
                  fillColor = "grey", color = "black")
      } else if(is.null(input$LA)){
        p <- leaflet()%>%
          addTiles() %>%
          setView(lng = -4.160495, lat = 58, zoom = 6)
      }
    })
    
    observeEvent(
    eventExpr = input$selectAll,
    handlerExpr = 
    {
        updateCheckboxGroupInput(session = session,
                                 inputId = "LA",
                                 selected = unique(SpPolysLA@data$NAME))
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