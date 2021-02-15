#!/bin/bash
#
# Test LVBAG driver with latest GDAL Docker Image
#
# Just van den Broecke
#
# Check driver avail
# docker run --rm -v $(pwd):/work -it osgeo/gdal:alpine-small-latest sh -c "ogrinfo --formats"  | grep LVBAG

rm -rf $(pwd)/out > /dev/null 2>&1
mkdir $(pwd)/out

DOCKER_IMAGE="osgeo/gdal:alpine-small-latest"
OBJS="LIG NUM OPR PND STA VBO WPL"
NOT="-fieldTypeToString StringList"

OGR_OPTS="-overwrite -oo AUTOCORRECT_INVALID_DATA=YES -oo LEGACY_ID=YES -s_srs EPSG:28992 -t_srs EPSG:4326"

# NB we use host.docker.internal to connect from within Docker Container to localhost PostGIS!
PG="'PG:dbname=bagv2 active_schema=doesburg host=host.docker.internal user=postgres password=postgres'"

# Doesburg Small
# https://extracten.bag.kadaster.nl/lvbag/extracten/Gemeente%20LVC/0221/BAGGEM0221L-15022021.zip
for OBJ in ${OBJS}
do
  DATA_FILE="/work/data/lv/BAGNLDL-15092020-small-expand/0221${OBJ}15092020-000001.xml"
  JSON_OPTS="-f GeoJSON /work/out/${OBJ}\.json"

  # To GeoJSON
  CMD="ogr2ogr ${OGR_OPTS} ${JSON_OPTS} ${DATA_FILE}"
  echo "run: ${CMD}"
  docker run --rm -v $(pwd):/work -it ${DOCKER_IMAGE} sh -c "${CMD}"

  # To PostGIS
#   CMD="ogr2ogr ${OGR_OPTS} ${PG} ${DATA_FILE}"
#   echo "run: ${CMD}"
#   docker run --rm -v $(pwd):/work -it ${DOCKER_IMAGE} sh -c "${CMD}"
done

# Doesburg Entire
BAG_URL="https://extracten.bag.kadaster.nl/lvbag/extracten"
DATE="15022021"
GEM_CODE="0221"
BAG_ZIP="BAGGEM${GEM_CODE}L-${DATE}.zip"
BAG_ZIP_URL="${BAG_URL}/Gemeente%20LVC/${GEM_CODE}/${BAG_ZIP}"

echo "Download ${BAG_ZIP}"
curl --silent -o ${BAG_ZIP} ${BAG_ZIP_URL}

OBJS="LIG NUM OPR PND STA VBO WPL"
for OBJ in ${OBJS}
do
	# /vsizip/{/vsizip/{/vsizip/{BAGGEM0221L-15092020.zip}/0221GEM15092020.zip}/0221PND15092020.zip}
	# ogrinfo /vsizip/{/vsizip/{/vsizip/${BAG_ZIP}/${GEM_CODE}GEM${DATE}.zip}/${GEM_CODE}${OBJ}${DATE}.zip}
    DATA_FILE="/vsizip/{/vsizip/{/vsizip/work/${BAG_ZIP}/${GEM_CODE}GEM${DATE}.zip}/${GEM_CODE}${OBJ}${DATE}.zip}"
    CMD="ogr2ogr ${OGR_OPTS} ${PG} ${DATA_FILE}"
    echo "run: ${CMD}"
    docker run --rm -v $(pwd):/work -it ${DOCKER_IMAGE} sh -c "${CMD}"

done

/bin/rm ${BAG_ZIP}
