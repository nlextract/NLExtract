#!/bin/sh
#
# Auteur: Just van den Broecke
# Volledig Top10NL GML bestand naar PostGIS brengen.
# pas top10-settings.sh aan voor specifieke opties

echo "BEGIN top10-extract.sh: `date`"

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

GML_FILE=$1
GML_FILE_SPLIT=${GML_FILE}.split.gml

# GML geometrie uitsplitsen  met XSLT
$BASEDIR/bin/top10-split.sh $GML_FILE  $GML_FILE_SPLIT

# GML naar bijv. PostGIS  met ogr2ogr
$BASEDIR/bin/top10-ogr.sh  $GML_FILE_SPLIT

echo "EIND top10-extract.sh: `date`"
