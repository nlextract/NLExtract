#!/bin/bash
# Download complete BRK/DKK GML-leveringen vanaf PDOK
#
# Voorbeeld
# mkdir -p leveringen/160401
# ./download-brk.sh leveringen/160401
#
# Auteur: Just van den Broecke
#
# Probeert BRK-DKK GML van alle provincies te downloaden. Er kan nogal wat mis gaan,
# en gebeurt veel in praktijk, vandaar veel checks en retries:
# - connectie wordt vaak verbroken
# - download lijkt ok, maar .zip is 0 bytes
#
# NB soms is .zip file 0 bytes, lijkt vreemd probleem PDOK
# Ligt misschien aan self-signed certificate?
# "WARNING: cannot verify geodatastore.pdok.nl's certificate, issued by `/C=NL/O=QuoVadis Trustlink BV/OU=Issuing Certification Authority/CN=QuoVadis CSP - PKI Overheid CA - G2':
#    Self-signed certificate encountered."

# Download gegevens: dataset IDs en 12 provincies
# Zie https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-kadaster/kadastrale-kaart
base_url="https://geodatastore.pdok.nl/id/dataset"

# Datasets als tuples: datasetID en provincie naam
datasets="ab1e23c5-cbf3-4da8-a993-9ce088cc70ed,Flevoland \
58830183-c66d-41e7-aeb8-84ca33fe118a,Drenthe \
55e7376d-d8a0-4f82-96a1-386782984cb3,Friesland \
d731c350-9378-4044-ab94-b89a97f79bec,Gelderland \
dccf8230-bd36-4515-975d-b7b0d496cce8,Groningen \
71e39f29-7968-40e4-8792-8de5c9997256,Limburg \
d434165b-7441-4263-b4da-9e58e8d036e4,Noord-Brabant \
e0fa4cbb-3fb4-4e2f-a004-f86bdebb5837,Noord-Holland \
fdd0fa6f-be66-4b87-81b5-d67700029702,Overijssel \
f5554f62-4423-49bf-8987-d01ea0bda0ca,Utrecht \
b1f9fd73-7050-4af1-a48e-85fbd06e17f2,Zeeland \
131d387d-7222-46f0-a021-63b5b8852124,Zuid-Holland"

# Download
doel_dir=$1

# Ga door alle provincie tuples
for dataset in ${datasets}
do
  # DatasetID,Provincie is tuple, scheid deze
  IFS=","
  set $dataset

  uuid="${1}"
  provincie="${2}"
  
  # Download
  target_file="${doel_dir}/${provincie}.zip"
  target_url="${base_url}/${uuid}"

  # Blijf proberen bestand op te halen tot gelukt
  while true
  do
    echo "Downloading ${provincie} ..."
    /bin/rm -f ${target_file} > /dev/null 2>&1

    # Haal file op
    wget -O ${target_file} --no-check-certificate ${target_url}

	# Check download outcome and stop on error
	if [ $? -ne 0 ]
	then
	  echo "Download ${provincie} NOT OK - download interrupted"
	  continue
	fi
	
	# Download ok: proceed
	# check zipfile content
	unzip -l ${target_file}
	if [ $? -ne 0 ]
	then
	  echo "Download ${provincie} NOT OK, zipfile corrupt"
	  continue
	fi

    # Many times a downloaded seems to succeed but .zip is 0 bytes, if not break inner loop
    if [ ! -s "${target_file}" ]
    then
      echo "Download ${provincie} NOT OK, zero file, retrying...!"
	  continue
    fi

    # ASSERT: we get here when all checks ok
	echo "Download ${provincie} OK!"
	break
  done
  # Reset field seperator
  unset IFS
done

echo "Klaar, bestanden in ${doel_dir} !"
