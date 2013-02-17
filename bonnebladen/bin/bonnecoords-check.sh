#!/bin/bash
#
# Check bonne coordinaten in .csv
#
# Author: Just van den Broecke
#

SETTINGS_SCRIPT="settings-`hostname`.sh"
. $SETTINGS_SCRIPT


while read line
do
    echo "START CHECKING $line"

    bladnr=`echo $line | cut -d' ' -f1`
    nwx=`echo $line | cut -d' ' -f2`
    nwy=`echo $line | cut -d' ' -f3`
    nex=`echo $line | cut -d' ' -f4`
    ney=`echo $line | cut -d' ' -f5`
    swx=`echo $line | cut -d' ' -f6`
    swy=`echo $line | cut -d' ' -f7`
    sex=`echo $line | cut -d' ' -f8`
    sey=`echo $line | cut -d' ' -f9`

    # check if empty
    if [ -z "$swx" ] || [ -z "$nwy" ] || [ -z "$nex" ] || [ -z "$sey" ]
    then
        echo "ERROR $srcname : coords EMPTY"
    fi

    nw="$swx $nwy"
    se="$nex $sey"

   # check x distance
    nexint=`echo $nex | cut -d'.' -f1`
    swxint=`echo $swx | cut -d'.' -f1`
    deltaX=$(( $nexint - $swxint ))
    if [ $deltaX -gt 50000 ]
    then
        echo "ERROR deltaX = $deltaX "
    fi

    # check y distance
    nwyint=`echo $nwy | cut -d'.' -f1`
    seyint=`echo $sey | cut -d'.' -f1`
    deltaY=$(( $nwyint - $seyint ))
    if [ $deltaY -gt 50000 ]
    then
        echo "ERROR deltaY = $deltaY "
    fi


   echo "END CHECKING $line"

done <bonnecoords.csv

