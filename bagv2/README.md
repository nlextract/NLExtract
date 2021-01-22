# NLExtract voor BAG Versie 2

Main change is we can use the GDAL/OGR Driver `LVBAG`.

## Download van Kadaster

* via https://extracten.bag.kadaster.nl/lvbag/extracten/
* BAG v1: tot april 2021, met handmatige controle, voor enkele problemen
* april-sept 2021 ook maar zonder controle, verwacht 99.9% correct
* tarieven: https://www.kadaster.nl/-/tarieven-2021 
* 180,- enkele levering, 120,- maandabbo, 12,- p/m voor dagelijkse mutaties

## Outstanding Issues GDAL LVBAG

See https://github.com/OSGeo/gdal/issues/3217

* `identificatie` niet
* Pand `oorspronkelijkBouwjaar` moet `int` zijn (niet YY-MM-DD)
* onnodige lege velden: `lvID` altijd `'.'` plus `namespace`, `lokaalid` en `versie` zijn altijd `Null`.  

Verdere problemen (nog issue aan te maken)

* VBO: meerdere gebruiksdoelen niet gehonoreerd
* VBO: geometrie kan Punt of Vlak zijn (nu alleen Punt verondersteld)
* VBO-PND N-M: meerdere gerelateerde PND mogelijk
* VBO: Nevenadres wordt niet afgehandeld

* inlezen Gem-Woonplaats relatie

## Historie 

* voorkomen-id, opeenvolgend, kunnen "gaten" in zitten
* registratie-historie. niet altijd chronologisch
* advies: gebruik voor volgorde, voorkomen-id en begintijdstip
* begin, eindtijden: begintijden altijd kleiner 

## Mutaties Verwerken

Verschil met BAG v1.

* Begingeldigheid niet meer onderdeel actieve sleutel
* in onderzoek: negeren, is apart bestand
* toekomstmutaties!
* inactief/NIet-BAG

Was-wordt Mutaties: negeer enkele fout, niet hele mutatie bestand!

* verwerk in juiste volgorde, meerdere mutaties op 1 dag
* 
