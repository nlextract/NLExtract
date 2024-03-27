# NLExtract - BRK - DKK
BRK inlezen met [Stetl ETL framework](https://stetl.org).

door: Just van den Broecke en Frank Steggink - update 2024

Deze map bevat de ETL configuratie en commando om via [Stetl](http://stetl.org)
de BRK (Digitale Kadastrale Kaart, BRK-DKK) vanuit de gezipte
[GML bron-bestanden van PDOK](https://www.pdok.nl/nl/producten/pdok-downloads/basisregistratie-kadaster) naar verschillende outputs weg te schrijven.
Standaard is dit PostGIS, maar omdat output via [ogr2ogr](http://www.gdal.org/ogr2ogr.html) verloopt kan dit
elke output zijn die ``ogr2ogr`` ondersteunt, bijv SHP, GeoJSON of GeoPackage, in theorie ook bijv Oracle.

Om gebruik te maken van Stetl moet de externe GitHub submodule ``externals/stetl``
aanwezig zijn. Bij het klonen van de GitHub komt Stetl als volgt mee:

``git clone --recursive https://github.com/nlextract/NLExtract.git``

Stetl hoeft niet apart geinstalleerd, alleen de Stetl-dependencies.

Dependencies van Stetl installeren, zie
https://stetl.org/en/latest/install.html

Meer over Stetl: https://stetl.org

## Downloaden GML

Met het hulpscript [download-brk.sh](download-brk.sh) kan de BRK-DKK 
eerst gedownload worden naar het doelbestand `dkk-gml-nl-nohist.zip`.

Onder Windows: [download-brk.cmd <doelmap>](download-brk.cmd)   naar `doelmap/dkk-gml-nl-nohist.zip`

NB, soms zijn de gedownloade files 0 bytes. Oorzaak is vreemd HTTPS probleem bij PDOK vermoedelijk. Dit is
ondervangen door het downloaden met wget in een loop uit te voeren en vervolgens met unzip de inhoud
te controleren. Daartoe gebruiken we het script [robust-download.sh](robust-download.sh).

Op Windows heb je wget en unzip nodig om de bestanden te downloaden. De executables hiervan moeten in de
PATH environment variabele staan.
wget: https://eternallybored.org/misc/wget/
unzip: http://gnuwin32.sourceforge.net/packages/unzip.htm

## Commando

``./etl.sh``

Windows: ``etl.cmd``

Gebruikt default opties (database params etc) uit ``options/default.args``.

Stetl configuratie, hoeft niet gewijzigd, alleen indien bijv andere output gewenst:
[conf/etl-brk.cfg](conf/etl-brk.cfg)

## Opties/argumenten

Een aantal opties kunnen op 2 manieren vervangen worden:

* Impliciet: Overrule default opties (database params etc) met een eigen lokale file gebaseerd op je lokale hostnaam: ``options/<jouw host naam>.args``
* Expliciet: op command line via  ``./etl.sh <mijn opties file>.args`` Windows: ``etl-brk.cmd <mijn opties file>.args``

Indien methode 2 gebruikt wordt, prevaleren de expliciete opties-file boven 1 en de default opties!

## Database mapping

[gfs/brk.gfs](gfs/brk.gfs) is de GDAL/OGR "GFS Template" en bepaalt de mapping van GML elementen/attributen
naar PostGIS kolom(namen). Maak eventueel een eigen GFS file en specificeer deze in je
``options/<jouw host naam>.args`` (optie 1): bijv ``gfs_template=gfs/mijnbrk.gfs`` of expliciet in optie 2.

## TODO
* [GUI](https://github.com/geopython/stetl/issues/39) - funding is welkom!
