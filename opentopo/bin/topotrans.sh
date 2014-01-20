#!/bin/bash
#
# Transformeer en bewerk OpenTopo JPEGs naar GeoTiffs.
#
# Auteur: Just van den Broecke

# NB World files moeten wel in de bron dir staan!!

#
# $1 bron directory
# $2 doel directory
src_dir=$1
dst_dir=$2

for src_tif in `ls -1 $src_dir/*.tif`
do
    # Doel tif moet in bron dir aangemaakt aanvakelijk, anders foutmelding
    dst_tif=$src_dir/p`basename $src_tif|cut -d'.' -f1`.tif
    echo $src_tif to $dst_tif

    echo "START  CONVERT $src_tif"
    # Builds a VRT. A VRT is basically just a XML file saying what all the source tif files are.
    # gdalbuildvrt -srcnodata 255 -vrtnodata 255 -a_srs EPSG:28992 -input_file_list tiff_list.txt %THIS_DIR%.vrt

    # Maak GeoTIFF van TIFF met juiste georeferentie uit CSV, en internal tiling
    echo "gdal_translate"
    #  This is what actually does the mosaicing.
    # gdal_translate -of GTiff -co TILED=YES -co BIGTIFF=YES -co COMPRESS=JPEG -co JPEG_QUALITY=80
    #    -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -co PHOTOMETRIC=YCBCR %THIS_DIR%.vrt %THIS_DIR%.tif

    # OUD: Tiff (wordt 427MB per file!)
    # gdal_translate -of GTiff -co TILED=YES -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -a_srs EPSG:28992  $src_tif $dst_tif

    # NIEUW met JPEG compressie en alleen 1e 3 banden meenemen....
    gdal_translate -b 1 -b 2 -b 3 -of GTiff -co TILED=YES -co COMPRESS=JPEG -co JPEG_QUALITY=90 -co alpha=yes -co PHOTOMETRIC=RGB -co BLOCKXSIZE=512 -co BLOCKYSIZE=512 -a_srs EPSG:28992  $src_tif $dst_tif

    # Maak overview (pyramid)
    echo "Maak overview met gdaladdo"
    # number of pyramids = log(pixelsize of image) / log(2) - log (pixelsize of tile) / log(2).
    # Plaatje is typisch 10000x8000 neem grootste
    # log(10000) / log(2) - log (512) / log(2) = 4.28 = ~5
    #
    #  Now creating pyramids.
    #    gdaladdo %THIS_DIR%.tif -r average --config COMPRESS_OVERVIEW JPEG
    #    --config JPEG_QUALITY_OVERVIEW 60 --config INTERLEAVE_OVERVIEW PIXEL
    #      --config PHOTOMETRIC_OVERVIEW YCBCR 2 4 8 16 32 64 128 256 512
    gdaladdo -r average $dst_tif  2 4 8 16 32

    # Verplaats doel tif naar doel-dir
    mv $dst_tif $dst_dir
    echo "END CONVERT $src_tif"

done
