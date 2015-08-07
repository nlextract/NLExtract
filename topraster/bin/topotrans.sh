#!/bin/bash
#
# Transformeer en bewerk TopRaster Tiffs naar geoptimaliseerde GeoTiffs.
#
# Voorbeeld: bron Tiffs en world files in directory 'src', lege directory 'dst'
#
# Auteur: Just van den Broecke


#
# $1 bron directory
# $2 doel directory
src_dir=$1
dst_dir=$2

for src_tif in `ls -1 $src_dir/*.tif`
do
    # Doel file
    dst_tif=$dst_dir/`basename $src_tif|cut -d'.' -f1`.tif

    echo "START  CONVERT $src_tif to $dst_tif"

    # Maak GeoTIFF van TIFF met juiste georeferentie, en internal tiling
    echo "gdal_translate"

    gdal_translate  -of GTiff -co TILED=YES -co PROFILE=Geotiff \
            -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -a_srs EPSG:28992  $src_tif $dst_tif

    # Maak overview (pyramid)
    echo "Maak overview met gdaladdo"
    # number of pyramids = log(pixelsize of image) / log(2) - log (pixelsize of tile) / log(2).
    # Plaatje is typisch 10000x8000 neem grootste
    # log(10000) / log(2) - log (512) / log(2) = 4.28 = ~5
    # 
    gdaladdo -r gauss --config INTERLEAVE_OVERVIEW PIXEL $dst_tif  2 4 8 16 32
    
    echo "END CONVERT $src_tif"

done

echo "Maak index.shp aan met gdaltindex in $dst_dir"
pushd $dst_dir
gdaltindex index.shp *.tif
popd
