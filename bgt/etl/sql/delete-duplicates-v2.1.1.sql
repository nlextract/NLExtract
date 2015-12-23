-- Auteur: Frank Steggink
-- Doel: script om dubbele records te verwijderen, middels een hulptabel

SET search_path={schema},public;

DROP TABLE IF EXISTS _nlx_temp;

CREATE OR REPLACE FUNCTION _nlx_dedup_data(tablename VARCHAR)
RETURNS VARCHAR AS
$$
DECLARE
    rowcount INTEGER;
BEGIN

    EXECUTE 'CREATE TABLE _nlx_temp AS SELECT ogc_fid, lokaalid FROM ' || tablename || ' WHERE lokaalid IN (SELECT lokaalid FROM (SELECT lokaalid, COUNT(*) AS aantal FROM ' || tablename || ' GROUP BY lokaalid ORDER BY lokaalid) AS x WHERE aantal>1);';

    EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _nlx_temp WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM _nlx_temp GROUP BY lokaalid));';
    GET DIAGNOSTICS rowcount = ROW_COUNT;

    DROP TABLE IF EXISTS _nlx_temp;

    RETURN tablename || ': ' || rowcount;

END;
$$
LANGUAGE plpgsql;

SELECT _nlx_dedup_data('bak');
SELECT _nlx_dedup_data('bak_2d');
SELECT _nlx_dedup_data('bak_lod0');

SELECT _nlx_dedup_data('begroeidterreindeel');
SELECT _nlx_dedup_data('begroeidterreindeel_2d');
SELECT _nlx_dedup_data('begroeidterreindeel_kruinlijn');
SELECT _nlx_dedup_data('begroeidterreindeel_lod0');

SELECT _nlx_dedup_data('bord');
SELECT _nlx_dedup_data('bord_2d');
SELECT _nlx_dedup_data('bord_lod0');

SELECT _nlx_dedup_data('buurt');
SELECT _nlx_dedup_data('buurt_2d');
SELECT _nlx_dedup_data('buurt_lod0');

SELECT _nlx_dedup_data('functioneelgebied');
SELECT _nlx_dedup_data('functioneelgebied_2d');
SELECT _nlx_dedup_data('functioneelgebied_lod0');

SELECT _nlx_dedup_data('gebouwinstallatie');
SELECT _nlx_dedup_data('gebouwinstallatie_2d');
SELECT _nlx_dedup_data('gebouwinstallatie_lod0');

SELECT _nlx_dedup_data('installatie');
SELECT _nlx_dedup_data('installatie_2d');
SELECT _nlx_dedup_data('installatie_lod0');

SELECT _nlx_dedup_data('kast');
SELECT _nlx_dedup_data('kast_2d');
SELECT _nlx_dedup_data('kast_lod0');

SELECT _nlx_dedup_data('kunstwerkdeel');
SELECT _nlx_dedup_data('kunstwerkdeel_2d');
SELECT _nlx_dedup_data('kunstwerkdeel_lod0');

SELECT _nlx_dedup_data('mast');
SELECT _nlx_dedup_data('mast_2d');
SELECT _nlx_dedup_data('mast_lod0');

SELECT _nlx_dedup_data('nummeraanduidingreeks');

SELECT _nlx_dedup_data('onbegroeidterreindeel');
SELECT _nlx_dedup_data('onbegroeidterreindeel_2d');
SELECT _nlx_dedup_data('onbegroeidterreindeel_kruinlijn');
SELECT _nlx_dedup_data('onbegroeidterreindeel_lod0');

SELECT _nlx_dedup_data('ondersteunendwaterdeel');
SELECT _nlx_dedup_data('ondersteunendwaterdeel_2d');
SELECT _nlx_dedup_data('ondersteunendwaterdeel_lod0');

SELECT _nlx_dedup_data('ondersteunendwegdeel');
SELECT _nlx_dedup_data('ondersteunendwegdeel_2d');
SELECT _nlx_dedup_data('ondersteunendwegdeel_kruinlijn');
SELECT _nlx_dedup_data('ondersteunendwegdeel_lod0');

SELECT _nlx_dedup_data('ongeclassificeerdobject');
SELECT _nlx_dedup_data('ongeclassificeerdobject_2d');
SELECT _nlx_dedup_data('ongeclassificeerdobject_lod0');

SELECT _nlx_dedup_data('openbareruimte');
SELECT _nlx_dedup_data('openbareruimte_2d');
SELECT _nlx_dedup_data('openbareruimte_lod0');

SELECT _nlx_dedup_data('openbareruimtelabel');

SELECT _nlx_dedup_data('overbruggingsdeel');
SELECT _nlx_dedup_data('overbruggingsdeel_2d');
SELECT _nlx_dedup_data('overbruggingsdeel_lod0');

SELECT _nlx_dedup_data('overigbouwwerk');
SELECT _nlx_dedup_data('overigbouwwerk_2d');
SELECT _nlx_dedup_data('overigbouwwerk_lod0');

SELECT _nlx_dedup_data('overigeconstructie');
SELECT _nlx_dedup_data('overigeconstructie_2d');
SELECT _nlx_dedup_data('overigeconstructie_lod0');

SELECT _nlx_dedup_data('overigescheiding');
SELECT _nlx_dedup_data('overigescheiding_2d');
SELECT _nlx_dedup_data('overigescheiding_lod0');

SELECT _nlx_dedup_data('paal');
SELECT _nlx_dedup_data('paal_2d');
SELECT _nlx_dedup_data('paal_lod0');

SELECT _nlx_dedup_data('pand');
SELECT _nlx_dedup_data('pand_2d');
SELECT _nlx_dedup_data('pand_lod0');

SELECT _nlx_dedup_data('plaatsbepalingspunt');

SELECT _nlx_dedup_data('put');
SELECT _nlx_dedup_data('put_2d');
SELECT _nlx_dedup_data('put_lod0');

SELECT _nlx_dedup_data('scheiding');
SELECT _nlx_dedup_data('scheiding_2d');
SELECT _nlx_dedup_data('scheiding_lod0');

SELECT _nlx_dedup_data('sensor');
SELECT _nlx_dedup_data('sensor_2d');
SELECT _nlx_dedup_data('sensor_lod0');

SELECT _nlx_dedup_data('spoor');
SELECT _nlx_dedup_data('spoor_2d');
SELECT _nlx_dedup_data('spoor_lod0');

SELECT _nlx_dedup_data('stadsdeel');
SELECT _nlx_dedup_data('stadsdeel_2d');
SELECT _nlx_dedup_data('stadsdeel_lod0');

SELECT _nlx_dedup_data('straatmeubilair');
SELECT _nlx_dedup_data('straatmeubilair_2d');
SELECT _nlx_dedup_data('straatmeubilair_lod0');

SELECT _nlx_dedup_data('tunneldeel');
SELECT _nlx_dedup_data('tunneldeel_2d');
SELECT _nlx_dedup_data('tunneldeel_lod0');

SELECT _nlx_dedup_data('vegetatieobject');
SELECT _nlx_dedup_data('vegetatieobject_2d');
SELECT _nlx_dedup_data('vegetatieobject_lod0');

SELECT _nlx_dedup_data('waterdeel');
SELECT _nlx_dedup_data('waterdeel_2d');
SELECT _nlx_dedup_data('waterdeel_lod0');

SELECT _nlx_dedup_data('waterinrichtingselement');
SELECT _nlx_dedup_data('waterinrichtingselement_2d');
SELECT _nlx_dedup_data('waterinrichtingselement_lod0');

SELECT _nlx_dedup_data('waterschap');
SELECT _nlx_dedup_data('waterschap_2d');
SELECT _nlx_dedup_data('waterschap_lod0');

SELECT _nlx_dedup_data('wegdeel');
SELECT _nlx_dedup_data('wegdeel_2d');
SELECT _nlx_dedup_data('wegdeel_kruinlijn');
SELECT _nlx_dedup_data('wegdeel_lod0');

SELECT _nlx_dedup_data('weginrichtingselement');
SELECT _nlx_dedup_data('weginrichtingselement_2d');
SELECT _nlx_dedup_data('weginrichtingselement_lod0');

SELECT _nlx_dedup_data('wijk');
SELECT _nlx_dedup_data('wijk_2d');
SELECT _nlx_dedup_data('wijk_lod0');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;

