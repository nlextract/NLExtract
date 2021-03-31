#!/bin/bash
#
# ETL voor BAG Extract versie 2 XML met gebruik Stetl en GDAL LVBAG Driver.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-imbag.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#

NLX_ETL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Uiteindelijke commando. Kan ook gewoon "stetl -c conf/etl-imbag-v2.1.0.cfg -a ..." worden indien Stetl installed
${NLX_ETL_DIR}/stetl.sh -c conf/etl-imbag-2.1.0.cfg $@
