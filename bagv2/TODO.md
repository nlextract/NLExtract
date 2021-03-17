# TODO Lijst

Zie ook issue 296 en PR 306: https://github.com/nlextract/NLExtract/pull/306.

## Open

### Juiste historie condities actueel VIEWs

* https://geoforum.nl/t/bag-extract-v2-definitie-van-actueel/5579

### Migratie v1 attributen

* https://geoforum.nl/t/bag-extract-v2-migratie-van-v1-object-attributen/5588

### autocorrecting invalid Pand/Building geometry renders non-Polygon types

Zie issue: https://github.com/OSGeo/gdal/issues/3581
               
Update: issue 3467 is gesloten (Pand heeft nu Polygon geometrie type) maar wanneer heel NL verwerkt (niet bijv bij Amsterdam) 
deze melding:

    # In BAG LV 8-feb-2021
    ogr2ogr -f PostgreSQL "PG:dbname=bagv2 host=bagv2_db port=5432 user=*** password=*** active_schema=bagactueel" -lco LAUNDER=YES -lco PREC\
    ISION=NO -lco FID=gid -lco SPATIAL_INDEX=NONE -append --config PG_USE_COPY YES -a_srs EPSG:28992 -gt 200000  -oo AUTOCORRECT_INVALID_DATA=YES -oo LEGACY_ID=YES temp/temp_dir
    Warning 1: Self-intersection at or near point 210444.6939819445 462183.56186922867
    Warning 1: Geometry to be inserted is of type Multi Polygon, whereas the layer geometry type is Polygon.
    Insertion is likely to fail
    ERROR 1: COPY statement failed.
    ERROR:  Geometry type (MultiPolygon) does not match column type (Polygon)
    CONTEXT:  COPY pand, line 28484, column wkb_geometry: "010600002040710000020000000103000000010000000A000000DD67468D65B00941A7A55A3F9E351C416ABC749391B00941..."
    
    ERROR 1: ERROR:  relation "pand" does not exist
    
    ERROR 1: ERROR:  relation "pand" does not exist
    
    ERROR 1: no COPY in progress
    
    ERROR 1: Unable to write feature 199999 from layer Pand.
    ERROR 1: Terminating translation prematurely after failed
    translation of layer Pand (use -skipfailures to skip errors)

    ogr2ogr -f PostgreSQL "PG:dbname=bagv2 host=bagv2_db port=5432 user=*** password=*** active_schema=bagactueel" -lco LAUNDER=YES -lco PRECISION=NO -lco FID=gid -lco SPATIAL_INDEX=NONE -append --config PG_USE_COPY YES -a_srs EPSG:28992 -gt 200000  -oo AUTOCORRECT_INVALID_DATA=YES -oo LEGACY_ID=YES temp/temp_dir
    Warning 1: Self-intersection at or near point 192905.48699999999 426593.91399999999
    Warning 1: Geometry to be inserted is of type Geometry Collection, whereas the layer geometry type is Polygon.
    Insertion is likely to fail
    ERROR 1: COPY statement failed.
    ERROR:  Geometry type (GeometryCollection) does not match column type (Polygon)
    CONTEXT:  COPY pand, line 189263, column wkb_geometry: "0107000020407100000200000001030000000100000016000000894160E54B8C0741B29DEFA787091A4121B07268668C0741..."
    
    etc

Met `AUTOCORRECT_INVALID_DATA=NO` is de error verdwenen maar hebben we geen autocorrectie.

Na zoeken bijv Pand with id: `0147100000016964` heeft (historische) voorkomens met invalide geometrie (self-intersecting polygons).
Ook in PostGIS:

    SELECT ST_AsText(ST_MakeValid(ST_GeomFromText('POLYGON((247452.468 480187.571, 247453.262 480177.649, 247460.405 480177.914, 247459.876 480188.894, 247456.834 480188.629, 247456.834 480187.174, 247452.468 480187.306, 247452.468 480187.571))')));

Ook in versie 1 BAG en NLExtract. NLExtract gebruikte ook een kolom `is_valid` die ook in VIEWs meegenomen werd.


### Autocorrectie Datum ver in toekomst
 
* PND with LVBAG NL - version `08022021` to Postgres shows with `-oo AUTOCORRECT_INVALID_DATA=YES`:

```
Warning 1: Invalid date : 2104-01-21, value set to null
Warning 1: Invalid date : 2104-01-21, value set to null
```
 
Bijv Pand id `0381100000108002`  lijkt toch weer gecorrigeerd, dus op NULL zetten niet de goede oplossing.
Doe
```
select identificatie,begindatumtijdvakgeldigheid,einddatumtijdvakgeldigheid from pand where identificatie = '0381100000108002'

"0381100000108002"	"1999-10-28"	"2104-01-21"
"0381100000108002"	"2104-01-21"	null
```

This is weird but the second record is the valid (actueel) object.  According to other dates (`documentdatum` = 2014-01-21) the
2104 should be 2014.  So a typo with quite some impact...

## OPGELOST

See https://github.com/geopython/stetl/issues/112

* inlezen Gem-Woonplaats relatie - gedaan: via nieuwe Stetl VsiZipFile reader en Format Converter.
* interessant: op deze manier zouden we de gehele BAG v2 kunnen verwerken!

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

### Performance

Heel NL verwerken duurde eerste 13.5 uur! Aantal zaken:

* vannuit vsizip lezen te traag
* beste is uitpakken in dir en gehele dir aan ogr2ogr geven  
* `ogr2ogr -skipfailures` resulteert dat `-gt N` ignored wordt dus transactie size 1! (bekend issue).
* tevoren tabellen aanmaken en `ogr2ogr` daarin laten schrijven factor 5 langzamer

### Geometrie Pand moet Polygon zijn

Geometrie LIG, STA, WPL en PND

* WPL is `VlakOfMultivlak` in XSD dus ok als `MultiPolygon`
* LIG, STA, PND type Surface (niet MultiSurface) in BAG XSDs
* LVBAG: LIG en STA Polygon ok, maar PND als `MultiPolygon`
* Polygon of MultiPolygon in PostGIS? e.g. Pand id=0221100000311827 0221100000312258
* `SELECT st_asGML(geovlak) FROM test.pand WHERE identificatie = '0221100000312258' and eindregistratie is null;`  
* Is Polygon met hole dus exterior/interior poslists
* Dat kan wel in PostGIS: https://postgis.net/docs/using_postgis_dbmanagement.html#OGC_Validity
* Issue voor Pand: https://github.com/OSGeo/gdal/issues/3467

* voorlopige oplossing zou een expliciete CAST kunnen zijn


### zipfile met 1 XML file

See https://github.com/OSGeo/gdal/issues/3462

* Als .zip 1 XML file bevat niet herkend als LVBAG bestand. 
* voorlopige oplossing: laat `VsiZipFileInput` volledige paden naar ALLE embedded .xml files genereren

### Gemeente en Provincie Tabellen aanmaken
* Ivm v1 compat.
* Zie v1 SQL, via WPL aggregatie/Union


### begin/eindtijdvakgeldigheid toch maar timestamp ipv date type
* Ivm v1 compat.


### 3D Geometry typen
* Ivm v1 compat.

* brondata is ook SRSdim 3 maar alleen voor PND en VBO

### NUM huisnummer type  numeric(0,5)
* Ivm v1 compat.

### Pand bouwjaar numeric(4,0)
* Ivm v1 compat.

### oppervlakteverblijfsobject numeric(6,0) in v2 maken
* Ivm v1 compat.

### v2: woonplaatsnaam character varying(80) maken
* Ivm v1 compat.

### Statusnaamgeving -specifiek per objecttype maken

* Ivm v1 compat.
* NUM
* OPR `openbareruimtestatus bagactueel.openbareruimtestatus`

### provincie_gemeente

* provinciecode numeric(4,0)
* `begindatum timestamp with time zone, einddatum timestamp with time zone` missen in v2  - niet nodig
