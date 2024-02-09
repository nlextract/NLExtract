.. _brtextract:

***********
BRT-Extract
***********

Hieronder staat de handleiding voor het gebruik van de tools om de diverse BRT datasets, zoals TOP10NL, te extraheren. Deze tools
heten kortweg ``BRT-Extract`` of soms ``NLExtract-BRT``.

	NB: als je alleen interesse hebt om een PostGIS versie van de laatste BRT bijv TOP10NL te hebben, kun
	je deze ook (betaald) downloaden als  PostGIS dumpfile via de link via de link https://geotoko.nl/.
	De dump file (``.dump`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdmin``.
	Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract-team, zie "Ondersteuning": https://nlextract.nl

Handleiding BRT-Extract
=======================

Algemeen
--------

De `BRT Levering van Kadaster via PDOK <https://www.pdok.nl/introductie/-/article/basisregistratie-topografie-brt-topnl>`_
bestaat uit 6 (Vector) datasets, ieder voor specifieke schaal: TOP10NL, TOP50NL, TOP100NL, TOP250NL, TOP500NL, TOP1000NL.
Voor gemak hieronder als TOP-NL aangeduid.


Dus bijv TOP10NL is onderdeel van de `Kadaster Basisregistratie Topografie (BRT) <https://www.kadaster.nl/zakelijk/registraties/basisregistraties/brt>`_.

``BRT-Extract`` bevat de tools om de TOP-NL GML-bronbestanden, zoals geleverd door het Kadaster (bijv via PDOK),
om te zetten naar hanteerbare formaten, zoals PostGIS. Tevens bevat BRT-Extract visualisatie-bestanden
(onder de map `style/` ) voor QGIS en SLDs om kaarten te maken. (NB deze zijn nu nog gebaseerd op TOP10NL 1.0!).

TOP-NL (v1.2) wordt via PDOK geleverd d.m.v. `OGC Download APIs <https://www.pdok.nl/ogc-apis/-/article/basisregistratie-topografie-brt-topnl>`_.

Zie `Bestandswijzer_GML_TOP10NL_2012.pdf <https://github.com/nlextract/NLExtract/blob/master/brt/top10nl/doc/Bestandswijzer_GML_TOP10NL_2012.pdf>`_
voor de kaartbladindeling.

Er zijn 13 typen TOP10NL objecten. Zie voor de beschrijving van de structuur en verdere bijzonderheden voor de GML bestandsindeling in
`BRT_Catalogus_Productspecificaties.pdf <https://github.com/nlextract/NLExtract/blob/master/brt/top10nl/doc/1.2/BRT_Catalogus_Productspecificaties.pdf>`_ (nog gebaseerd op versie 1.1.1).

TOP-NL downloaden
-----------------

TOP-NL brondata in GML kun je
via de `PDOK OGC Download APIs <https://www.pdok.nl/ogc-apis/-/article/basisregistratie-topografie-brt-topnl>`_ downloaden.

`NB: het is heel belangrijk om de laatste versie van bijv TOP10NL te gebruiken. Dit is versie 1.2.` Deze wordt geleverd
met ingang van november 2015. Alleen deze versie wordt ondersteund door de huidige versie
BRT-Extract. Met ingang van deze datum is ook het Kadaster volledig overgeschakeld. De oude
versies van TOP10NL worden niet meer ondersteund. Mocht je toch de oude versie willen inlezen,
gebruik dan een oude release van NLExtract.

BRT-Extract downloaden
----------------------

Vind altijd de laatste versie op:
https://github.com/nlextract/NLExtract/releases. De nieuwste versie staat bovenaan: kies de "real-release" nlextract zip.

Omdat NLExtract voortdurend in ontwikkeling is, kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone https://github.com/nlextract/NLExtract.git
- snapshot als .zip: https://github.com/nlextract/NLExtract/archive/master.zip

BRT-Extract draaien
-------------------

Zie `per dataset de READMEs <https://github.com/nlextract/NLExtract/tree/master/brt>`_.

Ontwerp
-------

In eerste instantie wordt de GML geconverteerd en geladen naar PostGIS. Dit gebeurt met de GDAL/OGR tool
ogr2ogr binnen Stetl. Echter, er zijn 2 belangrijke zaken die dit lastig maken:

- meerdere geometrieën per object, bijv een Waterdeel GML element kan een punt, een lijn of een vlak bevatten
- meerdere voorkomens van een attribuut (attribute multiplicity), bijv. een Wegdeel GML element kan meerdere element-attributen genaamd "nWegnummer" bevatten

Voorheen werd met een XSLT script de
GML-elementen uitgesplitst naar geometrie, zodat ieder element een enkele geometrie bevat. Bijvoorbeeld
Wegdeel kent maar liefst 5 geometrie-attributen. Dit wordt opgesplitst naar Wegdeel_Lijn, Wegdeel_Vlak etc.
Een nieuw GML-bestand wordt hiermee opgebouwd.

Echter momenteel wordt middels Stetl en
een `GDAL GFS bestand <https://github.com/nlextract/NLExtract/blob/master/brt/top10nl/etl/gfs/top10-v1.2.gfs>`_ (voorbeeld TOP10NL)
TOP-NL direct in PostGIS ingelezen met alle geometrieën per tabel (=object-type).
Daarna wordt de uitsplitsing naar één geometrie per tabel
met `SQL-postprocessing <https://github.com/nlextract/NLExtract/blob/master/brt/top10nl/etl/sql/create-final-tables-v1.2.sql>`_ gedaan.

Met ingang van de november-release van de BRT (2015R11) wordt
alleen het Stetl-framework ondersteund voor BRT-Extract.
Zie verder :doc:`stetl-framework` voor de werking van BRT-Extract.
