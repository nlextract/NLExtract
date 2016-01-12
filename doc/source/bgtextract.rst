.. _bgtextract:


***********
Bgt-extract
***********

Hieronder staat de handleiding voor het gebruik van de tools om BGT te extraheren. Deze tools
heten kortweg ``Bgt-extract`` of soms ``NLExtract-BGT``.

.. NB: als je alleen interesse hebt om een PostGIS versie van de laatste TOP10NL te hebben, kun
   je deze ook downloaden als PostGIS dumpfile via de link http://data.nlextract.nl/top10nl.
   De dump file (``.backup`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdminIII``.
   Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract-team, zie "Ondersteuning": http://www.nlextract.nl/issues.

Handleiding BGT-extract
=======================

Algemeen
--------

Bgt-extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van de Basisregistratie Grootschalige Topografie (BGT). Deze open dataset bestaat uit een aantal GML-bestanden en wordt (voorlopig) ingelezen in een PostgreSQL/PostGIS database.

Er zijn 41 typen BGT-objecten (featureklassen). Iedere featureklasse heeft een groot aantal attributen en meestal ook meerdere geometrie-attributen. De BGT is gebaseerd op CityGML. Hierdoor biedt het datamodel ruimte voor toekomstige uitbreiding, bijv. de toevoeging van 3D-geometrie. Zie voor de beschrijving van de structuur en verdere bijzonderheden voor de GML-bestandsindeling de documentatie op `BGTweb <https://bgtweb.pleio.nl/documentatie>`_.

BGT downloaden
--------------

De brondata van de BGT in GML kun je via `PDOK Download Basisregistratie Grootschalige Topografie <https://www.pdok.nl/nl/producten/pdok-downloads/download-basisregistratie-grootschalige-topografie>`_ downloaden.

De BGT wordt via PDOK geleverd in ZIP-bestanden. Het is mogelijk om zowel een landelijk bestand als deelbestanden te downloaden. De laatste zijn opgedeeld in een grid van 2x2, 4x4, 8x8, 16x16, 32x32 en 64x64 km. Het is niet mogelijk om de BGT van een gemeente, provincie of een zelf te definiëren gebied via PDOK te downloaden.

De BGT is beschikbaar in meerdere varianten:
* Met of zonder plaatsbepalingspunten: deze worden door NLExtract ondersteund. Vanwege de omvang van de data wordt sterk aanbevolen om de variant zonder plaatsbepalingspunten te gebruiken.
* GML of GML Light: alleen GML wordt ondersteund.

De BGT bestaat uit zowel een verplicht (BGT) als optioneel (IMGeo) deel. Dit is het zogenaamde "plus"-deel, welke ook door NLExtract wordt ondersteund. Dit laatste bestaat uit nieuwe featureklassen en extra attributen bij bestaande featureklassen.

Momenteel (januari 2016) zijn veel bronhouders bezig om de BGT te vullen. De omvang van het BGT ZIP-bestand van heel Nederland, zonder plaatsbepalingspunten, was op 12 januari jl. 1,91 GB. Voor de kerst, op 21 december jl., was het slechts 1,41 GB. De verwachting is dat het ZIP-bestand van heel Nederland uiteindelijk bijna 50 GB zal zijn. 

Als je heel Nederland wilt inlezen, kun je het beste het bestand exclusief plaatsbepalingspunten, GML-variant, gebruiken. Zie PDOK voor de directe link. Deze verandert namelijk iedere dag.

Top10-Extract downloaden
------------------------

Vind altijd de laatste versie op: http://www.nlextract.nl/file-cabinet (TODO, niet actueel).

Omdat NLExtract voortdurend in ontwikkeling is, kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/opengeogroep/NLExtract/archive/master.zip

Ontwerp
-------

In eerste instantie wordt de GML geconverteerd en geladen naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr. Echter, het feit dat er meerdere geometrieën per object kunnen voorkomen, maakt dit lastiger. De meeste objecten bevatten zowel een LoD 0-geometrie als een 2D-geometrie. Sommige objecten bevatten tevens een kruinlijn-geometrie. De BGT bevat geen attributen met multipliciteit, d.w.z. meerdere voorkomens van een attribuut.

Om het eerste probleem op te lossen worden middels een XSLT script (etl/xsl/imgeo-split_v2.1.1.xsl) de
GML-elementen uitgesplitst naar geometrie, zodat ieder element een enkele geometrie bevat. Bijvoorbeeld het TrafficArea-element (Wegdeel) wordt opgesplitst naar TrafficArea_2D en TrafficArea_kruinlijn. Vervolgens wordt via ogr2ogr dit uitgesplitste GML bestand in PostGIS geladen. Hierbij vindt ook de uiteindelijke vertaling van de in CityGML gedefinieerde objecten, zoals TrafficArea, naar het Nederlands plaats, zoals Wegdeel.

[TODO] Vanaf hier is de tekst gelijk aan Top10-extract. Beschrijf Stetl en de afhankelijkheden.
NLExtract maakt i.h.a. gebruik van Python voor alle scripts. De Python scripts voor Bgt-extract roepen
`native` tools aan:

* XML parsing via ``libxml2``
* XSLT processing via ``libxslt``
* GDAL/OGR ``ogr2ogr``

De reden hiervoor is vooral de snelheid. Deze native libraries zijn beschikbaar binnen Python d.m.v. zogenaamde `bindings`.

Afhankelijkheden
----------------

De volgende software dient aanwezig te zijn om Bgt-extract te draaien.

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

Bgt-extract werkt op de drie voornaamste platformen: Windows, Mac OSX en Linux. De bovengenoemde afhankelijkheden hebben ieder hun eigen handleiding voor installatie op desbetreffend platform. Raadpleeg deze als eerste. Hieronder volgt een aantal tips en bijzonderheden per platform.

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

- NB: als je een proxy gebruikt via http_proxy, doe dan easy_install -E (exporteer huidige environment)

Windows
~~~~~~~

De Python scripts zijn ontwikkeld en getest op Windows 7 met Python 2.7.

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

Stetl
-----

NLExtract gaat steeds meer gebruik maken van de ETL framework Stetl, zie http://stetl.org.
Hierdoor hoeft niet meer per dataset een apart programma worden gemaakt. Met ingang van de november-release van de BRT (2015R11) wordt alleen de "Stetl versie" ondersteund van Top10-extract.

Uitvoeren: ``./etl-top10.sh``

Opties zetten: maak hiertoe een eigen lokaal bestand in de options-directory, met de naam ``options-<hostnaam>.sh``. Default worden de opties in options.sh gebruikt. D.m.v. het lokale bestand kun je deze overriden.

De Stetl-configuratie in etl-top10nl.cfg hoeft niet te worden gewijzigd, alleen indien bijv. een andere output gewenst is.

Let op: het Windows batch-bestand etl-top10nl is een work-in-progress. Hier wordt nog aan gewerkt.
Er is een alternatief: het bash-script werkt ook op Windows via `MSYS <http://www.mingw.org/wiki/msys>`_.
Dit is een collectie van GNU-utilites, waardoor .sh-scripts uitgevoerd kunnen worden. MSYS wordt
ondermeer geïnstalleerd als onderdeel van QGIS.

Voorbeeld configuratiebestand (Windows):
::

    #!/bin/sh
    #
    # Host-specific settings - Frank's laptop

    # INPUT
    # Let op, de alternatieve syntax /c/Temp/top10nl_201511 werkt niet goed.
    export input_files=c:\\Temp\\top10_201511

    # OUTPUT
    export db_host=localhost
    export db_port=5432
    export PGUSER=top10nl
    export PGPASSWORD=top10nl
    export database=top10nl
    export schema=ttnl

    # Python settings
    # Let op: bij gebruik MSYS wordt de Python-installatie van QGIS gebruikt. Deze
    # herkent niet mijn eigen site-packages. Tevens worden dan eventuele Windows-
    # paden (bijv. naar Mapnik 2.2.0) overschreven. Dat is hier toch niet nodig.
    export PYTHONPATH=/c/python27/lib/site-packages

    # Overige opties
    export max_features=20000
  
Uitleg opties
~~~~~~~~~~~~~

De volgende opties worden samengesteld tot een command line string waarmee het Stetl-script wordt aangeroepen. De opties worden ingesteld d.m.v. het zetten van environment variabelen.

**input-files**
    Directory met inputbestanden.
    
**db_host**
    Hostnaam van de server waarop de database staat.
    
**db_port**
    Poortnummer waarmee verbinding gemaakt kan worden met de database server.

**PGUSER**
    Gebruikersnaam van de PostgreSQL gebruiker waarmee verbinding gemaakt moet worden.

**PGPASSWORD**
    Wachtwoord van de PostgreSQL gebruiker waarmee verbinding gemaakt moet worden.
    
**database**
    Naam van de database waarmee verbinding gemaakt moet worden.
    
**schema**
    Naam van het database schema die de datatabellen zal bevatten.
    
**max_features**
    Aantal features (nog niet uitgesplitst) dat tegelijkertijd geladen zal worden.
    
**multi_opts**
    Wijze waarop omgegaan moet worden met multiattributen (ogr2ogr-opties). Varianten:
        - Eerstvoorkomende attribuutwaarde: ``multi_opts=-splitlistfields~-maxsubfields 1``
        - Meerdere kolommen: ``multi_opts=-splitlistfields``
        - Stringlijst: ``multi_opts=-fieldTypeToString~StringList``
        - Array (default): ``multi_opts=~``

**spatial_extent**
    Definieert het in te lezen gebied. Formaat: ``<minx>~<miny>~<maxx>~<maxy>``. Wanneer dit leeggelaten wordt, wordt alle data ingelezen.
