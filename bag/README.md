# NLExtract BAG

NLExtract BAG is onderdeel van de NLExtract tools voor het inlezen en verrijken van Kadaster BAG 
(Basisregistratie Adressen en Gebouwen) GML leveringen (via o.a. PDOK) in (voorlopig) een Postgres/Postgis database.

De BAG Leveringsbestanden (totaal plm 1.2 GB .zip) worden iedere maand ververst en zijn te downloaden via deze  
link: http://geodata.nationaalgeoregister.nl/inspireadressen/atom/inspireadressen.xml (Atom feed).

NLExtract BAG biedt de volgende functionaliteiten:

* Laden van een Kadaster BAG Extract vanuit Kadaster (.zip GML) levering
* Toepassen van Kadaster BAG mutaties vanuit Kadaster (.zip GML) levering
* Verrijken BAG met gemeenten en provincies
* Verrijken: tabel met volledige "ACN-achtige" adressen genereren
* Geocoderen: afgeleide tabellen en functies
* Stijlen (SLDs) om de ingelezen BAG data te visualiseren via een WMS
* Validatie van input vlak geometrie
* Database VIEWs om bagobjecten te selecteren die actueel, bestaand en valide geometrie hebben

Documentatie vind je op: http://nlextract.readthedocs.org
