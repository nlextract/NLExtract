#!/bin/bash
#
# ETL voor BAG Extract XML met gebruik Stetl.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-imbag.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pushd ${DIR}

NLX_HOME=../..

# Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
if [ -z "${STETL_HOME}" ]; then
  STETL_HOME=../../externals/stetl
  # STETL_HOME=../../../../../project/stetl/git
fi

# Nodig voor imports
if [ -z "${PYTHONPATH}" ]; then
  export PYTHONPATH=${STETL_HOME}:${NLX_HOME}:.
else
  export PYTHONPATH=${STETL_HOME}:${NLX_HOME}:.:${PYTHONPATH}
fi

# Default arguments/options
options_file=options/default.args

# Optionally overules default options file by using a host-based file options/<your hostname>.args
# To add your localhost add <your hostname>.args in options directory
host_options_file=options/$(hostname).args

[ -f "${host_options_file}" ] && options_file=${host_options_file}

# Evt via commandline overrulen: etl.sh <my options file>
# e.g. etl.sh options/docker.args
[ -f "$1" ] && options_file=$1

# Uiteindelijke commando. Kan ook gewoon "stetl -c conf/etl-imbag-v2.1.0.cfg -a ..." worden indien Stetl installed
python ${STETL_HOME}/stetl/main.py -c conf/etl-imbag-v2.1.0.cfg -a ${options_file}

popd
