library(leaflet)
library(RColorBrewer)
library(mapview)
library(reshape2)
library(DT)
library(ggplot2)

##Read shapefiles
SpPolysDF <- readRDS("Shapes.rds")
SpPolysLA<- readRDS("LAPolys.rds")

#read and tidy indicator data
DZdta <- readRDS("clndzdata.rds")  
LAdta <- readRDS("clnladata.rds")
LAdta$value <- as.numeric(as.character(LAdta$value))

#read Geo Lookups and metadata
geoLk <- readRDS("geoLookup.rds")
mtaDZ <- readRDS("dzMeta.rds")