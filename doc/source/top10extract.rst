.. _top10extract:


************
top10extract
************

Hieronder staat de handleiding voor het gebruik van de tools om top10NL te extraheren.

Handleiding top10-extract
=========================

Algemeen
--------
NLExtract/Top10NL, kortweg Top10Extract bevat tools de Top10NL geleverd door Het Kadaster (GML)
om te zetten naar hanteerbare formaten zoals PostGIS. Tevens bevat Top10Extract visualisatie-bestanden
(onder style map) voor QGIS en SLDs om kaarten te maken.

Uitleg
------

Top10NL wordt geleverd door Het Kadaster als een .zip file van plm 2GB. Daarin zit weer een zipfile
en een PDF (zie doc/TOP10NL_GML_Bestandswijzer_2011.pdf).

In de resulterende zipfile, genaamd bijvoorbeeld TOP10NL_GML_50D_Blokken_september_2012.zip
zitten plm 110 GML bestanden. Ieder GML bestand komt overeen met een "kaartblad"
(zie doc/TOP10NL_GML_Bestandswijzer_2011.pdf ) met daarin alle Top10NL objecten voor dat gebied.
Er zijn 14 typen Top10NL objecten. Zie ook de beschrijving in doc/structuur-top10nl-0.2.pdf.

In eerste instantie converteren/laden we de GML naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr. Echter er zijn 2 belangrijke zaken die dit lastig maken:

- meerdere geometrieen per object, bijv een Waterdeel GML element kan een lijn en een vlak bevatten
- meerdere voorkomens van een attribuut (attribute multiplicity), bijv. een Wegdeel GML element kan meerdere element-attributen genaamd "nwegNummer" bevatten

Om het eerste probleem op te lossen worden middels een XSLT script (bin/top10-split-geom.xsl) de GML
elementen uitgesplitst naar geometrie, zodat ieder element een enkele geometrie bevat. Bijvoorbeeld
Wegdeel kent maar liefst 5 geometrie attributen. Dit wordt opgesplitst naar Wegdeel_Lijn, Wegdeel_Vlak etc.
Een nieuw GML bestand wordt hiermee opgebouwd. Vervolgens wordt via ogr2ogr dit uitgesplitste GML bestand
in PostGIS geladen.

Top10NL Downloaden
------------------

Uiteraard heb je Top10NL brondata nodig. Deze kun je via http://kadaster.nl/top10nl vinden, maar
we hebben ook een directe download link beschikbaar met dank aan OpenStreetMap-NL, zie:
http://mirror.openstreetmap.nl/kadaster/Top10NL_v1_1_1

``NB  heel belangrijk is om de laatste versie van Top10NL te gebruiken: v1.1.1.`` Deze wordt geleverd met ingang van
september 2012. In bijv. PDOK zijn momenteel (okt 2012) nog oudere versies van Top10NL.

top10-extract downloaden
------------------------

Vind altijd de laatste versie op: http://www.nlextract.nl/file-cabinet

Omdat NLExtract voortdurend in ontwikkeling is kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/opengeogroep/NLExtract/zipball/master

Installatie
-----------
NLExtract maakt i.h.a. gebruik van Python voor alle scripts.

Vereist:
- Python 2.6 of hoger (niet Python 3!)
- lxml
- libxml2 en libxslt bibliotheken
- GDAL/OGR v1.8.1 minimaal (voor ogr2ogr) http://www.gdal.org

Ubuntu/Debian
apt-get install gdal-bin
apt-get install xmlstarlet (of apt-get install xsltproc)

Testen
------
Het beste is eerst te testen als volgt:

- pas `bin/top10-settings.ini` aan voor je lokale situatie
- maak een lege database aan met PostGIS  template bijv. ``top10nl`` (createdb -T postgis)
- in de ``top10nl/test`` directory executeer ``./top10-test.sh`` of ``./top10-test.cmd``

Hoe te gebruiken ?
------------------
Onder bin/ staan Python-scripts om de conversies (ook wel ETL, Extract Transform Load geheten)  te doen.

``pas eerst bin/top10-settings.ini aan m.n. voor je lokale database en ogr2ogr opties``

top10-extract.py <file of directory> - converteert 1 enkele GML file of hele directory met GML files naar PostGIS

top10-trans.py is een hulp script dat aangeroepen wordt door top10-extract.py

Valideren
---------

Sommige Top10NL files van Kadaster blijken invalide GML syntax te bevatten.

top10-validate.py <Top10NL GML file> - valideer input GML

Voorbeeld:

top10-validate.py  06_west.gml

geeft output:

   06_west.gml:65535: element geometrieLijn: Schemas validity error :
   Element '{http://www.kadaster.nl/top10nl}geometrieLijn': This element is not expected.
   06_west.gml - invalid

(Top10NL versie van 11.nov.2011)

Top10NL Versies
---------------

Sinds september 2012 is er een nieuwe versie van Top10NL, versie 1.1.1. Gebruik altijd deze. Na NLExtract v1.1.2
zullen we de oude Top10NL versie niet meer ondersteunen.



