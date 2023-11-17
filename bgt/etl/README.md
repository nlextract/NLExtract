# BGT / IMGeo inlezen met Stetl (www.stetl.org) ETL framework.

door: Just van den Broecke en Frank Steggink

Deze map bevat de ETL configuratie en commando om via Stetl
BGT / IMGeo vanuit de bron GML bestanden naar verschillende outputs weg te schrijven.
Standaard is dit PostGIS, maar omdat output via ogr2ogr verloopt kan dit
elke output zijn die ogr2ogr ondersteunt, bijv SHP, GeoJSON of GeoPackage, in theorie ook bijv Oracle.

Om gebruik te maken van Stetl moet de externe GitHub submodule externals/stetl
aanwezig zijn.

Bij het klonen van de GitHub komt Stetl als volgt mee:
`git clone --recursive https://github.com/nlextract/NLExtract.git`
Stetl komt dan mee, hoeft niet apart geinstalleerd, alleen de Stetl-dependencies.

Dependencies Stetl installeren:
https://www.stetl.org/en/latest/install.html

Meer over Stetl: https://stetl.org

## Downloaden GML

Met het hulpscript `download-bgt.sh <doelbestand>` kan de hele BGT eerst gedownload worden naar een doelbestand.
Windows: `download-bgt.cmd <doelmap>` TODO
NB, soms zijn de gedownloade files 0 bytes. Oorzaak is vreemd HTTPS probleem PDOK vermoedelijk. Dit is
ondervangen door het downloaden met wget in een loop uit te voeren en vervolgens met unzip de inhoud
te controleren.

Op Windows heb je wget en unzip nodig om de bestanden te downloaden. De executables hiervan moeten in de
PATH environment variabele staan.
wget: https://eternallybored.org/misc/wget/
unzip: http://gnuwin32.sourceforge.net/packages/unzip.htm

## Commando

`./etl.sh`
Windows: `etl.cmd `

Gebruikt default opties (database params etc) uit options/default.args.

Stetl configuratie, hoeft niet gewijzigd, alleen indien bijv andere output gewenst:
`conf/etl-imgeo-v2.1.1.cfg`

## Opties/argumenten

Een aantal opties kunnen op 2 manieren vervangen worden:

* Impliciet: Overrule [default opties](options/default.args) (database params etc) met een eigen lokale file gebaseerd op  lokale hostnaam: `options/<jouw host naam>.args`
* Expliciet op command line via  `./etl.sh <mijn opties file>.args` of (Win) `etl.cmd <mijn opties file>.args`

Indien methode 2 gebruikt wordt, prevaleert deze boven 1 en de default opties!

## Database mapping

[gfs/imgeo-v2.1.1.gfs](gfs/imgeo-v2.1.1.gfs) is de GDAL/OGR "GFS Template" en bepaalt de mapping van GML elementen/attributen
naar PostGIS kolom(namen). Maak eventueel een  eigen GFS file en specificeer deze in je
`options/<jouw host naam>.args`: bijv `gfs_template=gfs/mijnbgk.gfs`

## BGT Lean

Om een compactere BGT te krijgen kan na bovenstaande handmatig 
het script [bgt-lean.sql](sql/bgt-lean.sql) gedraaid worden met bijv `psql`.
Deze zal de complete BGT in schema `latest` omzetten naar een 'lean' versie in eigen schema `bgt_lean`.
