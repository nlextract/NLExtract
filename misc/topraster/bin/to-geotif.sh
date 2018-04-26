#!/bin/bash
# JvdB shorthands
#
trans=./topotrans.sh
sets="top25/2015-R06 top50/2015-R06 top250/2011-R00"

for raster in ${sets}
do
   echo "START ${raster}"
   /bin/rm -rf ${raster}/geotif/*
   $trans ${raster}/tif ${raster}/geotif > ${raster}/geotif/trans.log 2>&1
   echo "END ${raster}"
done


