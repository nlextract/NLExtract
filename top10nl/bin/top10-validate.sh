#!/bin/sh
#
# Auteur: Just van den Broecke
# Top10NL GML schema validatie.
# Maakt gebruik van "xmlstarlet" zie http://xmlstar.sourceforge.net/
# Installeer eerst "xmlstarlet"
# Bijv. op Ubunto apt-get install xmlstarlet
#

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

# Check of xmlstarlet is installed
hash xmlstarlet 2>&- || { echo >&2 "xmlstarlet prog is nodig, installeer deze eerst: http://xmlstar.sourceforge.net. Ik houd hier op..."; exit 1; }

GML_FILE=$1
XSD_FILE=$BASEDIR/doc/schema/top10nl.xsd

echo "BEGIN top10-validate.sh: `date` file=$GML_FILE"

xmlstarlet val -e --xsd $XSD_FILE $GML_FILE
echo "END top10-validate.sh: `date`"

