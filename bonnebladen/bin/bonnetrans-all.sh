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

/bin/rm -rf ${BONNE_DATA_DST_DIR}
mkdir ${BONNE_DATA_DST_DIR}

while read fileName
do
  ./bonnetrans.sh $fileName

done <bonnefiles.txt

