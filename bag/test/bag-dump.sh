#!/bin/sh
#
# Maak DB dump.
#

export PGPASSWORD=postgres

pg_dump \
--host localhost \
--port 5432 \
--username postgres \
--no-password \
--format custom \
--no-owner \
--compress 7 \
--encoding UTF8 \
--verbose \
--file bag-test.dump \
--schema test \
bag
