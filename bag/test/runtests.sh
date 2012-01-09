#!/bin/sh
#
# Alle testen draaien
#
DATA_DIR=$PWD/data
DB_DIR=$PWD/../db
cd ../src
python bagextract.py --dbinit -v
python bagextract.py -e $DATA_DIR -v
python bagextract.py -e $DB_DIR/data -v
python bagextract.py -v -q $DB_DIR/script/gemeente-tabel.sql
python bagextract.py -v -q $DB_DIR/script/provincie-tabel.sql
python bagextract.py -v -q $DB_DIR/script/adres-tabel.sql

cd -

