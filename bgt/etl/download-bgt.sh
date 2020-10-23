#!/bin/bash

# See https://www.pdok.nl/nl/producten/pdok-downloads/download-basisregistratie-grootschalige-topografie
today=`date +"%d-%m-%Y"`

# ID's van 32x32 km gebieden om de BGT te downloaden. Let op, de ID's mogen geen voorloopnullen bevatten.
blocks="39 45 48 50 51 54 55 56 57 58 59 60 61 62 63 74 75 96 97 98 99 104 105 106 107 110 111 145 148 149 150 151 156 157 158 159 180 181 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 224 225 228 229 230"

# 64x64 aggregaatlevel 5
# https://downloads.pdok.nl/service/extract.zip?extractname=bgt&extractset=citygml&excludedtypes=plaatsbepalingspunt&history=true&tiles=%7B%22layers%22%3A%5B%7B%22aggregateLevel%22%3A5%2C%22codes%22%3A%5B13%5D%7D%5D%7D
blocks="0 1 4 5 16 17 2 3 6 7 18 19 8 9 12 13 24 25 10 11 14 15 26 27 32 33 36 37 48 49 34 35 38 39 50 51"
#bbox=[-36000, 264000, 28000, 328000] 0
#bbox=[28000, 264000, 92000, 328000] 1
#bbox=[92000, 264000, 156000, 328000] 4
#bbox=[156000, 264000, 220000, 328000] 5
#bbox=[220000, 264000, 284000, 328000] 16
#bbox=[284000, 264000, 348000, 328000] 17
#bbox=[-36000, 328000, 28000, 392000] 2
#bbox=[28000, 328000, 92000, 392000] 3
#bbox=[92000, 328000, 156000, 392000] 6
#bbox=[156000, 328000, 220000, 392000] 7
#bbox=[220000, 328000, 284000, 392000] 18
#bbox=[284000, 328000, 348000, 392000] 19
#bbox=[-36000, 392000, 28000, 456000] 8
#bbox=[28000, 392000, 92000, 456000] 9
#bbox=[92000, 392000, 156000, 456000] 12
#bbox=[156000, 392000, 220000, 456000] 13
#bbox=[220000, 392000, 284000, 456000] 24
#bbox=[284000, 392000, 348000, 456000] 25
#bbox=[-36000, 456000, 28000, 520000] 10
#bbox=[28000, 456000, 92000, 520000] 11
#bbox=[92000, 456000, 156000, 520000] 14
#bbox=[156000, 456000, 220000, 520000] 15
#bbox=[220000, 456000, 284000, 520000] 26
#bbox=[284000, 456000, 348000, 520000] 27
#bbox=[-36000, 520000, 28000, 584000] 32
#bbox=[28000, 520000, 92000, 584000] 33
#bbox=[92000, 520000, 156000, 584000] 36
#bbox=[156000, 520000, 220000, 584000] 37
#bbox=[220000, 520000, 284000, 584000] 48
#bbox=[284000, 520000, 348000, 584000] 49
#bbox=[-36000, 584000, 28000, 648000] 34
#bbox=[28000, 584000, 92000, 648000] 35
#bbox=[92000, 584000, 156000, 648000] 38
#bbox=[156000, 584000, 220000, 648000] 39
#bbox=[220000, 584000, 284000, 648000] 50
#bbox=[284000, 584000, 348000, 648000] 51
# 0 1 4 5 16 17 2 3 6 7 18 19 8 9 12 13 24 25 10 11 14 15 26 27 32 33 36 37 48 49 34 35 38 39 50 51


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[ -z "$1" ] && pushd leveringen/latest || pushd $1
for block in ${blocks}
do 
  echo "Downloading BGT-blok ${block} ..."
  block_url="https://downloads.pdok.nl/service/extract.zip?extractname=bgt&extractset=citygml&excludedtypes=plaatsbepalingspunt&history=true&tiles=%7B%22layers%22%3A%5B%7B%22aggregateLevel%22%3A4%2C%22codes%22%3A%5B${block}%5D%7D%5D%7D&enddate=${today}"

  bash ${DIR}/robust-download.sh ${block_url} bgt_${block}.zip
done

popd 
