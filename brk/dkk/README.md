## Digitale Kadastrale Kaart

Just van den Broecke - dec 2015

Hier komt de ETL voor de "Digitale Kadastrale Kaart", onderdeel van de BRK met
percelen, gebouwen en annotaties.

Per 19/12/2015 te downloaden (per provincie) via data.overheid.nl:
https://data.overheid.nl/data/dataset?tags=kadastrale+percelen+perceelgrenzen
of NGR/PDOK:
http://nationaalgeoregister.nl/geonetwork/srv/dut/search#fast=index&from=1&to=50&keyword=kadastrale percelen, perceelgrenzen&relation=within

De structuur van de GML is simpel genoeg om in te lezen met GDAL ogr2ogr (1.11+) samen
met een GFS-file waarmee de geneste GML elementen kunnen worden aangeduid en
geextraheerd. Zie test/ hieronder.

