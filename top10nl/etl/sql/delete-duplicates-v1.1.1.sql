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

    EXECUTE 'CREATE TABLE _nlx_temp AS SELECT ogc_fid, identificatie FROM ' || tablename || ' WHERE identificatie IN (SELECT identificatie FROM (SELECT identificatie, COUNT(*) AS aantal FROM ' || tablename || ' GROUP BY identificatie ORDER BY identificatie) AS x WHERE aantal>1);';

    EXECUTE 'DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM _nlx_temp WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM _nlx_temp GROUP BY identificatie));';
    GET DIAGNOSTICS rowcount = ROW_COUNT;

    DROP TABLE IF EXISTS _nlx_temp;

    RETURN tablename || ': ' || rowcount;

END;
$$
LANGUAGE plpgsql;

SELECT _nlx_dedup_data('functioneelgebied_punt');
SELECT _nlx_dedup_data('functioneelgebied_vlak');
SELECT _nlx_dedup_data('gebouw_vlak');
SELECT _nlx_dedup_data('geografischgebied_punt');
SELECT _nlx_dedup_data('geografischgebied_vlak');
SELECT _nlx_dedup_data('hoogteofdiepte_punt');
SELECT _nlx_dedup_data('hoogteverschilhz_lijn');
SELECT _nlx_dedup_data('hoogteverschillz_lijn');
SELECT _nlx_dedup_data('inrichtingselement_lijn');
SELECT _nlx_dedup_data('inrichtingselement_punt');
SELECT _nlx_dedup_data('isohoogte_lijn');
SELECT _nlx_dedup_data('kadeofwal_lijn');
SELECT _nlx_dedup_data('overigrelief_lijn');
SELECT _nlx_dedup_data('overigrelief_punt');
SELECT _nlx_dedup_data('registratiefgebied_punt');
SELECT _nlx_dedup_data('registratiefgebied_vlak');
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

