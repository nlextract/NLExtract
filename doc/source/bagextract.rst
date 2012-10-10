.. _bagextract:


**********
bagextract
**********

Hieronder staat de handleiding voor het gebruik van de BAGExtract tools.

Handleiding bag-extract
=======================

bag-extract is onderdeel van de NLExtract tools voor het inlezen en verrijken van Kadaster BAG
(Basisregistratie Adressen en Gebouwen) GML leveringen in (voorlopig) een Postgres/Postgis database.

BAG Downloaden
--------------

De BAG Leveringsbestanden (totaal plm 1.2 GB .zip) worden iedere maand ververst en zijn te downloaden via deze
link: http://geodata.nationaalgeoregister.nl/inspireadressen/atom/inspireadressen.xml (Atom feed).
Als je wilt testen met een kleiner bestand kun je via http://www.nlextract.nl/file-cabinet
ook de "BAG Amstelveen" (5.6 MB) downloaden.

Wat doet bag-extract ?
----------------------

bag-extract biedt de volgende functionaliteiten:
 - Laden van een Kadaster BAG Extract vanuit Kadaster (.zip GML) levering
 - Toepassen van Kadaster BAG mutaties vanuit Kadaster (.zip GML) levering
 - Verrijken BAG met gemeenten en provincies
 - Verrijken: tabel met volledige "ACN-achtige" adressen genereren
 - Geocoderen: afgeleide tabellen en functies
 - Stijlen (SLDs) om de ingelezen BAG data te visualiseren via een WMS
 - Validatie van input vlak geometrie
 - Database VIEWs om bagobjecten te selecteren die actueel, bestaand en valide geometrie hebben

bag-extract downloaden
----------------------

 - download NLExtract
    laatste versie op: http://www.nlextract.nl/file-cabinet
    of snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
    en snapshot als .zip: https://github.com/opengeogroep/NLExtract/zipball/master

Afhankelijkheden
----------------

 - Python: versie 2, minimaal versie 2.4.3, beste is 2.7 of hoger voor lxml, geen Python 3
 - Python argparse package, voor argument parsing alleen indien Python < 2.7
 - psycopg2: Python PostgreSQL client bibliotheek. Zie http://initd.org/psycopg
 - lxml voor razendsnelle native XML parsing, Zie http://lxml.de
 - GDAL/OGR Python bindings Zie www.gdal.org en http://pypi.python.org/pypi/GDAL
   voor Geometrie parsing/validatie en manipulatie

Installatie (Linux)
-------------------

 - optioneel: Python package afhankelijkheden installeren bijv
   apt-get of yum install python-setuptools (voor easy_install commando)
   apt-get of yum install python-devel (tbv psycopg2 bibliotheek)
   apt-get of yum install postgresql-devel (tbv psycopg2 bibliotheek)

 - razendsnelle native XML parsing met libxml2/libxslt libraries samen met Python lxml:
   kan meer dan een factor twee in snelheid schelen...
   Zie http://lxml.de/installation.html
   apt-get of yum install libxml2
   apt-get of yum install libxslt1.1
   apt-get of yum install python-lxml

 - GDAL (www.gdal.org) met Python bindings voor OGR geometrie-parsing en geometrie-validatie (NLX v1.1.0 en hoger)
   apt-get of yum install gdal-bin
   apt-get of yum install python-gdal

 - de PostgreSQL python bibliotheek psycopg2:
   sudo easy_install psycopg2

 - Python package "argparse"
   sudo easy_install argparse

 - NB als je een proxy gebruikt via http_proxy  doe dan easy_install -E (exporteer huidige environment)

Installatie (Windows)
---------------------

 - beschreven door Pim Verver
   http://groups.google.com/group/nlextract/browse_frm/thread/c02af6012b43767a

Commando:
---------

 - direct via python "python src/bagextract.py"
 - of (Unix,Linux,Mac) via shell script: "bin/bag-extract.sh"
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
	bin/bag-extract.sh -h

	Alle commando's kunnen via Python of shell .sh script uitgevoerd vanaf elke directory.

1. Initialiseer de database en vul/verrijk met referentie-koppeldata (gemeenten/provincies) (-c):

	python bagextract.py -c
	of
	bag-extract.sh -c

2. Importeer een extract in de database (-e):

	python bagextract.py -e 9999STA01052011-000002.xml
	python bagextract.py -e 9999STA01052011.zip

	-e werkt op directory, file of .zip inclusief mutatie-bestanden


3. Verrijken: genereren gemeente + provincie tabellen met geometrie uit woonplaatsen aggregeren
	NB Doe altijd eerst stappen 1-2 anders blijft de tabel "gemeente" leeg. !

	 python bagextract.py -v -q ../db/script/gemeente-provincie-tabel.sql

	Met de -q (query) optie kan elk SQL bestand worden uitgevoerd


4. Verrijken: aanmaken tabel met volledige "ACN-achtige" adressen uit BAG + gemeente + provincie tabellen
   (kan lang duren op gehele BAG, lijkt sneller te gaan via "psql" Postgres commando).
   NB Doe altijd eerst stappen 1-2, stap 3 is niet strict noodzakelijk.

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

