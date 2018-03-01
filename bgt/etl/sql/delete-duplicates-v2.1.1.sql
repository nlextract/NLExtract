-- Auteur: Frank Steggink
-- Doel: script om dubbele records te verwijderen

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
		EXECUTE 'WITH ft AS (SELECT * FROM ' || tablename || '), fids AS (SELECT ogc_fid, lokaalid, tijdstipregistratie FROM ft WHERE eindregistratie IS NOT NULL AND lokaalid||tijdstipregistratie IN (SELECT lokaalid||tijdstipregistratie FROM ft WHERE eindregistratie IS NOT NULL GROUP BY lokaalid,tijdstipregistratie HAVING COUNT(*)>1) ORDER BY lokaalid, tijdstipregistratie, lv_publicatiedatum), fids_to_delete AS (SELECT ogc_fid FROM fids WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM fids GROUP BY lokaalid,tijdstipregistratie)) DELETE FROM ' || tablename || ' WHERE ogc_fid IN (SELECT ogc_fid FROM fids_to_delete);';
        GET DIAGNOSTICS rowcount = ROW_COUNT;

        RETURN tablename || ': ' || rowcount;
    ELSE
        RETURN tablename || ' does not exist';
    END IF;

END;
$$
LANGUAGE plpgsql;

SELECT _nlx_dedup_data('bak_tmp');
SELECT _nlx_dedup_data('begroeidterreindeel_tmp');
SELECT _nlx_dedup_data('bord_tmp');
SELECT _nlx_dedup_data('buurt_tmp');
SELECT _nlx_dedup_data('functioneelgebied_tmp');
SELECT _nlx_dedup_data('gebouwinstallatie_tmp');
SELECT _nlx_dedup_data('installatie_tmp');
SELECT _nlx_dedup_data('kast_tmp');
SELECT _nlx_dedup_data('kunstwerkdeel_tmp');
SELECT _nlx_dedup_data('mast_tmp');
SELECT _nlx_dedup_data('onbegroeidterreindeel_tmp');
SELECT _nlx_dedup_data('ondersteunendwaterdeel_tmp');
SELECT _nlx_dedup_data('ondersteunendwegdeel_tmp');
SELECT _nlx_dedup_data('ongeclassificeerdobject_tmp');
SELECT _nlx_dedup_data('openbareruimte_tmp');
SELECT _nlx_dedup_data('openbareruimtelabel');
SELECT _nlx_dedup_data('overbruggingsdeel_tmp');
SELECT _nlx_dedup_data('overigbouwwerk_tmp');
SELECT _nlx_dedup_data('overigescheiding_tmp');
SELECT _nlx_dedup_data('paal_tmp');
SELECT _nlx_dedup_data('pand_tmp');

-- Plaatsbepalingspunten tijdelijk uitgeschakeld, bevatten geen tijdstipregistratie en zitten niet
-- in de dump.
--SELECT _nlx_dedup_data('plaatsbepalingspunt');

SELECT _nlx_dedup_data('put_tmp');
SELECT _nlx_dedup_data('scheiding_tmp');
SELECT _nlx_dedup_data('sensor_tmp');
SELECT _nlx_dedup_data('spoor_tmp');
SELECT _nlx_dedup_data('stadsdeel_tmp');
SELECT _nlx_dedup_data('straatmeubilair_tmp');
SELECT _nlx_dedup_data('tunneldeel_tmp');
SELECT _nlx_dedup_data('vegetatieobject_tmp');
SELECT _nlx_dedup_data('waterdeel_tmp');
SELECT _nlx_dedup_data('waterinrichtingselement_tmp');
SELECT _nlx_dedup_data('waterschap_tmp');
SELECT _nlx_dedup_data('wegdeel_tmp');
SELECT _nlx_dedup_data('weginrichtingselement_tmp');
SELECT _nlx_dedup_data('wijk_tmp');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;

