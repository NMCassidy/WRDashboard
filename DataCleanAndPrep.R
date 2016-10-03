##Data cleaning and transformations
#Load packages
library(tidyverse)
library(reshape2)
library(readxl)
#Datazone data
#The Data sourcing file will read the data and convert it to RDS
dzdta <- readRDS("dzdata.rds")  

#Melt and split column
dtaMlt <- melt(dzdta, id.vars = "datazone")
dtaMlt[c(4,5)] <- colsplit(dtaMlt$variable, "_", c("Indicator", "Date"))
dtaMlt <- dtaMlt[,-2]
##Read other information
#Geography lookup
geoLk <- read_excel("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Geographies/geographies.xlsx")
##metadata
dzmta <- read_csv("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Data Zones/metadata.csv")
dzmta <- dzmta[complete.cases(dzmta$`Variable name`),]
##merge it all together
#dtaMlt <- left_join(dtaMlt, dzmta, by = c("Indicator" = "Variable name"))
#dtaMlt <- left_join(dtaMlt, geoLk, by = c("datazone" = "datazone"))
#dtaMlt <- dtaMlt[,-14]
#save to rds
saveRDS(dtaMlt, "Q:/WRDashboard/clndzdata.rds")
saveRDS(geoLk, "Q:/WRDashboard/geoLookup.rds")
saveRDS(dzmta, "Q:/WRDashboard/dzMeta.rds")
##Local Authority Data
ladta <- readRDS("ladata.rds")

#melt and split column
ladtaMlt <- melt(ladta, id.vars = "Local Authority")
ladtaMlt[c(4,5)] <- colsplit(ladtaMlt$variable, "_", c("Indicator", "Date"))

##read other information
#metadata
lamta <- read_csv("S:/G - Governance & Performance Mngmt/Programmes/Welfare Reform/All Data and Dashboard Files/Master Data Files/Local Authority/metadata.csv")
lamta <- lamta[complete.cases(lamta$`Variable name`),]
#merge together
ladtaMlt <- left_join(ladtaMlt, lamta, by = c("Indicator" = "Variable name"))
saveRDS(ladtaMlt,"Q:/WRDashboard/clnladata.rds" )