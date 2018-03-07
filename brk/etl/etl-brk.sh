#!/bin/bash
#
# ETL voor BRK GML met gebruik Stetl.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-brk.cfg) en parameters (options/myoptions.args) aan te roepen.
#
# Author: Just van den Broecke
#

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR >/dev/null

NLX_HOME=../..

# Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
if [ -z "$STETL_HOME" ]; then
  STETL_HOME=../../externals/stetl
fi

# Nodig voor imports
if [ -z "$PYTHONPATH" ]; then
  export PYTHONPATH=$STETL_HOME:$NLX_HOME
else
  export PYTHONPATH=$STETL_HOME:$NLX_HOME:$PYTHONPATH
fi

# Default arguments/options
options_file=options/default.args

# Optionally overules default options file by using a host-based file options/<your hostname>.args
# To add your localhost add <your hostname>.args in options directory
host_options_file=options/`hostname`.args

[ -f "$host_options_file" ] && options_file=$host_options_file

# Evt via commandline overrulen: etl-brk.sh <my options file>
[ -f "$1" ] && options_file=$1

# Uiteindelijke commando. Kan ook gewoon "stetl -c etl-brk.cfg -a ..." worden indien Stetl installed
# python $STETL_HOME/stetl/main.py -c conf/etl-brk.cfg -a "$pg_options temp_dir=temp max_features=$max_features gml_files=$gml_files $multi $spatial_extent"
python $STETL_HOME/stetl/main.py -c conf/etl-brk.cfg -a $options_file

popd >/dev/null
