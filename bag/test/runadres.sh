#!/bin/bash
#
# Run tests voor Adressen.
#
# Auteur: Just van den Broecke
#
# Hiervoor is groter BAG bronbestand nodig omdat pivot tabellen moeten
# worden aangemaakt. Vandaar BAG voor Amsterdam als test bestand.
# PostGIS moet wel CREATE EXTENSION TABLEFUNC; hebben.
#
# Uitvoeren: ./runadres.sh > runadres.log 2>&1
#
BE_HOME_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

TEST_DIR=$BE_HOME_DIR/test
DATA_DIR=$TEST_DIR/data
DB_DIR=$BE_HOME_DIR/db
BAG_EXTRACT="${BE_HOME_DIR}/bin/bag-extract.sh -f ${BE_HOME_DIR}/extract.conf"
BAG_ZIP="bag-amsterdam.zip"
export PGPASSWORD=postgres
export PGOPTIONS="-c search_path=test,public"

# log
function log() {
  local msg=$1
  echo "LOG: $(date +"%y-%m-%d %H:%M:%S") - ${msg}"
}

# Download BAG Brondata voor Gemeente Amsterdam
log "Download ${BAG_ZIP}..."
curl --silent -o ${TEST_DIR}/${BAG_ZIP} https://data.nlextract.nl/brondata/bag/${BAG_ZIP}
log "Download ${BAG_ZIP} OK"

# DB leeg en schema aanmaken, geen prompt (-j of --ja optie)
log "Lege DB maken"
${BAG_EXTRACT} --dbinit -j -v

# Inlezen in PostGIS
log "Inlezen ${BAG_ZIP}, kan even duren..."
${BAG_EXTRACT} -v -e ${TEST_DIR}/${BAG_ZIP}

log "Inlezen ${BAG_ZIP} OK, Adressen maken"
SQL=${DB_DIR}/script/adres-tabel-plus.sql
psql -U postgres -d bag -f ${SQL}

log "Adressen maken OK, naar CSV"
SQL=${DB_DIR}/script/adres-plus2csv.sql
psql -U postgres -d bag -f ${SQL}
mv /tmp/bagadresplus.csv ${TEST_DIR}/

log "Aantal regels in CSV:"
wc -l ${TEST_DIR}/bagadresplus.csv

log "Bewaar deel van CSV"
head -100 ${TEST_DIR}/bagadresplus.csv  > bagadres-plus.csv

log "KLAAR - VERWIJDER BESTANDEN"
rm ${TEST_DIR}/${BAG_ZIP} ${TEST_DIR}/bagadresplus.csv
