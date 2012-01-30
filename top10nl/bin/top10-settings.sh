#!/bin/sh
#
# Auteur: Just van den Broecke
#
# Instellingen voor top10 tools zoals GDAL ogr2ogr
# Verander voor je eigen omgeving.

# PostgreSQL/PostGIS database
PG_HOST=localhost
PG_DB=top10nl
PG_PORT=5432
PG_USER=postgres
PG_PASSWORD=postgres
PGCLIENTENCODING="UTF-8"

# Wat te doen met meervoudig-voorkomende elementen als "nwegnummer"
# 3 mogelijkheden:
# 1) niets doen: wordt char[] array in postgres (OGR_OPT_MULTIATTR leeg) (hier kan bijv GeoServer niet mee omgaan!)
# 2) lijst in 1 enkele string  (-fieldTypeToString StringList)
# 3) meerdere kolommen met ieder 1 waarde bijv. typeweg1, typeweg2 etc. (-splitlistfields) (kost aanzienlijk meer processing tijd)
OGR_OPT_MULTIATTR="-fieldTypeToString StringList"
# OGR_OPT_MULTIATTR=-splitlistfields
# OGR_OPT_MULTIATTR=

# Bron SRS, altijd NL RD epsg:28992
OGR_SSRS=epsg:28992

# Ken deze SRS toe aan resultaat
OGR_ASRS=epsg:28992

# Evt transformeren naar bijv Google (epsg:900913) of WGS84 (epsg:4326)
OGR_TSRS=

# In theorie kunnen we ook naar andere formaten converteren, bijv. ESRI Shape
OGR_OUT_FORMAT=PostgreSQL
OGR_OUT_OPTIONS="PG:dbname=$PG_DB host=$PG_HOST port=$PG_PORT user=$PG_USER password=$PG_PASSWORD"

# PostgreSQL Layer Creation (-lco) opties
OGR_LCO="-lco PG_USE_COPY=YES -lco PRECISION=NO -lco LAUNDER=YES"
# -lco PGSQL_OGR_FID=fid  (werkt niet)

# Overwrite of append
OGR_OVERWRITE_OR_APPEND="-append"

# Aantal records per transactie
OGR_GT="-gt 65536"

# In onderzoek...dit zou de mogelijkheid moeten geven geometrie uit te splitsen zodat we
# de XSLT niet nodig zouden hebben. Werkt in ieder geval niet in GDAL 1.8.1
# OGR_SQL="-sql "select * from waterdeel where OGR_GEOMETRY = 'LINESTRING'" -dialect OGRSQL"


