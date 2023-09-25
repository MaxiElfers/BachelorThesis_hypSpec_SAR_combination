#### Preprocessing der Sentinel 2 Daten (von Jan Hoping) ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)

# Arbeitsort festlegen
setwd("D:/Bachelorarbeit Maxi/Daten_Jan_Hoping/S2A_MSIL2A_20210618T103021_N0300_R108_T33UUA_20210618T133547.SAFE/GRANULE/L2A_T33UUA_A031279_20210618T103022/IMG_DATA")

# Alle Sentinel Kanäle einladen (10m und 20m Auflösung)  

senstack_10 <- rast(c("R10m/T33UUA_20210618T103021_B02_10m.jp2",
                      "R10m/T33UUA_20210618T103021_B03_10m.jp2",
                      "R10m/T33UUA_20210618T103021_B04_10m.jp2",
                      "R10m/T33UUA_20210618T103021_B08_10m.jp2"))
senstack_20 <- rast(c("R20m/T33UUA_20210618T103021_B05_20m.jp2",
                      "R20m/T33UUA_20210618T103021_B06_20m.jp2",
                      "R20m/T33UUA_20210618T103021_B07_20m.jp2",
                      "R20m/T33UUA_20210618T103021_B11_20m.jp2",
                      "R20m/T33UUA_20210618T103021_B12_20m.jp2",
                      "R20m/T33UUA_20210618T103021_B8A_20m.jp2"))

senstack_10_crop <- crop(senstack_10, c(348790, 353212, 6030789, 6034432)) # zuschneiden auf Zielgebiet
senstack_20_crop <- crop(senstack_20, c(348790, 353212, 6030789, 6034432)) # zuschneiden auf Zielgebiet
senstack_20_res <- resample(senstack_20_crop,senstack_10_crop) # resample to 10 meters
pre_senstack <- rast(list(senstack_10_crop,senstack_20_res))

names(pre_senstack) <- substr(names(pre_senstack),
                              nchar(names(pre_senstack))-6, # von der 6-letzten Stelle...
                              nchar(names(pre_senstack))-4) #bis zur 4-letzten

# Umbennenen der Kanäle, sodass diese zu den Trainingsdaten passen
names(pre_senstack)[1] <- "B"
names(pre_senstack)[2] <- "G"
names(pre_senstack)[3] <- "R"
names(pre_senstack)[4] <- "NIR"
names(pre_senstack)[5] <- "RE1"
names(pre_senstack)[6] <- "RE2"
names(pre_senstack)[7] <- "RE3"
names(pre_senstack)[8] <- "SWIR1"
names(pre_senstack)[9] <- "SWIR2"
names(pre_senstack)[10] <- "RE4"


# Preprocessed Sentinel 2 Daten ausschreiben
setwd("D:/Bachelorarbeit Maxi/R processing data")
writeRaster(pre_senstack, "pre_senstack.tiff", overwrite=TRUE)