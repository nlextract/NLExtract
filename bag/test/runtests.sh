#!/bin/sh
#
# Alle testen draaien
#

# Plaatsbepaling
#BE_HOME_DIR=`dirname $0`/..
#BE_HOME_DIR=`(cd "$BE_HOME_DIR"; pwd)`
# Bepaal waar we zijn zodat we kunnen uitvoeren vanaf elke directory
# werkt ook met symlinks dankzij gidema.
if [ -h "$0" ] ; then
  BE_HOME_DIR=`readlink "$0"`
  BE_HOME_DIR=`dirname "$BE_HOME_DIR"`/..
else
  BE_HOME_DIR=`dirname $0`/..
fi
BE_HOME_DIR=`(cd "$BE_HOME_DIR"; pwd)`

TEST_DIR=$BE_HOME_DIR/test
DATA_DIR=$TEST_DIR/data
DATA_DUBBEL_DIR=$TEST_DIR/datadubbel
MUT_DIR=$TEST_DIR/mutatie
DB_DIR=$BE_HOME_DIR/db
BAG_EXTRACT=$BE_HOME_DIR/bin/bag-extract.sh

# DB leeg en schema aanmaken
$BAG_EXTRACT --dbinit -v

# Nieuwe objecten
$BAG_EXTRACT -v -e $DATA_DIR

# Dubbele objecten
$BAG_EXTRACT -v -e $DATA_DUBBEL_DIR

# Ontdubbelen
$BAG_EXTRACT -v -q $DB_DIR/script/ontdubbel.sql

# Mutaties
$BAG_EXTRACT -v -e $MUT_DIR

# Test verrijking van data met gemeenten+provincies
$BAG_EXTRACT -v -q $DB_DIR/script/gemeente-provincie-tabel.sql

# Maak een "ACN-achtig" adres met alles erin
$BAG_EXTRACT -v -q $DB_DIR/script/adres-tabel.sql

# Geocode tabellen  en functies
$BAG_EXTRACT -v -q $DB_DIR/script/geocode/geocode-tabellen.sql
$BAG_EXTRACT -v -q $DB_DIR/script/geocode/geocode-functies.sql
$BAG_EXTRACT -v -q $TEST_DIR/geocode/geocode-functies-test.sql


