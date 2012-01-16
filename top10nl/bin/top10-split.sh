#!/bin/sh
#
# Auteur: Just van den Broecke
# xsltproc commando executie
# pas top10-settings.sh aan voor specifieke opties

echo "BEGIN top10-split: `date`"

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

. $BASEDIR/bin/top10-settings.sh

hash xsltproc 2>&- || { echo >&2 "xsltproc prog is nodig, installeer deze eerst. Ik houd hier op..."; exit 1; }

nice xsltproc --maxdepth 50000 $BASEDIR/bin/top10-split.xsl $1 >  $2

echo "EIND top10-split: `date`"
