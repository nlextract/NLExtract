-- Author: Just van den Broecke
-- SET search_path TO test,public;

-- Maak tabellen zoveel mogelijk compatibel met BAG v1

UPDATE ligplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE nummeraanduiding SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE openbareruimte SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE pand SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE standplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE verblijfsobject SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE woonplaats SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);
UPDATE adresseerbaarobjectnevenadres SET aanduidingrecordinactief=(tijdstipinactief is not NULL OR tijdstipnietbaglv is not NULL);

ALTER TABLE ligplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE nummeraanduiding RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE openbareruimte RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE pand RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE standplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE verblijfsobject RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE woonplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE adresseerbaarobjectnevenadres RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;
ALTER TABLE gemeente_woonplaats RENAME COLUMN begingeldigheid TO begindatumTijdvakGeldigheid;


ALTER TABLE ligplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE nummeraanduiding RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE openbareruimte RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE pand RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE standplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE verblijfsobject RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE woonplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE adresseerbaarobjectnevenadres RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;
ALTER TABLE gemeente_woonplaats RENAME COLUMN eindgeldigheid TO einddatumTijdvakGeldigheid;

-- LIG specifiek
ALTER TABLE ligplaats RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE ligplaats RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE ligplaats RENAME COLUMN status TO ligplaatsStatus;

-- NUM specifiek
ALTER TABLE nummeraanduiding RENAME COLUMN openbareruimteref TO gerelateerdeOpenbareRuimte;
ALTER TABLE nummeraanduiding RENAME COLUMN woonplaatsref TO gerelateerdeWoonplaats;
ALTER TABLE nummeraanduiding RENAME COLUMN status TO nummeraanduidingStatus;

-- OPR specifiek
ALTER TABLE openbareruimte RENAME COLUMN naam TO openbareRuimteNaam;
ALTER TABLE openbareruimte RENAME COLUMN verkorteNaam TO verkorteOpenbareRuimteNaam;
ALTER TABLE openbareruimte RENAME COLUMN type TO openbareRuimteType;
ALTER TABLE openbareruimte RENAME COLUMN woonplaatsref TO gerelateerdeWoonplaats;
ALTER TABLE openbareruimte RENAME COLUMN status TO openbareRuimteStatus;

-- PND specifiek
ALTER TABLE pand RENAME COLUMN oorspronkelijkbouwjaar TO bouwjaar;
ALTER TABLE pand RENAME COLUMN status TO pandStatus;

-- STA specifiek
ALTER TABLE standplaats RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE standplaats RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE standplaats RENAME COLUMN status TO standplaatsStatus;

-- VBO specifiek
ALTER TABLE verblijfsobject RENAME COLUMN hoofdadresnummeraanduidingref TO hoofdadres;
ALTER TABLE verblijfsobject RENAME COLUMN nevenadresnummeraanduidingref TO nevenadressen;
ALTER TABLE verblijfsobject RENAME COLUMN gebruiksdoel TO gebruiksdoelverblijfsobject;
ALTER TABLE verblijfsobject RENAME COLUMN oppervlakte TO oppervlakteVerblijfsobject;
ALTER TABLE verblijfsobject RENAME COLUMN pandref TO gerelateerdepanden;
ALTER TABLE verblijfsobject RENAME COLUMN status TO verblijfsobjectStatus;

-- WPL specifiek
ALTER TABLE woonplaats RENAME COLUMN naam TO woonplaatsNaam;
ALTER TABLE woonplaats RENAME COLUMN status TO woonplaatsStatus;

-- GEM-WPL specifiek
ALTER TABLE gemeente_woonplaats
  ALTER COLUMN begindatumTijdvakGeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING begindatumTijdvakGeldigheid::timestamp with time zone;

ALTER TABLE gemeente_woonplaats
  ALTER COLUMN einddatumTijdvakGeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING einddatumTijdvakGeldigheid::timestamp with time zone;

ALTER TABLE gemeente_woonplaats DROP COLUMN geometry;

-- Convert MultiPolygon to Polygon for Pand
-- See GDAL Issue: https://github.com/OSGeo/gdal/issues/3467
-- LBVBAG driver generates MultiPolygon while BAG standard/XSD defines Polygon
-- This can be removed when that issue solved and incorporated in GDAL lib
ALTER TABLE pand ADD COLUMN geovlak_tmp geometry(Polygon, 28992);
UPDATE pand SET geovlak_tmp = (SELECT ST_GeometryN(geovlak,1) FROM pand p WHERE pand.gid = p.gid);
ALTER TABLE pand DROP COLUMN geovlak;
ALTER TABLE pand RENAME COLUMN geovlak_tmp TO geovlak;
