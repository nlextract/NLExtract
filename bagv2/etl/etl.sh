#!/bin/bash
#
# ETL voor BAG Extract XML met gebruik Stetl.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-imbag.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#

# error and exit
function error_exit() {
  local msg=$1
  echo "ERROR: $(date +"%y-%m-%d %H:%M:%S") - ${msg} - exit..."
  exit -1
}

# log
function log_info() {
  local msg=$1
  echo "INFO: $(date +"%y-%m-%d %H:%M:%S") - ${msg}"
}

NLX_ETL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NLX_HOME=$(cd ${NLX_ETL_DIR}/../../;pwd)

pushd ${NLX_ETL_DIR}

# Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
# Dan extern export STETL_HOME= zetten.
[[ -z ${STETL_HOME} ]] && STETL_HOME="${NLX_HOME}/externals/stetl"

# Nodig voor imports
[[ -z ${PYTHONPATH} ]] && export PYTHONPATH="${STETL_HOME}:${NLX_HOME}:."
[[ -z ${PYTHONPATH} ]] || export PYTHONPATH="${STETL_HOME}:${NLX_HOME}:.:${PYTHONPATH}"

# Default arguments/options, common.args is always applied
common_options_file="${NLX_ETL_DIR}/options/common.args"
docker_options_file="${NLX_ETL_DIR}/options/docker.args"
options_file="${NLX_ETL_DIR}/options/default.args"

# Optionally overules default options file by using a host-based file options/<your hostname>.args
# To add your localhost add <your hostname>.args in options directory
[[ -f /.dockerenv  ]] && options_file="${docker_options_file}"
host_options_file="options/$(hostname).args"
[[ -f "${host_options_file}" ]] && options_file="${host_options_file}"

# Evt via commandline overrulen: etl.sh <my options file>
# e.g. etl.sh options/docker.args
[ -f "$1" ] && options_file="$1"

log_info "Using options_file=${options_file}"

# Uiteindelijke commando. Kan ook gewoon "stetl -c conf/etl-imbag-v2.1.0.cfg -a ..." worden indien Stetl installed
python ${STETL_HOME}/stetl/main.py -c conf/etl-imbag-v2.1.0.cfg -a ${common_options_file} -a ${options_file}

popd
