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
# Eerst wordt tabel adres_plus gemaakt, de tabellen adres en adres_full
# worden daarvan afgeleid.
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

# Alle adres tabellen aanmaken
log "Inlezen ${BAG_ZIP} OK, Adressen maken"
SQLS="adres-tabel-plus.sql adres-plus2adres-tabel.sql adres-plus2adres-full-tabel.sql"
for SQL in ${SQLS}
do
  log "Adressen maken - ${SQL}"
  psql -U postgres -d bag -f ${DB_DIR}/script/${SQL}
done

# Dump alle adres tabellen als CSV
log "Adressen maken OK, naar CSV"
SQLS="adres2csv.sql adres-full2csv.sql adres-plus2csv.sql"
for SQL in ${SQLS}
do
  log "CSV maken - ${SQL}"
  psql -U postgres -d bag -f ${DB_DIR}/script/${SQL}
done

# test CSV resultaten
log "CSV maken OK, test en bewaar"
CSVS="bagadres.csv bagadres-full.csv bagadresplus.csv "
for CSV in ${CSVS}
do
  log "Aantal regels in ${CSV}:"
  wc -l /tmp/${CSV}

  log "Bewaar deel van CSV"
  head -100 /tmp/${CSV}  > ${CSV}

  /bin/rm /tmp/${CSV}
done

log "KLAAR - VERWIJDER BESTANDEN"
rm ${TEST_DIR}/${BAG_ZIP}
