.. _brkextract:


***********
BRK-Extract
***********

Hieronder staat de handleiding voor het gebruik van de tools om de BRK Digitale Kadastrale Kaart  te extraheren. Deze tools
heten kortweg ``BRK-Extract`` of soms ``NLExtract-BRK``.

   NB: als je alleen interesse hebt om een PostGIS versie van de laatste BRK te hebben, kun
   je deze ook (betaald) downloaden als PostGIS dumpfile via de link https://geotoko.nl/.
   De dump file (``.dump`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdmin``.
   Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract-team, zie "Ondersteuning": https:/nlextract.nl.

Handleiding BRK-Extract
=======================

Algemeen
--------

BRK-Extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van de Digitale Kadastrale Kaart van Kadaster.
Dit betreft o.a. grenzen, percelen en perceelnummers uit
de `Basisregistratie Kadaster <https://www.digitaleoverheid.nl/overzicht-van-alle-onderwerpen/stelsel-van-basisregistraties/10-basisregistraties/brk/>`_ (BRK),
maar bijv geen eigendomsinformatie.

Via `PDOK wordt Digitale Kadastrale Kaart <(https://www.pdok.nl/downloadviewer/-/article/kadastrale-kaart>`_ in verschillende vormen als Open Data uitgeleverd.

De "download" bestaat uit GML-bestanden en wordt door BRK-Extract ingelezen in een PostGIS database. De huidige versie van Digitale Kadastrale Kaart is "v5".


BRK downloaden
--------------

De brondata van de BRK in GML kun je via `PDOK Kadastralekaart Download API <https://api.pdok.nl/kadaster/kadastralekaart/download/v5_0/ui/>`_ downloaden.
Voor NLExtract zijn reeds downloadscripts gemaakt, voor zowel Linux als Windows.

De BRK wordt via PDOK geleverd in ZIP-bestanden.


BRK-Extract downloaden
----------------------

Vind altijd de laatste versie op: https://github.com/nlextract/NLExtract/releases. De nieuwste versie staat bovenaan: kies de "real-release" nlextract zip.

Omdat NLExtract voortdurend in ontwikkeling is, kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone https://github.com/NLExtract/NLExtract.git
- snapshot als .zip: https://github.com/nlextract/NLExtract/archive/master.zip

Maar handiger is om Docker te gebruiken.

Ontwerp
-------

Zie https://github.com/nlextract/NLExtract/tree/master/brk .

In eerste instantie wordt de GML geconverteerd en geladen naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr binnen Stetl. Hiermee kunnen ook de meerdere geometrieën van een perceel ingelezen worden. Het GFS-bestand, een
`GDAL stuurbestand <https://github.com/nlextract/NLExtract/blob/master/brk/etl/gfs/brk.gfs>`_
voor het inlezen van GML-data via ogr2ogr, is hierop aangepast.


Zie verder :doc:`stetl-framework` voor de werking van BRK-Extract.
