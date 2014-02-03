
# Test: converteer files voor frieslan
#  ./bonnetrans-affine.sh b074-1931.png
# ./bonnetrans-affine.sh b075-1930.png
# ./bonnetrans-affine.sh b091-1932.png
./bonnetrans-affine.sh b092-1928.png

SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT
# mv ${BONNE_DATA_DST_DIR}/b074-1931.tif ${BONNE_DATA_HOME}/friesland-affine
# mv ${BONNE_DATA_DST_DIR}/b075-1930.tif ${BONNE_DATA_HOME}/friesland-affine
# mv ${BONNE_DATA_DST_DIR}/b091-1932.tif ${BONNE_DATA_HOME}/friesland-affine
mv ${BONNE_DATA_DST_DIR}/b092-1928.tif ${BONNE_DATA_HOME}/friesland-affine


