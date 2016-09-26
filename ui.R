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
            column(width = 3,box(actionButton("selectAll", label = "Select All"),
                                 actionButton("deselectAll", label = "Select None"),
                                 checkboxGroupInput("LA", "Select a LA", 
                  unique(SpPolysLA@data$NAME), selected = unique(SpPolysLA@data$NAME)), width = NULL)),
            column(width = 9, box(leafletOutput("newplot", height = "700px"), width = NULL))
                             )
        #   tags$head(tags$style("row1{height:800px}")),
)
           )
    )
  
    )
  
)