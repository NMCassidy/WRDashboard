library(shinydashboard)

shinyUI(dashboardPage(
  dashboardHeader(title = "Welfare Reform DashBoard", titleWidth = 300),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Local Authority Map", tabName = "lamap", icon = icon("map")),
      menuItem("Local Authority Data", tabName = "ladata", icon = icon("area-chart")),
      menuItem("Neighbourhood Map", tabName = "dzmap", icon = icon("globe")),
      menuItem("Neighbourhood Data", tabName = "dzdata", icon = icon("beer"))
  )),
  dashboardBody(
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "custom.css"),
      tags$style(HTML("div.checkbox {margin-top:0;}"))
    ),
    tabItems(
      tabItem(tabName = "lamap",
           fluidRow(
   #          column(width = 12, box(mapviewOutput("LAplot", height = "800px"), width = NULL))
           )
      ),
      tabItem(tabName = "ladata",
            fluidRow(
              column(width = 3, box(width = NULL, title = "Select Local Authority",
                div(class = "chckBx", checkboxGroupInput("LA", label =NULL,
                unique(LAdta$`Local Authority`), selected = unique(LAdta$`Local Authority`), inline = FALSE)
                    )
                                )
              ),
              column(width = 9,
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
              column(width = 9,
                     box(
                       DT::dataTableOutput("LASummaryStats"), width = NULL
                     ),
                     box(
                       DT::dataTableOutput("LABasicStats"), height = "450px"
                    ),
                    box(plotOutput("LABarGraph"))
              )
            )
      ),
      
      
      tabItem(tabName = "dzmap",
              fluidRow(
                column(width = 3,box(title = "Select Local Authority", 
                                     actionButton("selectAllDZ", label = "Select All"),
                                     actionButton("deselectAllDZ", label = "Select None"),
              div(class = "chckBx",checkboxGroupInput("datazoneLA", label = NULL, 
                                 unique(SpPolysDF@data$council), selected = unique(SpPolysDF@data$council)))
                              ,width = NULL)    
                ),
                column(width = 9,
                     box(
     #                  leafletOutput("neighbourhoodPlot", height = "700px"), width=NULL
                     ),
                     box(
                       actionButton("rerend", "ReRender map")
                     )
                )
              )
           ),
      tabItem(tabName = "dzdata",
              fluidRow(box(width = NULL,
                  div(class = "dzdatsels", selectInput("dzdataDomain", "Select Domain", unique(mtaDZ[mtaDZ$Domain != "Geographic Classifications", 3]), selected = NULL)),
                  div(class = "dzdatsels",uiOutput("dzdataSubDomUI")),
                  div(class = "dzdatsels",uiOutput("dzdataSubSubDomUI")),
                  div(class = "dzdatsels",uiOutput("dzdataIndicatorUI")),
                  div(class = "dzdatsels",uiOutput("dzdataYearUI"))
                )
              ),
              fluidRow(
                column(width = 3, box(title = "Select Local Authority",
                   div(class = "chckBx", checkboxGroupInput("datazoneLA2", label = NULL,
                                       unique(geoLk$laname), selected = unique(geoLk$laname)
                    )), width = NULL
                  )
                ),
                column(width = 7, box(
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