#!/bin/sh
#
# Auteur: Just van den Broecke
# Top10NL GML schema validatie.
# Maakt gebruik van "xmlstarlet" zie http://xmlstar.sourceforge.net/
# Installeer eerst "xmlstarlet"
# Bijv. op Ubuntu apt-get install xmlstarlet
#

# Alle vars
TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
XSD_FILE=$TOP10NL_HOME/doc/schema/top10nl.xsd
XML_FILE=$1

# Laadt util functies
. $TOP10NL_BIN/utils.sh

# Check input
checkVarUsage "$0 <top10nl gml bestand>" $XML_FILE
checkFile $XML_FILE
checkFile $XSD_FILE

# Check required prog + (optionele) msg if not installed
checkProg "xmlstarlet" "Installeer deze eerst: http://xmlstar.sourceforge.net"

startProg "$0"  "file=$XML_FILE"

xmlstarlet val -e --xsd $XSD_FILE $XML_FILE

endProg "$0"

