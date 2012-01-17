#!/bin/sh
#
# Alle testen draaien
#

# Plaatsbepaling
BE_HOME_DIR=`dirname $0`/..
BE_HOME_DIR=`(cd "$BE_HOME_DIR"; pwd)`
TEST_DIR=$BE_HOME_DIR/test
DATA_DIR=$TEST_DIR/data
MUT_DIR=$TEST_DIR/mutatie
DB_DIR=$BE_HOME_DIR/db
BAG_EXTRACT=$BE_HOME_DIR/bin/bag-extract.sh

# DB leeg en schema aanmaken
$BAG_EXTRACT --dbinit -v

# Nieuwe objecten
$BAG_EXTRACT -e $DATA_DIR -v

# Ontdubbelen
$BAG_EXTRACT -v -q $DB_DIR/script/ontdubbel.sql

# Mutaties
$BAG_EXTRACT -e $MUT_DIR -v

# Test verrijking van data met gemeenten+provincies
$BAG_EXTRACT -e $DB_DIR/data -v
$BAG_EXTRACT -v -q $DB_DIR/script/gemeente-tabel.sql
$BAG_EXTRACT -v -q $DB_DIR/script/provincie-tabel.sql

# Maak een "ACN-achtig" adres met alles erin
$BAG_EXTRACT -v -q $DB_DIR/script/adres-tabel.sql


