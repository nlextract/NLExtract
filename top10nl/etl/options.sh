#!/bin/sh
#
# Options for the Stetl Top10NL extract command

# DEFAULTS
# INPUT
export input_files=test/v1_2/nlextract

# OUTPUT
export db_host=localhost
export db_port=5432
export PGUSER=postgres
export PGPASSWORD=postgres
export database=top10nl
export schema=test

# maximum number of features in memory DOM struct, typically 10000-20000
# hoger getal: betere performance maar meer geheugen...
export max_features=20

# OPTION: attribuut waarden bijv typeWeg die meerdere keren in XML voorkomen, wat daarmee te doen
# Zie ogr2ogr opties
# May use: these options
# Note: '~' is used a s space separator
# multi_opts=-splitlistfields~-maxsubfields 1
# multi_opts=-splitlistfields
# multi_opts=-fieldTypeToString~StringList
# multi_opts=~
export multi_opts="-fieldTypeToString~StringList"

# Welk gebied (clip), zet leeg voor alles
# export spatial_extent="120000~450000~160000~500000"
export spatial_extent=

# Optionally sets/overules host-specific variables
# To add your localhost add options-<your hostname>.sh in options directory
host_options=options/options-`hostname`.sh

[ -x "$host_options" ] && . $host_options

# Assemble vars for Stetl command
# No need to change beyond this point
export multi="multi_opts=$multi_opts"

# Welk gebied ?
export spatial_extent="spatial_extent=$spatial_extent"

# INPUT: gml files, point to directory or file(s) pattern
# export gml_files=/Users/just/geodata/top10nl/TOP10NL_GML_50D_Blokken_september_2012/GML_50D_Blokken/Top10NL_05Oost.gml
export gml_files=$input_files

# OUTPUT: all Postgres DB options
export pg_options="host=$db_host port=$db_port user=$PGUSER password=$PGPASSWORD database=$database schema=$schema"
