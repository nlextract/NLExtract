#!/bin/bash
PG="PG:dbname=bag active_schema=bagv2 host=localhost user=postgres password=postgres"
# ogr2ogr -f PostgreSQL "${PG}" data/lv/
ogr2ogr -overwrite -t_srs EPSG:4326 -f PostgreSQL "${PG}" /vsizip/data/0221PND15092020.zip