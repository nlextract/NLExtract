
SETTINGS_SCRIPT="settings.sh"
. $SETTINGS_SCRIPT

# Test: converteer files voor frieslan
./bonnetrans.sh b310-1924.png  ${BONNE_DATA_HOME}/testarea-trans
./bonnetrans.sh b311-1911.png  ${BONNE_DATA_HOME}/testarea-trans
./bonnetrans.sh b328-1930.png  ${BONNE_DATA_HOME}/testarea-trans
./bonnetrans.sh b329-1922.png  ${BONNE_DATA_HOME}/testarea-trans
./bonnetrans.sh b346-1926.png  ${BONNE_DATA_HOME}/testarea-trans
./bonnetrans.sh b347-1929.png  ${BONNE_DATA_HOME}/testarea-trans

echo "Maak index.shp aan met gdaltindex in ${BONNE_DATA_HOME}/friesland-trans"
pushd ${BONNE_DATA_HOME}/testarea-trans
gdaltindex index.shp *.tif
popd
