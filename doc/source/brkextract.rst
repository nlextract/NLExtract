.. _brkextract:


***********
BRK-extract
***********

Hieronder staat de handleiding voor het gebruik van de tools om BRK te extraheren. Deze tools
heten kortweg ``Brk-extract`` of soms ``NLExtract-BRK``.

   NB: als je alleen interesse hebt om een PostGIS versie van de laatste BRK te hebben, kun
   je deze ook (betaald) downloaden als PostGIS dumpfile via de link https://geotoko.nl/.
   De dump file (``.dump`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdminIII``.
   Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract-team, zie "Ondersteuning": http://www.nlextract.nl/issues.

Handleiding BRK-extract
=======================

Algemeen
--------

Brk-extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van de Basisregistratie Kadaster (BRK). Deze open dataset bestaat uit een aantal GML-bestanden en wordt (voorlopig) ingelezen in een PostgreSQL/PostGIS database.

Er zijn vier typen BRK-objecten (featureklassen). Iedere featureklasse heeft een groot aantal attributen. Drie hiervan, Annotatie, Bebouwing en Kadastrale Grens, hebben één geometrie, maar Perceel heeft twee geometrieën (perceelgrens en labelpunt).

BRK downloaden
--------------

De brondata van de BRK in GML kun je via `PDOK Downloads Kadastrale Kaart <https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-kadaster/kadastrale-kaart>`_ downloaden. Voor NLExtract zijn reeds downloadscripts gemaakt, voor zowel Linux als Windows.

De BRK wordt via PDOK geleverd in ZIP-bestanden. Deze worden per provincie beschikbaar gesteld. De bestanden bevatten geen overlappende gegevens. Ieder ZIP-bestand bevat vier GML-bestanden: één bestand per featureklasse. Het is mogelijk om de kadastrale kaart via PDOK-services te downloaden, bijv. via WFS. Het inlezen van deze gegevens via NLExtract wordt niet ondersteund. De ZIP-bestanden zijn samen ca. 4 GB groot.

Brk-extract downloaden
----------------------

Vind altijd de laatste versie op: https://github.com/nlextract/NLExtract/releases. De nieuwste versie staat bovenaan: kies de "real-release" nlextract zip.

Omdat NLExtract voortdurend in ontwikkeling is, kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/nlextract/NLExtract/archive/master.zip

Ontwerp
-------

In eerste instantie wordt de GML geconverteerd en geladen naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr. GDAL/OGR versie 1.11 is de minimale versie. Hiermee kunnen ook de meerdere geometrieën van een perceel ingelezen worden. Het GFS-bestand, een stuurbestand voor het inlezen van GML-data via ogr2ogr, is hierop aangepast.

Zie verder :doc:`stetl-framework` voor de werking van Brk-extract.
