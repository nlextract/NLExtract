#!/bin/bash
#
# Transformeer en bewerk AHN Tiffs naar geoptimaliseerde GeoTiffs.
#
# Voorbeeld: bron Tiffs en world files in directory 'src', lege directory 'dst'
#
# ahntrans.sh <src dir> <dst dir>
#
# Auteur: Just van den Broecke


#
# $1 bron directory
# $2 doel directory
src_dir=$1
dst_dir=$2

for src_tif in `ls -1 $src_dir/*.tif`
do
    # Doel file op basis filenaam bron file
    dst_tif=$dst_dir/`basename $src_tif|cut -d'.' -f1`.tif

    echo "START  CONVERT $src_tif to $dst_tif"

    # Maak GeoTIFF van TIFF met juiste georeferentie  en internal tiling
    echo "gdal_translate"

    # NIEUW met JPEG compressie en alleen 1e  band meenemen....
    # Refs: http://words.mixedbredie.net/archives/2024
    gdal_translate -b 1 -of GTiff -co TILED=YES -co PROFILE=Geotiff -co COMPRESS=JPEG -co JPEG_QUALITY=95 \
             -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -a_srs EPSG:28992  $src_tif $dst_tif

    # Maak overview (pyramid)
    echo "Maak overview met gdaladdo"
    gdaladdo -r gauss --config COMPRESS_OVERVIEW JPEG --config PHOTOMETRIC_OVERVIEW YCBCR --config JPEG_QUALITY_OVERVIEW 90 --config INTERLEAVE_OVERVIEW PIXEL $dst_tif  2 4 8 16 32
    
    echo "END CONVERT $src_tif"

done

# Hiermee direct serveren met bijv MapServer
echo "Maak index.shp aan met gdaltindex in $dst_dir"
pushd $dst_dir
gdaltindex index.shp *.tif
popd
