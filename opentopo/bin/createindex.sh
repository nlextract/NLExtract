#!/bin/bash
#
# Maak index op dir GeoTiffs.
#
# Auteur: Just van den Broecke


#
# $1 doel directory
dst_dir=$1

echo "Maak index.shp aan met gdaltindex in $dst_dir"
pushd $dst_dir
gdaltindex index.shp *.tif
popd
