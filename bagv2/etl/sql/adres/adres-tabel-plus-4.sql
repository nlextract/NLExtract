/*
----------------------------------------------------------------------------------------------------------------
--- START BLOK4 Per vbo een aantal gegevens vaststellen (dus niet alleen vbo met Woonfucntie maar allen)
----------------------------------------------------------------------------------------------------------------
Resultaat is de tabel "vbo_pandgegevens"

Nu we alle adressen te pakken hebben is het de bedoeling dat we die adressen van het type verblijfsobject
(vbo) gaan verrijken met gegevens over het gerelateerde pand c.q. de gerelateerde panden. Van deze panden
willen we de oppervlakte weten  en daarnaast willen we weten of een vbo er 1 van de velen is die bij het
zelfde pand behoren (bv appartementcomplex) of dat het een vbo is dat hangt aan 1 pand waarvan dit vbo de
enige is. (meeste huizen). Heel soms is 1 vbo gerealteerd aan meer dan 1 pand. Ook dat willen we weten.
Om dit te kunnen moeten we wat tabellen/views voorbereiden.

-------------------------------------------------------------------------------------------------------------
Bepaal per vbo id (uit adresselectie) het aantal verbonden panden dus ongeacht of de vbo een woonfunctie
heeft. Basis hiervoor is de view verblijfsobjectpandactueelbestaand. Omdat daarin records voor kunnen komen
zonder gerelateerd record in verblijfsobjectactueelbestaand en/of pandactueelbestaand maken we daarmee ook
een inner join. We zien dus alleen resultaten als in zowel verblijfsobjectpandactueelbestaand als
verblijfsobjectactueelbestaand als pandactueelbestaand_plus_woningtype een gerelateerd record zit.
-------------------------------------------------------------------------------------------------------------
*/


-- haal uit de tabel verblijfsobjectpandactueelbestaand (relatietabel tussen
-- vbo en pand) per vbo een aantal gegevens op en vul dat aan met woningtype
BEGIN;
DROP TABLE IF EXISTS vbo_actueelbestaand_met_aantal_verbonden_pnd CASCADE;
CREATE TABLE vbo_actueelbestaand_met_aantal_verbonden_pnd AS
SELECT
  vbo_pnd.identificatie AS vbo_id,
  vbo.verblijfsobjectstatus,
  TEXT 'vbo' AS typeadresseerbaarobject,
  count(vbo_pnd.gerelateerdpand) AS aantalpnd_vbo,
  max(vbo_pnd.gerelateerdpand) AS max_pnd_id,
  max(vbo.hoofdadres) AS hoofdadres,
  max(vbo.oppervlakteverblijfsobject) AS opp_verblijfsobject_m2
FROM
  verblijfsobjectpandactueelbestaand vbo_pnd
INNER JOIN verblijfsobjectactueelbestaand vbo
    ON vbo_pnd.identificatie = vbo.identificatie
INNER JOIN (SELECT DISTINCT adresseerbaarobject_id FROM adresselectie) adr
    ON vbo.identificatie = adr.adresseerbaarobject_id
LEFT OUTER JOIN pandactueelbestaand_plus_woningtype pnd
    ON vbo_pnd.gerelateerdpand = pnd.identificatie
GROUP BY
    vbo_pnd.identificatie,
    vbo.hoofdadres,
    vbo.verblijfsobjectstatus;
--20200531: Query returned successfully: 9282292 rows affected, 04:59 minutes execution time.

CREATE INDEX vbo_actueelbestaand_met_aantal_verbonden_pnd_id
    ON vbo_actueelbestaand_met_aantal_verbonden_pnd USING btree (vbo_id);
-- 20200531 Query returned successfully with no result in 13.5 secs.
COMMIT;


--- Bepaal per pnd id het aantal verbonden vbo's (uit adresselectie) ongeacht of die vbo een woonfunctie heeft
BEGIN;
DROP TABLE IF EXISTS pnd_actueelbestaand_met_aantal_vbo CASCADE;
CREATE TABLE pnd_actueelbestaand_met_aantal_vbo AS
SELECT
  vbo_pnd.gerelateerdpand AS pnd_id,
  count(vbo_pnd.identificatie) AS aantalvbo_pnd,
  max(vbo_pnd.identificatie) AS max_vbo_id,
  sum(adr.opp_adresseerbaarobject_m2) AS sum_oppervlakte_alle_vbo_in_pand
FROM
  verblijfsobjectpandactueelbestaand vbo_pnd
INNER JOIN adresselectie adr
    ON vbo_pnd.identificatie = adr.adresseerbaarobject_id
INNER JOIN pandactueelbestaand_plus_woningtype pnd
    ON vbo_pnd.gerelateerdpand = pnd.identificatie
GROUP BY
    vbo_pnd.gerelateerdpand;
--20200531: Query returned successfully: 6323693 rows affected, 02:11 minutes execution time.

-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE pnd_actueelbestaand_met_aantal_vbo
  ADD CONSTRAINT pk_pnd_actueelbestaand_met_aantal_vbo PRIMARY KEY (pnd_id);
COMMIT;
-- 20200531:Query returned successfully with no result in 8.4 secs.

BEGIN;
DROP TABLE IF EXISTS vbo_pandgegevens;
CREATE TABLE vbo_pandgegevens AS
SELECT
	vbo.vbo_id,
	vbo.typeadresseerbaarobject,
	vbo.verblijfsobjectstatus,
	vbo.aantalpnd_vbo AS aantal_pand_relaties_dit_vbo,
	vbo.hoofdadres,
	vbo.opp_verblijfsobject_m2,
	vbo_woon.woningtype AS vbo_woningtype,
	pnd_act.woningtype,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd.pnd_id
         END AS pnd_id_uniek,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd.aantalvbo_pnd
         END AS aantal_vbo_relaties_dit_pnd,
    CASE WHEN vbo.aantalpnd_vbo = 1 AND pnd.aantalvbo_pnd = 1
         THEN 1 ELSE 0
         END AS vbo_pnd_1_op_1,
    CASE WHEN vbo.aantalpnd_vbo = 1 AND pnd.aantalvbo_pnd = 1
         THEN pnd.max_vbo_id
         END AS vbo_id_pnd_vbo_1_op_1,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd_act.opp_pand
         END AS opp_pand,
    CASE WHEN vbo.aantalpnd_vbo = 1 AND pnd_act.opp_pand > 0
         THEN round(pnd.sum_oppervlakte_alle_vbo_in_pand / pnd_act.opp_pand, 2)
         END verhouding_opp_vbo_opp_pnd,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd_act.omtrek_pand
         END AS omtrek_pand,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd_act.pandstatus
         END AS pandstatus,
    CASE WHEN vbo.aantalpnd_vbo = 1
         THEN pnd_act.bouwjaar
         END AS bouwjaar
FROM
	vbo_actueelbestaand_met_aantal_verbonden_pnd vbo
LEFT OUTER JOIN pnd_actueelbestaand_met_aantal_vbo pnd
    ON vbo.max_pnd_id = pnd.pnd_id
LEFT OUTER JOIN pandactueelbestaand_plus_woningtype pnd_act
    ON pnd.pnd_id = pnd_act.identificatie
LEFT OUTER JOIN vbo_woningtype vbo_woon
    ON vbo_woon.vbo_id = vbo.vbo_id;
--20200531: Query returned successfully: 9282292 rows affected, 01:15 minutes execution time.
COMMIT;

-- en een index hierop maken
BEGIN;
CREATE INDEX vbo_pandgegevens_vbo_id ON vbo_pandgegevens USING btree (vbo_id);
-- 20200531 Query returned successfully with no result in 51.7 secs.
COMMIT;

----------------------------------------------------------------------------------------------------------------
--- EINDE BLOK4 Per vbo een aantal gegevens vaststellen (dus niet allen vbo met Woonfucntie maar allen)
----------------------------------------------------------------------------------------------------------------
