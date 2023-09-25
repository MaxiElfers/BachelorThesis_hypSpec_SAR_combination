#### Erstellen der Trainingsdaten ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)
library(sf)

# Arbeitsort festlegen
setwd("D:/Bachelorarbeit Maxi/R processing data")

# Daten einladen
pre_senstack <- rast("pre_senstack.tiff")
pre_senstack_radar <- rast("pre_senstack_radar.tiff")

# Arbeitsort neu festlegen
setwd("D:/Bachelorarbeit Maxi/Daten_Jan_Hoping/Maximilian_centroid_Traindata")

referenzOie <- read_sf("Sentinel2_traindata_centroid_for_Maximilian.gpkg")
referenzOie_utm <- st_transform(referenzOie, crs(pre_senstack))

# Arbeitsort neu festlegen
setwd("D:/Bachelorarbeit Maxi/R processing data")

# Sentinel 2 Trainingsdaten ausschreiben
saveRDS(referenzOie_utm, file= "traindata_sen2.RDS")

referenzOie_utm[ , c('G', 'B','R', 'NIR', 'RE1', 'RE2',
                     'RE3', 'RE4', 'ID', 'NDVI', 'GDVI', 'GNDVI', 'GRVI',
                     'GIPVI', 'SR', 'GDI', 'GRDI', 'NDVIre', 'SRre', 'RTVIcor',
                     'MSRre', 'Datt4', 'MSRr_m_5')] <- list(NULL)

extr <- extract(pre_senstack_radar, referenzOie_utm) 
referenzOie_utm$PointID <- 1:nrow(referenzOie_utm)
extr <- merge(extr, referenzOie_utm,by.x="ID",by.y="PointID")

# Kombinierte Trainingsdaten ausschreiben
saveRDS(extr, file="traindata_radar.RDS")
