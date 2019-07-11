# BRT - Top10NL Inlezen

Top10NL inlezen met Stetl (www.stetl.org) ETL framework.
door: Just van den Broecke en Frank Steggink

Deze map bevat de ETL configuratie en commando om via Stetl
Top10NL vanuit de bron GML bestanden naar verschillende outputs weg te schrijven.
Standaard is dit PostGIS, maar omdat output via `ogr2ogr` verloopt kan dit
elke output zijn die ogr2ogr ondersteunt, bijv SHP, GeoJSON of GeoPackage, 
in theorie ook bijv Oracle.

Om gebruik te maken van Stetl moet de externe GitHub submodule externals/stetl
aanwezig zijn.

Bij het klonen van de GitHub komt Stetl als volgt mee:

	git clone --recursive https://github.com/nlextract/NLExtract.git
	
Stetl komt dan mee, hoeft niet apart geinstalleerd, alleen de Stetl-dependencies.

Dependencies Stetl installeren:
http://www.stetl.org/en/latest/install.html

Meer over Stetl: http://stetl.org

## Commando

	./etl.sh
	Windows: etl.cmd

Gebruikt default opties (database params etc) uit `options/default.args` bestand.

Stetl configuratie, hoeft niet gewijzigd, alleen indien bijv andere output gewenst:
`conf/etl-top10nl-v1.2.cfg`

## Opties/argumenten

Een aantal opties kunnen op 2 manieren vervangen worden:

1) Impliciet: Overrule default opties (database params etc) met een eigen lokale file gebaseerd op
lokale hostnaam: `options/<jouw host naam>.args`

2) Expliciet op command line via  `./etl.sh <mijn opties file>.args` Windows: `etl.cmd <mijn opties file>.args`

Indien methode 2 gebruikt wordt, prevaleert deze boven 1 en de default opties!

Een opties-bestand hoeft niet alle argumenten te bevatten. De `options/default.args` wordt altijd
als default gebruikt. Eigen/host-based opties bestanden bevatten argumenten die de default
vervangen ("overriding"). Bijv een standaard gebruik is alleen bron GML en DB gegevens in een eigen opties bestand:

	# INPUT: bron bestanden map
	input_dir=/home/me/download/top10nl
	
	# OUTPUT: PostGIS settings
	host=mijndbhost
	user=mijnuser
	password=mijnww
	database=mijndb
	schema=mijntop10

## Database mapping

`gfs/top10-v1.2.gfs` is de GDAL/OGR "GFS Template" en bepaalt de mapping van GML elementen/attributen
naar PostGIS kolom(namen). Maak eventueel een eigen GFS file en specificeer deze in je
`options/<jouw host naam>.args`: bijv `gfs_template=gfs/mijntop10.gfs`

## TODO

* GUI
