-- Author: Just van den Broecke
-- SET search_path TO test,public;

-- Maak tabellen zoveel mogelijk compatibel met BAG v1


-- LIG specifiek
ALTER TABLE ligplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE ligplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE ligplaats RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE ligplaats RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE ligplaats RENAME COLUMN status TO ligplaatsStatus;
UPDATE ligplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- NUM specifiek
ALTER TABLE nummeraanduiding ALTER COLUMN identificatie TYPE character varying(16);
ALTER TABLE nummeraanduiding ALTER COLUMN begingeldigheid TYPE timestamp with time zone;
ALTER TABLE nummeraanduiding ALTER COLUMN eindgeldigheid TYPE timestamp with time zone;
ALTER TABLE nummeraanduiding ALTER COLUMN documentnummer TYPE character varying(40);
ALTER TABLE nummeraanduiding ALTER COLUMN huisnummer TYPE numeric(5);
ALTER TABLE nummeraanduiding ALTER COLUMN huisletter TYPE character varying(1);
ALTER TABLE nummeraanduiding ALTER COLUMN huisnummertoevoeging TYPE character varying(4);
ALTER TABLE nummeraanduiding ALTER COLUMN postcode TYPE character varying(6);
ALTER TABLE nummeraanduiding ALTER COLUMN typeadresseerbaarobject TYPE typeadresseerbaarobject USING typeadresseerbaarobject::text::typeadresseerbaarobject;
ALTER TABLE nummeraanduiding ALTER COLUMN status TYPE nummeraanduidingStatus USING status::text::nummeraanduidingStatus;
ALTER TABLE nummeraanduiding ALTER COLUMN openbareruimteref TYPE character varying(16);
ALTER TABLE nummeraanduiding ADD COLUMN IF NOT EXISTS woonplaatsref character varying;
ALTER TABLE nummeraanduiding ALTER COLUMN woonplaatsref TYPE character varying(16);
ALTER TABLE nummeraanduiding DROP COLUMN IF EXISTS wkb_geometry CASCADE;

ALTER TABLE nummeraanduiding RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE nummeraanduiding RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE nummeraanduiding RENAME COLUMN openbareruimteref TO gerelateerdeOpenbareRuimte;
ALTER TABLE nummeraanduiding RENAME COLUMN woonplaatsref TO gerelateerdeWoonplaats;
ALTER TABLE nummeraanduiding RENAME COLUMN status TO nummeraanduidingStatus;
ALTER TABLE nummeraanduiding ADD COLUMN aanduidingRecordInactief boolean default false;
UPDATE nummeraanduiding SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- OPR specifiek
ALTER TABLE openbareruimte RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE openbareruimte RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE openbareruimte RENAME COLUMN naam TO openbareRuimteNaam;
ALTER TABLE openbareruimte RENAME COLUMN verkorteNaam TO verkorteOpenbareRuimteNaam;
ALTER TABLE openbareruimte RENAME COLUMN type TO openbareRuimteType;
ALTER TABLE openbareruimte RENAME COLUMN woonplaatsref TO gerelateerdeWoonplaats;
ALTER TABLE openbareruimte RENAME COLUMN status TO openbareRuimteStatus;
UPDATE openbareruimte SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- PND specifiek
ALTER TABLE pand ALTER COLUMN identificatie TYPE character varying(16);
ALTER TABLE pand ALTER COLUMN begingeldigheid TYPE timestamp with time zone;
ALTER TABLE pand ALTER COLUMN eindgeldigheid TYPE timestamp with time zone;
ALTER TABLE pand ALTER COLUMN status TYPE pandStatus USING status::text::pandStatus;
ALTER TABLE pand ALTER COLUMN documentnummer TYPE character varying(40);
ALTER TABLE pand ALTER COLUMN oorspronkelijkbouwjaar TYPE numeric(4);
ALTER TABLE pand ALTER COLUMN wkb_geometry TYPE geometry(PolygonZ, 28992) USING ST_Force3D(wkb_geometry);

ALTER TABLE pand RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE pand RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE pand RENAME COLUMN oorspronkelijkbouwjaar TO bouwjaar;
ALTER TABLE pand RENAME COLUMN status TO pandStatus;
ALTER TABLE pand RENAME COLUMN wkb_geometry TO geovlak;
ALTER TABLE pand ADD COLUMN aanduidingRecordInactief boolean default false;
UPDATE pand SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- STA specifiek
ALTER TABLE standplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE standplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE standplaats RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE standplaats RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE standplaats RENAME COLUMN status TO standplaatsStatus;
UPDATE standplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- VBO specifiek
ALTER TABLE verblijfsobject ALTER COLUMN identificatie TYPE character varying(16);
ALTER TABLE verblijfsobject ALTER COLUMN begingeldigheid TYPE timestamp with time zone;
ALTER TABLE verblijfsobject ALTER COLUMN eindgeldigheid TYPE timestamp with time zone;
ALTER TABLE verblijfsobject ALTER COLUMN status TYPE verblijfsobjectStatus USING status::text::verblijfsobjectStatus;
ALTER TABLE verblijfsobject ALTER COLUMN documentnummer TYPE character varying(40);
ALTER TABLE verblijfsobject ALTER COLUMN hoofdadresnummeraanduidingref TYPE character varying(16);
ALTER TABLE verblijfsobject ALTER COLUMN nevenadresnummeraanduidingref TYPE character varying(16) ARRAY;
ALTER TABLE verblijfsobject ALTER COLUMN oppervlakte TYPE numeric(6);
ALTER TABLE verblijfsobject ALTER COLUMN pandref TYPE character varying(16) ARRAY;
ALTER TABLE verblijfsobject ALTER COLUMN wkb_geometry TYPE geometry(PointZ, 28992) USING ST_Force3D(wkb_geometry);

ALTER TABLE verblijfsobject RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE verblijfsobject RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE verblijfsobject RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE verblijfsobject RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE verblijfsobject RENAME COLUMN gebruiksdoel TO gebruiksdoelverblijfsobject;
ALTER TABLE verblijfsobject RENAME COLUMN oppervlakte TO oppervlakteVerblijfsobject;
ALTER TABLE verblijfsobject RENAME COLUMN pandref TO gerelateerdepanden;
ALTER TABLE verblijfsobject RENAME COLUMN status TO verblijfsobjectStatus;
ALTER TABLE verblijfsobject RENAME COLUMN wkb_geometry TO geopunt;
ALTER TABLE verblijfsobject ADD COLUMN aanduidingRecordInactief boolean default false;
UPDATE verblijfsobject SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- WPL specifiek
ALTER TABLE woonplaats ALTER COLUMN naam TYPE character varying(80);
ALTER TABLE woonplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE woonplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE woonplaats RENAME COLUMN naam TO woonplaatsNaam;
ALTER TABLE woonplaats RENAME COLUMN status TO woonplaatsStatus;
UPDATE woonplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);

-- PROV-GEM specifiek
-- Sorry Fryslân it spyt my - but for v1 compat...
UPDATE provincie_gemeente SET provincienaam='Friesland' where provinciecode = 21;

-- GEM-WPL specifiek
ALTER TABLE gemeente_woonplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE gemeente_woonplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE gemeente_woonplaats DROP COLUMN geometry;

-- Adresseerbaarobjectnevenadres
ALTER TABLE adresseerbaarobjectnevenadres RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE adresseerbaarobjectnevenadres RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
UPDATE adresseerbaarobjectnevenadres SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL OR tijdstipinactiefLV is not NULL);


-- Convert MultiPolygon to Polygon for Pand
-- See GDAL Issue: https://github.com/OSGeo/gdal/issues/3467
-- LBVBAG driver generates MultiPolygon while BAG standard/XSD defines Polygon
-- This can be removed when that issue solved and incorporated in GDAL lib
-- ALTER TABLE pand ADD COLUMN geovlak_tmp geometry(Polygon, 28992);
-- UPDATE pand SET geovlak_tmp = (SELECT ST_GeometryN(geovlak,1) FROM pand p WHERE pand.gid = p.gid);
-- ALTER TABLE pand DROP COLUMN geovlak;
-- ALTER TABLE pand RENAME COLUMN geovlak_tmp TO geovlak;
