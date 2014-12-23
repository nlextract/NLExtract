.. _bagextract:


***********
Bag-extract
***********

Hieronder staat de handleiding voor het gebruik van de tools voor de BAG.

Handleiding Bag-extract
=======================

Bag-extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van Kadaster BAG
(Basisregistratie Adressen en Gebouwen) GML leveringen in (voorlopig) een Postgres/Postgis database.

BAG Downloaden
--------------

De BAG Leveringsbestanden (totaal plm 1.2 GB .zip) worden iedere maand ververst en zijn te downloaden via deze
PDOK link: http://geodata.nationaalgeoregister.nl/inspireadressen/atom/inspireadressen.xml (Atom feed).
Als je wilt testen met een kleiner bestand kun je via http://www.nlextract.nl/file-cabinet
ook de "BAG Amstelveen" (5.6 MB) downloaden.

Wat doet Bag-extract ?
----------------------

Bag-extract biedt de volgende functionaliteiten:

- Laden van een Kadaster BAG Extract vanuit Kadaster (.zip GML) levering
- Toepassen van Kadaster BAG mutaties vanuit Kadaster (.zip GML) levering
- Verrijken BAG met gemeenten en provincies
- Verrijken: tabel met volledige "ACN-achtige" adressen genereren
- Geocoderen: afgeleide tabellen en functies
- Stijlen (SLDs) om de ingelezen BAG data te visualiseren via een WMS
- Validatie van input vlak geometrie
- Database VIEWs om bagobjecten te selecteren die actueel, bestaand en valide geometrie hebben

Bag-extract downloaden
----------------------

- download NLExtract, zie laatste versie op: http://www.nlextract.nl/file-cabinet
- of snapshot (huidige repo versie) via git: git clone http://github.com/opengeogroep/NLExtract.git
- of snapshot als .zip: https://github.com/opengeogroep/NLExtract/zipball/master

Afhankelijkheden
----------------

- PostgreSQL: relationele database, minimaal versie 8.3, optimaal is versie 9.1, zie http://www.postgresql.org
- PostGIS: spatial extensie PostgreSQL, bijv. opslag geodata, minimaal versie 1.5, optimaal is versie 2.x, zie http://postgis.org
- Python: versie 2, minimaal versie 2.4.3, beste is 2.7 of hoger voor lxml, geen Python 3
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

Er zijn een aantal mogelijkheden gebaseerd op bijdragen van gebruikers en een van de developers (Just).

- Nieuw: `beschrijving door Just (23 juni 2013) met behulp van Portable GIS <windows-usbgis.html>`_
- beschrijving door Pim Verver http://groups.google.com/group/nlextract/browse_frm/thread/c02af6012b43767a
- hieronder een installatie met PostgreSQL 9 en PostGIS 2.0, beschreven door Reinier Sterkenburg (met dank) en wat aanvullingen van Just:

#. Installeer Postgresql 9.2 64 bits van http://www.enterprisedb.com/products-services-training/pgdownload#windows
#. Installeer Postgis 2.0 (postgis-pg92x64-setup-2.0.1-1.exe) van http://postgis.refractions.net/download/windows/#postgis-installers. Tijdens de installatie wordt je de mogelijkheid geboden om meteen een spatial database aan te maken. Dat heb ik gedaan, en die noemde ik bag.
#. Installeer Python 2.7.3 64bits (python-2.7.3.amd64.msi)  van http://www.python.org/ftp/python/2.7.3/python-2.7.3.amd64.msi
#. Voeg de folder waarin Python is geinstalleerd toe aan Path. Via windows explorer, right-click op Computer, klik op Eigenschappen, Klik links op Geavanceerde Systeeminstellingen, klik in tabblad Geavanceerd op knop Omgevingsvariableen, klik bovenin op variable PATH, klik op knop Bewerken en voeg het volledige pad naar de Python folder, incl. een semi colon vooraan (in mijn geval ";C:\Python27") toe. Klik op de diverse OK knoppen om af te sluiten.
#. Download en installeer 'setuptools-0.6c11.win32-py2.7.exe (md5)' van http://pypi.python.org/pypi/setuptools
#. Voeg de 'scripts' folder van de Python hoofdfolder toe aan Path (zoals beschreven in punt 4).
#. Installeer LXML lxml-2.3.6.win-amd64-py2.7.exe (2.3.6 was de meest recente versie van Lxml) van http://www.lfd.uci.edu/~gohlke/pythonlibs
#. Installeer GDAL (64 bits = gdal-19-1600-x64-core.msi) en GDAL Python bindings (64 bits + Python 2.7 = GDAL-1.9.0.win-amd64-py2.7.msi) via http://www.gisinternals.com/sdk/Download.aspx?file=release-1600-x64-gdal-1-9-mapserver-6-0\gdal-19-1600-x64-core.msi. en via http://www.gisinternals.com/sdk/PackageList.aspx?file=release-1600-x64-gdal-1-9-mapserver-6-2.zip (het versienummer loopt daar snel op trouwens)
#. Voeg GDAL folder, C:\\Program Files\\GDAL\\, toe aan Path (zoals beschreven in punt 4).
#. Python Postgres Client: Download  'psycopg2-2.4.6.win-amd64-py2.7-pg9.2.2-release.exe' (dus 64 bits, voor Python 2.7 en Postgresql 9.2.2) van http://www.stickpeople.com/projects/python/win-psycopg/
#. Maak dan binnen Postgresql een database aan waar de BAG gegevens ingezet worden. Gebruik als template de template die je hebt gedefinieerd bij de installatie van Postgis en selecteer een gebruiker. Bij het installeren van PostGIS wordt je de mogelijkheid geboden een spatial database aan te maken. Die heb ik gebruikt om de bag database te laten maken. Alternatief: zie punt 2.

12. Maak een folder structuur voor NLEXTRACT aan, bv
::

    C:\BAGExtract\ (bevat extract.conf)
    C:\BAGExtract\scripts
    C:\BAGExtract\db

en kopieer de scripts en db folders van NLExtract.zip naar deze folders.

13. Vul in de extract.conf file de gegevens van je server, de onder punt 11 aangemaakte database, de onder punt 11 aangemaakte gebruiker en bijbehorend wachtwoord. Standaard maken de scripts gebruik van deze gegevens.
NB: De extract.conf file staat onder NL Extract (subfolder bag).
::

    [DEFAULT]
    database = bag
    schema = public
    host     = localhost
    user     = postgres
    password = admin
    port = 5432

Initialiseer de database:
::

    python bagextract.py  -H localhost -d bag -U postgres -W admin -c -v

In deze stap (-c) wordt de database leeg gemaakt en de DB scripts: bag-db.sql, bag-view-actueel-bestaand.sql uitgevoerd en alle data onder db\\data ingelezen: Gemeente-woonplaats-relatietabel.zip
en cbs-gemeentenperprovincie-2012.csv. NB: de parameters -H, -d, -U en -W kunnen achterwege blijven als die in de extract.conf file staan ingevuld.

14.   Importeer BAG data met:
::

    python bagextract.py -v -e PAD_NAAR_XML_FILE_OF_DIRECTORY_OF_ZIP_BESTAND

PAD_NAAR_XML_FILE_OF_DIRECTORY_OF_ZIP_BESTAND is bij voorkeur het gehele BAG .zip download bestand, bijv. DNLDLXAE02-0000673060-0096000265-08042012.zip of de hoofddirectory wanneer deze zip wordt uitgepakt.
Het is belangrijk om dit zo te doen omdat NLExtract allerlei meta-bestanden ook inleest, bijv. een nieuwere woonplaats-gemeente koppel tabel (dan onder db/data) en meta info voor
de tabel nlx_bag_info.

15.  Optioneel: Verrijken: genereren gemeente + provincie tabellen met geometrie uit woonplaatsen aggregeren.
::

     python bagextract.py -v -q ../db/script/gemeente-provincie-tabel.sql

16. Optioneel: Verrijken: aanmaken tabel met volledige �ACN-achtige� adressen uit BAG + gemeente + provincie tabellen (kan lang duren op gehele BAG, lijkt sneller te gaan via �psql� Postgres commando).
::

     "c:\Program Files\PostgreSQL\9.2\bin\psql" -d bag -U postgres < ../db/script/adres-tabel.sql

17. Optioneel: Verrijken: reverse geocoding (voor gebruik, zie commentaar in onderstaande sql files). Evt. aanpassen van script: vervang ndims door st_ndims en srid door st_srid
::

     python bagextract.py -v -q ../db/script/geocode/geocode-tabellen.sql
     python bagextract.py -v -q ../db/script/geocode/geocode-functies.sql


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

Commando:
---------

- direct via python "python src/bagextract.py"
- of (Unix,Linux,Mac) via shell script: "bin/Bag-extract.sh"
- Windows: voorlopig alleen via "python src/bagextract.py"

 Alle commando's werken onafhankelijk van de plek (directory) waar ze aangeroepen worden

Instellingen:
-------------

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

Voorbeelden:
------------

0. Help en opties:

    python src/bagextract.py -h
    of
    bin/Bag-extract.sh -h

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

Issues:
-------

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

Zie http://docs.kademo.nl/project/bagextract.html voor een installatie voorbeeld.

