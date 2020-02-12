.. _algemeen:


********
Algemeen
********

Hieronder staat algemene informatie over het hoe en waarom van NLExtract.
Zie ook de website: http://nlextract.nl en de ontwikkeling
`NLExtract GitHub <https://github.com/nlextract/NLExtract>`_.

Voor commerciële ondersteuning zoals gespecialiseerde extracties, downloads en andere
services neem :ref:`contact` met ons op.

Waarom NLExtract ?
==================

Nederlandse overheidsinstellingen zoals Het Kadaster en Rijkswaterstaat stellen
hun (geo) data meer en meer beschikbaar als Open Data. Bijvoorbeeld de BAG
(Basisregistratie Adressen en Gebouwen, www.kadaster.nl/BAG) levert je alle
adressen en gebouwen in Nederland met hun coordinaten. De Top10NL
(www.kadaster.nl/top10nl) bevat gegevens voor de gehele topografie van
Nederland, veel gedetailleerder dan Google Maps dat biedt.

Dat is dus prachtig, want nu kan iedereen deze data zelf downloaden en naar eigen
believen gebruiken...Ok, downloaden, maar dan ? Wat je op dit moment geleverd
krijgt is niet bijvoorbeeld een digitale kaart maar de "ruwe data", d.w.z. de
vector-bestanden met alle punten, lijnen en vlakken tezamen met hun vele kenmerken.
Bijvoorbeeld de straat van A naar B in geometrische lijn-coordinaten en
vlak-coordinaten, maar ook met haar straatnaam en wegnummer. Dat is mooi, want dan
kun je bijv. zelf bepalen welke kleur die straat op de kaart krijgt en met welk
font de naam afgebeeld wordt....

Maar... er moet nog flink wat gebeuren voor je een echte gedetailleerde kaart kunt
zien of bij wijze van spreken de oppervlakte van je eigen huis (BAG). Het is alsof
je een enorm spreadsheet met cijfers krijgt waarvan je eigenlijk de grafieken wilt
zien. Wat is er aan de hand en wat moet er dan gebeuren ?

De gegevens en bestands formaten waarin deze overheids-datasets worden aangeleverd
zijn dus ruwe data. Deze leveringen komen in XML (GML), CSV formaten en zelfs als
MS Access database. Deze bestanden zijn dan ook bedoeld voor uitwisseling, zodat
je zelf kunt bepalen wat en hoe je ze "op de kaart" wilt hebben. Er is ook vaak
uitgebreide documentatie van deze formaten, maar voor de gemiddelde kaarten-maker
kan dat (bijv. GML-schema's) abacadabra zijn.

Om bijvoorbeeld een kaartdienst te maken met een open standaard zoals de Web Map
Service (WMS) is het veel en veel handiger om met bijvoorbeeld een ruimtelijke
database als PostGIS (www.postgis.org) te werken. Dan kun je bijvoorbeeld een
"query" maken om alleen zeg maar de rijkswegen of alle naaldbossen te extraheren
uit de Top10NL gegevens. Of om de oppervlakte van je eigen huis te achterhalen
uit de BAG.

Ook wil je vaak data combineren en/of afleiden uit verschillende data-sets.
Een voorbeeld is het verrijken van BAG data met gemeente en provincie grenzen.
Dit is in theorie allemaal binnen je bereik, echter er is nog net een stapje nodig:
de aangeleverde bestanden omzetten naar een ruimtelijke database zodat je er echt
mee aan de slag kunt. In de Open Source wereld is de op PostgreSQL gebaseerde
geo-database PostGIS (www.postgis.org) de standaard. Ook kun je gemakkelijk een
kaartdienst (via WMS) of datadienst (via WFS) met Open Source server-software
als GeoServer of MapServer op een PostGIS database aansluiten. Via "Styled Layer
Descriptors (SLD, soort CSS) kun je dan zelf je kaarten vormgeven en naar voren
laten komen wat voor jou belangrijk is (voor mij bijvoorbeeld liever naaldbossen
dan rijkswegen).

Een heel verhaal maar hoe zetten we die data dan om naar PostGIS en maken we een
begin met die SLDs ? Daarom is er nu NLExtract !

NLExtract levert tools, recepten, voorbeelden om Nederlandse geodata sets te
converteren en te ontsluiten. Het gehele traject van brondata conversie (naar
PostGIS, later ook naar bijv Oracle en Shape) tot visualisatie (SLDs) wordt
afgedekt. Er wordt binnen NLextract zoveel mogelijk gebruik gemaakt van
bestaande Open Source Geo tools zoals GDAL/OGR (www.gdal.org). Bij voorkeur
wordt vector data geconverteerd naar PostGIS (en later ook rasterdata naar
GeoTIFF).

De eerste datasets die gedaan zullen worden zijn BAG, Top10NL, IMGeo/BGT (Grootschalige
Topografie) en NWB (Nationaal Wegen Bestand van Rijkswaterstaat). Ook zijn er plannen
om raster datasets te doen zoals TopRaster en "Bonne Bladen" (historische topo-kaarten).

Iedere dataset heeft hieronder een eigen directory met aanwijzingen hoe te
converteren en te visualiseren.

De GitHub hier bevat puur de NLExtract-broncode dus is in de eerste plaats
gericht op ontwikkelaars. Wil je als ontwikkelaar meedoen ? Graag !
Laat ons weten, bijv. via info@opengeogroep.nl. Vooral zoeken we nog
Windows-experts zodat het op dat platform ook goed gaat werken. Wil je
nieuwe zaken zien of vind je fouten ? Gebruik de "issues" link hierboven.

Meer dan Extraheren
===================

Het installeren en uitvoeren van de NLExtract ETL (extracties) kan vaak tijdrovend zijn terwijl
de meeste gebruikers vaak hetzelfde doel hebben: bijv maandelijks de BAG omzetten naar PostGIS
of de laatste versie van Top10NL. Daarnaast kan het zijn dat voor andere datasets
zoals `OpenTopo <http://www.opentopo.nl>`_ je een web service zoals een TMS of WMS wil opzetten.
Het kan ook zijn dat je bijv op smartphone/tablet eenvoudigweg de OpenTopo
kaarten wil raadplegen.

Daartoe zijn in 2014 in NLExtract drie nieuwe NLExtract Services opgestart.

* NLExtract Downloads
* NLExtract Apps

In 2020 zijn de NLExtract Downloads te vinden via https://geotoko.nl.
Veel informatie en voorbeeldbestanden vind je via https://geocatalogus.nl.
De "Ga Naar Bron" links verwijzen nar geotoko.nl.

Lees in het volgende hoofdstuk :ref:`services` meer hierover.
