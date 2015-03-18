#!/bin/bash
#
# Zet files geldig in jaar samen in dir.
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
# /bin/rm -rf $targetDir  > /dev/null 2>&1
mkdir -p $targetDir > /dev/null 2>&1
/bin/rm -f ${targetDir}/*.tif > /dev/null 2>&1
/bin/rm -f ${targetFile} > /dev/null 2>&1

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
            echo "${fileName}" >> ${targetFile}
            # ln -s $filePath $targetDir/$fileName
            # cp $filePath $targetDir/$fileName
            break
        fi

        yearFit=$(( $yearFit - 1 ))
   done

done < ${DATA_DIR}/bonnefiles-numbers.txt

