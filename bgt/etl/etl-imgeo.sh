#!/bin/bash
#
# ETL voor IMGeo GML met gebruik Stetl.
#
# Dit is een front-end/wrapper shell-script om uiteindelijk Stetl met een configuratie
# (etl-imgeo.cfg) en parameters (in options.sh) aan te roepen.
#
# Author: Just van den Broecke
#

. options.sh

# Gebruik Stetl meegeleverd met NLExtract (kan in theorie ook Stetl via pip install stetl zijn)
STETL_HOME=../../externals/stetl

# Nodig voor imports
export PYTHONPATH=$STETL_HOME:$PYTHONPATH

# Uiteindelijke commando. Kan ook gewoon "stetl -c etl-imgeo.cfg -a ..." worden indien Stetl installed
python $STETL_HOME/stetl/main.py -c conf/etl-imgeo-v2.1.1.cfg -a "$pg_options temp_dir=temp max_features=$max_features gml_files=$gml_files $multi $spatial_extent"
