#!/bin/bash
#
# Zet files voor tijdsperiode bij elkaar in directory.
#
# Author: Just van den Broecke
#

# In de settings file per host, staat de locatie van de bron
# .png van de Bonnebladen
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT
SETTINGS_SCRIPT="settings-`hostname`.sh"
. $SETTINGS_SCRIPT


yearStart=$1
yearEnd=$2
targetDir=${BONNE_DATA_PERIOD_DIR}/${yearStart}-${yearEnd}
/bin/rm -rf $targetDir  > /dev/null 2>&1
mkdir ${BONNE_DATA_PERIOD_DIR} > /dev/null 2>&1
mkdir $targetDir

while read line
do
 #   echo "$line"

    yearEnd=$2
    while [ $yearEnd -ge $yearStart ]
    do
        # echo "$line : $yearEnd"

        fileName=${line}-${yearEnd}.tif
        filePath=${BONNE_DATA_DST_DIR}/$fileName
        if [ -e $filePath ]
        then
            echo "OK linking $fileName"
            # ln -s $filePath $targetDir/$fileName
            cp $filePath $targetDir/$fileName
            break
        fi

        yearEnd=$(( $yearEnd - 1 ))
   done

done <bonnefiles-numbers.txt

