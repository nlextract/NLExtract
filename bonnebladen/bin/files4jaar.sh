#!/bin/bash
#
# Zet files geldig in jaar samen in dir.
#
# Author: Just van den Broecke
#

# In de settings file per host, staat de locatie van de bron
# .png van de Bonnebladen
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT

year=$1
oldestYear=1820

sourceDir=${BONNE_DATA_SRC_DIR}
targetDir=${BONNE_DATA_YEAR_DIR}/${year}
fileExt="png"
/bin/rm -rf $targetDir  > /dev/null 2>&1
mkdir -p $targetDir

while read line
do
    # echo "$line"

    yearFit=$year
    while [ $yearFit -ge 1820 ]
    do
        # echo "$line : $yearFit"

        fileName=${line}-${yearFit}.${fileExt}
        filePath=${sourceDir}/${fileName}
        # echo "TEST  yearFit=$yearFit fileName=$fileName year=$year $filePath"
        if [ -e $filePath ]
        then
            echo "OK  $fileName for year: $year"
            ln -s $filePath $targetDir/$fileName
            # cp $filePath $targetDir/$fileName
            break
        fi

        yearFit=$(( $yearFit - 1 ))
   done

done <../data/bonnefiles-numbers.txt

