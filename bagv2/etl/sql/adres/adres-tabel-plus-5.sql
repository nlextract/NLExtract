----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- START BLOK5 AANMAKEN TABEL adres_plus inclusief een paar aanpassingen
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- De adres tabel maken met een groot aantal gegevens. Tevens een rangorde per postcode huisnummer toevoegen om later een tabel/view te kunnen maken waar per PC/HN maar 1 record in zit. Dit ivm match externe adressen die niet de BAG conventie volgen.

BEGIN;
DROP TABLE IF EXISTS adres_plus CASCADE;
CREATE TABLE adres_plus AS
SELECT
  adres.openbareruimtenaam,
  adres.verkorteopenbareruimtenaam,
  adres.obr_id AS openbareruimte_id,
  adres.huisnummer,
  adres.huisletter,
  adres.huisnummertoevoeging,
  adres.postcode,
  adres.nad_id AS nummeraanduiding_id,
  adres.woonplaatsnaam,
  adres.woonplaats_id AS woonplaatscode,
  adres.gemeentenaam,
  adres.gemeente_id AS gemeentecode,
  adres.provincienaam,
  adres.provincie_id AS provinciecode,
  adres.nevenadres,
  adres.typeadresseerbaarobject,
  adres.adresseerbaarobject_status,
  adres.opp_adresseerbaarobject_m2,
  adr_nad.aantal AS aantal_nad_per_adresobject,  -- check
  adres.adresseerbaarobject_id,
  cast(adres.geopunt AS geometry(Point, 28992)),
  adres.x,
  adres.y,
  adres.lon,
  adres.lat,
  vbo_gbd.woonfunctie,
  vbo_gbd.bijeenkomstfunctie,
  vbo_gbd.celfunctie,
  vbo_gbd.gezondheidszorgfunctie,
  vbo_gbd.industriefunctie,
  vbo_gbd.kantoorfunctie,
  vbo_gbd.logiesfunctie,
  vbo_gbd.onderwijsfunctie,
  vbo_gbd.sportfunctie,
  vbo_gbd.winkelfunctie,
  vbo_gbd.overige_gebruiksfunctie,
  vbo_pnd.aantal_pand_relaties_dit_vbo,  -- check
  vbo_pnd.pnd_id_uniek AS pand_id,
  vbo_pnd.aantal_vbo_relaties_dit_pnd,  -- check
  vbo_pnd.vbo_pnd_1_op_1,  -- check
  vbo_pnd.opp_pand,
  vbo_woningtype.woningtype,
  vbo_pnd.omtrek_pand,
  vbo_pnd.verhouding_opp_vbo_opp_pnd,
  vbo_pnd.pandstatus,
  vbo_pnd.bouwjaar,
  adres.uniq_key
FROM
  adresselectie adres
-- voeg toe alle gebruiksdoelen aan het adres indien het een VBO betreft
LEFT OUTER JOIN verblijfsobjectgebruiksdoelactueelbestaand_pivot vbo_gbd
    ON adres.adresseerbaarobject_id = vbo_gbd.vbo_id
-- voeg toe alle pandgegevens aan het adres indien het een VBO betreft dat
-- aan slechts 1 pand gekoppeld is
LEFT OUTER JOIN vbo_pandgegevens vbo_pnd
    ON adres.adresseerbaarobject_id = vbo_pnd.vbo_id
LEFT OUTER JOIN vbo_woningtype
    ON vbo_woningtype.vbo_id = adres.adresseerbaarobject_id
LEFT OUTER JOIN adresseerbaarobject_aantal_nad adr_nad
    ON adres.adresseerbaarobject_id = adr_nad.adresseerbaarobject_id;
-- 20200604: Query returned successfully: 9340457 rows affected, 12:04 minutes execution time.
COMMIT;

-----------------------------------------------------------------------------------
-- START: optioneel een aantal gegevens aanpassen b.v. wegens vreemde invoer
-----------------------------------------------------------------------------------

--Een aantal bronhouders vult bij oppervlakte maar iets in. Bv 999999 (bij verblijfsobject gevormd) en terwijl er nog geen actueel pand is.

BEGIN;
UPDATE adres_plus adres
SET opp_adresseerbaarobject_m2 = 0
WHERE adres.opp_adresseerbaarobject_m2 = 999999
  AND adres.adresseerbaarobject_status = 'Verblijfsobject gevormd'
  AND adres.pandstatus IS NULL;
 --20200531 Query returned successfully: 0 rows affected, 4.0 secs execution time.

----------------------------------------------------------------------------
-- EINDE optioneel een aantal gegevens aanpassen b.v. wegens vreemde invoer
----------------------------------------------------------------------------

-- Maak indexen aan (betere performance)
BEGIN;
CREATE INDEX adres_plus_geom_idx ON adres_plus USING gist (geopunt);
CREATE INDEX adres_plus_postcode ON  adres_plus USING btree (postcode);
CREATE INDEX adres_plus_adreseerbaarobject_id ON adres_plus USING btree (adresseerbaarobject_id);
CREATE INDEX adres_plus_nummeraanduiding_id ON adres_plus USING btree (nummeraanduiding_id);
CREATE INDEX adres_plus_pand_id ON adres_plus USING btree (pand_id);
-- CREATE INDEX adres_plus_idx ON adres_plus USING gin (textsearchable_adres);
ALTER TABLE adres_plus ADD PRIMARY KEY (uniq_key);
COMMIT;

------------------------------------------------------------------------------
------------------------------------------------------------------------------
-- EINDE BLOK5 AANMAKEN TABEL adres_plus
------------------------------------------------------------------------------
------------------------------------------------------------------------------

BEGIN;
-- Alle tijdelijke tabellen/views verwijderen
DROP VIEW IF EXISTS adres_nog_te_ontdubbelen CASCADE;
DROP VIEW IF EXISTS adres_vergelijk CASCADE;
DROP VIEW IF EXISTS pandactueelbestaand_plus CASCADE;
DROP TABLE IF EXISTS adres_dubbel CASCADE;
DROP TABLE IF EXISTS adres_pand1 CASCADE;
DROP TABLE IF EXISTS adres_pand2 CASCADE;
DROP TABLE IF EXISTS adres_te_ontdubbelen CASCADE;
DROP TABLE IF EXISTS adresseerbaarobject_aantal_nad CASCADE;
DROP TABLE IF EXISTS adresselectie CASCADE;
-- DROP TABLE IF EXISTS bag_wpl_actbest_gegevens CASCADE;
-- DROP TABLE IF EXISTS pandontdubbel CASCADE;
DROP TABLE IF EXISTS pnd_actueelbestaand_met_aantal_vbo CASCADE;
DROP TABLE IF EXISTS pnd_woon_relaties CASCADE;
DROP TABLE IF EXISTS pnd_woon_relaties_aantal CASCADE;
DROP TABLE IF EXISTS pnd_woon_type CASCADE;
DROP TABLE IF EXISTS vbo_actueelbestaand_met_aantal_verbonden_pnd CASCADE;
DROP TABLE IF EXISTS vbo_pandgegevens CASCADE;
DROP TABLE IF EXISTS vbo_woningtype CASCADE;
DROP TABLE IF EXISTS vbo_woningtype_ontdubbeld CASCADE;
DROP TABLE IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand_pivot CASCADE;
-- DROP TABLE IF EXISTS woning_nad_gegevens CASCADE;
-- DROP TABLE IF EXISTS woning_nad_pnd_gegevens CASCADE;
DROP TABLE IF EXISTS woning_nad_vbo_pnd CASCADE;
DROP TABLE IF EXISTS woning_pnd_extra_gegevens CASCADE;
DROP TABLE IF EXISTS woning_vbo_gegevens CASCADE;
DROP TABLE IF EXISTS woning_vbo_pnd_gegevens CASCADE;
COMMIT;
