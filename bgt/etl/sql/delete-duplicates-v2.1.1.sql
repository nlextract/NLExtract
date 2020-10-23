-- Auteur: Frank Steggink  - _nlx_dedup_data
-- Just van den Broecke - feb 2020 - replace by _nlx_dedup_table
--
-- Doel: script om dubbele records te verwijderen

SET search_path={schema},public;

-- DROP TABLE IF EXISTS _nlx_temp;
-- 
-- CREATE OR REPLACE FUNCTION _nlx_dedup_data(tablename VARCHAR)
-- RETURNS VARCHAR AS
-- $$
-- DECLARE
--     rowcount INTEGER;
-- BEGIN
-- 
--     IF EXISTS (SELECT 1
--             FROM information_schema.tables
--             WHERE table_schema='{schema}' AND table_name=tablename) THEN
-- 
-- --     IF EXISTS (
-- --         SELECT table_name
-- --         FROM information_schema.tables
-- --         WHERE table_schema='{schema}' AND table_name=tablename
-- --    )
-- --    THEN
-- 		EXECUTE 'WITH ft AS (SELECT * FROM ' || tablename || '), fids AS (SELECT ogc_fid, lokaalid, tijdstipregistratie FROM ft WHERE eindregistratie IS NOT NULL AND lokaalid||tijdstipregistratie IN (SELECT lokaalid||tijdstipregistratie FROM ft WHERE eindregistratie IS NOT NULL GROUP BY lokaalid,tijdstipregistratie HAVING COUNT(*)>1) ORDER BY lokaalid, tijdstipregistratie, lv_publicatiedatum), fids_to_delete AS (SELECT ogc_fid FROM fids WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM fids GROUP BY lokaalid,tijdstipregistratie)) DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM fids_to_delete);';
--         GET DIAGNOSTICS rowcount = ROW_COUNT;
-- 
--         RETURN tablename || ': ' || rowcount;
--     ELSE
--         RETURN tablename || ' does not exist';
--     END IF;
-- 
-- END;
-- $$
-- LANGUAGE plpgsql;

-- Voorbeeld: Ontdubbelen voorkomens panden
-- create table pand_dubbelevoorkomens as select max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, count(*) aantal from pand group by lokaalid, tijdstipregistratie, lv_publicatiedatum having count(*) > 1 order by lokaalid, tijdstipregistratie, lv_publicatiedatum;
-- 
-- create table pand_todelete as select p.ogc_fid from pand p join pand_dubbelevoorkomens d on p.lokaalid=d.lokaalid and p.tijdstipregistratie=d.tijdstipregistratie and p.lv_publicatiedatum=d.lv_publicatiedatum and p.ogc_fid!=d.max_fid;
-- 
-- delete from pand where ogc_fid in (select ogc_fid from pand_todelete);
-- drop table pand_dubbelevoorkomens;
-- drop table pand_todelete;

-- Crude but effective - JvdB
CREATE OR REPLACE FUNCTION _nlx_dedup_table(tablename VARCHAR)
RETURNS VARCHAR AS
$$
BEGIN
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete;';

    EXECUTE 'CREATE TABLE _dubbelevoorkomens_' || tablename || ' AS SELECT max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, count(*) aantal FROM ' || tablename || ' GROUP BY lokaalid, tijdstipregistratie, lv_publicatiedatum having count(*) > 1 ORDER BY lokaalid, tijdstipregistratie, lv_publicatiedatum;';
    EXECUTE 'CREATE TABLE _todelete AS SELECT p.ogc_fid FROM ' || tablename || ' p JOIN _dubbelevoorkomens_' || tablename || ' d ON p.lokaalid=d.lokaalid AND p.tijdstipregistratie=d.tijdstipregistratie AND p.lv_publicatiedatum=d.lv_publicatiedatum AND p.ogc_fid!=d.max_fid;';
    EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _todelete);';
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete;';
    RETURN tablename;
END;
$$
LANGUAGE plpgsql;

-- omdat openbareruimtelabel uit subfeatures is gegenereerd, zijn alle BGT keys/ids sowieso dubbel
-- _nlx_dedup_table() zou alle dubbele geheel deleten...
-- dus additionele criteria aanwenden: geometrie_punt en tekst
CREATE OR REPLACE FUNCTION _nlx_dedup_table_openbareruimtelabel(tablename VARCHAR)
RETURNS VARCHAR AS
$$
BEGIN
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete;';

    EXECUTE 'CREATE TABLE _dubbelevoorkomens_' || tablename || ' AS SELECT max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, geometrie_punt, tekst, count(*) aantal FROM ' || tablename || ' GROUP BY lokaalid, tijdstipregistratie, lv_publicatiedatum, geometrie_punt, tekst having count(*) > 1 ORDER BY lokaalid, tijdstipregistratie, lv_publicatiedatum;';
    EXECUTE 'CREATE TABLE _todelete AS SELECT p.ogc_fid FROM ' || tablename || ' p JOIN _dubbelevoorkomens_' || tablename || ' d ON p.lokaalid=d.lokaalid AND p.tijdstipregistratie=d.tijdstipregistratie AND p.lv_publicatiedatum=d.lv_publicatiedatum AND p.geometrie_punt=d.geometrie_punt AND p.tekst=d.tekst AND p.ogc_fid!=d.max_fid;';
    EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _todelete);';
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete;';
    RETURN tablename;
END;
$$
LANGUAGE plpgsql;


-- omdat pand_nummeraanduiding uit subfeatures is gegenereerd, zijn alle BGT keys/ids sowieso dubbel
-- _nlx_dedup_table() zou alle dubbele geheel deleten...
-- dus additionele criteria aanwenden: geometrie_nummeraanduiding en nummeraanduidingtekst
CREATE OR REPLACE FUNCTION _nlx_dedup_table_nummeraanduiding(tablename VARCHAR)
RETURNS VARCHAR AS
$$
BEGIN
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete_' || tablename || ' ';

    EXECUTE 'CREATE TABLE _dubbelevoorkomens_' || tablename || ' AS SELECT max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, geometrie_nummeraanduiding, nummeraanduidingtekst, count(*) aantal FROM ' || tablename || ' GROUP BY lokaalid, tijdstipregistratie, lv_publicatiedatum, geometrie_nummeraanduiding, nummeraanduidingtekst having count(*) > 1 ORDER BY lokaalid, tijdstipregistratie, lv_publicatiedatum;';
    EXECUTE 'CREATE TABLE _todelete_' || tablename || ' AS SELECT p.ogc_fid FROM ' || tablename || ' p JOIN _dubbelevoorkomens_' || tablename || ' d ON p.lokaalid=d.lokaalid AND p.tijdstipregistratie=d.tijdstipregistratie AND p.lv_publicatiedatum=d.lv_publicatiedatum AND p.geometrie_nummeraanduiding=d.geometrie_nummeraanduiding AND p.nummeraanduidingtekst=d.nummeraanduidingtekst AND p.ogc_fid!=d.max_fid;';
    EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _todelete_' || tablename || ');';
    EXECUTE 'DROP TABLE IF EXISTS _dubbelevoorkomens_' || tablename || ' ';
    EXECUTE 'DROP TABLE IF EXISTS _todelete_' || tablename || ' ';
    RETURN tablename;
END;
$$
LANGUAGE plpgsql;

SELECT _nlx_dedup_table('bak');
SELECT _nlx_dedup_table('begroeidterreindeel');
SELECT _nlx_dedup_table('bord');
SELECT _nlx_dedup_table('buurt');
SELECT _nlx_dedup_table('functioneelgebied');
SELECT _nlx_dedup_table('gebouwinstallatie');
SELECT _nlx_dedup_table('installatie');
SELECT _nlx_dedup_table('kast');
SELECT _nlx_dedup_table('kunstwerkdeel');
SELECT _nlx_dedup_table('mast');
SELECT _nlx_dedup_table('onbegroeidterreindeel');
SELECT _nlx_dedup_table('ondersteunendwaterdeel');
SELECT _nlx_dedup_table('ondersteunendwegdeel');
SELECT _nlx_dedup_table('ongeclassificeerdobject');
SELECT _nlx_dedup_table('openbareruimte');
SELECT _nlx_dedup_table_openbareruimtelabel('openbareruimtelabel');  --subfeatures komen per definitie meerdere keren voor
SELECT _nlx_dedup_table('overbruggingsdeel');
SELECT _nlx_dedup_table('overigbouwwerk');
SELECT _nlx_dedup_table('overigescheiding');
SELECT _nlx_dedup_table('paal');
SELECT _nlx_dedup_table('pand');
SELECT _nlx_dedup_table_nummeraanduiding('pand_nummeraanduiding'); --subfeatures komen per definitie  meerdere keren voor

-- Plaatsbepalingspunten tijdelijk uitgeschakeld, bevatten geen tijdstipregistratie en zitten niet
-- in de dump.
--SELECT _nlx_dedup_table('plaatsbepalingspunt');

SELECT _nlx_dedup_table('put');
SELECT _nlx_dedup_table('scheiding');
SELECT _nlx_dedup_table('sensor');
SELECT _nlx_dedup_table('spoor');
SELECT _nlx_dedup_table('stadsdeel');
SELECT _nlx_dedup_table('straatmeubilair');
SELECT _nlx_dedup_table('tunneldeel');
SELECT _nlx_dedup_table('vegetatieobject');
SELECT _nlx_dedup_table('waterdeel');
SELECT _nlx_dedup_table('waterinrichtingselement');
SELECT _nlx_dedup_table('waterschap');
SELECT _nlx_dedup_table('wegdeel');
SELECT _nlx_dedup_table('weginrichtingselement');
SELECT _nlx_dedup_table('wijk');

DROP FUNCTION _nlx_dedup_table(tablename VARCHAR);
DROP FUNCTION _nlx_dedup_table_openbareruimtelabel(tablename VARCHAR);
DROP FUNCTION _nlx_dedup_table_nummeraanduiding(tablename VARCHAR);

SET search_path="$user",public;
