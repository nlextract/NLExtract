# NLExtract voor BAG Versie 2

Main change is we can use the GDAL/OGR Driver `LVBAG`.

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
