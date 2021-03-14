#!/bin/bash
#
# Test LVBAG driver with latest GDAL Docker Image.OGR_OPTS
# Check out what works best.
#
# Just van den Broecke
#
DOCKER_IMAGE="osgeo/gdal:ubuntu-small-latest"
PGSCHEMA="test"
export PGOPTIONS="-c search_path=${PGSCHEMA},public"

echo "DROP TABLE IF EXISTS pand CASCADE" | psql bagv2

# Layer creation options -lco SPATIAL_INDEX=NO
LCO="-lco LAUNDER=YES -lco PRECISION=NO -lco FID=gid"

# DO NOT USE -skipfailures with -gt ! See https://lists.osgeo.org/pipermail/gdal-dev/2019-March/049889.html
OGR_OPTS="-append -gt 200000 --config PG_USE_COPY YES -oo AUTOCORRECT_INVALID_DATA=YES -oo LEGACY_ID=YES -a_srs EPSG:28992 ${LCO}"

# NB we use host.docker.internal to connect from within Docker Container to localhost PostGIS!
PG="'PG:dbname=bagv2 active_schema=test host=host.docker.internal user=postgres password=postgres'"

DOCKER_DATA_DIR="/work/pand"
LOCAL_DATA_DIR="/Users/just/project/nlextract/data/BAG-2.0/PND-ADAM"
CMD="ogr2ogr ${OGR_OPTS} ${PG} ${DOCKER_DATA_DIR}"

echo "run: ${CMD}"

echo "START DOCKER $(date)"
docker run --rm  -v ${LOCAL_DATA_DIR}:${DOCKER_DATA_DIR} -it ${DOCKER_IMAGE} sh -c "${CMD}"
echo "END   DOCKER $(date)"

echo "DROP TABLE IF EXISTS pand CASCADE" | psql bagv2

echo "START LOCAL $(date)"
ogr2ogr ${OGR_OPTS} 'PG:dbname=bagv2 active_schema=test host=127.0.0.1 user=postgres password=postgres' ${LOCAL_DATA_DIR}

echo "END   LOCAL $(date)"
