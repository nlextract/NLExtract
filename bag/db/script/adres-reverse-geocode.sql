-- Reverse Geocode: vind adres(sen) dichtst bij een punt
--

-- Just van den Broecke

-- START Originele Code, Regina Obe
--   doc:  http://bostongis.com/PrinterFriendly.aspx?content_name=postgis_nearest_neighbor_generic
--   SQL: http://bostongis.com/downloads/pgis_nn.txt
CREATE OR REPLACE FUNCTION expandoverlap_metric(a geometry, b geometry, maxe double precision, maxslice double precision)
  RETURNS integer AS
$BODY$
BEGIN
    FOR i IN 0..maxslice LOOP
        IF expand(a,maxe*i/maxslice) && b THEN
            RETURN i;
        END IF;
    END LOOP;
    RETURN 99999999;
END;
$BODY$
LANGUAGE 'plpgsql' IMMUTABLE;

CREATE TYPE pgis_nn AS
   (nn_gid integer, nn_dist numeric(16,5));

CREATE OR REPLACE FUNCTION _pgis_fn_nn(geom1 geometry, distguess double precision, numnn integer, maxslices integer, lookupset varchar(150), swhere varchar(5000), sgid2field varchar(100), sgeom2field varchar(100))
  RETURNS SETOF pgis_nn AS
$BODY$
DECLARE
    strsql text;
    rec pgis_nn;
    ncollected integer;
    it integer;
--NOTE: it: the iteration we are currently at
--start at the bounding box of the object (expand 0) and move up until it has collected more objects than we need or it = maxslices whichever event happens first
BEGIN
    ncollected := 0; it := 0;
    WHILE ncollected < numnn AND it <= maxslices LOOP
        strsql := 'SELECT currentit.' || sgid2field || ', distance(ref.geom, currentit.' || sgeom2field || ') as dist FROM ' || lookupset || '  as currentit, (SELECT geometry(''' || CAST(geom1 As text) || ''') As geom) As ref WHERE ' || swhere || ' AND distance(ref.geom, currentit.' || sgeom2field || ') <= ' || CAST(distguess As varchar(200)) || ' AND expand(ref.geom, ' || CAST(distguess*it/maxslices As varchar(100)) ||  ') && currentit.' || sgeom2field || ' AND expandoverlap_metric(ref.geom, currentit.' || sgeom2field || ', ' || CAST(distguess As varchar(200)) || ', ' || CAST(maxslices As varchar(200)) || ') = ' || CAST(it As varchar(100)) || ' ORDER BY distance(ref.geom, currentit.' || sgeom2field || ') LIMIT ' ||
        CAST((numnn - ncollected) As varchar(200));
        --RAISE NOTICE 'sql: %', strsql;
        FOR rec in EXECUTE (strsql) LOOP
            IF ncollected < numnn THEN
                ncollected := ncollected + 1;
                RETURN NEXT rec;
            ELSE
                EXIT;
            END IF;
        END LOOP;
        it := it + 1;
    END LOOP;
END
$BODY$
LANGUAGE 'plpgsql' STABLE;

CREATE OR REPLACE FUNCTION pgis_fn_nn(geom1 geometry, distguess double precision, numnn integer, maxslices integer, lookupset varchar(150), swhere varchar(5000), sgid2field varchar(100), sgeom2field varchar(100))
  RETURNS SETOF pgis_nn AS
$BODY$
    SELECT * FROM _pgis_fn_nn($1,$2, $3, $4, $5, $6, $7, $8);
$BODY$
  LANGUAGE 'sql' STABLE;
-- EIND Originele Code, Regina Obe


--  -- BEGIN NLExtract Specifiek

-- Adressen voor x,y binnen straal meters
-- TODO geef ook afstand erbij terug
DROP FUNCTION IF EXISTS adressen_voor_xy(x double precision, y double precision, straal_meters double precision, max_records integer);
CREATE OR REPLACE FUNCTION adressen_voor_xy(x double precision, y double precision, straal_meters double precision, max_records integer)
  RETURNS SETOF adres AS
$BODY$
DECLARE
    point geometry;
    rnn pgis_nn%rowtype;
    radres adres%rowtype;
BEGIN
  point := ST_GeomFromText('POINT(' || x || ' ' || y || ')', 28992);

-- 111253 454919 centrum bodegraven
  for rnn in  SELECT * FROM pgis_fn_nn(point, straal_meters, max_records, 50,'adres', 'true', 'gid', 'geopunt') ORDER BY nn_dist LOOP
    for radres in  SELECT * FROM adres WHERE gid = rnn.nn_gid LOOP
       return next radres;
    end LOOP;
  end LOOP;
  return;

 END
$BODY$
LANGUAGE 'plpgsql' STABLE;

-- Dichtstbijzijnde adres voor x,y, geef 1 enkel adres terug
DROP FUNCTION IF EXISTS adres_voor_xy(x double precision, y double precision);
CREATE OR REPLACE FUNCTION adres_voor_xy(x double precision, y double precision)
RETURNS SETOF adres AS
  $BODY$
  DECLARE
    r adres;
  BEGIN
    for r in SELECT * from adressen_voor_xy(x ,y , 5000, 1) LOOP
      return next r;
    end LOOP;
    return;
  END
$BODY$
LANGUAGE 'plpgsql' STABLE;

-- EIND NLExtract Specifiek


-- create function GetEmployees() returns setof employee as 'select * from employee;' language 'sql';

-- Probeersels
--   for r in SELECT * FROM pgis_fn_nn(point, 100000, max_records, 1000, 'adres', 'true', 'gid', 'geopunt')
--       ORDER BY nn_dist DESC LOOP
--     return next r;
--     end LOOP;
--   return;

-- select * from pgis_fn_nn(ST_GeomFromText('POINT(252767 593745)',28992), 1000000, 2,1000,'adres', 'true', 'gid', 'geopunt');
--   select * from adres_voor_xy(118562, 480600, 1000000, 2);

--  -- SELECT * FROM Adres;
--         , pgis_fn_nn(point, 100000, max_records, 1000, 'adres', 'true', 'gid', 'geopunt') g
--    WHERE adr.gid = g.nn_gid;

--  SELECT * FROM pgis_fn_nn(point, 100000, max_records, 1000, 'adres', 'true', 'gid', 'geopunt');
--   SELECT g1.gid as gid_ref, adr.*, g1.nn_dist as afstand_meters, g1.nn_gid
--   FROM (SELECT b.gid,
--     (pgis_fn_nn(point_geom, 1000000, max_records,1000,'adres', 'true', 'gid', 'geopunt')).*
--       FROM (SELECT * FROM adres limit 1000) b) As g1, adres adr
--       WHERE adr.gid = g1.nn_gid
--       ORDER BY g1.nn_dist DESC

