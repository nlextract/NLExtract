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

SELECT _nlx_dedup_data('bak_2d_tmp');
SELECT _nlx_dedup_data('begroeidterreindeel_2d_tmp');
SELECT _nlx_dedup_data('begroeidterreindeel_kruinlijn_tmp');
SELECT _nlx_dedup_data('bord_2d_tmp');
SELECT _nlx_dedup_data('buurt_2d_tmp');
SELECT _nlx_dedup_data('functioneelgebied_2d_tmp');
SELECT _nlx_dedup_data('gebouwinstallatie_2d_tmp');
SELECT _nlx_dedup_data('installatie_2d_tmp');
SELECT _nlx_dedup_data('kast_2d_tmp');
SELECT _nlx_dedup_data('kunstwerkdeel_2d_tmp');
SELECT _nlx_dedup_data('mast_2d_tmp');

-- Nummeraanduidingsreeksen zijn niet te dedupliceren, omdat ze via panden geladen worden. Mogelijk
-- ontstaan hierdoor toch dubbelingen. Nader onderzoeken.
--SELECT _nlx_dedup_data('nummeraanduidingreeks');

SELECT _nlx_dedup_data('onbegroeidterreindeel_2d_tmp');
SELECT _nlx_dedup_data('onbegroeidterreindeel_kruinlijn_tmp');
SELECT _nlx_dedup_data('ondersteunendwaterdeel_2d_tmp');
SELECT _nlx_dedup_data('ondersteunendwegdeel_2d_tmp');
SELECT _nlx_dedup_data('ondersteunendwegdeel_kruinlijn_tmp');
SELECT _nlx_dedup_data('ongeclassificeerdobject_2d_tmp');
SELECT _nlx_dedup_data('openbareruimte_2d_tmp');
SELECT _nlx_dedup_data('openbareruimtelabel');
SELECT _nlx_dedup_data('overbruggingsdeel_2d_tmp');
SELECT _nlx_dedup_data('overigbouwwerk_2d_tmp');
SELECT _nlx_dedup_data('overigescheiding_2d_tmp');
SELECT _nlx_dedup_data('paal_2d_tmp');
SELECT _nlx_dedup_data('pand_2d_tmp');

-- Plaatsbepalingspunten tijdelijk uitgeschakeld, bevatten geen tijdstipregistratie en zitten niet
-- in de dump.
--SELECT _nlx_dedup_data('plaatsbepalingspunt');

SELECT _nlx_dedup_data('put_2d_tmp');
SELECT _nlx_dedup_data('scheiding_2d_tmp');
SELECT _nlx_dedup_data('sensor_2d_tmp');
SELECT _nlx_dedup_data('spoor_2d_tmp');
SELECT _nlx_dedup_data('stadsdeel_2d_tmp');
SELECT _nlx_dedup_data('straatmeubilair_2d_tmp');
SELECT _nlx_dedup_data('tunneldeel_2d_tmp');
SELECT _nlx_dedup_data('vegetatieobject_2d_tmp');
SELECT _nlx_dedup_data('waterdeel_2d_tmp');
SELECT _nlx_dedup_data('waterinrichtingselement_2d_tmp');
SELECT _nlx_dedup_data('waterschap_2d_tmp');
SELECT _nlx_dedup_data('wegdeel_2d_tmp');
SELECT _nlx_dedup_data('wegdeel_kruinlijn_tmp');
SELECT _nlx_dedup_data('weginrichtingselement_2d_tmp');
SELECT _nlx_dedup_data('wijk_2d_tmp');

DROP FUNCTION _nlx_dedup_data(tablename VARCHAR);

SET search_path="$user",public;

