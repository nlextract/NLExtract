#!/bin/bash
PG="PG:dbname=bagv2 active_schema=test host=localhost user=postgres password=postgres"
# ogr2ogr -f PostgreSQL "${PG}" data/lv/
# ogr2ogr -overwrite -t_srs EPSG:4326 -f PostgreSQL "${PG}" /vsizip/data/0221PND15092020.zip

ogr2ogr -overwrite -f PostgreSQL "${PG}" /vsizip/data/0221PND15092020.zip

