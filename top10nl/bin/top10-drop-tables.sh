#!/bin/sh
#
# Util: clean existing tables
#
# Auteur: Just van den Broecke
#
TOP10NL_HOME=`dirname $0`/..
TOP10NL_HOME=`(cd "$TOP10NL_HOME"; pwd)`
TOP10NL_BIN=$TOP10NL_HOME/bin
SQL_FILE=$TOP10NL_BIN/top10-drop-tables.sql

# Laadt util functies
. $TOP10NL_BIN/utils.sh

checkProg "psql" "Het PostgreSQL client programma. Installeer deze of zet je PATH goed"

. $TOP10NL_BIN/top10-settings.sh

export PGPASSWORD=$PG_PASSWORD
export PGCLIENTENCODING="UTF-8"
psql -d $PG_DB -U $PG_USER -p $PG_PORT -h $PG_HOST -f $SQL_FILE

