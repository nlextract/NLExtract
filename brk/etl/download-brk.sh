#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROBUST_DOWNLOAD="${DIR}/../../tools/download/robust-download.sh"

# ${ROBUST_DOWNLOAD} https://www.pdok.nl/download/service/cache/kadastralekaartv3-gml-nl-nohist.zip kadastralekaartv3-gml-nl-nohist.zip
${ROBUST_DOWNLOAD} https://downloads.pdok.nl/kadastralekaart/api/v4_0/full/predefined/dkk-gml-nl-nohist.zip dkk-gml-nl-nohist.zip