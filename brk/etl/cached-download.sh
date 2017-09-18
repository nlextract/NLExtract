#!/bin/bash
# Downloadscript om gecachte ZIP-bestanden van PDOK te downloaden.
#
# Auteur: Frank Steggink
#
# Probeert gezipte GML-bestanden van PDOK te downloaden. Er kan nogal wat mis gaan en gebeurt veel
# in praktijk, vandaar veel checks en retries:
# - connectie wordt vaak verbroken
# - download lijkt ok, maar .zip is 0 bytes
#
# Let op: onder water wordt de continue-optie (-c) van wget aangeroepen. De server moet dus range
# requests ondersteunen. Gebruik dit script alleen voor gecachte bestanden van PDOK, niet voor
# bestanden die dynamisch gegenereerd worden, zoals de BGT- en BRK-downloads via de kaart.
#
# Aanroep: ./cached-download.sh <url> <bestand>

# Download
target_url=$1
target_file=$2

if [[ -z ${target_file} ]]; then
  echo "Onvoldoende argumenten opgegeven!"
  echo "Aanroep: $0 <url> <bestand>"
  exit 1
fi

if [[ -d ${target_file} ]]; then
  echo "Doelbestand is een directory!"
  exit 1
fi

filename=$(basename ${target_file})

# Ruim het voorgaande bestand op
/bin/rm -f ${target_file} > /dev/null 2>&1

# Blijf proberen bestand op te halen tot gelukt
while true
do
  echo "Downloading ${filename} ..."

  # Haal file op
  wget -c -O ${target_file} --no-check-certificate ${target_url} 2>/dev/null

  # Check download outcome and stop on error
  if [ $? -ne 0 ]
  then
    echo "Download ${filename} NOT OK - download interrupted"
    continue
  fi

  # Download ok: proceed
  # check zipfile content
  unzip -l ${target_file}
  if [ $? -ne 0 ]
  then
    echo "Download ${filename} NOT OK, zipfile corrupt"
    continue
  fi

  # Many times a downloaded seems to succeed but .zip is 0 bytes, if not break inner loop
  if [ ! -s "${target_file}" ]
  then
    echo "Download ${filename} NOT OK, zero file, retrying...!"
    continue
  fi

  # ASSERT: we get here when all checks ok
  echo "Download ${filename} OK!"
  break
done
