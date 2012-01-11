#!/bin/sh
#
# Alle testen draaien
#
DATA_DIR=$PWD/data
MUT_DIR=$PWD/mutatie
DB_DIR=$PWD/../db

cd ../src

# DB leeg en schema aanmaken
python bagextract.py --dbinit -v

# Nieuwe objecten
python bagextract.py -e $DATA_DIR -v

# Mutaties
python bagextract.py -e $MUT_DIR -v

# Test verrijking van data met gemeenten+provincies
python bagextract.py -e $DB_DIR/data -v
python bagextract.py -v -q $DB_DIR/script/gemeente-tabel.sql
python bagextract.py -v -q $DB_DIR/script/provincie-tabel.sql

# Maak een "ACN-achtig" adres met alles erin
python bagextract.py -v -q $DB_DIR/script/adres-tabel.sql

cd -

