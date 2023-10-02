# Bachelor Thesis by Maximilian Elfers

This Git repository contains the data and scripts used in the bachelor thesis "Kombination von Sentinel 1 und Sentinel 2 Daten zur 
Klassifikation kleinräumiger Salzmarsch Gebieten anhand des Beispiels der Barther Oie" by Maximilian Elfers. 

To recreate the workflow from the thesis work through the scripts in the following order: 
1. R_code_Sen2_preprocessing
2. R_code_Sen2_processing
3. R_code_Sen1_processing
4. R_code_traindata
5. R_code_model_training
6. R_code_prediction

In the scripts the working directories are missing. There you need to add the link to the directory that is used.
To simply use the scripts you should have a folder structure containing of four folders.
1. Where the Sentinel 2 raw data is stored
2. Where the Sentinel 1 preprocessed data is stored
3. Where the trainigdata is stored
4. Where the output or results of the workflow are stored

Also in this repository you are able to find some of the data and all of the results of the thesis.
