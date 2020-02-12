.. _bagextract:


***********
BAG-Extract
***********

Hieronder staat de handleiding voor het gebruik van de tools voor de BAG, NLExtract-BAG of BAG-Extract geheten.

Handleiding BAG-Extract
=======================

BAG-Extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van Kadaster BAG
(Basisregistratie Adressen en Gebouwen) GML leveringen in (voorlopig) een Postgres/Postgis database.

BAG Bronbestanden downloaden
----------------------------

De BAG Leveringsbestanden (totaal plm 1.5 GB .zip) worden iedere maand ververst en zijn te downloaden via deze
PDOK link: http://geodata.nationaalgeoregister.nl/inspireadressen/atom/inspireadressen.xml (Atom feed).
Als je wilt testen met een kleiner bestand kun je via https://data.nlextract.nl/bag/bron/BAG_Amstelveen_2011feb01.zip
ook de "BAG Amstelveen" (5.6 MB) downloaden. Let wel dat de bestandsstructuur van de Amstelveen-levering afwijkt van de tegenwoordige BAG-leveringen.

BAG PostGIS dumps downloaden
----------------------------

Als je geen zin/tijd hebt om NLExtract-BAG zelf te installeren en te draaien, dan kun je ook de
PostGIS database en CSV adressen dumps downloaden via https://geotoko.nl.
Deze worden maandelijks ververst direct na uitkomen nieuwe BAG-levering. Een leveringsbijdrage is vereist.

Wat doet BAG-Extract?
---------------------

BAG-Extract biedt de volgende functionaliteiten:

- Laden van een Kadaster BAG Extract vanuit Kadaster (.zip GML) levering
- Toepassen van Kadaster BAG mutaties vanuit Kadaster (.zip GML) levering (v1.1.5 en hoger)
- Verrijken BAG met gemeenten en provincies
- Verrijken: tabel met volledige "ACN-achtige" adressen genereren
- Geocoderen: afgeleide tabellen en functies
- Stijlen (SLDs) om de ingelezen BAG data te visualiseren via een WMS
- Validatie van input vlak geometrie
- Database VIEWs om bagobjecten te selecteren die actueel, bestaand en valide geometrie hebben
- Checkpointing: bijhouden welke bestanden reeds verwerkt t.b.v. herstarts en mutatie-verwerking
- Logging in database zodat gechecked kan worden waar evt fouten zijn en welke bestanden verwerkt

BAG-Extract downloaden
----------------------

- download NLExtract, zie laatste versie op: https://github.com/nlextract/NLExtract/releases. De nieuwste versie staat bovenaan: kies de "real-release" nl  extract zip.
- of snapshot (huidige repo versie) via git: git clone http://github.com/opengeogroep/NLExtract.git
- of snapshot als .zip: https://github.com/nlextract/NLExtract/zipball/master

Afhankelijkheden
----------------

- PostgreSQL: relationele database, minimaal versie 9.1, optimaal is versie 9.5, Aangemaakte DB moet **UTF8 encoding** hebben. zie http://www.postgresql.org
- PostGIS: spatial extensie PostgreSQL, bijv. opslag geodata, minimaal versie 2.0, optimaal is versie 2.2, zie http://postgis.org
- Python: versie 2, minimaal versie 2.4.3, beste is 2.7 voor lxml, geen Python 3
- Python argparse package, voor argument parsing alleen indien Python < 2.7
- psycopg2: Python PostgreSQL client bibliotheek. Zie http://initd.org/psycopg
- lxml voor razendsnelle native XML parsing, Zie http://lxml.de
- GDAL/OGR tools en bibliotheek voor geodata manipulatie. Minimaal 1.8.1. Zie http://gdal.org
- GDAL/OGR Python bindings Zie www.gdal.org en http://pypi.python.org/pypi/GDAL voor Geometrie parsing/validatie en manipulatie

Installatie (Linux)
-------------------

- Ubuntu: beste is om eerst UbuntuGIS PPA aan je package repo toe te voegen, voor laatste versie Geo-tools als GDAL en PostGIS. ::

    apt-get install python-software-properties
    add-apt-repository ppa:ubuntugis/ubuntugis-unstable
    apt-get update

- Ubuntu: PostgreSQL+PostGIS . PostgreSQL is een OS relationele database (RDBMS). PostGIS is een extentie die van PostgreSQL een ruimtelijke (spatial) database maakt. Installatie PostgreSQL 9.1 + PostGIS 2.1 ::

    $ apt-get install postgis postgresql-9.1 postgresql-contrib

    # Server Instrumentation, met admin pack.
    $ sudo -u postgres psql
    psql (9.1.10)
    Type "help" for help.

    postgres=# CREATE EXTENSION adminpack;
    CREATE EXTENSION

    # Installatie controleren met ::

    $ psql -h localhost -U postgres template1

    $ pg_lsclusters
    Ver Cluster Port Status Owner    Data directory               Log file
    9.1 main    5432 online postgres /var/lib/postgresql/9.1/main /var/log/postgresql/postgresql-9.1-main.log

    # Enablen locale connecties in ``/etc/postgresql/9.1/main/pg_hba.conf``.

    # Database administrative login by Unix domain socket
    local   all             postgres                                md5

    # TYPE  DATABASE        USER            ADDRESS                 METHOD

    # "local" is for Unix domain socket connections only
    local   all             all                                     md5
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            md5
    # IPv6 local connections:
    host    all             all             ::1/128                 md5


    # PostGIS en template opzetten. Ook dit nodig om Postgis extension aan te maken.
    $ apt-get -s install postgresql-9.1-postgis-2.1

    # Anders krijg je op ``CREATE EXTENSION postgis`` dit ::

    # ERROR: could not open extension control file "/usr/share/postgresql/9.1/extension/postgis.control": No such file or directory

    # Template DB``postgis2`` opzetten. ::

    $ su postgres
    createdb postgis2
    psql -h localhost postgis2
    postgis2=# CREATE EXTENSION postgis;
    # CREATE EXTENSION
    postgis2=# CREATE EXTENSION postgis_topology;
    # CREATE EXTENSION

    # Nieuwe database "bag" aanmaken met template "postgis2"
    # NB belangrijk is dat de bag DB de character-set UTF8 (-E UTF8) heeft!
    createdb --owner postgres -T postgis2 -E UTF8 bag

- optioneel: Python package afhankelijkheden installeren bijv
  ::

   apt-get of yum install python-setuptools (voor easy_install commando)
   apt-get of yum install python-devel (tbv psycopg2 bibliotheek)
   apt-get of yum install postgresql-devel (tbv psycopg2 bibliotheek)

- Onder Ubuntu zijn dat de volgende packages
  ::

   sudo apt-get install python-setuptools
   sudo apt-get install python-dev
   sudo apt-get install libpq-dev

- razendsnelle native XML parsing met libxml2/libxslt libraries samen met Python lxml:
  kan meer dan een factor twee in snelheid schelen...
  Zie http://lxml.de/installation.html
  ::

   apt-get of yum install libxml2
   apt-get of yum install libxslt1.1
   apt-get of yum install python-lxml

- GDAL (www.gdal.org) met Python bindings voor OGR geometrie-parsing en geometrie-validatie (NLX v1.1.0 en hoger)
  ::

   apt-get of yum install gdal-bin
   apt-get of yum install python-gdal

- de PostgreSQL python bibliotheek psycopg2
  ::

   sudo easy_install psycopg2

- Python package "argparse"
  ::

   sudo easy_install argparse

- NB als je een proxy gebruikt via http_proxy  doe dan easy_install -E (exporteer huidige environment)

Installatie (Windows)
---------------------

De installatie van BAG-Extract op Windows werd in het verleden gekenmerkt door lastige installaties, vanwege het feit dat open source ontwikkeling op Windows gefragmenteerd plaatsvindt. Tegenwoordig is het een stuk gemakkelijker om BAG-Extract aan de praat te krijgen. Als je zelf BAG-Extract wilt uitvoeren, voer dan onderstaande beschrijving uit. Voor het gebruiken van de PostGIS-dump, volg dan de instructie die door Geert Doornbos beschikbaar is gesteld (`work in progress <https://github.com/nlextract/NLExtract/issues/186>`_).

Benodigdheden:

- PostgreSQL 9.x: https://www.postgresql.org/download/. 
- PostGIS 2.x: wordt geïnstalleerd via de Stack Builder van PostgreSQL.
- Python 2.7: https://www.python.org/downloads/windows/, momenteel is versie 2.7.11 de meest recente versie. Neem de 64-bits versie als je een 64-bits machine hebt. Let op, als je Python via de hoofdpagina downloadt, krijg je de 32-bits versie.
- Recente GDAL-versie (1.11 of 2.x): te installeren via `QGIS <http://www.qgis.org/en/site/forusers/download.html>`_ of via de `OSGeo4W installer <http://trac.osgeo.org/osgeo4w/>`_ (niet getest).
- Python bindings: http://www.lfd.uci.edu/~gohlke/pythonlibs/. Nodig zijn:

  - lxml (alleen getest met lxml-3.4.4)
  - psycopg (dit is Psycopg2)
  - gdal
  
  Neem de cp27-versies. Neem de win_amd64.whl-versie als je 64-bits Python gebruikt.
  
Let bij het downloaden van de software of je de 32-bits of de 64-bits versie gebruikt. De 64-bits versie werkt op de meeste recente computers. De 32-bits versie werkt op alle Windows-computers, maar issues met het geheugen zijn dan niet uitgesloten.

Installatie:

- PostgreSQL, PostGIS en het aanmaken van een spatial database: zie de instructie voor het terugzetten van de PostgreSQL dump. Kort gezegd komt het op het volgende neer:

  - PostgreSQL: voer de installer uit.
  - PostGIS: via de Stack Builder van PostgreSQL.
  - Aanmaken BAG-gebruiker en database: via pgAdmin III of via de commandline (niet beschreven).
  
- Python: voer de installer uit. Python 2.7.11 wordt helaas met een verouderde versie van Pip meegeleverd. Deze dient geüpgrade te worden naar versie 8. Dit is nodig voor het installeren van de Psycopyg-wheel. Commando::
    
    python -m pip install -U pip
    
  Je kunt ook pip rechtsteeks aanroepen. Voeg dan de Python scripts-directory eerst toe aan de PATH-variabele.

- Python dependencies::

    python -m pip install <wheel>.whl
    
- GDAL: voer de installer van QGIS uit. Natuurlijk is niet altijd QGIS nodig, zeker op een server-omgeving. Op een desktop is het wel aan te bevelen, zodat je gelijk het resultaat in de database kunt controleren. Op een server kun je de OSGeo4W-installer gebruiken. Dit is niet getest met NLExtract.

Zie Instellingen_ voor de configuratie en het gebruik van BAG-Extract.
    

Installatie (Mac OSX)
---------------------

Voor Mac OSX zijn meerdere mogelijkheden. Hieronder wordt uitgegaan van MacPorts http://www.macports.org, een Unix package
manager waarmee je gemakkelijk tools en bibliotheken en hun afhankelijkheden  kunt installeren.
MacPorts is sowieso aan te bevelen als je meerdere Unix/Linux tools gaat gebruiken. Python is al aanwezig
op de Mac en is bruikbaar, de versie van Python kan afhankelijk zijn van je OSX versie. Probeer te vermijden om Python
te installeren  tenzij je precies weet wat je doet. Ook het `easy_install` Python programma zou al aanwezig moeten
zijn. Al het onderstaande doe je in de Terminal.

Onder de manier die  Just, een van de NLExtract ontwikkelaars gebruikt. (NLExtract werkt dus op de Mac!).

- Python, 2.6.1 of hoger, liefst 2.7+.  2.6.1 Mac-versie werkt.

- Python package "argparse" installeren (alleen nodig voor Python < 2.7)
  ::

    sudo easy_install argparse

- libxml2 en libxslt: via MacPorts:
  ::

    sudo port install libxml2
    sudo port install libxslt

- lxml
  ::

    sudo easy_install lxml

- GDAL: KyngChaos (indien MacPorts GDAL-versie < 1.8.1 is) : http://www.kyngchaos.com/software/index Download en install `GDAL Complete`.

- GDAL-Python bindings (zijn mogelijk al via GDAL beschikbaar?)

- Postgres client psycopg2
  ::

    sudo python easy_install psycopg2

Commando
--------

- direct via python "python src/bagextract.py"
- of (Unix,Linux,Mac) via shell script: "bin/BAG-Extract.sh"
- Windows: voorlopig alleen via "python src/bagextract.py"

 Alle commando's werken onafhankelijk van de plek (directory) waar ze aangeroepen worden

Instellingen
------------

- extract.conf
    Configuratiebestand dat nodig is bij het uitvoeren van de programma's.
    Dit bestand bevat de volgende instellingen:
    - database naam van de Postgres database
    - schema   [optioneel] schemanaam of schema search path waar de tabellen worden aangemaakt (default "public")
    - host     host waar de Postgres database draait
    - user     user voor toegang tot de Postgres database
    - password password van de user voor toegang tot de Postgres database

    Deze  settings kunnen via commandline opties of via -f <mijn conf file> overuled worden, bijv.
    bagextract.py -H localhost -d bag -U postgres -W postgres -c
    bagextract.py -f mijn.conf -c

Voorbeelden
-----------

0. Help en opties:

    python src/bagextract.py -h
    of
    bin/BAG-Extract.sh -h

    Alle commando's kunnen via Python of shell .sh script uitgevoerd vanaf elke directory.

1. Initialiseer de database en vul/verrijk met referentie-koppeldata (gemeenten/provincies) (-c)::

    python bagextract.py -c
    of
    bag-extract.sh -c

    # -c vraagt gebruiker interactief voor bevestinging. Met -j (ja-optie) is er geen prompt. Handig voor batch-situaties
    python bagextract.py -cj
    of
    bag-extract.sh -cj

2. Importeer een extract in de database (-e)::

    python bagextract.py -e 9999STA01052011-000002.xml
    python bagextract.py -e 9999STA01052011.zip

    -e werkt op directory, file of .zip inclusief mutatie-bestanden


3. Verrijken: genereren gemeente + provincie tabellen met geometrie uit woonplaatsen aggregeren
    NB Doe altijd eerst stappen 1-2 anders blijft de tabel "gemeente" leeg. !  ::

     python bagextract.py -v -q ../db/script/gemeente-provincie-tabel.sql

    Met de -q (query) optie kan elk SQL bestand worden uitgevoerd


4. Verrijken: aanmaken tabel met volledige "ACN-achtige" adressen uit BAG + gemeente + provincie tabellen
   (kan lang duren op gehele BAG, lijkt sneller te gaan via "psql" Postgres commando).
   NB Doe altijd eerst stappen 1-3! ::

     psql -d bag < ../db/script/adres-tabel.sql

   Gebruik het psql commando "set search_path to <your schema>,public; "
   als je de adres-tabel in een expliciet Postgres schema wilt. Bijv ::

        # set search_path to bag,public;
        # \i /opt/nlextract/git/bag/db/script/adres-tabel.sql

5. Geocoding : zie tabellen en functies onder db/script/geocode
    De BAG is niet standaard geschikt om geocoding op uit te voeren.
    Daartoe dienen eerst afgeleide tabellen te worden aangemaakt
    en hulp functies voor met name "reverse geocoding" (vind adres
    voor x,y coordinaten).

Issues
------

Het is mogelijk de hele BAG .zip levering in te lezen vanuit de "hoofd" zip, maar dit kan
soms geheugen-problemen opleveren. De voorlopige oplossing is om de hoofdzip uit te pakken in een enkele
directory en dan de (7) individuele BAG .zip files te extraheren.

Het (geometrisch) aggregeren van woonplaatsen naar gemeenten en vervolgens naar provincies
kent een probleem waarbij uit PostGIS de volgende melding komt:
"NOTICE:  TopologyException: found non-noded intersection between LINESTRING (...) at ...
ERROR:  GEOS union() threw an error!". Dit is mogelijk een bug in "libgeos" (GEOS) een library gebruikt
door PostGIS. Dit probleem trad op in GEOS v3.2.2 maar niet in versie 3.3.1.

Het script db/script/adres-tabel.sql vergt 20 minuten tot enkele uren. Vaak afhankelijk van je machine maar
vooral ook je PostgreSQL instellingen. Beste is om deze met standaard PSQL uit te voeren.

Het resultaat van het genereren van gemeenten en provincies uit woonplaats geometrieen is nog "rommelig":
veel kleine polygonen. Die willen we nog uitfilteren.

Bij foutmeldingen als *COPY failed for table "nummeraanduiding": ERROR: value too long for type character varying(20)*
heeft je "bag" database niet de **UTF8 character encoding** (zie boven). Check bij aanmaken, vooral op Windows,
of je DB de character-encoding UTF8 heeft. Is later aan te passen.
Zie ook `dit issue <https://github.com/nlextract/NLExtract/issues/217>`_.

Zie http://docs.kademo.nl/project/bagextract.html voor een installatie voorbeeld.

