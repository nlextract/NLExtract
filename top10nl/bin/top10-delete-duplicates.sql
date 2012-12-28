-- Auteur: Frank Steggink
-- Doel: script om dubbele records te verwijderen, middels een hulptabel

\i cf_checkandsetschema.sql
SELECT nlextract.checkandsetschema(:'schema');

\echo Schemanaam: :schema

DROP TABLE IF EXISTS nlextract._blah;

CREATE OR REPLACE FUNCTION nlextract.dedup_data(tablename VARCHAR)
RETURNS VARCHAR AS
$$
DECLARE
    rowcount INTEGER;
BEGIN

    EXECUTE FORMAT('CREATE TABLE nlextract._blah AS SELECT ogc_fid, identificatie FROM %I WHERE identificatie IN (SELECT identificatie FROM (SELECT identificatie, COUNT(*) AS aantal FROM %I GROUP BY identificatie ORDER BY identificatie) AS x WHERE aantal>1);', tablename, tablename);

    EXECUTE FORMAT('DELETE FROM %I WHERE ogc_fid IN (SELECT ogc_fid FROM nlextract._blah WHERE ogc_fid NOT IN (SELECT MIN(ogc_fid) FROM nlextract._blah GROUP BY identificatie));', tablename);
    GET DIAGNOSTICS rowcount = ROW_COUNT;

    DROP TABLE IF EXISTS nlextract._blah;
    
    RETURN tablename || ': ' || rowcount;

END;
$$
LANGUAGE plpgsql;

SELECT nlextract.dedup_data('functioneelgebied_punt');
SELECT nlextract.dedup_data('functioneelgebied_vlak');
SELECT nlextract.dedup_data('gebouw_vlak');
SELECT nlextract.dedup_data('geografischgebied_punt');
SELECT nlextract.dedup_data('geografischgebied_vlak');
SELECT nlextract.dedup_data('hoogteofdiepte_punt');
SELECT nlextract.dedup_data('hoogteverschilhz_lijn');
SELECT nlextract.dedup_data('hoogteverschillz_lijn');
SELECT nlextract.dedup_data('inrichtingselement_lijn');
SELECT nlextract.dedup_data('inrichtingselement_punt');
SELECT nlextract.dedup_data('isohoogte_lijn');
SELECT nlextract.dedup_data('kadeofwal_lijn');
SELECT nlextract.dedup_data('overigrelief_lijn');
SELECT nlextract.dedup_data('overigrelief_punt');
SELECT nlextract.dedup_data('registratiefgebied_punt');
SELECT nlextract.dedup_data('registratiefgebied_vlak');
SELECT nlextract.dedup_data('spoorbaandeel_lijn');
SELECT nlextract.dedup_data('spoorbaandeel_punt');
SELECT nlextract.dedup_data('terrein_vlak');
SELECT nlextract.dedup_data('waterdeel_lijn');
SELECT nlextract.dedup_data('waterdeel_punt');
SELECT nlextract.dedup_data('waterdeel_vlak');
SELECT nlextract.dedup_data('wegdeel_hartlijn');
SELECT nlextract.dedup_data('wegdeel_hartpunt');
SELECT nlextract.dedup_data('wegdeel_lijn');
SELECT nlextract.dedup_data('wegdeel_punt');
SELECT nlextract.dedup_data('wegdeel_vlak');

\i df_checkandsetschema.sql

DROP FUNCTION nlextract.dedup_data(tablename VARCHAR);
