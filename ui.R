library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Welfare Ref DB"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Local Authority Map", tabName = "lamap", icon = icon("map")),
      menuItem("Local Authority Data", tabName = "ladata", icon = icon("area-chart")),
      menuItem("Neighbourhood Map", tabName = "dzmap", icon = icon("globe")),
      menuItem("Neighbourhood Data", tabName = "dzdata", icon = icon("beer"))
  )),
  dashboardBody(
    tabItems(
      tabItem(tabName = "lamap",
           fluidRow(
             column(width = 12, box(mapviewOutput("LAplot", height = "500px"), width = NULL))
           )
      ),
      tabItem(tabName = "ladata",
            fluidRow(
              column(width = 2, box(
                checkboxGroupInput("LA", "Select a LA", 
                unique(LAdta$`Local Authority`), selected = unique(LAdta$`Local Authority`)), width =NULL
                                )
              ),
              column(width = 10,
                        box(
                          selectInput("laDomain", "Select Domain",unique(LAdta[!is.na(LAdta$Domain), 8]), selected = "Mid-Year Estimates")
                          ), box(
                          uiOutput("laSubDomUI")
                          ), box(
                          uiOutput("laIndicatorUI")
                          ), box(
                          uiOutput("laYearUI")
                          )
                      ),
              column(width = 10,
                     box(
                       DT::dataTableOutput("LASummaryStats"), width = NULL
                     ),
                     box(
                       DT::dataTableOutput("LABasicStats"), height = "600px"
                    ),
                    box(plotOutput("LABarGraph"))
              )
            )
      ),
      
      
      tabItem(tabName = "dzmap",
              fluidRow(
                column(width = 3,box(actionButton("selectAllDZ", label = "Select All"),
                                     actionButton("deselectAllDZ", label = "Select None"),
              checkboxGroupInput("datazoneLA", "Select a LA", 
                                 unique(SpPolysDF@data$council), selected = unique(SpPolysDF@data$council))
                              ,width = NULL)    
                ),
                column(width = 8,
                     box(
                       leafletOutput("neighbourhoodPlot", height = "700px"), width=NULL
                     ),
                     box(
                       actionButton("rerend", "ReRender map")
                     )
                )
              )
           ),
      tabItem(tabName = "dzdata",
              fluidRow(
                column(width = 3, box(
                  selectInput("dzdataDomain", "Select Domain", unique(mtaDZ[mtaDZ$Domain != "Geographic Classifications", 3]), selected = NULL), width = NULL
                )
                       ),
                column(width = 2, box(
                  uiOutput("dzdataSubDomUI"), width = NULL
                  )
                       ),
                column(width =2, box(
                  uiOutput("dzdataSubSubDomUI"), width = NULL
                  )
                ),
                column(width = 3, box(
                  uiOutput("dzdataIndicatorUI"), width = NULL
                  )
                ),
                column(width = 2, box(
                  uiOutput("dzdataYearUI"), width = NULL
                ))
              ),
              fluidRow(
                column(width = 2, box(
                    checkboxGroupInput("datazoneLA2", "Select a LA",
                                       unique(geoLk$laname), selected = unique(geoLk$laname)
                    ), width = NULL
                  )
                ),
                column(width = 8, box(
                  DT::dataTableOutput("dzTable"), width = NULL
                  )
                 ),
                column(width = 2, box(
                  textOutput("mtaDtaTxt"), width = NULL
                )
                       )
                
              )
        
      )
      )
  
    )
  
  )
)