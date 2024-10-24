-- Dit script maakt de view "adres_compleet_pchn_uniek" aan.
-- De logica hiervoor stond oorspronkelijk in adres-tabel-plus.sql,
-- maar is hiernaartoe verplaatst ivm compatibiliteit met BAG mutaties.


-- De adres tabel maken met een groot aantal gegevens. Tevens een rangorde per postcode huisnummer toevoegen om later een tabel/view te kunnen maken waar per PC/HN maar 1 record in zit. Dit ivm match externe adressen die niet de BAG conventie volgen.


BEGIN;
SELECT PRINT_NOTICE('start: 39 adres_plus: ' || current_time);
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
  adr_nad.aantal AS aantal_nad_per_adresobject,
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
  vbo_pnd.aantal_pand_relaties_dit_vbo,
  vbo_pnd.pnd_id_uniek AS pand_id,
  vbo_pnd.aantal_vbo_relaties_dit_pnd,
  vbo_pnd.vbo_pnd_1_op_1,
  vbo_pnd.opp_pand,
  vbo_woningtype.woningtype,
  vbo_pnd.omtrek_pand,
  vbo_pnd.verhouding_opp_vbo_opp_pnd,
  vbo_pnd.pandstatus,
  vbo_pnd.bouwjaar,
  adres.uniq_key,
  adres.pchnhlht,
  adres.pchnhlht_uniek,
  adres.pchn_uniek,
  -- de rangorder toevoegen zodat we later in de view "adres_compleet_pchn_uniek"
  -- per postcode/huisnummer slechts 1 record krijgen met rang 1. Idealiter zou de
  -- order by alleen op postcode, huisnummer, huisletter en huisnummertoevoeging
  -- moeten gaan maar omdat er een beperkt aantal adressen zijn waarbij deze 4
  -- kolommen identiek zijn voeg ik nog een woonfunctie, openbareruimte_id toe
  -- zodat we maar 1 record (per PC HN) op rang 1 krijgen.
  -- 20210129: RANK functie vervangen door row_num
  row_number() OVER (
      PARTITION BY
          adres.postcode,
          adres.huisnummer
      ORDER BY
          vbo_gbd.woonfunctie DESC NULLS LAST,
          adres.huisletter NULLS FIRST,
          adres.huisnummertoevoeging NULLS FIRST,
          adres.nad_id DESC
      ) AS rangorde_pchn
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
    ON adres.adresseerbaarobject_id = adr_nad.adresseerbaarobject_id
;
-- 20200604: Query returned successfully: 9340457 rows affected, 12:04 minutes execution time.
COMMIT;


BEGIN;
  SELECT PRINT_NOTICE('start: 40 UPDATEN van adres_plus: '||current_time);
update adres_plus adres  set opp_adresseerbaarobject_m2 = 0
 where   adres.opp_adresseerbaarobject_m2 = 999999 and  adres.adresseerbaarobject_status = 'Verblijfsobject gevormd' and adres.pandstatus is null;
 --20200531 Query returned successfully: 0 rows affected, 4.0 secs execution time.

-- Maak indexen aan (betere performance)
BEGIN;
SELECT PRINT_NOTICE('start: 41 adres_plus_geom_idx: '||current_time);
CREATE INDEX adres_plus_geom_idx ON adres_plus USING gist (geopunt);
SELECT PRINT_NOTICE('start: 42 adres_plus_postcode: '||current_time);
CREATE INDEX adres_plus_postcode ON  adres_plus USING btree (postcode);
SELECT PRINT_NOTICE('start: 43 adres_plus_adreseerbaarobject_id: '||current_time);
CREATE INDEX adres_plus_adreseerbaarobject_id ON adres_plus USING btree (adresseerbaarobject_id);
SELECT PRINT_NOTICE('start: 44 adres_plus_nummeraanduiding_ID: '||current_time);
CREATE INDEX adres_plus_nummeraanduiding_ID ON adres_plus USING btree (nummeraanduiding_ID);
SELECT PRINT_NOTICE('start: 45 adres_plus_pand_id: '||current_time);
CREATE INDEX adres_plus_pand_id ON adres_plus USING btree (pand_id);

--CREATE INDEX adres_plus_idx ON adres_plus USING gin (textsearchable_adres);
ALTER TABLE adres_plus ADD PRIMARY KEY (uniq_key);

COMMIT;


--En nu nog (wegens ontbreken betrouwbare huisnummertoevoegingen in vele administraties)  per PC_HN 1 record vaststellen
BEGIN;
  drop view  if exists  adres_compleet_PCHN_Uniek cascade;
  CREATE OR REPLACE VIEW adres_compleet_PCHN_Uniek  AS
  SELECT
  adres_plus.openbareruimtenaam, adres_plus.verkorteopenbareruimtenaam ,
  adres_plus.huisnummer,
  adres_plus.huisletter,
  adres_plus.huisnummertoevoeging,
  adres_plus.postcode,
  adres_plus.woonplaatsnaam,
  adres_plus.woonplaatscode,
  adres_plus.gemeentenaam,
  adres_plus.gemeentecode,
  adres_plus.provincienaam,
  adres_plus.provinciecode,
  adres_plus.typeadresseerbaarobject,
  adres_plus.opp_adresseerbaarobject_m2,
  adres_plus.adresseerbaarobject_id,
  adres_plus.nummeraanduiding_ID,
  adres_plus.nevenadres,
  adres_plus.x,
  adres_plus.y,
  adres_plus.lon,
  adres_plus.lat
FROM
  adres_plus
  where postcode is not null and Rangorde_PCHN = 1 ;

COMMIT;
