#### Trainieren der Modelle ####

rm(list=ls()) # löscht alle Variablen aus dem Environment

# libraries einladen
library(terra)
library(CAST)

# Arbeitsort festlegen
setwd("...") # Hier Ergebniss Ordner einfügen

# Daten einladen
senStack <- rast("senstack_all.tiff")
senStack_radar <- rast("senstack_all_radar.tiff")
traindata <- readRDS("traindata_sen2.RDS")
traindata_radar <- readRDS("traindata_radar.RDS")

# Daten zuschneiden auf Barther Oie
senStack <- crop(senStack, c(351785, 353256, 6030767, 6031902))
senStack_radar <- crop(senStack_radar, c(351785, 353256, 6030767, 6031902))

# Teile der Daten vorbereiten, welche sonst zweimal erstellt werden müssten
predictors_sen2 <- c("B","Datt4","G","GDI","GDVI","GIPVI","GRVI","MSRr_m_5",
                     "MSRre","NDVI","NDVIre","NIR","R","RE1","RE2","RE3","RE4",
                     "RTVIcor","SR","SRre")
predictors_radar <- c("B","Datt4","G","GDI","GDVI","GIPVI","GRVI","MSRr_m_5",
                "MSRre","NDVI","NDVIre","NIR","R","RE1","RE2","RE3","RE4",
                "RTVIcor","SR","SRre", "VV", "VH", "ratio", "RVI", "mRDFI")
traindata <- traindata[complete.cases(traindata[,predictors_sen2]),] #Kein NA in Prädiktoren enthalten
traindata_radar <- traindata_radar[complete.cases(traindata_radar[,predictors_radar]),] #Kein NA in Prädiktoren enthalten
trainids_default <- CreateSpacetimeFolds(traindata,spacevar="ID",class="Ordnung",k=6)
trainids_ffs <- CreateSpacetimeFolds(traindata, spacevar="ID", class="Ordnung", k=3)
ctrl_default <- trainControl(method="cv",index=trainids_default$index, savePredictions="all")
ctrl_ffs <- trainControl(method="cv",index=trainids_ffs$index, savePredictions="all")

####################################
### Modelltrainig für Sentinel 2 ###
####################################

### Modelltrainig Default ###

model_sen2 <- train(traindata[,predictors_sen2],
                  traindata$Ordnung,
                  importance=TRUE,
                  method="rf",
                  metric="Kappa",
                  tuneGrid = data.frame("mtry"=c(2:20)),
                  ntree=200,
                  trControl=ctrl_default)
plot(model_sen2)
plot(varImp(model_sen2)) # variablenwichtigkeit
cM_sen2_default <- confusionMatrix(model_sen2,"none")


#### Modelltraining FFS ###

ffsmodel_sen2 <- ffs(traindata[,predictors_sen2],
                    traindata$Ordnung,
                    method="rf",
                    metric="Kappa",
                    ntree=100,
                    tuneGrid=data.frame("mtry"=c(2:25)),
                    trControl=ctrl_ffs)
plot(ffsmodel_sen2)
plot(varImp(ffsmodel_sen2)) # variablenwichtigkeit
cM_sen2_ffs <- confusionMatrix(ffsmodel_sen2,"none")


###############################
### Modelltrainig für Kombi ###
###############################

### Modelltrainig Default ####

model_kombi <- train(traindata_radar[,predictors_radar],
                  traindata_radar$Ordnung,
                  importance=TRUE,
                  method="rf",
                  metric="Kappa",
                  tuneGrid = data.frame("mtry"=c(2:20)),
                  ntree=200,
                  trControl=ctrl_default)
plot(model_kombi)
plot(varImp(model_kombi)) # variablenwichtigkeit
cM_kombi_default <- confusionMatrix(model_kombi,"none")


#### Modelltraining FFS ####

ffsmodel_kombi <- ffs(traindata_radar[,predictors_radar],
                    traindata_radar$Ordnung,
                    method="rf",
                    metric="Kappa",
                    ntree=100,
                    tuneGrid=data.frame("mtry"=c(2:25)),
                    trControl=ctrl_ffs)
plot(ffsmodel_kombi) # see tuning results
plot(varImp(ffsmodel_kombi)) # variablenwichtigkeit
cM_kombi_ffs <- confusionMatrix(ffsmodel_kombi,"none")


# Modelle speichern
saveRDS(model_sen2,file="Default_Sen2_final.RDS") 
saveRDS(ffsmodel_sen2,file="FFS_Sen2_final.RDS") 
saveRDS(model_kombi,file="Default_Kombi_final.RDS")
saveRDS(ffsmodel_kombi,file="FFS_Kombi_final.RDS") 
