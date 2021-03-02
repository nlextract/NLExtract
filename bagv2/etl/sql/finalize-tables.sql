-- SET search_path TO test,public;

ALTER TABLE gemeente_woonplaats
  ALTER COLUMN begingeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING begingeldigheid::timestamp with time zone;

ALTER TABLE gemeente_woonplaats
  ALTER COLUMN eindgeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING eindgeldigheid::timestamp with time zone;

ALTER TABLE gemeente_woonplaats DROP COLUMN geometry;

-- Convert MultiPolygon to Polygon for Pand
-- See GDAL Issue: https://github.com/OSGeo/gdal/issues/3467
-- LBVBAG driver generates MultiPolygon while BAG standard/XSD defines Polygon
-- This can be removed when that issue solved and incorporated in GDAL lib
ALTER TABLE pand ADD COLUMN geovlak_tmp geometry(Polygon, 28992);
UPDATE pand SET geovlak_tmp = (SELECT ST_GeometryN(geovlak,1) FROM pand p WHERE pand.gid = p.gid);
ALTER TABLE pand DROP COLUMN geovlak;
ALTER TABLE pand RENAME COLUMN geovlak_tmp TO geovlak;
