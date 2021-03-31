#!/bin/bash
#
# Verrijk BAG tabel data met adressen.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (bag-adressen.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#


NLX_ETL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Uiteindelijke commando. Kan ook gewoon "stetl -c conf/adres.cfg -a ..." worden indien Stetl installed
${NLX_ETL_DIR}/stetl.sh -c conf/adres.cfg $@
