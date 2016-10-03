library(leaflet)
library(RColorBrewer)
library(mapview)
library(reshape2)
library(DT)

##Read shapefiles
SpPolysDF <- readRDS("Shapes.rds")
SpPolysLA<- readRDS("LAPolys.rds")

#read and tidy indicator data
DZdta <- readRDS("clndzdata.rds")  
LAdta <- readRDS("clnladata.rds")

#read Geo Lookups and metadata
geoLk <- readRDS("geoLookup.rds")
mtaDZ <- readRDS("dzMeta.rds")