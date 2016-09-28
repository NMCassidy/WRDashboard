library(leaflet)
library(RColorBrewer)
library(mapview)
library(reshape2)
##Read shapefiles
SpPolysDF <- readRDS("Shapes.rds")
SpPolysLA<- readRDS("LAPolys.rds")

#read and tidy indicator data
DBdta <- readRDS("dzdata.rds")
DBdtaMlt <- melt(DBdta, id.vars = "datazone")
DBdtaMlt[c(4,5)] <- colsplit(DBdtaMlt$variable, "_", c("Indicator", "Date"))
