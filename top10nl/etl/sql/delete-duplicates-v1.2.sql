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

SELECT _nlx_dedup_data('functioneelgebied_punt');
SELECT _nlx_dedup_data('functioneelgebied_vlak');
SELECT _nlx_dedup_data('gebouw_punt');
SELECT _nlx_dedup_data('gebouw_vlak');
SELECT _nlx_dedup_data('geografischgebied_punt');
SELECT _nlx_dedup_data('geografischgebied_vlak');
SELECT _nlx_dedup_data('hoogte_lijn');
SELECT _nlx_dedup_data('hoogte_punt');
SELECT _nlx_dedup_data('inrichtingselement_lijn');
SELECT _nlx_dedup_data('inrichtingselement_punt');
SELECT _nlx_dedup_data('plaats_punt');
SELECT _nlx_dedup_data('plaats_vlak');
SELECT _nlx_dedup_data('plantopografie_lijn');
SELECT _nlx_dedup_data('plantopografie_punt');
SELECT _nlx_dedup_data('plantopografie_vlak');
SELECT _nlx_dedup_data('registratiefgebied_vlak');
SELECT _nlx_dedup_data('relief_hogezijde');
SELECT _nlx_dedup_data('relief_lagezijde');
SELECT _nlx_dedup_data('relief_lijn');
SELECT _nlx_dedup_data('spoorbaandeel_lijn');
SELECT _nlx_dedup_data('spoorbaandeel_punt');
SELECT _nlx_dedup_data('terrein_vlak');
SELECT _nlx_dedup_data('waterdeel_lijn');
SELECT _nlx_dedup_data('waterdeel_punt');
SELECT _nlx_dedup_data('waterdeel_vlak');
SELECT _nlx_dedup_data('wegdeel_hartlijn');
SELECT _nlx_dedup_data('wegdeel_hartpunt');
SELECT _nlx_dedup_data('wegdeel_lijn');
SELECT _nlx_dedup_data('wegdeel_punt');
SELECT _nlx_dedup_data('wegdeel_vlak');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;

