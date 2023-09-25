#### Processing der Sentinel 2 Daten (von Jan Hoping) ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)

# Arbeitsort festlegen
setwd("D:/Bachelorarbeit Maxi/R processing data")

# Daten einladen
senstack_all <- rast("pre_senstack.tiff")

# Hinzufügen der hyperspektralen Indizes
senstack_all$NDVI <- (senstack_all$NIR - senstack_all$R)/(senstack_all$NIR + senstack_all$R)
#plot(NDVI)
senstack_all$GDVI <- senstack_all$NIR - senstack_all$G
#plot(GDVI)
senstack_all$GNDVI <- (senstack_all$NIR - senstack_all$G) / (senstack_all$NIR + senstack_all$G)
#plot(GNDVI)
senstack_all$GRVI <- senstack_all$NIR / senstack_all$G
#plot(GRVI)
senstack_all$GIPVI <- senstack_all$NIR / (senstack_all$NIR + senstack_all$G)
#plot(GIPVI)
senstack_all$SR <- senstack_all$NIR / senstack_all$R
#plot(SR) 
senstack_all$GDI <- senstack_all$NIR - senstack_all$R - senstack_all$G
#plot(GDI)
senstack_all$GRDI <- (senstack_all$G - senstack_all$R) / (senstack_all$G + senstack_all$R)
#plot(GRDI)
senstack_all$NDVIre <- (senstack_all$NIR - senstack_all$R) / (senstack_all$G + senstack_all$RE1)
#plot(NDVIre)
senstack_all$SRre <- senstack_all$NIR / senstack_all$RE1
#plot(SRre)
senstack_all$RTVIcor <- 100 * (senstack_all$NIR - senstack_all$RE1) - 10 * (senstack_all$NIR - senstack_all$G)
#plot(RTVIcor)
senstack_all$MSRre <- (senstack_all$NIR / (senstack_all$RE1 - 1)) / sqrt((senstack_all$NIR / (senstack_all$RE1 + 1)))
#plot(MSRre)
senstack_all$Datt4 <- (senstack_all$R / senstack_all$G) * senstack_all$RE1
#plot(Datt4)
senstack_all$MSRr_m_5 <- focal(MSRre,w=matrix(1/25,5,5),fun=mean)
#plot(MSRr_m_5)

# Processed Sentinel 2 Daten ausschreiben
setwd("I:/Bachelorarbeit Maxi/R processing data")
writeRaster(senstack_all, "senstack_all.tiff", overwrite=TRUE)
