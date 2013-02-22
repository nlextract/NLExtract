#!/bin/sh
#
# Auteur: Just van den Broecke
# Shortcut script om Python bagextract.py uit te voeren
#

# Bepaal waar we zijn zodat we kunnen uitvoeren vanaf elke directory
# werkt ook met symlinks dankzij gidema.
if [ -h "$0" ] ; then
  BASEDIR=`readlink "$0"`
  BASEDIR=`dirname "$BASEDIR"`/..
else
  BASEDIR=`dirname $0`/..
fi
BASEDIR=`(cd "$BASEDIR"; pwd)`

PY_SCRIPT=$BASEDIR/src/bagextract.py

# uitvoeren Python script met alle meegegeven args
python $PY_SCRIPT $@
