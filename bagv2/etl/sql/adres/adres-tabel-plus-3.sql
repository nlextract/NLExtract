/*
------------------------------------------------------------------------------
--- START BLOK3 Woningtype vaststellen per PND, NAD en VBO.
------------------------------------------------------------------------------

Woningtype vaststellen per PND, VBO.
Restultaat zijn de tabellen:

pandactueelbestaand_plus_woningtype
vbo_woningtype_ontdubbeld

Hier een aantal statements om gegevens vast te stellen van NAD, VBO en PND die
betrekking hebben op de woonfunctie.

Hiervoor geldt dat we alleen kijken naar adressen uit adresselectie en actueel
bestaand van alle relevante tabellen dus verblijfsobjectpandactueelbestaand en
pandactueelbestaand. Omdat een verblijfsobject (VBO) altijd gekoppeld is aan
een pand zijn er mogelijkheden om van een pand vast te stellen (indien het een
woning is) wat voor type woning het betreft. Denk aan hoekwoning, tussenwoning,
vrijstaand etc. Methode van afleiden is gebaseerd op de wijze die het Kadaster
ook hanteert:
https://www.kadaster.nl/documents/20838/88047/Productbeschrijving+Woningtypering/a72e071a-e7af-4b93-aef2-a211de0f2056
------------------------------------------------------------------------------
------------------------------------------------------------------------------

Omdat adressen zijn vastgesteld obv actueelbestaand van NAD, (VBO< LIG,STA)
kan het bij een VBO voorkomen dat het pand er nog niet is maar dat er al wel
een vergunning is verleend (bv nieuwbouw). Van dergelijke adressen willen we
wel gegevens van het pand zien (w.o. status). Daarom maken we eerst een tabel
waarin ook de panden zijn opgenomen met een vergunning die verleend is. Deze
tabel van alle "actuele" panden gaan we aanvullen met woninggegevens indien
van toepassing.

*/

/*

-- Query returned successfully with no result in 33.7 secs.
BEGIN;
DROP TABLE IF EXISTS pandactueelbestaand_plus CASCADE;
CREATE TABLE pandactueelbestaand_plus AS
 SELECT
  pand.gid,
	pand.identificatie,
	pand.aanduidingrecordinactief,
	pand.voorkomenidentificatie,
	pand.geconstateerd,
	-- pand.inonderzoek,
	pand.documentnummer,
	pand.documentdatum,
	pand.pandstatus,
	-- ik heb bouwjaren < 1000 bekeken en daar klopt er niet 1 van. Om de
	-- datumrange te verkleinen zet ik deze op 1000 als bouwjaar te ver in de
	-- toekomst (bv 9999) dan aanpassen naar iets recenters (in de toekomst)
	CASE
	  WHEN pand.bouwjaar < 1000 THEN 1000
	  WHEN pand.bouwjaar > date_part('year', CURRENT_DATE) + 5 THEN date_part('year', CURRENT_DATE) + 5
	  ELSE pand.bouwjaar
    END AS bouwjaar,
	round(cast(ST_Area(ST_Transform(pand.geovlak, 28992)) AS numeric), 0) AS opp_pand,
	round(cast(ST_Perimeter(ST_Transform(pand.geovlak, 28992)) AS numeric), 0) AS omtrek_pand,
	pand.begindatumtijdvakgeldigheid,
	pand.einddatumtijdvakgeldigheid,
	pand.geovlak
  FROM pand
 WHERE pand.begindatumtijdvakgeldigheid <= 'now'::text::timestamp without time zone
  AND (pand.einddatumtijdvakgeldigheid IS NULL
  OR pand.einddatumtijdvakgeldigheid >= 'now'::text::timestamp without time zone)
  AND pand.aanduidingrecordinactief = false
  AND pand.geom_valid = true
  AND pand.pandstatus <> 'Niet gerealiseerd pand'::pandstatus
  AND pand.pandstatus <> 'Pand gesloopt'::pandstatus
  AND pand.pandstatus <> 'Pand ten onrechte opgevoerd'::pandstatus;
 --20200603 Query returned successfully: 10331821 rows affected, 01:14 minutes execution time.
COMMIT;


---20200531 toch maar geen index aanmaken. Kijken of dat sneller is.

BEGIN;
 CREATE INDEX idx_pandactueelbestaand_plus_id ON pandactueelbestaand_plus USING btree(identificatie);
 --20200531 Query returned successfully with no result in 42.5 secs.;
COMMIT;


BEGIN;
CREATE INDEX idx_GEOM_pandactueelbestaand_plus_idl on pandactueelbestaand_plus USING gist (geovlak);
---20200531 Query returned successfully with no result in 01:44 minutes.
COMMIT;

*/

BEGIN;
DROP VIEW IF EXISTS pandactueelbestaand_plus CASCADE;
CREATE VIEW pandactueelbestaand_plus AS
SELECT
    pnd.gid,
    pnd.bouwjaar,
    pnd.identificatie,
    pnd.pandstatus,
    pnd.geconstateerd,
    pnd.documentdatum,
    pnd.documentnummer,
    pnd.voorkomenidentificatie,
    pnd.begindatumtijdvakgeldigheid,
    pnd.einddatumtijdvakgeldigheid,
    pnd.tijdstipregistratie,
    pnd.eindregistratie,
    pnd.tijdstipinactief,
    pnd.tijdstipregistratielv,
    pnd.tijdstipeindregistratielv,
    pnd.tijdstipinactieflv,
    pnd.tijdstipnietbaglv,
    pnd.geovlak,
    pnd.aanduidingrecordinactief,
    pnd.geom_valid
   FROM bagv2.pand pnd, bagv2.extract_datum
  WHERE pnd.begindatumtijdvakgeldigheid <= extract_datum.waarde
    AND (pnd.einddatumtijdvakgeldigheid IS NULL OR pnd.einddatumtijdvakgeldigheid > extract_datum.waarde)
    AND pnd.aanduidingrecordinactief IS FALSE
    AND pnd.pandstatus <> 'Niet gerealiseerd pand'::bagv2.pandstatus
    AND pnd.pandstatus <> 'Pand gesloopt'::bagv2.pandstatus
    AND pnd.pandstatus <> 'Pand ten onrechte opgevoerd'::bagv2.pandstatus
    AND pnd.geom_valid = true;
COMMIT;

/*
het komt voor dat een pand meer dan 1x voorkomt
SELECT identificatie, count(*) FROM pandactueelbestaand_plus GROUP BY identificatie having count(*) >1;
om die reden gaan we zorgen dat alleen het recod overblijft met de hoogste begindatumtijdvakgeldigheid
SELECT * FROM pandactueelbestaand_plus where identificatie = '0513100011124025'; -- komt helaas 2x voor dus
*/

/*

BEGIN;
DROP TABLE IF EXISTS pandontdubbel CASCADE;
CREATE TABLE pandontdubbel AS
SELECT 1 AS te_verwijderen, pnd.*
FROM pandactueelbestaand_plus pnd
INNER JOIN (
  SELECT identificatie
  FROM pandactueelbestaand_plus
  GROUP BY identificatie
  HAVING count(*) > 1
) a
ON pnd.identificatie = a.identificatie;
-- 20200531 Query returned successfully: 0 rows affected, 10.0 secs execution time.
COMMIT;

-- SELECT * FROM pandontdubbel;
BEGIN;
UPDATE pandontdubbel SET te_verwijderen = 0
WHERE (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid) IN (
  SELECT identificatie, max(voorkomenidentificatie), max(begindatumtijdvakgeldigheid) AS begindatumtijdvakgeldigheid
  FROM pandontdubbel  GROUP BY identificatie
);
--20200531 Query returned successfully: 0 rows affected, 17 msec execution time.
COMMIT;

BEGIN;
DELETE FROM pandactueelbestaand_plus d
WHERE d.gid IN (SELECT gid FROM pandontdubbel WHERE te_verwijderen = 1);
--20200531 Query returned successfully: 0 rows affected, 38 msec execution time.
COMMIT;

*/

-- Nu hebben we een tabel met unieke panden maar dat zijn dus ook panden die
-- geen woning zijn. Nu gaan we van de combinatie NAD, VBO en PND met een
-- woonfuntie een aantal tabellen maken die nodig zijn om woningtype per NAD
-- vast te stellen.

-- 20200523 statement om vast te stellen bij welk pand met (woonfunctie) de NAD
-- (met woonfunctie) hoort. Meestal is dat helder maar soms hoort een NAD bij
-- een VBO dat bij 2 panden hoort. Daarom ook nog obv spacial query uitzoeken
-- in welk pand het ligt. Deze tabel bevat dus nad_id, vbo_id en pnd_id en een
-- extra gegeven of het NAD "binnen" een pand valt. Geen van de IDs hoeft dus
-- uniek te zijn maar bevat wel alle nad_id met een woonfunctie die gekoppeld
-- zijn aan een pand.
BEGIN;
DROP TABLE IF EXISTS woning_nad_vbo_pnd CASCADE;
CREATE TABLE woning_nad_vbo_pnd AS
SELECT
    vbopnd.gerelateerdpand AS pnd_id,
    adr.nad_id as nad_id,
    vbopnd.identificatie AS vbo_id,
    CASE WHEN ST_Contains(pnd.geovlak, adr.geopunt)
         THEN 1 ELSE 0 END AS nad_in_pand
--     pnd.documentdatum AS pnd_documentdatum
FROM
    verblijfsobjectgebruiksdoelactueelbestaand vbogbd,
    adresselectie adr,
    verblijfsobjectpandactueelbestaand vbopnd,
    pandactueelbestaand_plus pnd
WHERE
    adr.adresseerbaarobject_id = vbogbd.identificatie
    AND adr.adresseerbaarobject_id = vbopnd.identificatie
    AND vbopnd.gerelateerdpand = pnd.identificatie
    AND vbogbd.gebruiksdoelverblijfsobject = 'woonfunctie';
 -- AND ST_Contains(pnd.geovlak, adr.geopunt)
 -- deze voorwaarde niet toepassen want anders krijgen we niet de NAD behorend
 -- bij een pand waar het NAD niet in ligt
--20200531 Query returned successfully: 8114013 rows affected, 03:43 minutes execution time.
COMMIT;

BEGIN;
CREATE INDEX idx_woning_nad_vbo_pnd_nad ON woning_nad_vbo_pnd USING btree(nad_id);
--20200531 Query returned successfully with no result in 05:48 minutes.
COMMIT;

/*
-- bepaal de van NAD met (via VBO ) woonfunctie wat gegevens
BEGIN;
DROP TABLE IF EXISTS woning_nad_gegevens CASCADE;
CREATE TABLE woning_nad_gegevens AS
SELECT
    nad_id,
    count(DISTINCT vbo_id) AS woon_aantal_vbo_per_nad,
    count(DISTINCT pnd_id) AS woon_aantal_pnd_per_nad,
    CASE
        WHEN count(vbo_id) = count(pnd_id) AND count(pnd_id) = 1 THEN 1
        ELSE 0
    END AS woon_nad_1_op_1_vbo_pnd
FROM woning_nad_vbo_pnd
GROUP BY nad_id;
--20200531 Query returned successfully: 8101004 rows affected, 01:26 minutes execution time.
COMMIT;
*/

-- bepaal per VBO met woonfunctie wat gegevens
BEGIN;
DROP TABLE IF EXISTS woning_vbo_gegevens CASCADE;
CREATE TABLE woning_vbo_gegevens AS
SELECT
    vbo_id,
--     count(DISTINCT nad_id) AS woon_aantal_nad_per_vbo,
    count(DISTINCT pnd_id) AS woon_aantal_pnd_per_vbo,
    CASE
        WHEN count(nad_id) = count(pnd_id) AND count(pnd_id) = 1 THEN 1
        ELSE 0
    END AS woon_vbo_1_op_1_nad_pnd
FROM woning_nad_vbo_pnd
GROUP BY vbo_id;
--20200531 Query returned successfully: 8098663 rows affected, 01:26 minutes execution time.
COMMIT;

BEGIN;
DROP TABLE IF EXISTS woning_pnd_extra_gegevens CASCADE;
CREATE TABLE woning_pnd_extra_gegevens AS
SELECT
    pnd_id,
--     count(DISTINCT nad_id) AS woon_aantal_nad_per_pnd,
    count(DISTINCT vbo_id) AS woon_aantal_vbo_per_pnd
--     CASE
--         WHEN count(nad_id) = count(vbo_id) AND count(vbo_id) = 1 THEN 1
--         ELSE 0
--     END AS woon_pnd_1_op_1_nad_vbo
FROM woning_nad_vbo_pnd
GROUP BY pnd_id;
--20200603 Query returned successfully: 5556791 rows affected, 01:04 minutes execution time.
COMMIT;

BEGIN;
ALTER TABLE woning_pnd_extra_gegevens
    ADD CONSTRAINT pand_extra_id PRIMARY KEY (pnd_id);
COMMIT;

/*
-- Woning NAD PND combinaties
BEGIN;
DROP TABLE IF EXISTS woning_nad_pnd_gegevens CASCADE;
CREATE TABLE woning_nad_pnd_gegevens AS
SELECT
    nad_id,
    pnd_id,
    max(nad_in_pand) AS nad_in_pand
--     max(pnd_documentdatum) AS pnd_documentdatum
FROM woning_nad_vbo_pnd
GROUP BY nad_id, pnd_id;
--20200531 Query returned successfully: 8114013 rows affected, 01:06 minutes execution time.
*/

-- Woning VBO_PND combinaties
DROP TABLE IF EXISTS woning_vbo_pnd_gegevens CASCADE;
CREATE TABLE woning_vbo_pnd_gegevens AS
SELECT
    vbo_id,
    pnd_id,
    max(nad_in_pand) AS nad_in_pand
FROM woning_nad_vbo_pnd
GROUP BY vbo_id, pnd_id;
-- Query returned successfully: 8111423 rows affected, 01:05 minutes execution time.
COMMIT;

--- 20200523 toegevoegd unieke panden met woonfunctie
--- 20200529 deze zou weg kunnen en daar waar PND_WOON gebrukt wordt kan ik pandactueelbestaand_plus gebruiken

-- Bepaal met een spatial query van alle woon-panden aan welke ander woon-pand
-- het verbonden is (30cm). Dit is minimaal 1 omdat dit het eigen pand is.
-- De 30cm is (arbitrair) gekozen omdat de BAG niet altijd even nauwkeurig is.
BEGIN;
DROP TABLE IF EXISTS pnd_woon_relaties CASCADE;
CREATE TABLE pnd_woon_relaties AS
SELECT
    pnd1.identificatie AS pnd_id1,
    pnd2.identificatie AS pnd_id2
FROM
    pandactueelbestaand_plus pnd1,
    woning_pnd_extra_gegevens w1,
    woning_pnd_extra_gegevens w2,
    pandactueelbestaand_plus pnd2
WHERE
    ST_DWithin(pnd1.geovlak, pnd2.geovlak, 0.3)
    AND pnd1.identificatie = w1.pnd_id
    AND pnd2.identificatie = w2.pnd_id;
-- 20200603 Query returned successfully: 12638123 rows affected, 09:14 minutes execution time.
COMMIT;

BEGIN;
-- stel per pand met een woonfunctie vast hoeveel panden met woonfunctie er "vast" zitten aan dat pand.
DROP TABLE IF EXISTS pnd_woon_relaties_aantal CASCADE;
CREATE TABLE pnd_woon_relaties_aantal AS
SELECT
    pnd_id1,
    count(*) AS aantal_gerelateerde_pnd
FROM pnd_woon_relaties
GROUP BY pnd_id1;
--20200531 Query returned successfully: 5556791 rows affected, 10.2 secs execution time.
COMMIT;

/*
Van alle panden gaan we gegevens ophalen maar tevens van de panden waar het mee
verbonden is om verschil tussen hoekwoning en 2 onder 1 kap vast te kunnen stellen.
Een hoekwoning is verbonden met een pand dat zelf met 2 andere panden verbonden is.
Een 2onder1kap is verbonden aan een pand dat slechts met 1 ander pand verbonden is.
*/

BEGIN;
-- stel per pand met een woonfunctie vast hoeveel panden met woonfunctie er "vast" zitten aan dat pand.
DROP TABLE IF EXISTS pnd_woon_type CASCADE;
CREATE TABLE pnd_woon_type AS
SELECT
    pwr.pnd_id1 AS pnd_id,
    substring(min(CASE
        WHEN aantnad.woon_aantal_vbo_per_pnd > 1 THEN '0 Appartement'
        WHEN aant1.aantal_gerelateerde_pnd = 1 THEN '1 Vrijstaande woning'
        WHEN aant1.aantal_gerelateerde_pnd > 2 THEN '2 Tussen of geschakelde woning'
        WHEN (pwr.pnd_id1 <> pwr.pnd_id2
              AND aant1.aantal_gerelateerde_pnd = 2
              AND aant2.aantal_gerelateerde_pnd = 2) THEN '3 Tweeonder1kap'
        WHEN (pwr.pnd_id1 <> pwr.pnd_id2
              AND aant1.aantal_gerelateerde_pnd = 2
              AND aant2.aantal_gerelateerde_pnd > 2) THEN '4 Hoekwoning'
        ELSE '5 onbekend'
    END), 3, 30) AS woningtype
FROM
    pnd_woon_relaties pwr, -- dit zijn alle woonpand-woonpand combinaties die spacial zijn verbonden. Dus minimaal 1 record per pand wegens verbonden met zichzelf
    pnd_woon_relaties_aantal aant2, -- dit zijn het aantal panden waar een pand spacial mee verbonden is
    pnd_woon_relaties_aantal aant1, -- dit zijn het aantal panden waar een pand spacial mee verbonden is
    woning_pnd_extra_gegevens aantnad -- dit zijn het aantal NAD waar een pand mee verbonden is
WHERE
    pwr.pnd_id1 = aant1.pnd_id1
    AND pwr.pnd_id2 = aant2.pnd_id1
    AND aantnad.pnd_id = pwr.pnd_id1
GROUP BY pwr.pnd_id1;
--20200603 Query returned successfully: 5556791 rows affected, 02:11 minutes execution time.
COMMIT;

BEGIN;
ALTER TABLE pnd_woon_type
 ADD CONSTRAINT pand_id PRIMARY KEY (pnd_id);
COMMIT;

-- maak een tabel van alle actuele panden en vul die aan met kenmerken
BEGIN;
DROP TABLE IF EXISTS pandactueelbestaand_plus_woningtype CASCADE;
CREATE TABLE pandactueelbestaand_plus_woningtype AS
SELECT
    p.*,
	round(cast(ST_Area(ST_Transform(p.geovlak, 28992)) AS numeric), 0) AS opp_pand,
	round(cast(ST_Perimeter(ST_Transform(p.geovlak, 28992)) AS numeric), 0) AS omtrek_pand,
    w.woningtype,
    CASE WHEN w.woningtype IS NOT NULL THEN 1 ELSE 0 END pand_is_woning,
--     e.woon_aantal_nad_per_pnd,
    e.woon_aantal_vbo_per_pnd
--     e.woon_pnd_1_op_1_nad_vbo
-- FROM pandactueelbestaand_plus p
FROM pandactueelbestaand_plus p
LEFT JOIN pnd_woon_type w ON p.identificatie = w.pnd_id
LEFT JOIN woning_pnd_extra_gegevens e ON e.pnd_id = p.identificatie;
COMMIT;

BEGIN;
CREATE INDEX idx_pandactueelbestaand_plus_woningtypeid ON pandactueelbestaand_plus_woningtype USING btree(identificatie);
 --20200531 Query returned successfully with no result in 42.5 secs.;
COMMIT;

-- vaststellen woningtype per VBO
-- Voor bijna alle VBO gaat dat gewoon goed omdat die aan 1 pand gerelateerd
-- zijn. Daar waar een VBO aan meer dan 1 pand gerelateerd is en het woningtype
-- van de panden is verschillend kunnen we het niet vaststellen. De krijgt dan
-- ook '99 Verschillend' als vbo_woningtype

BEGIN;
DROP TABLE IF EXISTS vbo_woningtype CASCADE;
CREATE TABLE vbo_woningtype AS
SELECT
    vbo.vbo_id,
    CASE
        WHEN min(woningtype) = max(woningtype) THEN max(woningtype)
        ELSE 'Verschillend'
    END AS woningtype,
    count(DISTINCT vbo.pnd_id) AS vbo_aantal_pandwoning
FROM
    woning_vbo_pnd_gegevens vbo,
    pandactueelbestaand_plus_woningtype pnd_woningtype
WHERE vbo.pnd_id = pnd_woningtype.identificatie
GROUP BY vbo.vbo_id;

--20200531 Query returned successfully: 8098663 rows affected, 01:49 minutes execution time.
-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE vbo_woningtype
    ADD CONSTRAINT pk_vbo_woningtype PRIMARY KEY (vbo_id);
--20200531 Query returned successfully with no result in 12.1 secs.
COMMIT;

--Nu gaan we proberen het aantal VBO met woningtype = 'Verschillend' te beperken en dat gaat lukken ;)
--Hoeveel adressen hebben Verschillend woningtype
--SELECT count(*) FROM adres_plus where woningtype = 'Verschillend';-- 3422
--SELECT count(*) FROM vbo_woningtype where Woningtype = '9 Verschillend' -- 3422 en dat is logisch

-- bepaal van de VBO die als woningtpye 'Verschillend' hebben alle panden waar het bijbehorende NAD in ligt.
-- Als al die panden zelfde woningtype hebben zet dan dat woningtype als woningtype in tabel vbo_woningtype.
--Er blijven dan nog maar stuk of 40 VBO over waarvan niet vast te stellen is wat het woningtype is
BEGIN;
DROP TABLE IF EXISTS vbo_woningtype_ontdubbeld CASCADE;
CREATE TABLE vbo_woningtype_ontdubbeld AS
SELECT
    vbo.vbo_id,
    min(x.pnd_id) AS minpnd_id,
    max(x.pnd_id) AS maxpnd_id,
    CASE
        WHEN max(w.woningtype) = min(w.woningtype) THEN max(w.woningtype)
        ELSE 'Verschillend'
    END AS ontdubbeld_woningtype,
    min(w.woningtype) AS min_woningtype,
    max(w.woningtype) AS max_woningtype,
    count(*) AS aantal
FROM vbo_woningtype vbo
INNER JOIN woning_nad_vbo_pnd x
    ON x.vbo_id = vbo.vbo_id
   AND vbo.woningtype = 'Verschillend'
   AND x.nad_in_pand = 1
INNER JOIN pandactueelbestaand_plus_woningtype w
    ON x.pnd_id = w.identificatie
GROUP BY vbo.vbo_id
ORDER BY count(*) DESC;
--20200531 Query returned successfully: 3422 rows affected, 3.4 secs execution time.
-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE vbo_woningtype_ontdubbeld
    ADD CONSTRAINT pk_vbo_woningtype_ontdubbeld PRIMARY KEY (vbo_id);
 --20200531 Query returned successfully with no result in 32 msec.
COMMIT;

BEGIN;
UPDATE vbo_woningtype
SET woningtype = b.ontdubbeld_woningtype
FROM vbo_woningtype_ontdubbeld b
WHERE vbo_woningtype.vbo_id = b.vbo_id;
--20200531 Query returned successfully: 3422 rows affected, 348 msec execution time.
COMMIT;

-- SELECT vbo_woningtype.*, length(vbo_woningtype) AS lengte, right(vbo_woningtype, length(vbo_woningtype) - 2) AS type FROM vbo_woningtype limit 100
-- SELECT vbo_woningtype, count(*) AS aantal FROM vbo_woningtype GROUP BY vbo_woningtype ORDER BY count(*) DESC;

----------------------------------------------------------------------------------------------------------------
--- EINDE BLOK3 Woningtype vaststellen per PND en VBO.
----------------------------------------------------------------------------------------------------------------
