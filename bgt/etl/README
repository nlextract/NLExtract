BGT / IMGeo inlezen met Stetl (www.stetl.org) ETL framework.
door: Just van den Broecke en Frank Steggink

Deze map bevat de ETL configuratie en commando om via Stetl
BGT / IMGeo vanuit de bron GML bestanden naar verschillende outputs weg te schrijven.
Standaard is dit PostGIS, maar omdat output via ogr2ogr verloopt kan dit
elke output zijn die ogr2ogr ondersteunt, bijv SHP, GeoJSON of GeoPackage, in theorie ook bijv Oracle.

Om gebruik te maken van Stetl moet de externe GitHub submodule externals/stetl
aanwezig zijn.

Bij het klonen van de GitHub komt Stetl als volgt mee:
git clone --recursive https://github.com/nlextract/NLExtract.git
Stetl komt dan mee, hoeft niet apart geinstalleerd, alleen de Stetl-dependencies.

Dependencies Stetl installeren:
http://www.stetl.org/en/latest/install.html

Meer over Stetl: http://stetl.org

Downloaden GML
--------------

Met het hulpscript download-bgt.sh <doelmap> kan de BGT eerst gedownload worden naar een doelmap.
Windows: download-bgt.cmd <doelmap>
NB, soms zijn de gedownloade files 0 bytes. Oorzaak is vreemd HTTPS probleem PDOK vermoedelijk. Dit is
ondervangen door het downloaden met wget in een loop uit te voeren en vervolgens met unzip de inhoud
te controleren.

Op Windows heb je wget en unzip nodig om de bestanden te downloaden. De executables hiervan moeten in de
PATH environment variabele staan.
wget: https://eternallybored.org/misc/wget/
unzip: http://gnuwin32.sourceforge.net/packages/unzip.htm

Commando
--------

./etl-imgeo.sh
Windows: etl-imgeo.cmd

Gebruikt default opties (database params etc) uit options/default.args.

Stetl configuratie, hoeft niet gewijzigd, alleen indien bijv andere output gewenst:
conf/etl-imgeo.cfg

Opties/argumenten
-----------------

Een aantal opties kunnen op 2 manieren vervangen worden:

1- Impliciet: Overrule default opties (database params etc) met een eigen lokale file gebaseerd op
lokale hostnaam: options/<jouw host naam>.args

2- Expliciet op command line via  ./etl-imgeo.sh <mijn opties file>.args
                                  etl-imgeo.cmd <mijn opties file>.args

Indien methode 2 gebruikt wordt, prevaleert deze boven 1 en de default opties!

Database mapping
----------------
gfs/imgeo-v2.1.1.gfs is de GDAL/OGR "GFS Template" en bepaalt de mapping van GML elementen/attributen
naar PostGIS kolom(namen). Maak eventueel een  eigen GFS file en specificeer deze in je
options/<jouw host naam>.args: bijv gfs_template=gfs/mijnbgk.gfs

TODO
----
* GUI
