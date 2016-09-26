library(readr)
library(dplyr)
system.time(dta <- read_csv("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Data Zones/dzdata.csv"))

#remove NA rows based on datazone column
dta2 <- dta[complete.cases(dta$datazone),]

#save as RDS
saveRDS(dta2, file = "Q:/WRDashboard/dzdata.rds")

system.time(dta2 <- readRDS("Q:/WRDashboard/dzdata.rds"))

##Council shapefiles are available at: https://www.ordnancesurvey.co.uk/business-and-government/products/boundary-line.html
library(rgdal)
shpfl_path <- file.path("S:", "G - Governance & Performance Mngmt", "Research Team", "Generic R Tools", "objects", "Shapefiles")
SpPolysLA <- readOGR(dsn = shpfl_path, layer = "councils")
#Transform
proj4string(SpPolysLA)
SpPolysLA <- spTransform(SpPolysLA, CRS("+proj=longlat +datum=WGS84"))
SpPolysLA@data$NAME <- as.character(SpPolysLA@data$NAME)
SpPolysLA@data$CODE <- as.character(SpPolysLA@data$CODE)
SpPolysLA <- SpPolysLA[order(SpPolysLA@data$NAME),]
#save RDS
saveRDS(SpPolysLA, "Q:/WRDashboard/LAPolys.rds")
