#### Vorhersagen mit den erstellten Modellen ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)
library(caret)

# Arbeitsort festlegen
setwd("...") # Hier Ergebniss Ordner einfügen

# Daten einladen
senstack <- rast("senstack_all.tiff")
senstack_radar_kirr <- rast("senstack_all_radar_kirr.tiff")
senstack_radar_oie <- rast("senstack_all_radar_oie.tiff")
model_def_sen2 <- readRDS("Default_Sen2_final.RDS")
model_ffs_sen2 <- readRDS("FFS_Sen2_final.RDS")
model_def_komb <- readRDS("Default_Kombi_final.RDS")
model_ffs_komb <- readRDS("FFS_Kombi_final.RDS")

# Sentinel 2 Zuschnitt Barther Oie
senstack_oie <- crop(sentinel, c(351785, 353256, 6030767, 6031902))
# Sentinel 2 Zuschnitt Kirr
#senstack_kirr <- crop(sentinel, c(349063, 352893, 6031961, 6034007))

# Klassifikation Default Sentinel 2
prediction_def_sen2 <- predict(as(senstack_oie,"Raster"),model_def_sen2)
prediction_terra_def_sen2 <- as(prediction_def_sen2,"SpatRaster")

# Klassifikation FFS Sentinel 2
prediction_ffs_sen2 <- predict(as(senstack_oie,"Raster"),model_ffs_sen2)
prediction_terra_ffs_sen2 <- as(prediction_ffs_sen2,"SpatRaster")

# Klassifikation Default Kombination
prediction_def_komb <- predict(as(senstack_radar_oie,"Raster"),model_def_komb)
prediction_terra_def_komb <- as(prediction_def_komb,"SpatRaster")

# Klassifikation Default Kombination
prediction_ffs_komb <- predict(as(senstack_radar_oie,"Raster"),model_ffs_komb)
prediction_terra_ffs_komb <- as(prediction_ffs_komb,"SpatRaster")

# Farben für die Klassifikationen
colors <- c( "beige","chartreuse4","darkseagreen","lightgreen","brown","coral",
             "burlywood3", "darkolivegreen3", "lightblue")

# Klassifikationen visualisieren
plot(prediction_terra_def_sen2, col = colors)
plot(prediction_terra_ffs_sen2, col = colors)
plot(prediction_terra_def_komb, col = colors)
plot(prediction_terra_ffs_komb, col = colors)

# AOA berechnen für das FFS Kombinationes Modell
aoa <- aoa(senstack_radar_kirr, model_ffs_komb)

# AOA Werte plotten
plot(aoa$DI)
plot(aoa$AOA)

# AOA in verbindung mit den Vorhersagen plotten
predi_kirr <- predict(as(senstack_radar_kirr,"Raster"),model_ffs_komb)
predi_terra_kirr <- as(predi_kirr,"SpatRaster")

plot(predi_terra_kirr, col=colors)
plot(aoa$AOA,col=c("black","transparent"),add=T)
