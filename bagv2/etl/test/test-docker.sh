#!/bin/bash
#
# Test LVBAG driver with latest GDAL Docker Image
#

# Check driver avail
# docker run --rm -v $(pwd):/work -it osgeo/gdal:alpine-small-latest sh -c "ogrinfo --formats"  | grep LVBAG

rm -rf $(pwd)/out > /dev/null 2>&1
mkdir $(pwd)/out

OBJS="LIG NUM OPR PND STA VBO WPL"
for OBJ in ${OBJS}
do
  CMD="ogr2ogr -overwrite -oo AUTOCORRECT_INVALID_DATA=YES -oo LEGACY_ID=YES -s_srs EPSG:28992 -t_srs EPSG:4326 -f GeoJSON /work/out/${OBJ}\.json /work/data/lv/BAGNLDL-15092020-small-expand/0221${OBJ}15092020-000001.xml"
  echo "run: ${CMD}"
  docker run --rm -v $(pwd):/work -it osgeo/gdal:alpine-small-latest sh -c "${CMD}"
done
