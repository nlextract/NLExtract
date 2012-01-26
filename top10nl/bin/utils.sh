#!/bin/sh
#
# Common helper functions for shell scripts.
#
# Author: Just van den Broecke
#

# Log message to stdout
pr() {
    if [ -z "${1:-}" ]; then
        return 1
    fi
    echo -n " $@"
}

# Util: error mesg and exit
function error() {
	echo "ERROR: $1"
	exit -1
}

# Util: usage and exit
function usage() {
	echo "Usage: $1 $2"
	exit -1
}

# Util: print info
function pr() {
	echo "INFO: $1"
}

# Util: check if file exists
function checkFile() {
    if [ ! -f $1 ]
    then
        error "Kan bestand '$1' niet vinden"
    fi
}

# Util: check if dir exists
function checkDir() {
    if [ ! -d $1 ]
    then
        error "Kan directory $1 niet vinden"
    fi
}

# Util: check if var is not empty
function checkProg() {
	# Check of prog is installed and can be found
	hash $1 2>&- || { echo >&2 "Kan programma $1 niet vinden. $2. Ik houd hier op..."; exit -1; }
}

# Util: check if var is not empty
function checkVar() {
    if [ -z "$1" ]
    then
        error "Geen argument gegeven"
    fi
}

# Util: check if var is not empty
function checkVarUsage() {
    if [ -z "$2" ]
    then
        usage "$1"
    fi
}

# Util: startProg
function startProg() {
	pr "BEGIN $1: `date` $2"
}

# Util: endProg
function endProg() {
	pr "END $1: `date` $2"
}
