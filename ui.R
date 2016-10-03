library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Welfare Reform Dashboard"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Local Authority Map", tabName = "lamap", icon = icon("map")),
      menuItem("Local Authority Data", tabName = "ladata", icon = icon("area-chart")),
      menuItem("Data Zone Map", tabName = "dzmap", icon = icon("globe"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "lamap",
           fluidRow(
             column(width = 12, box(mapviewOutput("LAplot", height = "700px"), width = NULL))
           )
      ),
      tabItem(tabName = "ladata",
            fluidRow(
              column(width = 4, box(
                checkboxGroupInput("LA", "Select a LA", 
                unique(SpPolysDF@data$council), selected = unique(SpPolysDF@data$council))
                                )
              ),
              column(width = 8,
                        box(
                          selectInput("laDomain", "Select Domain",unique(LAdta[!is.na(LAdta$Domain), 8]), selected = NULL)
                          ), box(
                          uiOutput("laSubDomUI")
                          ), box(
                          uiOutput("laIndicatorUI")
                          ), box(
                          uiOutput("laYearUI")
                          )
                      )
              ),
              column(width = 8,
                     box(
                       
                    )
              )
        
      ),
      
      
      tabItem(tabName = "dzmap",
              fluidRow(
                column(width = 4,box(actionButton("selectAll", label = "Select All"),
                                     actionButton("deselectAll", label = "Select None"),
              checkboxGroupInput("LA", "Select a LA", 
                                 unique(SpPolysDF@data$council), selected = unique(SpPolysDF@data$council))
                              )    
                ),
                column(width = 8,
                     box(
                       leafletOutput("neighbourhoodPlot", height = "700px"), width=NULL
                     ),
                     box(actionButton("rerend", "Rerender Map"))
                )
              )
           )
      )
  
    )
  
  )
)