#!/bin/bash
#
# Restore BAG made with bag-dump.sh.
#
# Author: Just van den Broecke - 2020
#

export PGPASSWORD=postgres
pg_restore -Fc -d bag -h localhost -p 5432 -U postgres bag-test.dump
