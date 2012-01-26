#!/bin/sh
#
# Auteur: Just van den Broecke
# xsltproc commando executie
# pas top10-settings.sh aan voor specifieke opties


# Alle vars
TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
XSL_FILE=$TOP10NL_BIN/top10-split.xsl
XML_IN=$1
XML_OUT=$2

. $TOP10NL_HOME/bin/top10-settings.sh

# Laadt util functies
. $TOP10NL_BIN/utils.sh

# Check input
checkVarUsage "$0 'gml input file' 'gml output file'" $XML_IN
checkVarUsage "$0 'gml input file' 'gml output file'" $XML_OUT

checkFile $XML_IN

# Check required prog + (optionele) msg if not installed
checkProg "xmlstarlet" "Installeer deze eerst. Zie http://xmlstar.sourceforge.net"

startProg "$0"  "file=$XML_IN"

nice xsltproc --maxdepth 50000 $XSL_FILE $XML_IN >  $XML_OUT

# Zie http://xmlstar.sourceforge.net/doc/xmlstarlet.txt
# nice xmlstarlet tr --maxdepth 50000  $XSL_FILE $XML_IN >  $XML_OUT

endProg "$0"
