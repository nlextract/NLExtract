#!/bin/bash
#
# Download BRK GML van PDOK.
#
# Auteurs: Just van den Broecke, Frank Steggink
#
# Aanroep: ./download-brk.sh [doel_directory]
# doel_directory is optioneel, anders wordt 'leveringen/latest' gebruikt in huidige dir
# (tbv automatische BRK verwerking op data.nlextract.nl
#

# Zie https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-kadaster/kadastrale-kaart
base_url="https://geodatastore.pdok.nl/id/dataset"

# UUIDs met bijbehorende provincie tbv identificeren .zip bestand.
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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

doel_dir="${DIR}/leveringen/latest"

# Evt via commandline overrulen: ./download-brk.sh [doel_directory]
[ ! -z "$1" ] && doel_dir=$1

echo "doel_dir is ${doel_dir}"

if [ ! -d "${doel_dir}" ]
then
  echo "${doel_dir} bestaat niet!"; exit 1
fi

pushd ${doel_dir}
for dataset in ${datasets}
do 
  IFS=","
  set $dataset
  echo "Downloading $2 ..."
  #wget -O ${2}.zip ${base_url}/${1}
  ${DIR}/robust-download.sh ${base_url}/${1} ${2}.zip
  unset IFS
done

popd 
