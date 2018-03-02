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

    IF EXISTS (
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema='{schema}' AND table_name=tablename
    )
    THEN
        EXECUTE 'CREATE TABLE _nlx_temp AS SELECT ogc_fid, lokaalid FROM ' || tablename || ' WHERE lokaalid IN (SELECT lokaalid FROM (SELECT lokaalid, COUNT(*) AS aantal FROM ' || tablename || ' GROUP BY lokaalid ORDER BY lokaalid) AS x WHERE aantal>1);';

        EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _nlx_temp WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM _nlx_temp GROUP BY lokaalid));';
        GET DIAGNOSTICS rowcount = ROW_COUNT;

        DROP TABLE IF EXISTS _nlx_temp;

        RETURN tablename || ': ' || rowcount;
    ELSE
        RETURN tablename || ' does not exist';
    END IF;

END;
$$
LANGUAGE plpgsql;

SELECT _nlx_dedup_data('annotatie');
SELECT _nlx_dedup_data('bebouwing_tmp');
SELECT _nlx_dedup_data('kadastralegrens_tmp');
SELECT _nlx_dedup_data('perceel_tmp');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;

