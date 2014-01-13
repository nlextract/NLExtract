#!/bin/bash
#
# Transformeer en bewerk OpenTopo JPEGs naar GeoTiffs.
#
# Auteur: Just van den Broecke

# NB World files moeten wel in de bron dir staan!!


# Converteer enkele JPEG
# $1 bron file
# $2 doel file
function createGeoTiff() {
    # Bestandsnamen
    src_jpg=$1
    dst_tif=$2
    echo "START  CONVERT $src_jpg"
    # Maak GeoTIFF van TIFF met juiste georeferentie uit CSV, en internal tiling
    echo "gdal_translate"
    gdal_translate -of GTiff -co TILED=YES -a_srs EPSG:28992  $src_jpg $dst_tif
    # Maak overview (pyramid)
    echo "Maak overview met gdaladdo"
    gdaladdo -r average $dst_tif  2 4 8 16 32 64 128

    echo "END CONVERT $src_jpg"
}

#
# $1 bron directory
# $2 doel directory
src_dir=$1
dst_dir=$2
for src_file in `ls -1 $src_dir/*.jpg`
do
    dst_file=$dst_dir/`basename $src_file|cut -d'.' -f1`.tif
    echo $src_file to $dst_file
    createGeoTiff $src_file $dst_file
done








