#!/bin/sh
#
# Auteur: Just van den Broecke
# Test script

bin=../bin
d=data

$bin/top10-drop-tables.sh

rm $d/*.split*

$bin/top10-extract.sh $d/test.gml

