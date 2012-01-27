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
error() {
	echo "ERROR: $1"
	exit -1
}

# Util: usage and exit
usage() {
	echo "Usage: $1 $2"
	exit -1
}

# Util: print info
pr() {
	echo "INFO: $1"
}

# Util: check if file exists
checkFile() {
    if [ ! -f $1 ]
    then
        error "Kan bestand '$1' niet vinden"
    fi
}

# Util: check if dir exists
checkDir() {
    if [ ! -d $1 ]
    then
        error "Kan directory $1 niet vinden"
    fi
}

# Util: check if var is not empty
checkProg() {
	# Check of prog is installed and can be found
	hash $1 2>&- || { echo >&2 "Kan programma $1 niet vinden. $2. Ik houd hier op..."; exit -1; }
}

# Util: check if var is not empty
checkVar() {
    if [ -z "$1" ]
    then
        error "Geen argument gegeven"
    fi
}

# Util: check if var is not empty
checkVarUsage() {
    if [ -z "$2" ]
    then
        usage "$1"
    fi
}

# Util: startProg
startProg() {
	pr "BEGIN `basename $1`: `date` $2"
}

# Util: endProg
endProg() {
	pr "END `basename $1`: `date` $2"
}
