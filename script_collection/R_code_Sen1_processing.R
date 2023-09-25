#### Vorbereitung der Sentinel 1 Daten ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)

# Arbeitsort festlegen
setwd("...") # Hier Ergebniss Ordner einfügen

# Daten einladen
senstack_all <- rast("senstack_all.tiff")
pre_senstack <- rast("pre_senstack.tiff")

#zuschneiden auf das gesamte Gebiet
senstack_all <- crop(senstack_all, c(348790, 353212, 6030789, 6034432))
pre_senstack <- crop(pre_senstack, c(348790, 353212, 6030789, 6034432))

# Arbeitsort erneut festlegen
setwd("...") # Hier Preprocessed Radar Ordner einfügen

### Einladen der Radar Daten

# VH Layer einladen
VH <- rast("sen1_preprocessed_dataset_linear_VH.tif")
VH <- VH$sen1_preprocessed_dataset_linear_VH_1
names(VH) <- "VH"
VH <- crop(VH, senstack_all) # georeferenzieren auf senstack
ext(VH) <- ext(senstack_all) # Extend angleichen

# VV Layer einladen
VV <- rast("sen1_preprocessed_dataset_linear_VV.tif")
VV <- VV$sen1_preprocessed_dataset_linear_VV_1
names(VV) <- "VV"
VV <- crop(VV, senstack_all) # georeferenzieren auf senstack
ext(VV) <- ext(senstack_all) # Extend angleichen

# Ratio erstellen
ratio <- VH / VV
names(ratio) <- "ratio"
ratio <- replace(ratio, ratio %in% c(NA), 0) # NA Werte enfernen
ratio <- replace(ratio, ratio > 6, 6) # Max ratio bei 6 setzen

### Hinzufügen zu dem Gesamtstacks
pre_senstack$VH <- VH
pre_senstack$VV <- VV
pre_senstack$ratio <- ratio
senstack_all$VH <- VH
senstack_all$VV <- VV
senstack_all$ratio <- ratio

### Berechnung RVI (umgewandelt für Sen1)
RVI <- ((4 * VH) / (VV + VH)) / 4
plot(RVI)
RVI <- replace(RVI, RVI %in% c(NA), 0)
ext(RVI) <- ext(senstack_all)
pre_senstack$RVI <- RVI
senstack_all$RVI <- RVI

### Berechnung mRDFI ### 
mRDFI <- (VV - VH) / (VV + VH) 
plot(mRDFI)
mRDFI <- replace(mRDFI, mRDFI %in% c(NA), 0)
ext(mRDFI) <- ext(senstack_all)
pre_senstack$mRDFI <- mRDFI
senstack_all$mRDFI <- mRDFI


# zuschneiden auf die Barther Oie
senstack_all_oie <- crop(senstack_all, c(351785, 353256, 6030767, 6031902))
#zuschneiden aug die Kirr
senstack_all_kirr <- crop(senstack_all, c(349063, 352893, 6031961, 6034007))


# Daten ausschreiben
setwd("...") # Hier Ergebniss Ordner einfügen
writeRaster(pre_senstack, "pre_senstack_radar.tiff", overwrite=TRUE)
writeRaster(senstack_all, "senstack_all_radar_komplett.tiff", overwrite=TRUE)
writeRaster(senstack_all, "senstack_all_radar_kirr.tiff", overwrite=TRUE)
writeRaster(senstack_all, "senstack_all_radar_oie.tiff", overwrite=TRUE)
