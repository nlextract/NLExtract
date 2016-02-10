#!/bin/bash
#
# ETL voor BRK GML met gebruik Stetl.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-brk.cfg) en parameters (in options.sh) aan te roepen.
#
# Author: Just van den Broecke
#

. options.sh

# Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
if [ -z "$STETL_HOME" ]; then
  STETL_HOME=../../externals/stetl
fi

# Nodig voor imports
if [ -z "$PYTHONPATH" ]; then
  export PYTHONPATH=$STETL_HOME
else
  export PYTHONPATH=$STETL_HOME:$PYTHONPATH
fi

# Uiteindelijke commando. Kan ook gewoon "stetl -c etl-brk.cfg -a ..." worden indien Stetl installed
python $STETL_HOME/stetl/main.py -c conf/etl-brk.cfg -a "$pg_options temp_dir=temp max_features=$max_features gml_files=$gml_files $multi $spatial_extent"
