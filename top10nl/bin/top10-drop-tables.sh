#!/bin/sh
#
# Util: clean existing tables
#
# Auteur: Just van den Broecke
#

hash psql 2>&- || { echo >&2 "Kan het PostgreSQL client programma psql niet vinden. Heb ik echt nodig..."; exit 1; }

BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

. $BASEDIR/bin/top10-settings.sh

export PGPASSWORD=$PG_PASSWORD
psql -d $PG_DB -U $PG_USER -p $PG_PORT -h $PG_HOST -f $BASEDIR/bin/top10-drop-tables.sql

