#!/bin/bash
#
# Zet bonne-filenamen die geldig in jaar zijn samen in file.
#
# Author: Just van den Broecke
#
# Bepaal onze home/bin dir
HOME_DIR=`dirname $0`/..
HOME_DIR=`(cd "$HOME_DIR"; pwd)`
BIN_DIR=${HOME_DIR}/bin
DATA_DIR=${HOME_DIR}/data

# In de settings file per host, staat de locatie van de bron
# .png van de Bonnebladen
SETTINGS_SCRIPT="${BIN_DIR}/settings.sh"
. $SETTINGS_SCRIPT

year=$1
oldestYear=1820

sourceDir=${BONNE_DATA_SRC_DIR}
targetDir=${BONNE_DATA_YEAR_DIR}/${year}
targetFile=${targetDir}/files.txt
fileExt="png"
mkdir -p $targetDir > /dev/null 2>&1
/bin/rm -f ${targetDir}/*.tif > /dev/null 2>&1
/bin/rm -f ${targetFile} > /dev/null 2>&1

while read line
do
    # echo "$line"

    yearFit=$year
    while [ $yearFit -ge 1820 ]
    do
        fileName=${line}-${yearFit}.${fileExt}
        filePath=${sourceDir}/${fileName}

        if [ -e $filePath ]
        then
            echo "OK  $fileName for year: $year"
            echo "${fileName}" >> ${targetFile}
            break
        fi

        yearFit=$(( $yearFit - 1 ))
   done

done < ${DATA_DIR}/bonnefiles-numbers.txt

