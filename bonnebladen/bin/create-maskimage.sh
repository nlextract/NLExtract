#!/bin/bash
#
# Transformeer enkel Bonneblad van bron (PNG) naar GeoTiff.
#
# Auteur: Just van den Broecke
# Frank Steggink: ImageMagick rotatie commandline
#
# Aanroep:
# bonnetrans.sh <bonneblad bronfile naam>
# voorbeeld:
# bonnetrans.sh b027-1932.png


# In de settings file per host, staat de locatie van de bron
# .png van de Bonnebladen
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT

# Maak mask file met alleen de "zwarte randen"
convert -colorspace sRGB -size 4019x2527 xc:none -fill ${BONNE_MASK_COLOR} \
    -draw 'polygon 0,0 0,2466 17,0' \
    -draw 'polygon 106,0 4018,26 4018,0' \
    -draw 'polygon 4018,27 4000,2526 4018,2526' \
    -draw 'polygon 3999,2526 0,2500 0,2526' \
    ${BONNE_MASK_IMG}