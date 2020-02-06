#!/bin/sh

export PGPASSWORD=postgres
export PGOPTIONS="-c search_path=test,public"

sql=../db/script/adres2csv.sql
psql -U postgres -d bag -f $sql
mv /tmp/bagadres.csv .
cat bagadres.csv

sql=../db/script/adres-full2csv.sql
psql -U postgres -d bag -f $sql
mv /tmp/bagadres-full.csv .
cat bagadres-full.csv
