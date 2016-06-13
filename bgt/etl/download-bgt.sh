#!/bin/bash

# See https://www.pdok.nl/nl/producten/pdok-downloads/download-basisregistratie-grootschalige-topografie
today=`date +"%d-%m-%Y"`
blocks="9 11 12 13 14 15 18 24 26 27 36 37 39 45 48 49 50 51 56 57"
#blocks="9 11 12 13"
#blocks="9 11 12"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd leveringen/latest
for block in ${blocks}
do 
  echo "Downloading BGT-blok ${block} ..."
  block_url="https://www.pdok.nl/download/service/extract.zip?extractset=citygml&tiles=%7B%22layers%22%3A%5B%7B%22aggregateLevel%22%3A0%2C%22codes%22%3A%5B%5D%7D%2C%7B%22aggregateLevel%22%3A1%2C%22codes%22%3A%5B%5D%7D%2C%7B%22aggregateLevel%22%3A2%2C%22codes%22%3A%5B%5D%7D%2C%7B%22aggregateLevel%22%3A3%2C%22codes%22%3A%5B%5D%7D%2C%7B%22aggregateLevel%22%3A4%2C%22codes%22%3A%5B%5D%7D%2C%7B%22aggregateLevel%22%3A5%2C%22codes%22%3A%5B${block}%5D%7D%5D%7D&excludedtypes=plaatsbepalingspunt&history=true&enddate=${today}"

  ${DIR}/robust-download.sh ${block_url} bgt_${block}.zip
done

popd 
