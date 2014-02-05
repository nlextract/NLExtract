#!/bin/bash
#
# Friesland voorbeeld via ImageMagick composite
#
# Auteur: Just van den Broecke
#
# Stappen:
# 1. maak een maskfile die randen wit/transparant maakt
# 2. leg maskfile over elk blad zodat randen 1 kleur/transparant/aplha zijn
# 3. voor ieder blad:
# 3.1 vind de aangrenzende bladen in N, W, Z, O die qua jaar aansluiten
# 3.2 voor iedere N,W,Z,O: leg aangrenzend blad over origineel zodat alleen de rand "ingeblend" wordt


function create_maskfile() {
  # Maak mask file met alleen de "zwarte randen"
  # bonnemask.png is maskfile die zwarte randen uniform transparant maakt
  echo "create mask file"
  /bin/rm -f bonnemask.png
  convert -colorspace sRGB -size 4019x2527 xc:none -fill '#FFFFFF' \
    -draw 'polygon 0,0 0,2466 17,0' \
    -draw 'polygon 106,0 4018,26 4018,0' \
    -draw 'polygon 4018,27 4000,2526 4018,2526' \
    -draw 'polygon 3999,2526 0,2500 0,2526' \
    bonnemask.png
}

function mask_source_file() {
  # e.g. map_num is b091-1932
  map_num=$1
  # Voor iedere kaart maak randen uniform transparant met mask file
  echo "laying bonnemask over $map_num"
  /bin/rm -f rm ${map_num}m.png
  composite -alpha on  -gravity center bonnemask.png ${map_num}.png ${map_num}m.png
}

# Leg het naburige kaartblad over target, bijvn westkant van blad b092 is overlayed met b091
# De transparante kleuren in de randen worden geblend via 'Multiply'
function create_composite() {
  src=$1
  dst=$2
  overlay=$3
  geometry=$4
  /bin/rm -f $dst

  echo "create composite: src=$src overlay=$overlay dst=$dst geometry=$geometry"
  composite -compose Multiply  -geometry $geometry $overlay $src $dst
}

function create_composite_nesw() {
  map_num=$1
  north_num=$2
  east_num=$3
  south_num=$4
  west_num=$5

  /bin/rm -f ${map_num}-result*

  echo "composite noord"
  create_composite ${map_num}m.png ${map_num}-result-n.png ${north_num}m.png "+18-2500"

  echo "composite oost"
  create_composite ${map_num}-result-n.png ${map_num}-result-no.png ${east_num}m.png "+4000+27"

  echo "composite zuid"
  create_composite ${map_num}-result-no.png ${map_num}-result-noz.png ${south_num}m.png "-18+2500"

  echo "composite west"
  create_composite ${map_num}-result-noz.png ${map_num}-result-nozw.png ${west_num}m.png "-4000-27"

  mv ${map_num}-result-nozw.png ../src-composed/${map_num}.png
}


# create_maskfile
# mask_source_file b057-1932
# mask_source_file b058-1931

# mask_source_file b073-1932
# mask_source_file b074-1931
# mask_source_file "b075-1930"
# mask_source_file "b076-1930"

# mask_source_file b090-1932
# mask_source_file "b091-1932"
# mask_source_file "b092-1928"
# mask_source_file "b093-1928"

# mask_source_file "b109-1932"
# mask_source_file "b110-1928"

# create_composite_nesw b074-1931 b057-1932 b075-1930 b091-1932 b073-1932
# create_composite_nesw b075-1930 b058-1931 b076-1930 b092-1928 b074-1931
# create_composite_nesw b091-1932 b074-1931 b092-1928 b109-1932 b090-1932
# create_composite_nesw b092-1928 b075-1930 b093-1928 b110-1928 b091-1932

