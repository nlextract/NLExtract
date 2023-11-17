#!/bin/bash
# Download hele BGT, 2023 versie.
# Author: Just van den Broecke

BGT_URL="https://api.pdok.nl/lv/bgt/download/v1_0/full/predefined/bgt-citygml-nl-nopbp.zip"

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

TARGET_FILE=$1
TARGET_FILE="${TARGET_FILE:=bgt-citygml-nl.zip}"

echo "START Downloading Full BGT to ${TARGET_FILE}..."

bash ${DIR}/robust-download.sh ${BGT_URL} ${TARGET_FILE}

echo "END Downloading Full BGT to ${TARGET_FILE}"
