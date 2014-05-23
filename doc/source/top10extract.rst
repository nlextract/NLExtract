.. _top10extract:


*************
Top10-extract
*************

Hieronder staat de handleiding voor het gebruik van de tools om Top10NL te extraheren.

Handleiding Top10-extract
=========================

Algemeen
--------

Top10NL is onderdeel van de Kadaster Basisregistratie Topografie (BRT). Vind algemene info
over Top10NL op http://www.kadaster.nl/web/artikel/productartikel/TOP10NL.htm.

NLExtract/Top10NL, kortweg Top10-Extract bevat tools om de Top10NL bronbestanden zoals geleverd door Het Kadaster (GML)
om te zetten naar hanteerbare formaten zoals PostGIS. Tevens bevat Top10-extract visualisatie-bestanden
(onder de map `style/` ) voor QGIS en SLDs om kaarten te maken. (NB deze zijn nu nog gebaseerd op Top10NL 1.0!).

Top10NL (v1.1.1) wordt geleverd door Het Kadaster als een .zip file van plm 2GB. Voor de landsdekkende
versies zijn er 2 soorten .zip-bestanden, een op basis van kaartbladen,
zie `Bestandswijzer_GML_TOP10NL_2012.pdf <https://github.com/opengeogroep/NLExtract/raw/master/top10nl/doc/Bestandswijzer_GML_TOP10NL_2012.pdf>`_
en een .zip file op basis van "GML FileChunks" waarbij de totale GML is opgedeeld in files van 300MB.

Zie verdere bijzonderheden voor de GML bestandsindeling in
`Structuur_GML_TOP10NL_1_1_1.pdf <https://github.com/opengeogroep/NLExtract/raw/master/top10nl/doc/Structuur_GML_TOP10NL_1_1_1.pdf>`_.

Er zijn 14 typen Top10NL objecten. Zie ook de Top10NL structuur-beschrijving in
`Structuur_TOP10NL_1_1_1.pdf <https://github.com/opengeogroep/NLExtract/raw/master/top10nl/doc/Structuur_TOP10NL_1_1_1.pdf>`_.

Top10NL Downloaden
------------------

Top10NL brondata in GML kun je via `PDOK Top10NL Downloads <https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-topografie/topnl/top10nl-downloads>`_ downloaden, maar
ook via OpenStreetMap-NL, zie:
http://mirror.openstreetmap.nl/kadaster/Top10NL_v1_1_1

Er zijn twee download varianten: de "GML File Chunks" en "50D Kaartbladen". De eerste is de totale verzameling opgesplitst
in 300MB GML Files, de tweede bevat de GML bestanden per kaartblad. Download de Kaartbladen alleen als je bijv. een enkel
gebied wilt inlezen of om te testen.

Als je heel Nederland wilt inlezen kun je het beste
de "GML File Chunks" gebruiken. De directe link is http://geodata.nationaalgeoregister.nl/top10nl/extract/chunkdata/actueel/gml/top10nl_gml_filechunks.zip.

Voor de Kaartbladen is dat: http://geodata.nationaalgeoregister.nl/top10nl/extract/kaartbladtotaal/actueel/gml/top10nl.zip.


`NB  heel belangrijk is om de laatste versie van Top10NL te gebruiken: v1.1.1.` Deze wordt geleverd met ingang van
september 2012. In bijv. PDOK zijn momenteel (okt 2012) nog oudere versies van Top10NL.

Top10-Extract downloaden
------------------------

Vind altijd de laatste versie op: http://www.nlextract.nl/file-cabinet

Omdat NLExtract voortdurend in ontwikkeling is kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/opengeogroep/NLExtract/archive/master.zip

Ontwerp
-------

In eerste instantie converteren/laden we de GML naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr. Echter er zijn 2 belangrijke zaken die dit lastig maken:

- meerdere geometrieën per object, bijv een Waterdeel GML element kan een lijn en een vlak bevatten
- meerdere voorkomens van een attribuut (attribute multiplicity), bijv. een Wegdeel GML element kan meerdere element-attributen genaamd "nWegnummer" bevatten

Om het eerste probleem op te lossen worden middels een XSLT script (bin/top10-split_v1_1_1.xsl) de GML
elementen uitgesplitst naar geometrie, zodat ieder element een enkele geometrie bevat. Bijvoorbeeld
Wegdeel kent maar liefst 5 geometrie-attributen. Dit wordt opgesplitst naar Wegdeel_Lijn, Wegdeel_Vlak etc.
Een nieuw GML bestand wordt hiermee opgebouwd. Vervolgens wordt via ogr2ogr dit uitgesplitste GML bestand
in PostGIS geladen.

NLExtract maakt i.h.a. gebruik van Python voor alle scripts. De Python scripts
voor Top10-extract roepen `native` tools aan:

* XML parsing via `libxml2`
* XSLT processing via `libxslt`
* GDAL/OGR `ogr2ogr`

De reden is vooral snelheid. Top10NL kan niet door `ogr2ogr` direct verwerkt worden.
Met name dienen objecten als `Wegdelen` die meerdere geometrieën bevatten
uitgesplitst te worden over objecten die een enkele geometrie bevatten, bijv. `Wegdeel_Hartlijn`
en `Wegdeel_Vlak`. Het uitsplitsen gaat met XSLT. De uitgesplitste bestanden worden tijdens
verwerken tijdelijk opgeslagen.

Afhankelijkheden
----------------

De volgende software dient aanwezig te zijn om Top10-extract te draaien.

 - Python 2.6 of hoger (niet Python 3!)
 - Python argparse package, voor argument parsing alleen indien Python < 2.7
 - PostGIS: PostgreSQL database server met PostGIS 1.x of 2.x : http://postgis.refractions.net
 - lxml voor razendsnelle native XML parsing, Zie http://lxml.de/installation.html
 - libxml2 en libxslt bibliotheken  (worden door lxml gebruikt)
 - GDAL/OGR v1.8.1 of hoger (voor ogr2ogr) http://www.gdal.org
 - NB: GDAL/OGR Python bindings zijn (voorlopig) `niet` nodig

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
``chcp 1252``.

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

Aanroep
-------

De aanroep van Top10-extract is op alle systemen hetzelfde, namelijk via Python::

    usage: top10extract.py [-h] --dir DIR [--ini SETTINGS_INI] [--pre PRE_SQL]
                       [--post POST_SQL] [--spat xmin ymin xmax ymax]
                       [--multi {eerste,meerdere,stringlist,array}]
                       [--gfs GFS_TEMPLATE]
                       [--max_split_features MAX_SPLIT_FEATURES]
                       [--skip_existing] [--pg_host PG_HOST]
                       [--pg_port PG_PORT] [--pg_db PG_DB]
                       [--pg_schema PG_SCHEMA] [--pg_user PG_USER]
                       [--pg_password PG_PASS]
                       GML [GML ...]

positionele argumenten::

  GML                   het GML-bestand of de lijst of directory met GML-bestanden

optionele argumenten::

  -h, --help            help bericht tonen en exit
  --dir DIR             lokatie getransformeerde bestanden
  --ini SETTINGS_INI    het settings-bestand (default: top10-settings.ini)
  --pre PRE_SQL         SQL-script vooraf
  --post POST_SQL       SQL-script achteraf
  --spat xmin ymin xmax ymax
                        spatial filter
  --multi {eerste,meerdere,stringlist,array}
                        multi-attributen (default: eerste)
  --gfs GFS_TEMPLATE    GFS template-bestand (default: top10-gfs-
                        template_split.xml)
  --max_split_features MAX_SPLIT_FEATURES
                        Max aantal features per XML transformatie
  --skip_existing       overschrijf al geconverteerde bestanden niet
  --pg_host PG_HOST     PostgreSQL server host
  --pg_port PG_PORT     PostgreSQL server poort
  --pg_db PG_DB         PostgreSQL database
  --pg_schema PG_SCHEMA
                        PostgreSQL schema
  --pg_user PG_USER     PostgreSQL gebruikersnaam
  --pg_password PG_PASS
                        PostgreSQL wachtwoord

Het GML-bestand of de GML-bestanden kunnen op meerdere manieren worden meegegeven:

- met 1 GML-bestand
- met bestand met GML-bestanden
- met meerdere GML-bestanden via wildcard
- met directory

NB: ook als er meerdere bestanden via de command line aangegeven kunnen worden, kunnen deze
wildcards bevatten. Een bestand wordt als GML-bestand beschouwd, indien deze de extensie GML of
XML heeft, anders wordt het als een GML-bestandslijst gezien.

Het beste kun je de `GML_Filechunks`-bestanden gebruiken (vanwege mogelijke geheugen-issues en duplicaten).
Na download moet je dus eerst de .zip file uitpakken.

Toepassen settings:

- Definitie in settings-file (top10-settings.ini)
- Mogelijk om settings te overriden via command-line parameters (alleen de PostgreSQL-settings)
- Mogelijk om settings file mee te geven via command-line

Het optionele argument --multi MULTI_ATTR specificeert hoe Top10-extract om moet gaan wanneer er meerdere attribuutwaarden
toegekent zijn aan een object, bijvoorbeeld meerdere wegnummers aan een Wegdeel. Hierbij zijn 4 mogelijke opties, (tussen haakjes de ``GDAL ogr2ogr``
opties die hieruit gegenereerd worde).

- 'eerste': gebruik de eerstvoorkomende attribuutwaarde, dit is de default (``ogr2ogr: -splitlistfields -maxsubfields 1``)
- 'meerdere' : maak meerdere kolommen aan bijv straatnaamNL1, straatnaamNL2 etc  (``ogr2ogr: -splitlistfields``)
- 'stringlist': gebruik alle waarden, encodeer als stringlijst in kolom, bijv ``(2:N242,N243)`` (``ogr2ogr: -fieldTypeToString StringList``)
- 'array': gebruik alle waarden, encodeer als PostgreSQL array-type kolom (``ogr2ogr: geen optie``)

Van belang te vermelden is dat in Top10NL 1.1.1 er sprake van prioritering, d.w.z. bij meerdere waarden is de eerste waarde
de belangrijkste waarde.

De directory die met ``--dir`` wordt meegegeven wordt gebruikt om bestanden
tussendoor op te slaan: eerst wordt de informatie uit de bronbestanden omgezet
en gefiltert en in die directory neergezet. Daarna worden ze overgezet naar de
database.

- Mocht het geheugengebruik een probleem zijn, dan kan het een oplossing zijn
  met ``--max_split_features`` een kleiner aantal features in de tussendoor
  opgeslagen bestanden te zetten. Standaard is het 30000, dus probeer dan
  bijvoorbeeld ``--max_split_features 10000``.

- Als er iets triviaals mis gaat bij het importeren in de database
  (bijvoorbeeld door een typfout in het wachtwoord) is het vervelend als de
  hele eerste import-stap opnieuw uitgevoerd moet worden. Met
  ``--skip_existing`` worden de al omgezette en gefilterde bronbestanden niet
  opnieuw verwerkt.


Testen
------
Het beste is om eerst je installatie te testen als volgt:

 * pas ``bin/top10-settings.ini`` aan voor je lokale situatie
 * maak een lege database aan met PostGIS  template bijv. ``top10nl`` (createdb -T postgis)
 * in de ``top10nl/test`` directory executeer ``./top10-test.sh`` of ``./top10-test.cmd``

Valideren
---------

Sommige Top10NL files van Kadaster kunnen soms invalide GML syntax bevatten.
Valideren van een GML bestand (tegen Top10NL 1.1.1 schema) ::

  top10validate.py <Top10NL GML file> - valideer input GML

Top10NL Versies
---------------

Sinds september 2012 is er een nieuwe versie van Top10NL, versie 1.1.1. Gebruik altijd deze. Na NLExtract v1.1.2
zullen we de oude Top10NL versie niet meer ondersteunen.
