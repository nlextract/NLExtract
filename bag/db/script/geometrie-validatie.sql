-- Geometrie validatie, evt later te gebruiken

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- validateGeometry.sql
--
-- validateGeometry - valideren en loggen van foute geometrieen
-- Just van den Broecke
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
-- This software is without any warrenty and you use it at your own risk
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

CREATE OR REPLACE FUNCTION validateGeometry(tabel text, identificatie varchar(16), geom geometry)
  RETURNS geometry AS
$BODY$DECLARE

BEGIN

  IF NOT isValid(geom) THEN
    RAISE NOTICE 'De geometrie voor record %.% is niet-valide, type = % summary=%', tabel, identificatie, GeometryType(geom),st_summary(geom);
    -- hier evt loggen
  ELSE
    -- RAISE INFO 'De geometrie voor record %.% is  WEL valide, type = % summary=%', tabel, identificatie, GeometryType(geom),st_summary(geom);

  END IF;
  RETURN geom;

END;$BODY$
LANGUAGE 'plpgsql' VOLATILE;

-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
--
-- $Id: cleanGeometry.sql 2008-04-24 10:30Z Dr. Horst Duester $
--
-- cleanGeometry - remove self- and ring-selfintersections from
--                 input Polygon geometries
-- http://www.sogis.ch
-- Copyright 2008 SO!GIS Koordination, Kanton Solothurn, Switzerland
-- Version 1.0
-- contact: horst dot duester at bd dot so dot ch
--
-- This is free software; you can redistribute and/or modify it under
-- the terms of the GNU General Public Licence. See the COPYING file.
-- This software is without any warrenty and you use it at your own risk
--
-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
-- See also : http://stackoverflow.com/questions/2023821/postgis-how-do-i-check-the-geometry-type-before-i-do-an-insert

CREATE OR REPLACE FUNCTION cleanGeometry(geometry)
  RETURNS geometry AS
$BODY$DECLARE
  inGeom ALIAS for $1;
  outGeom geometry;
  tmpLinestring geometry;

Begin

  outGeom := NULL;

-- Clean Process for Polygon
  IF (GeometryType(inGeom) = 'POLYGON' OR GeometryType(inGeom) = 'MULTIPOLYGON') THEN

-- Only process if geometry is not valid,
-- otherwise put out without change
    if not isValid(inGeom) THEN

-- create nodes at all self-intersecting lines by union the polygon boundaries
-- with the startingpoint of the boundary.
      tmpLinestring := st_union(st_multi(st_boundary(inGeom)),st_pointn(boundary(inGeom),1));
      outGeom = buildarea(tmpLinestring);
      IF (GeometryType(inGeom) = 'MULTIPOLYGON') THEN
        RETURN st_multi(outGeom);
      ELSE
        RETURN outGeom;
      END IF;
    else
      RETURN inGeom;
    END IF;


------------------------------------------------------------------------------
-- Clean Process for LINESTRINGS, self-intersecting parts of linestrings
-- will be divided into multiparts of the mentioned linestring
------------------------------------------------------------------------------
  ELSIF (GeometryType(inGeom) = 'LINESTRING') THEN

-- create nodes at all self-intersecting lines by union the linestrings
-- with the startingpoint of the linestring.
    outGeom := st_union(st_multi(inGeom),st_pointn(inGeom,1));
    RETURN outGeom;
  ELSIF (GeometryType(inGeom) = 'MULTILINESTRING') THEN
    outGeom := multi(st_union(st_multi(inGeom),st_pointn(inGeom,1)));
    RETURN outGeom;
  ELSIF (GeometryType(inGeom) = '<NULL>' OR GeometryType(inGeom) = 'GEOMETRYCOLLECTION') THEN
    RETURN NULL;
  ELSE
    RAISE NOTICE 'The input type % is not supported %',GeometryType(inGeom),st_summary(inGeom);
    RETURN inGeom;
  END IF;
End;$BODY$
  LANGUAGE 'plpgsql' VOLATILE;

-- http://www.spatialdbadvisor.com/postgis_tips_tricks/92/filtering-rings-in-polygon-postgis
-- http://www.bostongis.com/postgis_dump.snippet
-- SELECT ST_AsText(b.the_geom) as final_geom, ST_Area(b.the_geom) as area
--   FROM (SELECT (ST_DumpRings(vlak) FROM SELECT (ST_Dump(a.geovlak)).geom as vlak).geom As the_geom
--           FROM (SELECT geovlak FROM provincie  as geom
--                 ) a
--         ) b;
