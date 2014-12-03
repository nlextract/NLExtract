#!/bin/bash
#
# ETL for Top10NL using Stetl.
#
# Author: Just van den Broecke
#

. options.sh

python ../../externals/stetl/stetl/main.py -c etl-top10nl.cfg -a "$pg_options temp_dir=temp max_features=$max_features gml_files=$gml_files $multi $spatial_extent"
