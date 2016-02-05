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

* XML parsing via ``libxml2``;
* XSLT processing via ``libxslt``;
* GDAL/OGR via ``ogr2ogr``.

De reden hiervoor is vooral de snelheid. Deze native libraries zijn beschikbaar binnen Python d.m.v. zogenaamde `bindings`.

Afhankelijkheden
----------------

De volgende software dient aanwezig te zijn om gebruik te maken van het Stetl-framework:

* Python 2.6 of hoger (niet Python 3!). Let op dat de ontwikkeling van Python 2.6 is stopgezet!

  * Op Windows_ is Python 2.7 de minimale versie. Deze versie wordt ook geïnstalleerd wanneer je OSGeo4W met de juiste opties, of QGIS hebt geïnstalleerd.
  
* GDAL/OGR v1.11 of hoger (voor ``ogr2ogr``): http://www.gdal.org.
* PostGIS: PostgreSQL 8.x of 9.x database server met PostGIS 1.x of 2.x: http://postgis.refractions.net.

  * PostgreSQL 9.x met PostGIS 2.x wordt aanbevolen.

* Pip en Setuptools (o.a. voor package ``pkg_resources``): https://pip.pypa.io/en/latest/installing/#install-pip. Dit is alleen nodig indien je Python-versie ouder dan 2.7.9 is.
* ``argparse`` voor argument parsing. Alleen nodig bij Python 2.6.
* ``psycopg2`` voor het maken van database connecties met PostgreSQL vanuit Python.
* ``lxml`` voor razendsnelle native XML parsing: http://lxml.de/installation.html.
* ``libxml2`` en ``libxslt`` bibliotheken  (worden door ``lxml`` gebruikt).

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

Het is gebleken dat het lastig is om NLExtract goed op Windows aan de praat te krijgen. Een belangrijke reden is de OSGeo4W-installer, waar o.a. ook QGIS mee wordt geïnstalleerd. OSGeo4W levert een eigen Python-versie mee. Deze versie, 2.7.5, die o.a. met QGIS Lyon (2.12) wordt geïnstalleerd, loopt een stuk achter bij de laatste Python 2.7-relase, 2.7.11 (status januari 2016). De Python-executable bevindt zich zelfs in dezelfde directory als ogr2ogr, wat de zaak alleen gecompliceerder maakt.

Met onderstaande instructies is het mogelijk om NLExtract werkend te krijgen op Windows. Hierbij maakt het niet uit of je de OSGeo4W-versie van Python gebruikt of je eigen Python-versie. In het laatste geval moet je wel zelf op de een of andere manier ogr2ogr op je machine krijgen en de locatie hiervan in de PATH-variabele zetten. Vanwege de vele mogelijkheden zijn niet alle situaties getest. Open s.v.p. een issue-report in Github bij problemen of meld het op de mailinglijst. De kans is het grootst dat er problemen zijn met de PATH-variabele of de PYTHONPATH-variabele.

Open een command prompt. Indien Python, QGIS of de OSGeo4W-software in ``C:\Program Files`` of ``C:\Program Files (x86)`` staat, dien je de command prompt als Administrator te openen. Indien je OSGeo4W/QGIS hebt, kun je eventueel ook de OSGeo4W-shell of MSYS gebruiken.

In de instructies wordt gebruik gemaakt van Python wheels, ofwel WHL-bestanden. Voor Windows is een groot aantal van deze bestanden te vinden op de site van `Christian Gohlke <http://www.lfd.uci.edu/~gohlke/pythonlibs/>`_. Kies de Python 2.7-versie en kies de 32- of 64-bits versie. Dit is afhankelijk van de Python-versie of OSGeo4W/QGIS-versie die je hebt.

* Installatie Pip, Setuptools en pkg_resources: dit is alleen nodig indien je Python-versie ouder is dan 2.7.9, dus ook als je de OSGeo4W-versie gebruikt. Dit kan via het script ``get-pip.py``. Zie https://pip.pypa.io/en/latest/installing/#install-pip voor verdere instructies. Hierbij krijg je tevens ondersteuning voor de installatie van Python-wheels (WHL-bestanden). Dit is nodig voor de vervolgstappen. Zorg ervoor dat de Scripts-directory van Python, waar pip.exe staat, in het pad is in het commando shell waarmee je de installaties uitvoert. Een WHL-bestand kan als volgt met Pip geïnstalleerd worden::

    pip install <package>.whl

* Installatie lxml: download en installeer het WHL-bestand. Je hoeft niet apart libxml2 of libxslt te installeren.
* Installatie psycopg (niet bij OSGeo4W): download en installeer het WHL-bestand.

Let bij Windows ook op het volgende: wanneer je op de command line met PostgreSQL wilt connecten, gebruik
``chcp 1252`` om de code page van de console bij te werken naar ANSI. Je krijgt anders een waarschuwing wanneer je in PostgreSQL inlogt. Dit komt omdat de code page standaard 437 is (extended ASCII) i.p.v. 1252 (ANSI).

(Oud) Beschrijving installatie en run door Just (23 juni 2013) met behulp van Portable GIS: :doc:`windows-usbgis`.

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

Opties zetten: maak hiertoe een eigen lokaal bestand in de options-directory, met de naam ``options-<hostnaam>.sh``.
Default worden de opties in options.sh gebruikt. D.m.v. het lokale bestand kun je deze overriden.

De Stetl-configuratie in ``etl-<dataset>-<versie>.cfg`` hoeft niet te worden gewijzigd, alleen indien bijv. een andere
output gewenst is.

Let op: ook op Windows is het mogelijk om het bash-script uit te voeren. Dit kan via `MSYS <http://www.mingw.org/wiki/msys>`_
of via de OSGeo4W-shell. MSYS is een collectie van GNU-utilites, waardoor SH-scripts uitgevoerd kunnen worden. Zowel
MSYS als de OSGeo4W-shell worden geïnstalleerd als onderdeel van QGIS. MSYS gedraagt zich als een normale bash-shell.
De OSGeo4W-shell gedraagt zich als de Windows command prompt. Het shell-script kun je uitvoeren door in de juiste
etl-directory te gaan staan en vervolgens ``etl-<dataset>.sh`` in te typen.

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

    # Stetl path
    export STETL_HOME=../../../stetl

    # Reset pythonpath
    export PYTHONPATH=

    # Overige opties
    export max_features=20000

In het verleden was er bij Top10-extract een Windows batch-bestand aanwezig, maar er is besloten om de ontwikkeling
hiervan te stoppen. Dit is gedaan, omdat ontwikkelcapaciteit schaars is en het apart bijhouden van batch-bestanden
onderhoudsgevoelig is. Alle wijzigingen aan de shell-scripts, dus ook het toevoegen van extra opties, zouden dan dubbel
getest moeten worden. Met de OSGeo4W-shell is een goede oplossing beschikbaar voor mensen die de Windows command-prompt
gewend zijn.

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

