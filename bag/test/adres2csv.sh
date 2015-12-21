#!/bin/sh

export PGPASSWORD=postgres
sql=../db/script/adres2csv.sql
psql -U postgres -d bag -f $sql
mv /tmp/bagadres.csv .
cat bagadres.csv
