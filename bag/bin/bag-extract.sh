#!/bin/sh
#
# Auteur: Just van den Broecke
# Shortcut script om Python bagextract.py uit te voeren
#

# Bepaal waar we zijn zodat we kunnen uitvoeren vanaf elke directory
BASEDIR=`dirname $0`/..
BASEDIR=`(cd "$BASEDIR"; pwd)`

PY_SCRIPT=$BASEDIR/src/bagextract.py

# uitvoeren Python script met alle meegegeven args
python $PY_SCRIPT $@
