.. _stetl-framework:


***************
Stetl-framework
***************

NLExtract gaat steeds meer gebruik maken van de ETL framework Stetl, zie http://stetl.org.
Hierdoor hoeft niet meer per dataset een apart programma worden gemaakt.
De volgende extract-tools maken gebruik van het Stetl-framework:

* :doc:`top10extract`
* :doc:`bgtextract`

Stetl maakt i.h.a. gebruik van Python voor alle scripts. De Python-scripts voor de extract-tools die gebruik maken van het Stetl-framework roepen `native` tools aan:

* XML parsing via ``libxml2``
* XSLT processing via ``libxslt``
* GDAL/OGR ``ogr2ogr``

De reden hiervoor is vooral de snelheid. Deze native libraries zijn beschikbaar binnen Python d.m.v. zogenaamde `bindings`.

Afhankelijkheden
----------------

De volgende software dient aanwezig te zijn om gebruik te maken van het Stetl-framework:

* Python 2.6 of hoger (niet Python 3!);
* Python argparse package, voor argument parsing alleen indien Python < 2.7;
* PostGIS: PostgreSQL 8.x of 9.x database server met PostGIS 1.x of 2.x: http://postgis.refractions.net;

  * PostgreSQL 9.x met PostGIS 2.x wordt aanbevolen.

* ``lxml`` voor razendsnelle native XML parsing: http://lxml.de/installation.html;
* ``libxml2`` en ``libxslt`` bibliotheken  (worden door ``lxml`` gebruikt);
* GDAL/OGR v1.8.1 of hoger (voor ``ogr2ogr``): http://www.gdal.org.

NB: GDAL/OGR Python bindings zijn (voorlopig) `niet` nodig.

Installatie
-----------

Stetl werkt op de drie voornaamste platformen: Windows, Mac OSX, Linux.
De bovengenoemde afhankelijkheden hebben ieder hun eigen handleiding voor
installatie op desbetreffend platform. Raadpleeg deze als eerste.
Hieronder volgt een aantal tips en bijzonderheden per platform.

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
``chcp 1252`` om de code page van de console bij te werken naar ANSI. Je krijgt anders een waarschuwing wanneer je in PostgreSQL inlogt. Dit komt omdat de code page standaard 437 is (extended ASCII) i.p.v. 1252 (ANSI).

In Python 2.6:

- argparse module: http://pypi.python.org/pypi/argparse
  Het gemakkelijkst is om argparse.py in de directory Python26\\Lib\\ te droppen

- Beschrijving installatie en run door Just (23 juni 2013) met behulp van Portable GIS: :doc:`windows-usbgis`.

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

Stetl uitvoeren
---------------

Uitvoeren: ``./etl-<dataset>.sh``
Ga hiervoor met een prompt in de etl-directory staan van de desbetreffende dataset, dus in ``<dataset>/etl``.

Opties zetten: maak hiertoe een eigen lokaal bestand in de options-directory, met de naam ``options-<hostnaam>.sh``. Default worden de opties in options.sh gebruikt. D.m.v. het lokale bestand kun je deze overriden.

De Stetl-configuratie in etl-<dataset>-<versie>.cfg hoeft niet te worden gewijzigd, alleen indien bijv. een andere output gewenst is.

Let op: het Windows batch-bestand etl-top10nl (alleen bij TOP10NL) is een work-in-progress. Hier wordt nog aan gewerkt.
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
