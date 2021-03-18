.. _bagv2extract:


**************
BAG-V2 Extract
**************

Hieronder de handleiding voor het gebruik van de tools voor BAG versie 2
(dus VERSIE 2 van de Kadaster BAG brondata) verwerking.
Deze tooling heet hieronder NLExtract-BAGv2.

Achtergrond
===========

Het Kadaster heeft ongeveer in de periode 2015-2020 versie 2 van de BAG ontwikkeld.
D.w.z. een tweede versie voor de structuur van de BAG, gevat in het IMBAG model en
uiteindelijk in de XML Schema's (XSDs) en leveringen zoals LV BAG Extract, de BAG XML brondata.
BAG v2 is al enige tijd verkrijgbaar.

Voor NLExtract zijn de belangrijkste wijzigingen van BAG v1 naar v2:

* uitbreiden van het aantal tekens voor het brondocumentnummer van 24 naar 40;
* 2 nieuwe statussen van Panden en Verblijfsobjecten: `verbouwing` en `ten onrechte opgevoerd`
* drie nieuwe typen tijdstippen: `tijdstipRegistratie`, `eindRegistratie` en `LV-registratiedatum`.

In 2021 wordt versie 2 definitief uitgerold en wordt versie 1 uitgefaseerd.
De details zijn op dit moment (maart 2021):

* BAG v1: wordt tot en met maart 2021 geleverd, met handmatige controle, voor enkele problemen
* BAG v1: april-sept 2021 ook maar zonder controle, wel verwacht 99.9% correct
* BAG v2: per 1 okt 2021 defnitief, dan BAG v1 uitgefaseerd
* BAG Compact product levering stopt ook met BAG v2

Op dit moment is de versie IMBAGLV 2.1.0 met XSDs van datum: 1 juni 2020 (202020601).

Dankzij een sponsoring van de OpenGeoGroep, kon vanaf dec 2020 begonnen worden met
de ontwikkeling van NLExtract voor BAG v2. Op 6 maart 2021 is voor het eerst de gehele LV BAG
verwerkt in PostGIS. Hoofdontwikkelaar was/is Just van den Broecke.

Handleiding NLExtract-BAGv2
===========================

`NLExtract-BAGv2` is onderdeel van de NLExtract tools voor het inlezen en verrijken van Kadaster BAG
(Basisregistratie Adressen en Gebouwen) product "BAG Extract" (versie 2) leveringen
in (voorlopig) een PostgreSQL/Postgis database.

BAG Bronbestanden downloaden
----------------------------

De BAG bronbestanden zoals geleverd door Kadaster heten het "BAG Extract" product.
Er was ook bijv BAG Compact, maar deze wordt niet meer voor BAG v2 geleverd.

* voorlopig via https://extracten.bag.kadaster.nl/lvbag/extracten/
* daar zowel landelijke als per-gemeente BAG-Extract leveringen

BAG PostGIS dumps downloaden
----------------------------

Als je geen zin/tijd hebt om NLExtract-BAG zelf te installeren en te draaien, dan kun je ook kant-en-klare
PostGIS database en CSV adressen dumps downloaden via https://geotoko.nl.

Vanaf april 2021 zullen via geotoko.nl ook BAG v2 producten geleverd worden.
Beide versies (BAG v1 en v2) zullen van 1 april t/m 30 sept 2021 naast elkaar bestaan.
Ook zal een BAG Compact-equivalent product beschikbaar komen voor BAG versie 2.

Deze worden maandelijks ververst direct na uitkomen nieuwe BAG-levering.
Er wordt leveringsbijdrage gevraagd. De baten komen ook weer ten goede aan de ontwikkeling
van Stetl en NLExtract.

Wat doet NLExtract-BAGv2?
-------------------------

NLExtract-BAGv2 biedt de volgende functionaliteiten:

- Laden van een Kadaster BAG Extract levering vanuit Kadaster (.zip GML)
- Verrijken BAG met gemeenten en provincies
- Database VIEWs om bagobjecten te selecteren die actueel, of actueel en bestaand zijn

Nog te doen (12 maart 2021):

- Verrijken: tabel met volledige "ACN-achtige" adressen genereren in 3 varianten: Basis, Uitgebreid en Plus
- Checkpointing: bijhouden welke bestanden reeds verwerkt t.b.v. herstarts en mutatie-verwerking
- Logging in database zodat gechecked kan worden waar evt fouten zijn en welke bestanden verwerkt
- Toepassen van Kadaster BAG mutaties vanuit Kadaster (.zip GML) levering

BAG-Extract downloaden
----------------------

- download NLExtract, zie laatste versie op: https://github.com/nlextract/NLExtract/releases. De nieuwste versie staat bovenaan: kies de "real-release" nl  extract zip.
- of snapshot (huidige repo versie) via git: git clone http://github.com/opengeogroep/NLExtract.git
- of snapshot als .zip: https://github.com/nlextract/NLExtract/zipball/master
- of via Docker: https://hub.docker.com/repository/docker/nlextract/nlextract/

Afhankelijkheden
----------------

- `PostgreSQL`: relationele database, minimaal versie 10, Aangemaakte DB moet **UTF8 encoding** hebben. zie http://www.postgresql.org
- `PostGIS`: spatial extensie PostgreSQL, bijv. opslag geodata, minimaal versie 2.2 zie http://postgis.org
- `Python`: versie 3.7 of hoger
- `psycopg2`: Python PostgreSQL client bibliotheek. Zie http://initd.org/psycopg
- `lxml` voor razendsnelle native XML parsing, Zie http://lxml.de
- GDAL/OGR tools en bibliotheek voor geodata manipulatie. Minimaal 3.2.2. Zie https://gdal.org
- GDAL/OGR Python bindings Zie www.gdal.org en https://pypi.python.org/pypi/GDAL voor Geometrie parsing/validatie en manipulatie

Installatie (Linux)
-------------------

Nog te doen.

Installatie (Windows)
---------------------

Nog te doen.

Installatie (Mac OSX)
---------------------

Beste via `Homebrew`, nog te doen.

Commando
--------

- `etl.sh <opties>` - `opties` via standaard Stetl `-a <optie of args-bestand>`.

Instellingen
------------

- onder `etl/options`

Ontwerp
=======

De implementatie van NLExtract-BAGv2 is radikaal anders dan v1: er wordt gebruikt gemaakt van Stetl
net als de overige NLExtract Basisregistratie verwerkingen.

NOG AAN TE VULLEN - samengevat: ::

	# Stetl-Process-chains for extracting BAG VERSION 2 source data from input zip files to PostGIS.
	# A Chain is a series of Components: one Input, zero or more Filters and one Output.
	# The output of a Component is connected to the input of the next Component (except for
	# the final Output Component, which writes to the final destination, e.g. PostGIS or GeoPackage..
	# Stetl is the ETL tool used. No custom Python code is needed!
	#
	# Currently the following chains are executed in the following order:
	# - SQL pre:  DB initialization, create schema and tables
	# - Process "Leveringsdoc" put meta info like dataset date in nlx_bag_info table
	# - Process CBS gemeente provincie koppelingen
	# - BAG Woonplaats-Gemeente Koppeling (onderdeel van BAG Extract Kadaster product)
	# - input_bag_zip_file: inlezen BAG in PostGIS met LVBAG Driver
	# - input_sql_post: post-processing o.a. aanmaken indexen en VIEWs


GDAL LVBAG Driver
-----------------

Deze wordt gebruikt voor verwerking BAG object XML bestanden.
In Stetl kan daardoor de `ogr2ogr` gebaseerde Stetl-`Output` gebruikt worden.

BAG v1 Compatibiliteit
----------------------

Omdat veel implementaties al jaren gestoeld zijn op BAG v1 en de daarbij behorende attribuut/kolom namen,
is besloten om zoveel mogelijk de NLExtract-BAG versie 1 naamgeving aan te houden.
Ook de tussentabellen (VBO-PND N-M relatie) en multivalue tabellen (VBO Gebruiksdoelen, Nevenadressen)
zijn behouden. Hoewel met ARRAY typen (zie onder) veel handiger queries te doen zijn.

Array Typen
-----------

Sommige kolommen in BAG zijn "multi-valued".
Voor BAG v2 is voor Array typen (OGR StringList) gekozen i.p.v. tussentabellen uit NLExtract-BAG v1.

De velden zijn:

* VBO, LIG, STA: nevenadressen
* VBO: panden (VBO behoort tot 1 of meerdere PND)
* VBO: een of meer gebruiksdoelen

Daardoor kunnen gemakkelijker allerlei selecties gedaan worden (ipv tussentabellen of (sub)String matching):  ::

	# Selecteer 1e gebruiksdoel en pand identificaties (arrays in PG beginnen op index 1)
	select identificatie,gebruiksdoel[1],pandref[1] from doesburg.verblijfsobject limit 10

	 identificatie   | gebruiksdoel |     pandref
	------------------+--------------+------------------
	0221010000330136 | woonfunctie  | 0221100000316077
	0221010000330136 | woonfunctie  | 0221100000316077
	0221010000330138 | woonfunctie  | 0221100000316082
	0221010000330138 | woonfunctie  | 0221100000316082
	0221010000330140 | woonfunctie  | 0221100000316086
	0221010000330142 | woonfunctie  | 0221100000316090
	0221010000330142 | woonfunctie  | 0221100000316090
	0221010000330144 | woonfunctie  | 0221100000316096
	0221010000330144 | woonfunctie  | 0221100000316096
	0221010000330146 | woonfunctie  | 0221100000316101

	# Hoeveel VBOs hebben Nevenadressen?
	select count(gid) from doesburg.verblijfsobject where array_length(nevenadresnummeraanduidingref,1) > 0

	# Hoeveel VBOs zijn gekoppeld aan meer dan 1 PND?
	select count(gid) from doesburg.verblijfsobject where array_length(pandref,1) > 1


	# Hoeveel VBOs hebben meer dan 1 gebruiksdoel?
	select count(gid) from doesburg.verblijfsobject where array_length(gebruiksdoel,1) > 1


Veranderingen Kadaster BAG Levering v2
======================================

Voorkomen en Historie
---------------------

Bronnen:

* https://geoforum.nl/t/bag-extract-v2-migratie-van-v1-object-attributen/5588/2

actueel
~~~~~~~

* https://www.kadaster.nl/-/specificatie-bag-historiemodel
* https://geoforum.nl/t/bag-extract-v2-definitie-van-actueel/5579
* https://imbag.github.io/praktijkhandleiding/artikelen/hoe-ontstaan-niet-bag-en-inactieve-voorkomens

Formeel op grond bovenstaande is in BAG v2 de “actuele” conditie: ::

	begingeldigheid <= now()
	AND (eindgeldigheid is NULL OR eindgeldigheid > now())
	AND (tijdstipinactief is NULL AND tijdstipinactiefLV is NULL AND tijdstipnietbaglv is NULL)

De laatste 3 worden in NLExtract vervat in `aanduidingrecordinactief` kolom.

bestaand
~~~~~~~~

Extra status enum waarden:

* Pand: `'Verbouwing pand','Pand ten onrechte opgevoerd'`
* VBO: `'Verbouwing verblijfsobject','Verblijfsobject ten onrechte opgevoerd'`

aanduidingrecordcorrectie
~~~~~~~~~~~~~~~~~~~~~~~~~

P Dijkstra:
"De `aanduidingrecordcorrectie` bestaat niet meer. De aanduiding correctie is groter dan 0 als een object in BAG 1.0 de indicatie inactief ‘J’ kreeg.
Voorkomens met dezelfde sleutel kunnen meerdere keren inactief worden gemaakt, dat is dan te zien aan een oplopend getal bij de indicatie correctie.
Een çorrectie is in BAG 2.0 te herkennen aan een gevuld tijdstip Niet BAG en/of een gevuld tijdstip Inactief(LV).
Omdat het in BAG 2.0 een tijdstip is (in plaats van een indicatie) is het in BAG 2.0 niet meer nodig ook nog een correctie te leveren."

geconstateerd
~~~~~~~~~~~~~

P Dijkstra:
"De indicatie `geconstateerd` is ooit in het BAG 1.0 extract terecht gekomen als `officieel`.
Dit is aangepast in het BAG 2.0 extract. Inhoudelijk gezien is hier niets aan gewijzigd.
Als de indicatie `geconstateerd` ‘J’ is betekent dit dat het object niet op basis van een formeel brondocument
in de registratie is opgenomen. Dit geeft aan dat er sprake is van een mogelijk illegaal object."

inonderzoek
~~~~~~~~~~~

P Dijkstra:
"`inonderzoek` is in BAG 2.0 geen attribuut van een voorkomen meer. Het is als het ware een apart object op basis
van het ID van het object en het in onderzoek geplaatste gegeven met een eigen tijdlijn."
