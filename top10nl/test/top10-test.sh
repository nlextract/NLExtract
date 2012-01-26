#!/bin/sh
#
# Auteur: Just van den Broecke
# Test script
#
TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
TOP10NL_TEST_DATA=$TOP10NL_HOME/test/data

$TOP10NL_BIN/top10-drop-tables.sh

rm $TOP10NL_TEST_DATA/*.split*

$TOP10NL_BIN/top10-extract.sh $TOP10NL_TEST_DATA/test.gml

