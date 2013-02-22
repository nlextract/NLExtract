Hieronder staan tools om de zgn "Bonnebladen" te transformeren.
Wat zijn Bonnebladen ? Zie
http://www.kadaster.nl/web/artikel/productartikel/Bonnebladen.htm

Uit: http://nl.wikipedia.org/wiki/Bonnekaart

"Bonnekaarten of Bonnebladen zijn de eerste Nederlandse militaire stafkaarten.
De oudste werden kort voor 1900 uitgegeven. De offici‘le naam is Chromotopografische Kaart des Rijks.
Ze vervingen de Topografische en Militaire Kaart (TMK) uit de periode 1850-1864. De kaarten staan bekend
als de Bonnekaarten of Bonnebladen naar de Franse landmeter Bonne wiens projectievorm gebruikt werd.
De kaarten zijn door hun schaal en de precisie van de vele details een belangrijke informatiebron bij de
bestudering van het Nederlandse landschap van rond 1900. De vroegste kaartbladen zijn die van
strategisch gelegen gebieden aan de staatsgrens. Deze waren al voor de eeuwwisseling gereed.
De laatste kaarten verschenen rond 1930..."

Met de tools (onder ./bin) kan het volgende gedaan worden:

 - bin/bonnetrans.sh transformeer een bron PNG naar GeoTiff
 - bin/bonnetrans-all.sh - transformeer alle bonne kaarten
 - bin/settings.sh - settings voor transformatie parameters
 - bin/settings-<host>.sh per-host settings: maak een settings-<host>.sh voor je eigen host!

 - bin/files4periode.sh - maak dirs aan met files voor periode

Transformeren houdt in:
- rectificeren kaart (zwarte randen weg)
- georefereren  (vanuit bonnecoords.csv)
- helderder maken kaarten
- meer contrast in kaarten
- PNG naar GeoTiff





