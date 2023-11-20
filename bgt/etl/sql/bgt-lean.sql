--
-- Make a lean BGT in new schema.
-- - only actual+existing objects (actueelbestaand)
-- - only tables, no views
-- - one geometry per table
-- - only Simple geometries, no Curve/Surface like
-- - remove all obsolete columns
--
-- Author: Just van den Broecke - 2022

-- Assume bgt is loaded in 'bgt_full' schema
DROP SCHEMA IF EXISTS bgt_lean CASCADE;
CREATE SCHEMA bgt_lean;


-- --
-- -- BAK
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.bak_cols CASCADE;
CREATE VIEW bgt_lean.bak_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.bakactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.bak_punt CASCADE;
CREATE TABLE bgt_lean.bak_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.bak_cols a, latest.bakactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX bak_punt_geometrie_punt_geom_idx ON bgt_lean.bak_punt USING gist(geometrie_punt);
-- CREATE INDEX bak_punt_lokaalid_idx ON bgt_lean.bak_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.bak_punt ADD CONSTRAINT bak_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.bak_cols;
COMMIT;

-- --
-- -- BEGROEIDTERREINDEEL
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.begroeidterreindeel_cols CASCADE;
CREATE VIEW bgt_lean.begroeidterreindeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_fysiekvoorkomen,
    plus_fysiekvoorkomen,
    begroeidterreindeeloptalud
FROM latest.begroeidterreindeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.begroeidterreindeel_vlak CASCADE;
CREATE TABLE bgt_lean.begroeidterreindeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.begroeidterreindeel_cols a, latest.begroeidterreindeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX begroeidterreindeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.begroeidterreindeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX begroeidterreindeel_vlak_lokaalid_idx ON bgt_lean.begroeidterreindeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.begroeidterreindeel_vlak ADD CONSTRAINT begroeidterreindeel_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.begroeidterreindeel_kruinlijn CASCADE;
CREATE TABLE bgt_lean.begroeidterreindeel_kruinlijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_kruinlijn))::geometry(LineString, 28992) as geometrie_kruinlijn
FROM bgt_lean.begroeidterreindeel_cols a, latest.begroeidterreindeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_kruinlijn is not null AND ST_IsValid(b.geometrie_kruinlijn);
CREATE INDEX begroeidterreindeel_kruinlijn_geometrie_kruinlijn_geom_idx ON bgt_lean.begroeidterreindeel_kruinlijn USING gist(geometrie_kruinlijn);
-- CREATE INDEX begroeidterreindeel_kruinlijn_lokaalid_idx ON bgt_lean.begroeidterreindeel_kruinlijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.begroeidterreindeel_kruinlijn ADD CONSTRAINT begroeidterreindeel_kruinlijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.begroeidterreindeel_cols;
COMMIT;

-- --
-- -- BORD
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.bord_cols CASCADE;
CREATE VIEW bgt_lean.bord_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.bordactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.bord_punt CASCADE;
CREATE TABLE bgt_lean.bord_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.bord_cols a, latest.bordactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX bord_punt_geometrie_punt_geom_idx ON bgt_lean.bord_punt USING gist(geometrie_punt);
-- CREATE INDEX bord_punt_lokaalid_idx ON bgt_lean.bord_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.bord_punt ADD CONSTRAINT bord_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.bord_cols;
COMMIT;

--
-- BUURT
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.buurt_cols CASCADE;
CREATE VIEW bgt_lean.buurt_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    naam
FROM latest.buurtactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.buurt_vlak CASCADE;
CREATE TABLE bgt_lean.buurt_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.buurt_cols a, latest.buurtactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX buurt_vlak_geometrie_multivlak_geom_idx ON bgt_lean.buurt_vlak USING gist(geometrie_multivlak);
-- CREATE INDEX buurt_vlak_lokaalid_idx ON bgt_lean.buurt_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.buurt_vlak ADD CONSTRAINT buurt_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.buurt_cols;
COMMIT;

--
-- FUNCTIONEELGEBIED
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.functioneelgebied_cols CASCADE;
CREATE VIEW bgt_lean.functioneelgebied_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type,
    naam
FROM latest.functioneelgebiedactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.functioneelgebied_vlak CASCADE;
CREATE TABLE bgt_lean.functioneelgebied_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.functioneelgebied_cols a, latest.functioneelgebiedactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX functioneelgebied_vlak_geometrie_vlak_geom_idx ON bgt_lean.functioneelgebied_vlak USING gist(geometrie_vlak);
-- CREATE INDEX functioneelgebied_vlak_lokaalid_idx ON bgt_lean.functioneelgebied_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.functioneelgebied_vlak ADD CONSTRAINT functioneelgebied_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.functioneelgebied_cols;
COMMIT;

--
-- GEBOUWINSTALLATIE
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.gebouwinstallatie_cols CASCADE;
CREATE VIEW bgt_lean.gebouwinstallatie_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.gebouwinstallatieactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.gebouwinstallatie_vlak CASCADE;
CREATE TABLE bgt_lean.gebouwinstallatie_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.gebouwinstallatie_cols a, latest.gebouwinstallatieactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX gebouwinstallatie_vlak_geometrie_vlak_geom_idx ON bgt_lean.gebouwinstallatie_vlak USING gist(geometrie_vlak);
-- CREATE INDEX gebouwinstallatie_vlak_lokaalid_idx ON bgt_lean.gebouwinstallatie_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.gebouwinstallatie_vlak ADD CONSTRAINT gebouwinstallatie_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.gebouwinstallatie_cols;
COMMIT;

-- --
-- -- INSTALLATIE
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.installatie_cols CASCADE;
CREATE VIEW bgt_lean.installatie_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.installatieactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.installatie_punt CASCADE;
CREATE TABLE bgt_lean.installatie_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.installatie_cols a, latest.installatieactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX installatie_punt_geometrie_punt_geom_idx ON bgt_lean.installatie_punt USING gist(geometrie_punt);
-- CREATE INDEX installatie_punt_lokaalid_idx ON bgt_lean.installatie_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.installatie_punt ADD CONSTRAINT installatie_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.installatie_cols;
COMMIT;

-- --
-- -- KAST
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.kast_cols CASCADE;
CREATE VIEW bgt_lean.kast_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.kastactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.kast_punt CASCADE;
CREATE TABLE bgt_lean.kast_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.kast_cols a, latest.kastactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX kast_punt_geometrie_punt_geom_idx ON bgt_lean.kast_punt USING gist(geometrie_punt);
-- CREATE INDEX kast_punt_lokaalid_idx ON bgt_lean.kast_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.kast_punt ADD CONSTRAINT kast_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.kast_cols;
COMMIT;


--
-- KUNSTWERKDEEL
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.kunstwerkdeel_cols CASCADE;
CREATE VIEW bgt_lean.kunstwerkdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.kunstwerkdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.kunstwerkdeel_multipunt CASCADE;
CREATE TABLE bgt_lean.kunstwerkdeel_multipunt AS
SELECT
    a.*,
    b.geometrie_multipunt
FROM bgt_lean.kunstwerkdeel_cols a, latest.kunstwerkdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_multipunt is not null AND ST_IsValid(b.geometrie_multipunt);
CREATE INDEX kunstwerkdeel_multipunt_geometrie_multipunt_geom_idx ON bgt_lean.kunstwerkdeel_multipunt USING gist(geometrie_multipunt);
-- CREATE INDEX kunstwerkdeel_multipunt_lokaalid_idx ON bgt_lean.kunstwerkdeel_multipunt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.kunstwerkdeel_multipunt ADD CONSTRAINT kunstwerkdeel_multipunt_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.kunstwerkdeel_multivlak CASCADE;
CREATE TABLE bgt_lean.kunstwerkdeel_multivlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_multivlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.kunstwerkdeel_cols a, latest.kunstwerkdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_multivlak is not null AND ST_IsValid(b.geometrie_multivlak);
CREATE INDEX kunstwerkdeel_multivlak_geometrie_multivlak_geom_idx ON bgt_lean.kunstwerkdeel_multivlak USING gist(geometrie_multivlak);
-- CREATE INDEX kunstwerkdeel_multivlak_lokaalid_idx ON bgt_lean.kunstwerkdeel_multivlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.kunstwerkdeel_multivlak ADD CONSTRAINT kunstwerkdeel_multivlak_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.kunstwerkdeel_vlak CASCADE;
CREATE TABLE bgt_lean.kunstwerkdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.kunstwerkdeel_cols a, latest.kunstwerkdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX kunstwerkdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.kunstwerkdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX kunstwerkdeel_vlak_lokaalid_idx ON bgt_lean.kunstwerkdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.kunstwerkdeel_vlak ADD CONSTRAINT kunstwerkdeel_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.kunstwerkdeel_lijn CASCADE;
CREATE TABLE bgt_lean.kunstwerkdeel_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.kunstwerkdeel_cols a, latest.kunstwerkdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX kunstwerkdeel_lijn_geometrie_lijn_geom_idx ON bgt_lean.kunstwerkdeel_lijn USING gist(geometrie_lijn);
-- CREATE INDEX kunstwerkdeel_lijn_lokaalid_idx ON bgt_lean.kunstwerkdeel_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.kunstwerkdeel_lijn ADD CONSTRAINT kunstwerkdeel_lijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.kunstwerkdeel_cols;
COMMIT;


-- --
-- -- MAST
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.mast_cols CASCADE;
CREATE VIEW bgt_lean.mast_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.mastactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.mast_punt CASCADE;
CREATE TABLE bgt_lean.mast_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.mast_cols a, latest.mastactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX mast_punt_geometrie_punt_geom_idx ON bgt_lean.mast_punt USING gist(geometrie_punt);
-- CREATE INDEX mast_punt_lokaalid_idx ON bgt_lean.mast_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.mast_punt ADD CONSTRAINT mast_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.mast_cols;
COMMIT;

-- --
-- -- ONBEGROEIDTERREINDEEL
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.onbegroeidterreindeel_cols CASCADE;
CREATE VIEW bgt_lean.onbegroeidterreindeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_fysiekvoorkomen,
    plus_fysiekvoorkomen,
    onbegroeidterreindeeloptalud
FROM latest.onbegroeidterreindeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.onbegroeidterreindeel_vlak CASCADE;
CREATE TABLE bgt_lean.onbegroeidterreindeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.onbegroeidterreindeel_cols a, latest.onbegroeidterreindeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX onbegroeidterreindeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.onbegroeidterreindeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX onbegroeidterreindeel_vlak_lokaalid_idx ON bgt_lean.onbegroeidterreindeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.onbegroeidterreindeel_vlak ADD CONSTRAINT onbegroeidterreindeel_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.onbegroeidterreindeel_kruinlijn CASCADE;
CREATE TABLE bgt_lean.onbegroeidterreindeel_kruinlijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_kruinlijn))::geometry(LineString, 28992) as geometrie_kruinlijn
FROM bgt_lean.onbegroeidterreindeel_cols a, latest.onbegroeidterreindeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_kruinlijn is not null AND ST_IsValid(b.geometrie_kruinlijn);
CREATE INDEX onbegroeidterreindeel_kruinlijn_geometrie_kruinlijn_geom_idx ON bgt_lean.onbegroeidterreindeel_kruinlijn USING gist(geometrie_kruinlijn);
-- CREATE INDEX onbegroeidterreindeel_kruinlijn_lokaalid_idx ON bgt_lean.onbegroeidterreindeel_kruinlijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.onbegroeidterreindeel_kruinlijn ADD CONSTRAINT onbegroeidterreindeel_kruinlijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.onbegroeidterreindeel_cols;
COMMIT;


--
-- ONDERSTEUNENDWATERDEEL
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.ondersteunendwaterdeel_cols CASCADE;
CREATE VIEW bgt_lean.ondersteunendwaterdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.ondersteunendwaterdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.ondersteunendwaterdeel_vlak CASCADE;
CREATE TABLE bgt_lean.ondersteunendwaterdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.ondersteunendwaterdeel_cols a, latest.ondersteunendwaterdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX ondersteunendwaterdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.ondersteunendwaterdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX ondersteunendwaterdeel_vlak_lokaalid_idx ON bgt_lean.ondersteunendwaterdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.ondersteunendwaterdeel_vlak ADD CONSTRAINT ondersteunendwaterdeel_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.ondersteunendwaterdeel_cols;
COMMIT;

--
-- ONDERSTEUNENDWEGDEEL
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.ondersteunendwegdeel_cols CASCADE;
CREATE VIEW bgt_lean.ondersteunendwegdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_functie,
    plus_functie,
    bgt_fysiekvoorkomen,
    plus_fysiekvoorkomen,
    ondersteunendwegdeeloptalud
FROM latest.ondersteunendwegdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.ondersteunendwegdeel_vlak CASCADE;
CREATE TABLE bgt_lean.ondersteunendwegdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.ondersteunendwegdeel_cols a, latest.ondersteunendwegdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX ondersteunendwegdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.ondersteunendwegdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX ondersteunendwegdeel_vlak_lokaalid_idx ON bgt_lean.ondersteunendwegdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.ondersteunendwegdeel_vlak ADD CONSTRAINT ondersteunendwegdeel_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.ondersteunendwegdeel_kruinlijn CASCADE;
CREATE TABLE bgt_lean.ondersteunendwegdeel_kruinlijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_kruinlijn))::geometry(LineString, 28992) as geometrie_kruinlijn
FROM bgt_lean.ondersteunendwegdeel_cols a, latest.ondersteunendwegdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_kruinlijn is not null AND ST_IsValid(b.geometrie_kruinlijn);
CREATE INDEX ondersteunendwegdeel_kruinlijn_geometrie_kruinlijn_geom_idx ON bgt_lean.ondersteunendwegdeel_kruinlijn USING gist(geometrie_kruinlijn);
-- CREATE INDEX ondersteunendwegdeel_kruinlijn_lokaalid_idx ON bgt_lean.ondersteunendwegdeel_kruinlijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.ondersteunendwegdeel_kruinlijn ADD CONSTRAINT ondersteunendwegdeel_kruinlijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.ondersteunendwegdeel_cols;
COMMIT;

--
-- OPENBARERUIMTE
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.openbareruimte_cols CASCADE;
CREATE VIEW bgt_lean.openbareruimte_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    naam
FROM latest.openbareruimteactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.openbareruimte_multivlak CASCADE;
CREATE TABLE bgt_lean.openbareruimte_multivlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.openbareruimte_cols a, latest.openbareruimteactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX openbareruimte_multivlak_geometrie_multivlak_geom_idx ON bgt_lean.openbareruimte_multivlak USING gist(geometrie_multivlak);
-- CREATE INDEX openbareruimte_multivlak_lokaalid_idx ON bgt_lean.openbareruimte_multivlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.openbareruimte_multivlak ADD CONSTRAINT openbareruimte_multivlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.openbareruimte_cols;
COMMIT;


-- --
-- -- OPENBARERUIMTELABEL
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.openbareruimtelabel_cols CASCADE;
CREATE VIEW bgt_lean.openbareruimtelabel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    identificatiebagopr,
    tekst,
    hoek,
    openbareruimtetype
FROM latest.openbareruimtelabelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.openbareruimtelabel_punt CASCADE;
CREATE TABLE bgt_lean.openbareruimtelabel_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.openbareruimtelabel_cols a, latest.openbareruimtelabelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX openbareruimtelabel_punt_geometrie_punt_geom_idx ON bgt_lean.openbareruimtelabel_punt USING gist(geometrie_punt);
-- CREATE INDEX openbareruimtelabel_punt_lokaalid_idx ON bgt_lean.openbareruimtelabel_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.openbareruimtelabel_punt ADD CONSTRAINT openbareruimtelabel_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.openbareruimtelabel_cols;
COMMIT;


--
-- OVERBRUGGINGSDEEL
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.overbruggingsdeel_cols CASCADE;
CREATE VIEW bgt_lean.overbruggingsdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    typeoverbruggingsdeel,
    hoortbijtypeoverbrugging,
    overbruggingisbeweegbaar
FROM latest.overbruggingsdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.overbruggingsdeel_vlak CASCADE;
CREATE TABLE bgt_lean.overbruggingsdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.overbruggingsdeel_cols a, latest.overbruggingsdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX overbruggingsdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.overbruggingsdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX overbruggingsdeel_vlak_lokaalid_idx ON bgt_lean.overbruggingsdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.overbruggingsdeel_vlak ADD CONSTRAINT overbruggingsdeel_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.overbruggingsdeel_cols;
COMMIT;


--
-- OVERIGBOUWWERK
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.overigbouwwerk_cols CASCADE;
CREATE VIEW bgt_lean.overigbouwwerk_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type

FROM latest.overigbouwwerkactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.overigbouwwerk_multivlak CASCADE;
CREATE TABLE bgt_lean.overigbouwwerk_multivlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.overigbouwwerk_cols a, latest.overigbouwwerkactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX overigbouwwerk_multivlak_geometrie_multivlak_geom_idx ON bgt_lean.overigbouwwerk_multivlak USING gist(geometrie_multivlak);
-- CREATE INDEX overigbouwwerk_multivlak_lokaalid_idx ON bgt_lean.overigbouwwerk_multivlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.overigbouwwerk_multivlak ADD CONSTRAINT overigbouwwerk_multivlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.overigbouwwerk_cols;
COMMIT;

--
-- OVERIGESCHEIDING
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.overigescheiding_cols CASCADE;
CREATE VIEW bgt_lean.overigescheiding_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    plus_type
FROM latest.overigescheidingactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.overigescheiding_vlak CASCADE;
CREATE TABLE bgt_lean.overigescheiding_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.overigescheiding_cols a, latest.overigescheidingactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX overigescheiding_vlak_geometrie_vlak_geom_idx ON bgt_lean.overigescheiding_vlak USING gist(geometrie_vlak);
-- CREATE INDEX overigescheiding_vlak_lokaalid_idx ON bgt_lean.overigescheiding_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.overigescheiding_vlak ADD CONSTRAINT overigescheiding_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.overigescheiding_lijn CASCADE;
CREATE TABLE bgt_lean.overigescheiding_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.overigescheiding_cols a, latest.overigescheidingactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX overigescheiding_lijn_geometrie_lijn_geom_idx ON bgt_lean.overigescheiding_lijn USING gist(geometrie_lijn);
-- CREATE INDEX overigescheiding_lijn_lokaalid_idx ON bgt_lean.overigescheiding_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.overigescheiding_lijn ADD CONSTRAINT overigescheiding_lijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.overigescheiding_cols;

COMMIT;
-- --
-- -- PAAL
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.paal_cols CASCADE;
CREATE VIEW bgt_lean.paal_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type,
    hectometeraanduiding
FROM latest.paalactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.paal_punt CASCADE;
CREATE TABLE bgt_lean.paal_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.paal_cols a, latest.paalactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX paal_punt_geometrie_punt_geom_idx ON bgt_lean.paal_punt USING gist(geometrie_punt);
-- CREATE INDEX paal_punt_lokaalid_idx ON bgt_lean.paal_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.paal_punt ADD CONSTRAINT paal_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.paal_cols;
COMMIT;

--
-- PAND
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.pand_cols CASCADE;
CREATE VIEW bgt_lean.pand_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    identificatiebagpnd

FROM latest.pandactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.pand_multivlak CASCADE;
CREATE TABLE bgt_lean.pand_multivlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.pand_cols a, latest.pandactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX pand_multivlak_geometrie_multivlak_geom_idx ON bgt_lean.pand_multivlak USING gist(geometrie_multivlak);
-- CREATE INDEX pand_multivlak_lokaalid_idx ON bgt_lean.pand_multivlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.pand_multivlak ADD CONSTRAINT pand_multivlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.pand_cols;
COMMIT;

-- --
-- -- PAND_NUMMERAANDUIDING
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.pand_nummeraanduiding_cols CASCADE;
CREATE VIEW bgt_lean.pand_nummeraanduiding_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    identificatiebagpnd,
    nummeraanduidingtekst,
    nummeraanduidinghoek,
    identificatiebagvbolaagstehuisnummer,
    identificatiebagvbohoogstehuisnummer
FROM latest.pand_nummeraanduidingactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.pand_nummeraanduiding_punt CASCADE;
CREATE TABLE bgt_lean.pand_nummeraanduiding_punt AS
SELECT
    a.*,
    b.geometrie_nummeraanduiding as geometrie_punt
FROM bgt_lean.pand_nummeraanduiding_cols a, latest.pand_nummeraanduidingactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_nummeraanduiding is not null AND ST_IsValid(b.geometrie_nummeraanduiding);
CREATE INDEX pand_nummeraanduiding_punt_geometrie_punt_geom_idx ON bgt_lean.pand_nummeraanduiding_punt USING gist(geometrie_punt);
-- CREATE INDEX pand_nummeraanduiding_punt_lokaalid_idx ON bgt_lean.pand_nummeraanduiding_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.pand_nummeraanduiding_punt ADD CONSTRAINT pand_nummeraanduiding_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.pand_nummeraanduiding_cols;
COMMIT;

-- --
-- -- PUT
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.put_cols CASCADE;
CREATE VIEW bgt_lean.put_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.putactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.put_punt CASCADE;
CREATE TABLE bgt_lean.put_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.put_cols a, latest.putactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX put_punt_geometrie_punt_geom_idx ON bgt_lean.put_punt USING gist(geometrie_punt);
-- CREATE INDEX put_punt_lokaalid_idx ON bgt_lean.put_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.put_punt ADD CONSTRAINT put_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.put_cols;
COMMIT;


--
-- SCHEIDING
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.scheiding_cols CASCADE;
CREATE VIEW bgt_lean.scheiding_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.scheidingactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.scheiding_vlak CASCADE;
CREATE TABLE bgt_lean.scheiding_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.scheiding_cols a, latest.scheidingactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX scheiding_vlak_geometrie_vlak_geom_idx ON bgt_lean.scheiding_vlak USING gist(geometrie_vlak);
-- CREATE INDEX scheiding_vlak_lokaalid_idx ON bgt_lean.scheiding_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.scheiding_vlak ADD CONSTRAINT scheiding_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.scheiding_lijn CASCADE;
CREATE TABLE bgt_lean.scheiding_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.scheiding_cols a, latest.scheidingactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX scheiding_lijn_geometrie_lijn_geom_idx ON bgt_lean.scheiding_lijn USING gist(geometrie_lijn);
-- CREATE INDEX scheiding_lijn_lokaalid_idx ON bgt_lean.scheiding_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.scheiding_lijn ADD CONSTRAINT scheiding_lijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.scheiding_cols;
COMMIT;


--
-- SENSOR
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.sensor_cols CASCADE;
CREATE VIEW bgt_lean.sensor_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.sensoractueelbestaand;

DROP TABLE IF EXISTS bgt_lean.sensor_lijn CASCADE;
CREATE TABLE bgt_lean.sensor_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.sensor_cols a, latest.sensoractueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX sensor_lijn_geometrie_lijn_geom_idx ON bgt_lean.sensor_lijn USING gist(geometrie_lijn);
-- CREATE INDEX sensor_lijn_lokaalid_idx ON bgt_lean.sensor_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.sensor_lijn ADD CONSTRAINT sensor_lijn_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.sensor_punt CASCADE;
CREATE TABLE bgt_lean.sensor_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.sensor_cols a, latest.sensoractueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX sensor_punt_geometrie_punt_geom_idx ON bgt_lean.sensor_punt USING gist(geometrie_punt);
-- CREATE INDEX sensor_punt_lokaalid_idx ON bgt_lean.sensor_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.sensor_punt ADD CONSTRAINT sensor_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.sensor_cols;
COMMIT;


--
-- SPOOR
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.spoor_cols CASCADE;
CREATE VIEW bgt_lean.spoor_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_functie,
    plus_functie
FROM latest.spooractueelbestaand;

DROP TABLE IF EXISTS bgt_lean.spoor_lijn CASCADE;
CREATE TABLE bgt_lean.spoor_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.spoor_cols a, latest.spooractueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX spoor_lijn_geometrie_lijn_geom_idx ON bgt_lean.spoor_lijn USING gist(geometrie_lijn);
-- CREATE INDEX spoor_lijn_lokaalid_idx ON bgt_lean.spoor_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.spoor_lijn ADD CONSTRAINT spoor_lijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.spoor_cols;
COMMIT;

--
-- STADSDEEL
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.stadsdeel_cols CASCADE;
CREATE VIEW bgt_lean.stadsdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    naam
FROM latest.stadsdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.stadsdeel_vlak CASCADE;
CREATE TABLE bgt_lean.stadsdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.stadsdeel_cols a, latest.stadsdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX stadsdeel_vlak_geometrie_multivlak_geom_idx ON bgt_lean.stadsdeel_vlak USING gist(geometrie_multivlak);
-- CREATE INDEX stadsdeel_vlak_lokaalid_idx ON bgt_lean.stadsdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.stadsdeel_vlak ADD CONSTRAINT stadsdeel_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.stadsdeel_cols;
COMMIT;


-- --
-- -- STRAATMEUBILAIR
-- --

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.straatmeubilair_cols CASCADE;
CREATE VIEW bgt_lean.straatmeubilair_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.straatmeubilairactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.straatmeubilair_punt CASCADE;
CREATE TABLE bgt_lean.straatmeubilair_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.straatmeubilair_cols a, latest.straatmeubilairactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX straatmeubilair_punt_geometrie_punt_geom_idx ON bgt_lean.straatmeubilair_punt USING gist(geometrie_punt);
-- CREATE INDEX straatmeubilair_punt_lokaalid_idx ON bgt_lean.straatmeubilair_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.straatmeubilair_punt ADD CONSTRAINT straatmeubilair_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.straatmeubilair_cols;
COMMIT;


--
-- TUNNELDEEL
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.tunneldeel_cols CASCADE;
CREATE VIEW bgt_lean.tunneldeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging
FROM latest.tunneldeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.tunneldeel_vlak CASCADE;
CREATE TABLE bgt_lean.tunneldeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.tunneldeel_cols a, latest.tunneldeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX tunneldeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.tunneldeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX tunneldeel_vlak_lokaalid_idx ON bgt_lean.tunneldeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.tunneldeel_vlak ADD CONSTRAINT tunneldeel_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.tunneldeel_cols;
COMMIT;

--
-- VEGETATIEOBJECT
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.vegetatieobject_cols CASCADE;
CREATE VIEW bgt_lean.vegetatieobject_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.vegetatieobjectactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.vegetatieobject_lijn CASCADE;
CREATE TABLE bgt_lean.vegetatieobject_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.vegetatieobject_cols a, latest.vegetatieobjectactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX vegetatieobject_lijn_geometrie_lijn_geom_idx ON bgt_lean.vegetatieobject_lijn USING gist(geometrie_lijn);
-- CREATE INDEX vegetatieobject_lijn_lokaalid_idx ON bgt_lean.vegetatieobject_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.vegetatieobject_lijn ADD CONSTRAINT vegetatieobject_lijn_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.vegetatieobject_punt CASCADE;
CREATE TABLE bgt_lean.vegetatieobject_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.vegetatieobject_cols a, latest.vegetatieobjectactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX vegetatieobject_punt_geometrie_punt_geom_idx ON bgt_lean.vegetatieobject_punt USING gist(geometrie_punt);
-- CREATE INDEX vegetatieobject_punt_lokaalid_idx ON bgt_lean.vegetatieobject_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.vegetatieobject_punt ADD CONSTRAINT vegetatieobject_punt_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.vegetatieobject_vlak CASCADE;
CREATE TABLE bgt_lean.vegetatieobject_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.vegetatieobject_cols a, latest.vegetatieobjectactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX vegetatieobject_vlak_geometrie_vlak_geom_idx ON bgt_lean.vegetatieobject_vlak USING gist(geometrie_vlak);
-- CREATE INDEX vegetatieobject_vlak_lokaalid_idx ON bgt_lean.vegetatieobject_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.vegetatieobject_vlak ADD CONSTRAINT vegetatieobject_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.vegetatieobject_cols;
COMMIT;

--
-- WATERDEEL
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.waterdeel_cols CASCADE;
CREATE VIEW bgt_lean.waterdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.waterdeelactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.waterdeel_vlak CASCADE;
CREATE TABLE bgt_lean.waterdeel_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.waterdeel_cols a, latest.waterdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX waterdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.waterdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX waterdeel_vlak_lokaalid_idx ON bgt_lean.waterdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.waterdeel_vlak ADD CONSTRAINT waterdeel_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.waterdeel_cols;
COMMIT;

--
-- WATERINRICHTINGSELEMENT
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.waterinrichtingselement_cols CASCADE;
CREATE VIEW bgt_lean.waterinrichtingselement_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.waterinrichtingselementactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.waterinrichtingselement_lijn CASCADE;
CREATE TABLE bgt_lean.waterinrichtingselement_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.waterinrichtingselement_cols a, latest.waterinrichtingselementactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX waterinrichtingselement_lijn_geometrie_lijn_geom_idx ON bgt_lean.waterinrichtingselement_lijn USING gist(geometrie_lijn);
-- CREATE INDEX waterinrichtingselement_lijn_lokaalid_idx ON bgt_lean.waterinrichtingselement_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.waterinrichtingselement_lijn ADD CONSTRAINT waterinrichtingselement_lijn_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.waterinrichtingselement_punt CASCADE;
CREATE TABLE bgt_lean.waterinrichtingselement_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.waterinrichtingselement_cols a, latest.waterinrichtingselementactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX waterinrichtingselement_punt_geometrie_punt_geom_idx ON bgt_lean.waterinrichtingselement_punt USING gist(geometrie_punt);
-- CREATE INDEX waterinrichtingselement_punt_lokaalid_idx ON bgt_lean.waterinrichtingselement_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.waterinrichtingselement_punt ADD CONSTRAINT waterinrichtingselement_punt_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.waterinrichtingselement_cols;
COMMIT;


--
-- WATERSCHAP
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.waterschap_cols CASCADE;
CREATE VIEW bgt_lean.waterschap_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    naam
FROM latest.waterschapactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.waterschap_vlak CASCADE;
CREATE TABLE bgt_lean.waterschap_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.waterschap_cols a, latest.waterschapactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX waterschap_vlak_geometrie_multivlak_geom_idx ON bgt_lean.waterschap_vlak USING gist(geometrie_multivlak);
-- CREATE INDEX waterschap_vlak_lokaalid_idx ON bgt_lean.waterschap_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.waterschap_vlak ADD CONSTRAINT waterschap_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.waterschap_cols;
COMMIT;

--
-- WEGDEEL
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.wegdeel_cols CASCADE;
CREATE VIEW bgt_lean.wegdeel_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_functie,
    plus_functie,
    bgt_fysiekvoorkomen,
    plus_fysiekvoorkomen,
    wegdeeloptalud
FROM latest.wegdeelactueelbestaand;

-- NB No validation and ST_MakeValid(); see issue
-- https://github.com/nlextract/NLExtract/issues/363
DROP TABLE IF EXISTS bgt_lean.wegdeel_vlak CASCADE;
CREATE TABLE bgt_lean.wegdeel_vlak AS
SELECT
    a.*,
    ST_CurveToLine(b.geometrie_vlak)::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.wegdeel_cols a, latest.wegdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null;
CREATE INDEX wegdeel_vlak_geometrie_vlak_geom_idx ON bgt_lean.wegdeel_vlak USING gist(geometrie_vlak);
-- CREATE INDEX wegdeel_vlak_lokaalid_idx ON bgt_lean.wegdeel_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.wegdeel_vlak ADD CONSTRAINT wegdeel_vlak_pkey PRIMARY KEY (ogc_fid);


DROP TABLE IF EXISTS bgt_lean.wegdeel_kruinlijn CASCADE;
CREATE TABLE bgt_lean.wegdeel_kruinlijn AS
SELECT
    a.*,
    ST_CurveToLine(geometrie_kruinlijn)::geometry(LineString, 28992) as geometrie_kruinlijn
FROM bgt_lean.wegdeel_cols a, latest.wegdeelactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_kruinlijn is not null;
CREATE INDEX wegdeel_kruinlijn_geometrie_kruinlijn_geom_idx ON bgt_lean.wegdeel_kruinlijn USING gist(geometrie_kruinlijn);
-- CREATE INDEX wegdeel_kruinlijn_lokaalid_idx ON bgt_lean.wegdeel_kruinlijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.wegdeel_kruinlijn ADD CONSTRAINT wegdeel_kruinlijn_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.wegdeel_cols;
COMMIT;

--
-- WEGINRICHTINGSELEMENT
--

BEGIN;
-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.weginrichtingselement_cols CASCADE;
CREATE VIEW bgt_lean.weginrichtingselement_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    bgt_type,
    plus_type
FROM latest.weginrichtingselementactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.weginrichtingselement_lijn CASCADE;
CREATE TABLE bgt_lean.weginrichtingselement_lijn AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(geometrie_lijn))::geometry(LineString, 28992) as geometrie_lijn
FROM bgt_lean.weginrichtingselement_cols a, latest.weginrichtingselementactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_lijn is not null AND ST_IsValid(b.geometrie_lijn);
CREATE INDEX weginrichtingselement_lijn_geometrie_lijn_geom_idx ON bgt_lean.weginrichtingselement_lijn USING gist(geometrie_lijn);
-- CREATE INDEX weginrichtingselement_lijn_lokaalid_idx ON bgt_lean.weginrichtingselement_lijn USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.weginrichtingselement_lijn ADD CONSTRAINT weginrichtingselement_lijn_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.weginrichtingselement_punt CASCADE;
CREATE TABLE bgt_lean.weginrichtingselement_punt AS
SELECT
    a.*,
    b.geometrie_punt
FROM bgt_lean.weginrichtingselement_cols a, latest.weginrichtingselementactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_punt is not null AND ST_IsValid(b.geometrie_punt);
CREATE INDEX weginrichtingselement_punt_geometrie_punt_geom_idx ON bgt_lean.weginrichtingselement_punt USING gist(geometrie_punt);
-- CREATE INDEX weginrichtingselement_punt_lokaalid_idx ON bgt_lean.weginrichtingselement_punt USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.weginrichtingselement_punt ADD CONSTRAINT weginrichtingselement_punt_pkey PRIMARY KEY (ogc_fid);

DROP TABLE IF EXISTS bgt_lean.weginrichtingselement_vlak CASCADE;
CREATE TABLE bgt_lean.weginrichtingselement_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(Polygon, 28992) as geometrie_vlak
FROM bgt_lean.weginrichtingselement_cols a, latest.weginrichtingselementactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX weginrichtingselement_vlak_geometrie_vlak_geom_idx ON bgt_lean.weginrichtingselement_vlak USING gist(geometrie_vlak);
-- CREATE INDEX weginrichtingselement_vlak_lokaalid_idx ON bgt_lean.weginrichtingselement_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.weginrichtingselement_vlak ADD CONSTRAINT weginrichtingselement_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.weginrichtingselement_cols;
COMMIT;

--
-- WIJK
--
BEGIN;

-- Helper VIEW to select columns for final tables once
DROP VIEW IF EXISTS bgt_lean.wijk_cols CASCADE;
CREATE VIEW bgt_lean.wijk_cols AS
SELECT
    ogc_fid,
    lokaalid,
    relatievehoogteligging,
    naam
FROM latest.wijkactueelbestaand;

DROP TABLE IF EXISTS bgt_lean.wijk_vlak CASCADE;
CREATE TABLE bgt_lean.wijk_vlak AS
SELECT
    a.*,
    ST_MakeValid(ST_CurveToLine(b.geometrie_vlak))::geometry(MultiPolygon, 28992) as geometrie_multivlak
FROM bgt_lean.wijk_cols a, latest.wijkactueelbestaand b
WHERE a.ogc_fid = b.ogc_fid AND b.geometrie_vlak is not null AND ST_IsValid(b.geometrie_vlak);
CREATE INDEX wijk_vlak_geometrie_multivlak_geom_idx ON bgt_lean.wijk_vlak USING gist(geometrie_multivlak);
-- CREATE INDEX wijk_vlak_lokaalid_idx ON bgt_lean.wijk_vlak USING btree (lokaalid);
ALTER TABLE ONLY bgt_lean.wijk_vlak ADD CONSTRAINT wijk_vlak_pkey PRIMARY KEY (ogc_fid);

DROP VIEW bgt_lean.wijk_cols;
COMMIT;
