rm *result*

# Maak mask file met alleen de "zwarte randen"
# bonnemask.png is maskfile die zwarte randen uniform transparant maakt
convert -colorspace sRGB -size 4019x2527 xc:none -fill '#FFFFFF' \
    -draw 'polygon 0,0 0,2466 17,0' \
    -draw 'polygon 106,0 4018,26 4018,0' \
    -draw 'polygon 4018,27 4000,2526 4018,2526' \
    -draw 'polygon 3999,2526 0,2500 0,2526' \
    bonnemask.png

# Voor iedere kaart maak randen uniform transparant met mask file
composite -alpha on  -gravity center bonnemask.png b092-1928.png b092-1928m.png
composite -alpha on  -gravity center bonnemask.png b091-1932.png b091-1932m.png

# Leg het naburige kaartblad over target, hier westkant van blad b092 is overlayed met b091
# De transparante kleuren in de randen worden geblend via 'Multiply'
composite  -compose Multiply  -geometry -4000-27 b091-1932m.png b092-1928m.png b092-1928-result.png
