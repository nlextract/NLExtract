# NLExtract voor BAG Versie 2

Main change is we can use the GDAL/OGR Driver [LVBAG](https://gdal.org/drivers/vector/lvbag.html).
For now assumed this can be used in the Stetl Chain.

## Download van Kadaster

* via https://extracten.bag.kadaster.nl/lvbag/extracten/
* BAG v1: tot april 2021, met handmatige controle, voor enkele problemen
* april-sept 2021 ook maar zonder controle, verwacht 99.9% correct
* tarieven: https://www.kadaster.nl/-/tarieven-2021 
* 180,- enkele levering, 120,- maandabbo, 12,- p/m voor dagelijkse mutaties

## Issues GDAL LVBAG

### Open

#### Gem-Woonplaats relatie

* inlezen Gem-Woonplaats relatie

#### zipfile met 1 XML file

See https://github.com/OSGeo/gdal/issues/3462

* Als .zip 1 XML file bevat niet herkend als LVBAG bestand: 

#### Geometrie Pand moet Polygon zijn

Geometrie LIG, STA, WPL en PND

* WPL is `VlakOfMultivlak` in XSD dus ok als `MultiPolygon`
* LIG, STA, PND type Surface (niet MultiSurface) in BAG XSDs
* LVBAG: LIG en STA Polygon ok, maar PND als `MultiPolygon`
* Polygon of MultiPolygon in PostGIS? e.g. Pand id=0221100000311827 0221100000312258
* `SELECT st_asGML(geovlak) FROM test.pand WHERE identificatie = '0221100000312258' and eindregistratie is null;`  
* Is Polygon met hole dus exterior/interior poslists
* Dat kan wel in PostGIS: https://postgis.net/docs/using_postgis_dbmanagement.html#OGC_Validity
* Issue voor Pand: https://github.com/OSGeo/gdal/issues/3467

### Solved

See https://github.com/OSGeo/gdal/issues/3217

* `identificatie` niet
* Pand `oorspronkelijkBouwjaar` moet `int` zijn (niet YY-MM-DD)
* onnodige lege velden: `lvID` altijd `'.'` plus `namespace`, `lokaalid` en `versie` zijn altijd `Null`.  

See https://github.com/OSGeo/gdal/issues/3221 multiplicity for some attrs:


* VBO: meerdere gebruiksdoelen niet gehonoreerd
* VBO-PND N-M: meerdere gerelateerde PND mogelijk
* VBO: Nevenadres wordt niet afgehandeld

Let this remain:

* VBO: geometrie kan Punt of Vlak zijn (nu alleen Punt verondersteld)

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

