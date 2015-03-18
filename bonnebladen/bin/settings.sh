# Settings voor bonnetrans.sh script
# Bepaal onze home/bin dir
HOME_DIR=`dirname $0`/..
HOME_DIR=`(cd "$HOME_DIR"; pwd)`
DATA_DIR=${HOME_DIR}/data
BIN_DIR=${HOME_DIR}/bin

# Maakt plaatje lichter en scherper
# Zie http://www.imagemagick.org/script/command-line-options.php#brightness-contrast
BRIGHTNESS_CONTRAST=10x5

# Om zwarte randen weg te krijgen (Frank Steggink)
# De rotatiehoek is -0,4012 graden (dus linksom), ofwel atan(-28/3999)
# cos(hoek) = 0.999975
# sin(hoek)=-0.007002
# De 2e sin van de affine parameter is tegengesteld, dus die is hier 
# positief. Affine zet alleen de transformatiematrix klaar voor een andere 
# operatie, bijv. transform.
# 
# Bij crop treedt iets geks op. De grootte is 4000x2500 pixels. De 
# x-offset is 18 pixels, maar de y-offset, die na affine + transform 
# optreedt, is 30 pixels.  Dit is de offset als je alleen affine/transform 
# doet, maar die moet hier weggelaten worden. De verklaring is dat die 30 
# pixels offset wordt toegevoegd bij het saven van het resultaat van 
# transform. De rotatie gebeurt nl. om de linkerbovenhoek, dus de 
# correctie voor de x-offset van 18 pixels is genoeg.
AFFINE=0.999975,-0.007002,0.007002,0.999975
CROP=4000x2500+18

# tbv gdaladdo Pyramid
# TODO: mogelijk alignen met NL Tiling schema?
# number of pyramids = log(pixelsize of image) / log(2) - log (pixelsize of tile) / log(2).
# Plaatje is typisch 4018, 2527 neem grootste
# log(4200) / log(2) - log (512) / log(2) = 3.036 = ~4

GDAL_OVERVIEW_LEVELS="2 4 8 16 32"

# Mask image om randen transparant te maken
BONNE_MASK_COLOR='#FFFFFF'
BONNE_MASK_IMG=${DATA_DIR}/bonnemask.png

# Per-host settings
SETTINGS_SCRIPT="${BIN_DIR}/settings-`hostname`.sh"
. $SETTINGS_SCRIPT
