Introductie
-----------
Met de scripts in deze directory kan data worden geëxporteerd naar verschillende 3D-formaten.
Een voor de hand liggende combinatie is de BAG en AHN2.


Gebruik
-------
usage: exportBuildings.py [-h] --format FORMAT --bbox MINX MINY MAXX MAXY
                          [--centerOnOrigin] [--pg_host PG_HOST]
                          [--pg_port PG_PORT] [--pg_db PG_DB]
                          [--pg_schema PG_SCHEMA] --pg_user PG_USER
                          --pg_password PG_PASS --pg_table PG_TABLE
                          [--ogr_tsrs OGR_TSRS]

Exporteer gebouwen naar 3D

optional arguments:
  -h, --help            show this help message and exit
  --format FORMAT       Outputformaat
  --bbox MINX MINY MAXX MAXY
                        Bounding box
  --centerOnOrigin      Centreer op oorsprong
  --pg_host PG_HOST     PostgreSQL server host (default: localhost)
  --pg_port PG_PORT     PostgreSQL server poort (default: 5432)
  --pg_db PG_DB         PostgreSQL database (default: bag)
  --pg_schema PG_SCHEMA
                        PostgreSQL schema (default: public)
  --pg_user PG_USER     PostgreSQL gebruikersnaam
  --pg_password PG_PASS
                        PostgreSQL wachtwoord
  --pg_table PG_TABLE   PostgreSQL tabel
  --ogr_tsrs OGR_TSRS   EPSG-identifer data (default: 28992)
  
Alle OGR-formaten die 3D ondersteunen, kunnen worden gebruikt, evenals de formaten "Wavefront OBJ" en "CityGML". Het
Wavefront OBJ-formaat kan worden gebruikt om de gebouwen in 3D-pakketten zoals Maya en Blender te importeren. CityGML is
toegevoegd, omdat OGR hiervoor geen standaard ondersteuning kent. De gebouwen zullen worden geëxporteerd als prisma's.

De brondata dient in een PostGIS-tabel te staan. De tabel moet tenminste de volgende attributen bevatten:
* identificatie: unieke identifier van het gebouw
* geovlak: vlakgeometrie van het gebouw
* min_height: hoogte van het grondoppervlak
* avg_height: gemiddelde hoogte van het dakoppervlak
De BAG-pandentabel van NLExtract voldoet indien hier de kolommen min_height en avg_height aan toegevoegd worden (bijv.
in een view met standaardwaarden). De hoogtedata is in meters.

Het is mogelijk om de gebouwen te herprojecteren naar een ander coördinatenstelsel. Dit is bijv. nodig voor KML en ook
om GeoJSON-data te kunnen tonen met Cesium. De hoogtedata zal in meters blijven. Verder is het mogelijk om gebouwen te
centreren op de oorsprong wanneer de optie --centerOnOrigin wordt meegegeven. In dit geval heeft herprojectie geen zin.
  
  
Voorbeelden
-----------
De volgende aanroepen exporteren de gebouwen van het centrum van Amersfoort:
python exportBuildings.py --format "Wavefront OBJ" --bbox 154750 462700 155750 463700 --pg_user bag --pg_password bag --pg_schema data --pg_table pandmethoogte > c:\temp\output.obj
python exportBuildings.py --format "CityGML" --bbox 154750 462700 155750 463700 --pg_user bag --pg_password bag --pg_schema data --pg_table pandmethoogte > c:\temp\output.city.gml
python exportBuildings.py --format "GML" --bbox 154750 462700 155750 463700 --pg_user bag --pg_password bag --pg_schema data --pg_table pandmethoogte --ogr_tsrs 4326 > c:\temp\output.gml
python exportBuildings.py --format "GeoJSON" --bbox 154750 462700 155750 463700 --pg_user bag --pg_password bag --pg_schema data --pg_table pandmethoogte --ogr_tsrs 4326 > c:\temp\output.json

Let op: de laatste twee worden geherprojecteerd naar WGS84. De eerste twee blijven in RD.
Deze voorbeelden staan ook in de samples directory.


Afhankelijkheden
----------------
Dit Python-project kent de volgende verplichte afhankelijkheden:
* psycopg2: Python-binding voor PostgreSQL

Dit Python-project kent de volgende optionele afhankelijkheden, afhankelijk van het outputformaat:
* Triangle: Triangulatie (alleen Wavefront OBJ)
* LXML: XML library (alleen CityGML)
* Osgeo: GDAL/OGR Python bindings (alleen OGR-formaten)

De bindings, m.u.v. triangle, zijn voor Windows hier te vinden: http://www.lfd.uci.edu/~gohlke/pythonlibs/

Triangle is hier te vinden: http://dzhelil.info/triangle/. Easy-install aanroep: python -m easy_install triangle
Let op: Triangle mag niet worden gebruikt in commerciële applicaties, zonder een licentie van de auteur John Shewchuk. Zie voor meer info: http://www.cs.cmu.edu/~quake/triangle.html
