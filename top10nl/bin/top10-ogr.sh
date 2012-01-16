#!/bin/sh
# Auteur: Just van den Broecke
# ogr2ogr commando executie
# pas top10-settings.sh aan voor specifieke opties

echo "BEGIN top10-ogr: `date`"

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

. $BASEDIR/bin/top10-settings.sh

# Transformeren ?
if [ -n "$OGR_TSRS" ]
then
	OGR_TSRS="-t_srs $OGR_TSRS"
fi

echo "ogr2ogr $OGR_OVERWRITE_OR_APPEND -f $OGR_OUT_FORMAT "$OGR_OUT_OPTIONS" $OGR_GT $OGR_OPT_MULTIATTR $OGR_LCO -a_srs $OGR_ASRS $OGR_TSRS  -s_srs $OGR_SSRS  $1"
hash ogr2ogr 2>&- || { echo >&2 "ogr2ogr prog is nodig, installeer GDAL/OGR www.gdal.org eerst. Ik houd hier op..."; exit 1; }
ogr2ogr $OGR_OVERWRITE_OR_APPEND -f $OGR_OUT_FORMAT "$OGR_OUT_OPTIONS" $OGR_GT $OGR_OPT_MULTIATTR $OGR_LCO -a_srs $OGR_ASRS $OGR_TSRS -s_srs $OGR_SSRS  $1


echo "EIND top10-ogr: `date`"
