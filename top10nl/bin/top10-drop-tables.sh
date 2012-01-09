#!/bin/sh
#
# clean existing tables
# Author: Just van den Broecke

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

. $BASEDIR/bin/top10-settings.sh
psql -d $PG_DB -f $BASEDIR/bin/top10-drop-tables.sql

