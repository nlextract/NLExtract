.. _top10extract:


*************
Top10-extract
*************

Hieronder staat de handleiding voor het gebruik van de tools om TOP10NL te extraheren. Deze tools
heten kortweg ``Top10-extract`` of soms ``nlextract-top10``.

NB als je alleen interesse hebt om een PostGIS versie van de laatste TOP10NL te hebben, kun
je deze ook downloaden als  PostGIS dumpfile via de link http://data.nlextract.nl/top10nl.
De dump file (``.backup`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdminIII``.
Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract team, zie "Ondersteuning": http://www.nlextract.nl/issues.

Handleiding Top10-extract
=========================

Algemeen
--------

TOP10NL is onderdeel van de Kadaster Basisregistratie Topografie (BRT). Vind algemene info
over TOP10NL op http://www.kadaster.nl/web/artikel/productartikel/TOP10NL.htm.

``Top10-extract`` bevat de tools om de TOP10NL GML-bronbestanden, zoals geleverd door Het Kadaster (bijv via PDOK),
om te zetten naar hanteerbare formaten zoals PostGIS. Tevens bevat Top10-extract visualisatie-bestanden
(onder de map `style/` ) voor QGIS en SLDs om kaarten te maken. (NB deze zijn nu nog gebaseerd op TOP10NL 1.0!).

TOP10NL (v1.2) wordt geleverd door Het Kadaster als een .zip file van plm 2GB. Voor de landsdekkende
versies zijn er 2 soorten .zip-bestanden, een op basis van kaartbladen,
zie `Bestandswijzer_GML_TOP10NL_2012.pdf <https://github.com/opengeogroep/NLExtract/raw/master/top10nl/doc/Bestandswijzer_GML_TOP10NL_2012.pdf>`_
en een .zip file op basis van "GML FileChunks" waarbij de totale GML is opgedeeld in files van 300MB.

Er zijn 13 typen TOP10NL objecten. Zie voor de beschrijving van de structuur en verdere bijzonderheden voor de GML bestandsindeling in
`BRT_Catalogus_Productspecificaties.pdf <https://github.com/opengeogroep/NLExtract/raw/master/top10nl/doc/1.2/BRT_Catalogus_Productspecificaties.pdf>`_ (nog gebaseerd op versie 1.1.1).

TOP10NL Downloaden
------------------

TOP10NL brondata in GML kun je via `PDOK TOP10NL Downloads <https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-topografie/topnl/topnl-actueel/top10nl>`_ downloaden.

Er zijn twee download varianten: de "GML File Chunks" en "50D Kaartbladen". De eerste is de totale verzameling opgesplitst
in 300MB GML Files, de tweede bevat de GML bestanden per kaartblad. Download de Kaartbladen alleen als je bijv. een enkel
gebied wilt inlezen of om te testen. Beide ZIP-bestanden zijn ca. 2 GB groot.

Als je heel Nederland wilt inlezen kun je het beste
de "GML File Chunks" gebruiken.
De directe link is http://geodata.nationaalgeoregister.nl/top10nlv2/extract/chunkdata/top10nl_gml_filechunks.zip?formaat=gml.

Voor de Kaartbladen is dat: http://geodata.nationaalgeoregister.nl/top10nlv2/extract/kaartbladtotaal/top10nl.zip?formaat=gml.


`NB het is heel belangrijk om de laatste versie van Top10NL te gebruiken: v1.2.` Deze wordt geleverd
met ingang van november 2015. Alleen deze versie wordt ondersteund door de huidige versie
Top10-extract. Met ingang van deze datum is ook het Kadaster volledig overgeschakeld. De oude
versies van TOP10NL worden niet meer ondersteund. Mocht je toch de oude versie willen inlezen,
gebruik dan een oude release van NLExtract.

Top10-Extract downloaden
------------------------

Vind altijd de laatste versie op: http://www.nlextract.nl/file-cabinet

Omdat NLExtract voortdurend in ontwikkeling is kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/opengeogroep/NLExtract/archive/master.zip

Ontwerp
-------

In eerste instantie wordt de GML geconverteerd en geladen naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr. Echter, er zijn 2 belangrijke zaken die dit lastig maken:

- meerdere geometrieën per object, bijv een Waterdeel GML element kan een punt, een lijn of een vlak bevatten
- meerdere voorkomens van een attribuut (attribute multiplicity), bijv. een Wegdeel GML element kan meerdere element-attributen genaamd "nWegnummer" bevatten

Om het eerste probleem op te lossen worden middels een XSLT script (etl/xsl/top10-split_v1_2.xsl) de
GML-elementen uitgesplitst naar geometrie, zodat ieder element een enkele geometrie bevat. Bijvoorbeeld
Wegdeel kent maar liefst 5 geometrie-attributen. Dit wordt opgesplitst naar Wegdeel_Lijn, Wegdeel_Vlak etc.
Een nieuw GML-bestand wordt hiermee opgebouwd. Vervolgens wordt via ogr2ogr dit uitgesplitste GML bestand
in PostGIS geladen.

NLExtract maakt i.h.a. gebruik van Python voor alle scripts. De Python scripts voor Top10-extract roepen
`native` tools aan:

* XML parsing via ``libxml2``
* XSLT processing via ``libxslt``
* GDAL/OGR ``ogr2ogr``

De reden hiervoor is vooral de snelheid. Deze native libraries zijn beschikbaar binnen Python d.m.v. zogenaamde `bindings`.

Afhankelijkheden
----------------

De volgende software dient aanwezig te zijn om Top10-extract te draaien.

 - Python 2.6 of hoger (niet Python 3!);
 - Python argparse package, voor argument parsing alleen indien Python < 2.7;
 - PostGIS: PostgreSQL 8.x of 9.x database server met PostGIS 1.x of 2.x : http://postgis.refractions.net;
   - PostgreSQL 9.x met PostGIS 2.x wordt aanbevolen.
 - ``lxml`` voor razendsnelle native XML parsing, Zie http://lxml.de/installation.html;
 - ``libxml2`` en ``libxslt`` bibliotheken  (worden door ``lxml`` gebruikt);
 - GDAL/OGR v1.8.1 of hoger (voor ``ogr2ogr``) http://www.gdal.org.

NB: GDAL/OGR Python bindings zijn (voorlopig) `niet` nodig.

Installatie
-----------

Top10-extract werkt op de drie voornaamste platformen: Windows, Mac OSX, Linux.
De bovengenoemde afhankelijkheden hebben ieder hun eigen handleiding voor
installatie op desbetreffend platform. Raadpleeg deze als eerste.
Hieronder een aantal tips en bijzonderheden per platform.

Linux
~~~~~

Gebruik onder Ubuntu altijd `Ubuntu GIS`: https://wiki.ubuntu.com/UbuntuGIS
om de laatste versies van veel packages, met name GDAL en PostGIS 1.x te verkrijgen!

- optioneel: Python package afhankelijkheden installeren bijv.
  ::

   apt-get of yum install python-setuptools (voor easy_install commando)
   apt-get of yum install python-devel (tbv psycopg2 bibliotheek)
   apt-get of yum install postgresql-devel (tbv psycopg2 bibliotheek)

- lxml
  ::

   apt-get of yum install libxml2
   apt-get of yum install libxslt1.1
   apt-get of yum install python-lxml

- GDAL
  ::

   apt-get of yum install gdal-bin

- Python package "argparse" (alleen voor Python < 2.7)
  ::

   sudo easy_install argparse

- NB als je een proxy gebruikt via http_proxy  doe dan easy_install -E (exporteer huidige environment)

Windows
~~~~~~~

De Python scripts zijn ontwikkeld en getest op Windows 7 met Python 2.7.2.

Let op: wanneer je Windows gebruikt en je wilt op de command line met PostgreSQL connecten, gebruik
``chcp 1252`` om de code page van de console bij te werken. Je krijgt anders een waarschuwing wanneer je in PostgreSQL inlogt.

In Python 2.6:

- argparse module: http://pypi.python.org/pypi/argparse
  Het gemakkelijkst is om argparse.py in de directory Python26\\Lib\\ te droppen

- Nieuw: `beschrijving installatie en run door Just (23 juni 2013) met behulp van Portable GIS <windows-usbgis.html>`_

Mac OSX
~~~~~~~

- Python, 2.6.1 of hoger, liefst 2.7+,

- Python package "argparse" (alleen voor Python < 2.7)
  ::

    sudo easy_install argparse

- libxml2 en libxslt: via MacPorts:  http://www.macports.org/

- lxml
  ::

    sudo easy_install lxml

- GDAL: KyngChaos (MacPorts GDAL-versie is vaak outdated) : http://www.kyngchaos.com/software/index Download en install `GDAL Complete`.
  Om te zorgen dat de GDAL commando's, met name `ogr2ogr` kunnen worden gevonden, kun je het volgende
  wijzigen in `/etc/profile`, die standaard Shell settings in het Terminal window bepaalt:
  ::

    export PATH=/Library/Frameworks/GDAL.framework/Versions/Current/Programs:$PATH

Versies
-------

NLExtract gaat steeds meer gebruik maken van de ETL framework Stetl, zie http://stetl.org.
Hierdoor hoeft niet meer per dataset een apart programma worden gemaakt. Met ingang van de november-release van de BRT (2015R11) wordt alleen de "Stetl versie" ondersteund van Top10-extract. Deze versie werkt ook op Windows via `MSYS <http://www.mingw.org/wiki/msys>`_. Dit is een collectie van GNU-utilites, waardoor .sh-scripts uitgevoerd kunnen worden. MSYS wordt ondermeer geïnstalleerd als onderdeel van QGIS.
en ``top10nl/bin``. Alleen de Stetl versie wordt aktief onderhouden. Het is aan te raden deze m.n. op Linux en Mac te
gebruiken (Windows versie volgt).

Stetl Versie
------------

Zie details in de README onder ``top10nl/etl``.
