library(readr)
library(dplyr)

#read the original excel sheet and convert to RDS
system.time(dta <- read_csv("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Data Zones/dzdata.csv"))
#remove NA rows based on datazone column
dta2 <- dta[complete.cases(dta$datazone),]
#save as RDS
saveRDS(dta2, file = "Q:/WRDashboard/dzdata.rds")

#Read the Local Authority sheet and convert to RDS
dtaLA <- read_csv("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Local Authority/ladata.csv")
dtaLA <- dtaLA[complete.cases(dtaLA$`Local Authority`),]
#save as RDS
saveRDS(dtaLA, "Q:/WRDashboard/ladata.rds")

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

##Datazone shapes were sourced from CPOP maps
