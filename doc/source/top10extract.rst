.. _top10extract:


*************
Top10-extract
*************

Hieronder staat de handleiding voor het gebruik van de tools om TOP10NL te extraheren. Deze tools
heten kortweg ``Top10-extract`` of soms ``NLExtract-TOP10``.

NB: als je alleen interesse hebt om een PostGIS versie van de laatste TOP10NL te hebben, kun
je deze ook downloaden als  PostGIS dumpfile via de link http://data.nlextract.nl/top10nl/postgis.
De dump file (``.backup`` bestand)  kun je direct inlezen in PostGIS, bijv met ``PGAdminIII``.
Dan hoef je alle zaken hieronder niet uit te voeren :-).

Om gespecialiseerde extracties bijv naar andere databases zoals Oracle te doen, neem contact op
met het NLExtract-team, zie "Ondersteuning": http://www.nlextract.nl/issues.

Handleiding Top10-extract
=========================

Algemeen
--------

TOP10NL is onderdeel van de Kadaster Basisregistratie Topografie (BRT). Vind algemene info
over TOP10NL op http://www.kadaster.nl/web/artikel/productartikel/TOP10NL.htm.

``Top10-extract`` bevat de tools om de TOP10NL GML-bronbestanden, zoals geleverd door het Kadaster (bijv via PDOK),
om te zetten naar hanteerbare formaten, zoals PostGIS. Tevens bevat Top10-extract visualisatie-bestanden
(onder de map `style/` ) voor QGIS en SLDs om kaarten te maken. (NB deze zijn nu nog gebaseerd op TOP10NL 1.0!).

TOP10NL (v1.2) wordt geleverd door het Kadaster als een .zip file van plm 2 GB. Voor de landsdekkende
versies zijn er 2 soorten .zip-bestanden, een op basis van kaartbladen en een .zip file op basis van
"GML FileChunks" waarbij de totale GML is opgedeeld in files van 300 MB. Zie `Bestandswijzer_GML_TOP10NL_2012.pdf <https://github.com/nlextract/NLExtract/raw/master/top10nl/doc/Bestandswijzer_GML_TOP10NL_2012.pdf>`_ voor de kaartbladindeling.

Er zijn 13 typen TOP10NL objecten. Zie voor de beschrijving van de structuur en verdere bijzonderheden voor de GML bestandsindeling in
`BRT_Catalogus_Productspecificaties.pdf <https://github.com/nlextract/NLExtract/raw/master/top10nl/doc/1.2/BRT_Catalogus_Productspecificaties.pdf>`_ (nog gebaseerd op versie 1.1.1).

TOP10NL downloaden
------------------

TOP10NL brondata in GML kun je via `PDOK TOP10NL Downloads <https://www.pdok.nl/nl/producten/pdok-downloads/basis-registratie-topografie/topnl/topnl-actueel/top10nl>`_ downloaden.

Er zijn twee download varianten: de "GML File Chunks" en "50D Kaartbladen". De eerste is de totale verzameling opgesplitst
in 300MB GML Files, de tweede bevat de GML bestanden per kaartblad. Download de Kaartbladen alleen als je bijv. een enkel
gebied wilt inlezen of om te testen. Beide ZIP-bestanden zijn ca. 2 GB groot. Het is ook mogelijk om de TOP10NL via PDOK-services te downloaden, bijv. via WFS. Het inlezen van deze gegevens via NLExtract wordt niet ondersteund.

Als je heel Nederland wilt inlezen, kun je het beste de "GML File Chunks" gebruiken.
De directe link is http://geodata.nationaalgeoregister.nl/top10nlv2/extract/chunkdata/top10nl_gml_filechunks.zip?formaat=gml.

Voor de kaartbladen is dat: http://geodata.nationaalgeoregister.nl/top10nlv2/extract/kaartbladtotaal/top10nl.zip?formaat=gml.


`NB: het is heel belangrijk om de laatste versie van Top10NL te gebruiken. Dit is versie 1.2.` Deze wordt geleverd
met ingang van november 2015. Alleen deze versie wordt ondersteund door de huidige versie
Top10-extract. Met ingang van deze datum is ook het Kadaster volledig overgeschakeld. De oude
versies van TOP10NL worden niet meer ondersteund. Mocht je toch de oude versie willen inlezen,
gebruik dan een oude release van NLExtract.

Top10-extract downloaden
------------------------

Vind altijd de laatste versie op: https://github.com/nlextract/NLExtract/releases.

Omdat NLExtract voortdurend in ontwikkeling is, kun je ook de actuele broncode, een `snapshot`, downloaden
en op dezelfde manier gebruiken als een versie:

- snapshot via git: git clone http://github.com/opengeogroep/NLExtract.git
- snapshot als .zip: https://github.com/nlextract/NLExtract/archive/master.zip

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

Met ingang van de november-release van de BRT (2015R11) wordt alleen het Stetl-framework ondersteund voor Top10-extract. Zie verder :doc:`stetl-framework` voor de werking van Top10-extract.
