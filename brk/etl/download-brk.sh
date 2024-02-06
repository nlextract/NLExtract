#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

${DIR}/robust-download.sh https://api.pdok.nl/kadaster/kadastralekaart/download/v5_0/full/predefined/kadastralekaart-gml-nl-nohist.zip dkk-gml-nl-nohist.zip

