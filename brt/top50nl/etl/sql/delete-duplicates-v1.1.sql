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

SELECT _nlx_dedup_data('functioneelgebied');
SELECT _nlx_dedup_data('gebouw');
SELECT _nlx_dedup_data('geografischgebied');
SELECT _nlx_dedup_data('hoogte');
SELECT _nlx_dedup_data('inrichtingselement');
SELECT _nlx_dedup_data('registratiefgebied');
SELECT _nlx_dedup_data('relief');
SELECT _nlx_dedup_data('spoorbaandeel');
SELECT _nlx_dedup_data('terrein');
SELECT _nlx_dedup_data('waterdeel');
SELECT _nlx_dedup_data('wegdeel');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;
