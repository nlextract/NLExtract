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
done < ${DATA_DIR}/1900-files.txt

echo "Maak index.shp aan met gdaltindex in ${BONNE_DATA_YEAR_DIR}/1900"
pushd ${BONNE_DATA_YEAR_DIR}/1900
/bin/rm -f index.*
gdaltindex index.shp *.tif
popd

while read fileName
do
  ./bonnetrans.sh $fileName  ${BONNE_DATA_YEAR_DIR}/1925
done < ${DATA_DIR}/1925-files.txt

echo "Maak index.shp aan met gdaltindex in ${BONNE_DATA_YEAR_DIR}/1925"
pushd ${BONNE_DATA_YEAR_DIR}/1925
/bin/rm -f index.*
gdaltindex index.shp *.tif
popd

while read fileName
do
  ./bonnetrans.sh $fileName  ${BONNE_DATA_YEAR_DIR}/1949
done < ${DATA_DIR}/1949-files.txt

echo "Maak index.shp aan met gdaltindex in ${BONNE_DATA_YEAR_DIR}/1949"
pushd ${BONNE_DATA_YEAR_DIR}/1949
/bin/rm -f index.*
gdaltindex index.shp *.tif
popd
