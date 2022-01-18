-- Bijdrage van Willem Hoffmans - 18 jan 2022
-- Maak landsdekkende vlakken tabel uit alle BGT tabellen

-- landsdekkend vlakkenbestand maken
DROP TABLE IF EXISTS bgtvlakken CASCADE;
CREATE TABLE bgtvlakken
(gid SERIAL PRIMARY KEY,
laagnaam VARCHAR,
lokaalid VARCHAR,
relatievehoogteligging INTEGER,
bgt_functie VARCHAR,
plus_functie VARCHAR,
bgt_fysiekvoorkomen VARCHAR,
plus_fysiekvoorkomen VARCHAR,
bgt_type VARCHAR,
plus_type VARCHAR,
geom geometry (MultiSurface, 28992)
);


TRUNCATE TABLE bgtvlakken;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, geom)
SELECT 'begroeidterreindeel', lokaalid, relatievehoogteligging, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, ST_Multi(geometrie_vlak)
FROM begroeidterreindeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'gebouwinstallatie', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM gebouwinstallatie AS l1 WHERE geometrie_vlak IS NOT NULL;
-- Kunstwerkdeel: enkele en multi geom's
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'kunstwerkdeel', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM kunstwerkdeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'kunstwerkdeel', lokaalid, relatievehoogteligging, bgt_type, plus_type, geometrie_multivlak
FROM kunstwerkdeel AS l1 WHERE geometrie_multivlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, geom)
SELECT 'onbegroeidterreindeel', lokaalid, relatievehoogteligging, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, ST_Multi(geometrie_vlak)
FROM onbegroeidterreindeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'ondersteunendwaterdeel', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM ondersteunendwaterdeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, geom)
SELECT 'ondersteunendwegdeel', lokaalid, relatievehoogteligging, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, ST_Multi(geometrie_vlak)
FROM ondersteunendwegdeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, geom)
SELECT 'ongeclassificeerdobject', lokaalid, relatievehoogteligging, ST_Multi(geometrie_vlak)
FROM ongeclassificeerdobject AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, geom)
SELECT 'openbareruimte', lokaalid, relatievehoogteligging, ST_Multi(geometrie_vlak)
FROM openbareruimte AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'overigbouwwerk', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM overigbouwwerk AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, plus_type, geom)
SELECT 'overigescheiding', lokaalid, relatievehoogteligging, plus_type, ST_Multi(geometrie_vlak)
FROM overigescheiding AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, geom)
SELECT 'pand', lokaalid, relatievehoogteligging, ST_Multi(geometrie_vlak)
FROM pand AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'scheiding', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM scheiding AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'vegetatieobject', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM vegetatieobject AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'waterdeel', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM waterdeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, geom)
SELECT 'wegdeel', lokaalid, relatievehoogteligging, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, ST_Multi(geometrie_vlak)
FROM wegdeel AS l1 WHERE geometrie_vlak IS NOT NULL;
INSERT INTO bgtvlakken (laagnaam, lokaalid, relatievehoogteligging, bgt_type, plus_type, geom)
SELECT 'weginrichtingselement', lokaalid, relatievehoogteligging, bgt_type, plus_type, ST_Multi(geometrie_vlak)
FROM weginrichtingselement AS l1 WHERE geometrie_vlak IS NOT NULL;

CREATE INDEX idx_bgtvlakken_geom ON bgtvlakken USING gist(geom);
CREATE INDEX idx_bgtvlakken_laagnaam ON bgtvlakken USING btree(laagnaam);
CREATE INDEX idx_bgtvlakken_lokaalid ON bgtvlakken USING btree(lokaalid);
CREATE INDEX idx_bgtvlakken_gid ON bgtvlakken USING btree(gid);
CREATE INDEX idx_bgtvlakken_relatievehoogteligging ON bgtvlakken USING btree(relatievehoogteligging);

-- Afgeleide views, o.a. hoogteligging = 0
CREATE OR REPLACE VIEW bgtvlakken_hoogte0 AS
SELECT * FROM bgtvlakken WHERE relatievehoogteligging = 0;

