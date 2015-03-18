
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT

# Test: converteer files voor frieslan
./bonnetrans.sh b074-1931.png  ${BONNE_DATA_HOME}/friesland-trans
./bonnetrans.sh b075-1930.png  ${BONNE_DATA_HOME}/friesland-trans
./bonnetrans.sh b091-1932.png  ${BONNE_DATA_HOME}/friesland-trans
./bonnetrans.sh b092-1928.png  ${BONNE_DATA_HOME}/friesland-trans

echo "Maak index.shp aan met gdaltindex in ${BONNE_DATA_HOME}/friesland-trans"
pushd ${BONNE_DATA_HOME}/friesland-trans
gdaltindex index.shp *.tif
popd
