#!/bin/sh
# Auteur: Just van den Broecke
# ogr2ogr commando executie
# pas top10-settings.sh aan voor specifieke opties

TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
GML_FILE=$1

# Laadt util functies
. $TOP10NL_BIN/utils.sh
. $TOP10NL_HOME/bin/top10-settings.sh

# ogr2ogr moet installed zijn maar ook vindbaar in PATH
checkProg "ogr2ogr" "programma 'ogr2ogr' niet gevonden. Installeer dit eerst of voeg aan PATH toe. Zie www.gdal.org"

# Check input
checkVarUsage "$0 <top10nl gml bestand>" $GML_FILE
checkFile $GML_FILE

# Transformeren ?
if [ -n "$OGR_TSRS" ]
then
	OGR_TSRS="-t_srs $OGR_TSRS"
fi

# Uitvoeren ogr2ogr
startProg "$0" "file=$GML_FILE"
echo "ogr2ogr $OGR_OVERWRITE_OR_APPEND -f $OGR_OUT_FORMAT "$OGR_OUT_OPTIONS" $OGR_GT $OGR_OPT_MULTIATTR $OGR_LCO -a_srs $OGR_ASRS $OGR_TSRS  -s_srs $OGR_SSRS  $GML_FILE"
ogr2ogr $OGR_OVERWRITE_OR_APPEND -f $OGR_OUT_FORMAT "$OGR_OUT_OPTIONS" $OGR_GT $OGR_OPT_MULTIATTR $OGR_LCO -a_srs $OGR_ASRS $OGR_TSRS -s_srs $OGR_SSRS  $GML_FILE
endProg "$0"
