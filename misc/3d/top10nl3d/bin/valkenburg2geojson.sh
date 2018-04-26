#!/bin/bash
#
# Shortcut tool om meerdere 3D lagen uit het "Valkenburg" Top10NL3D proefbestand naar GeoJSON
# om te zetten.
#
# Gebruik: pak proefbestand in doel directory uit tot <doel directory>/Valkenburg.gdb.
# valkenburg2geojson.sh <doel directory>
#
# Auteur: Just van den Broecke - justb4@gmail.com
#
# Dit zijn de 3D lagen:
# 6: terreinpunten (3D Point)
# 7: wegdeelVlak_3D_LOD0 (3D Multi Polygon)
# 8: terreinVlak_3D_LOD0 (3D Multi Polygon)
# 9: gebouw_3D_LOD0 (3D Multi Polygon)
# 10: waterdeelVlak_3D_LOD0 (3D Multi Polygon)
# 11: gebouw_3D_LOD1 (3D Multi Polygon)
# 12: brugWater (3D Multi Polygon)
# 13: brugWeg (3D Multi Polygon)
# 14: TerreinOnder (3D Multi Polygon)

set -x  # debugging

bomb () {
	echo "FOUT: ${1}"
	exit 1
}

# Dit waarin proefbestand is uitgepakt tot $TOP10NL_3D_HOME_DEFAULT/Valkenburg.gdb.
TOP10NL_3D_HOME_DEFAULT=~/geodata/top10nl3d

# If we get a filename on the command line, use it instead of the default.
TOP10NL_3D_HOME="${1:-$TOP10NL_3D_HOME_DEFAULT}"
DEST_DIR_SANITY=`dirname "${TOP10NL_3D_HOME}"`

# Make sure the destination exists
[ -d "${DEST_DIR_SANITY}" ] || bomb "Directory ${DEST_DIR_SANITY} bestaat niet"

# Clean doel directories
GJ_HOME="${TOP10NL_3D_HOME}/geojson"
/bin/rm -rf ${GJ_HOME} > /dev/null
mkdir ${GJ_HOME}  > /dev/null
mkdir ${GJ_HOME}/rd  > /dev/null
mkdir ${GJ_HOME}/wgs84 > /dev/null
mkdir ${GJ_HOME}/3857 > /dev/null

# Voorlopig alleen de 3D lagen
DRIE_D_LAGEN="brugWater brugWeg terreinpunten wegdeelVlak_3D_LOD0 terreinVlak_3D_LOD0 gebouw_3D_LOD0 waterdeelVlak_3D_LOD0 gebouw_3D_LOD1 TerreinOnder"

for LAAG in $DRIE_D_LAGEN
do

   echo "Omzetten laag: $LAAG"

   # Naar GeoJSON in RD
   ogr2ogr -t_srs "EPSG:28992"  -f "GeoJSON" ${GJ_HOME}/rd/valkenburg-${LAAG}-rd.json ${TOP10NL_3D_HOME}/Valkenburg.gdb -sql "SELECT * FROM ${LAAG}"

   # Naar GeoJSON in WGS84
   ogr2ogr -s_srs "EPSG:28992" -t_srs "EPSG:4326"  -f "GeoJSON" ${GJ_HOME}/wgs84/valkenburg-${LAAG}-wgs84.json ${GJ_HOME}/rd/valkenburg-${LAAG}-rd.json

   # Naar GeoJSON in webmercator (EPSG:3857)
   ogr2ogr -s_srs "EPSG:4326" -t_srs "EPSG:3857"  -f "GeoJSON" ${GJ_HOME}/3857/valkenburg-${LAAG}-3857.json ${GJ_HOME}/wgs84/valkenburg-${LAAG}-wgs84.json
   
   # clipped/small fragments in area RD LL,UR: 186333 319820, 186630 320060 (about 300x200m)
   ogr2ogr -t_srs "EPSG:28992" -spat 186333 319820 186630 320060 -f "GeoJSON" ${GJ_HOME}/rd/valkenburg-${LAAG}-rd-s.json ${GJ_HOME}/rd/valkenburg-${LAAG}-rd.json
   ogr2ogr -s_srs "EPSG:28992" -t_srs "EPSG:4326"  -f "GeoJSON" ${GJ_HOME}/wgs84/valkenburg-${LAAG}-wgs84-s.json ${GJ_HOME}/rd/valkenburg-${LAAG}-rd-s.json
   ogr2ogr -s_srs "EPSG:4326" -t_srs "EPSG:3857"  -f "GeoJSON" ${GJ_HOME}/3857/valkenburg-${LAAG}-3857-s.json ${GJ_HOME}/wgs84/valkenburg-${LAAG}-wgs84-s.json

done
