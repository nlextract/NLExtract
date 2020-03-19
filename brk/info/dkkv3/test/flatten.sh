/bin/rm perceel-flat.gml > /dev/null 2>&1 ; ogr2ogr -overwrite  -f GML perceel-flat.gml perceel.gml
/bin/rm perceel-flat.json > /dev/null 2>&1 ; ogr2ogr -overwrite  -f GeoJSON perceel-flat.json perceel.gml
