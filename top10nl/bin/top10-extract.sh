#!/bin/sh
#
# Auteur: Just van den Broecke
# Volledig Top10NL GML bestand naar PostGIS brengen.
# pas top10-settings.sh aan voor specifieke opties
# Alle vars
TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
IN_FILE_OF_DIR=$1

# Laadt util functies
. $TOP10NL_BIN/utils.sh

# Extract: een enkele Top10NL GML file
function extractFile() {
	GML_FILE=$1
	GML_FILE_SPLIT=${GML_FILE}.split.xml

	startProg "$0"  "file=$GML_FILE"
	checkFile $GML_FILE

	# Stap 1: GML geometrie uitsplitsen  met XSLT
	$TOP10NL_BIN/top10-split.sh $GML_FILE  $GML_FILE_SPLIT

	# Stap 2: GML naar bijv. PostGIS  met ogr2ogr
	$TOP10NL_BIN/top10-ogr.sh  $GML_FILE_SPLIT

	endProg "$0"
}

# Extract: een directory met Top10NL GML files
function extractDir() {
	IN_DIR=$1
	pr "Alle Top10NL GML files in $IN_DIR exraheren..."
    for GML_FILE in `ls $IN_DIR/*.gml`
    do
       extractFile $GML_FILE
    done
}

# Directory gegeven als argument ?
if [ -d "$IN_FILE_OF_DIR" ]
then
	extractDir $IN_FILE_OF_DIR
	exit 1
fi

if [ -f "$IN_FILE_OF_DIR" ]
then
	extractFile $IN_FILE_OF_DIR
	exit 1
fi

usage "$0 <input Top10NL GML file of directory met Top10NL GML files>"




