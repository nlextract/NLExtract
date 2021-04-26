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
PYTHON="$(command -v python)"
if [ -z "${PYTHON}" ]; then
  PYTHON="$(command -v python3)"
  if [ -z "${PYTHON}" ]; then
    echo "Error: No usuable python found in PATH"
    exit 1
  fi
else
  ret=`"${PYTHON}" -c 'import sys; print("%i" % (sys.hexversion<0x03000000))'`
  if [ $ret -ne 0 ]; then
    PYTHON="$(command -v python3)"
    if [ -z "${PYTHON}" ]; then
      echo "Error: No usuable python found in PATH"
      exit 1
    fi
  fi
fi

"${PYTHON}" $PY_SCRIPT "$@"
