#!/bin/sh
#
# Shortcut script om Python gemeentelijke-indeling.py uit te voeren.
# Gebaseed op bag-extract.sh, auteur: Just van den Broecke.
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

PY_SCRIPT=$BASEDIR/src/gemeentelijke-indeling.py

# uitvoeren Python script met alle meegegeven args
ret=`python -c 'import sys; print("%i" % (sys.hexversion<0x03000000))'`
if [ $ret -eq 0 ]; then
    #Python 3 is de standaard, roep python aan.
    python $PY_SCRIPT "$@"
else
    python3 $PY_SCRIPT "$@"
fi
