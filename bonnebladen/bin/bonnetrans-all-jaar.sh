#!/bin/bash
#
# Converteer alle bonnefiles die in bonnefiels.txt staan naar GeoTiff
#
# Author: Just van den Broecke
#

# In de settings file per host, staat de locatie van de bron
# .png van de Bonnebladen
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT

while read fileName
do
  ./bonnetrans.sh $fileName  ${BONNE_DATA_YEAR_DIR}/1900
done < ${BONNE_DATA_YEAR_DIR}/1900/files.txt

while read fileName
do
  ./bonnetrans.sh $fileName  ${BONNE_DATA_YEAR_DIR}/1925
done < ${BONNE_DATA_YEAR_DIR}/1925/files.txt

while read fileName
do
  ./bonnetrans.sh $fileName  ${BONNE_DATA_YEAR_DIR}/1949
done < ${BONNE_DATA_YEAR_DIR}/1949/files.txt

