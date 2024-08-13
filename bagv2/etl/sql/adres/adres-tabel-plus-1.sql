--
-- Dit script is gemaakt door Peter van Wee (github: PeeWeeOSM)
--
-- Het resultaat van dit script zijn de volgende 3 tabellen/views
--
--  1 Tabel "adres_plus":
--  De "actuele adressen" met een groot aantal eigenscchappen waaronder gerelateerd pand inclusief woningtype (Vrijstaand, 2onder1kap etc.)
--
--  2 View "adres_compleet_PCHN_Uniek"
--  Dit is een subset (zowel rijen als kolommen) van  "adres_plus" waarbij per postcode-huisnummer combinatie slechts 1 record bestaat.
--  Dit om makkelijker te koppelen met externe adressen die de BAG conventie niet volgen (huisletter, huisnummertoevoeging)
--
--  3 Tabel "pandactueelbestaand_plus_woningtype"
--  De "actuele" panden van NL waarbij ook de status 'Bouwvergunning verleend' wordt meegenomen (want in de praktijk vaak al gerealiseerd) en waarin ook het woningtype (Vrijstaand, 2onder1kap etc.) is opgenomen. :
--
--
-- Conventies: Indien het "adres" toe te wijzen is aan 1 pand met een woonfunctie dan wordt het woontype aangegeven (Hoekhuis, 2onder1kap, vrijstaande woning etc. )
-- 1	Het betreft adressen met en zonder postcode.
-- 2	Doel is dat een adres uniek is volgens de volgende definitie. :
-- 		De combinatie van openbareruimte_id, postcode, huisnummer, huisletter, huisnummertoevoeging is uniek.
-- 		In eerste instantie zijn deze niet uniek. Door een aantal sequentiele statements wordt er ontdubbeld waardoor de adres tabel alleen unieke records heeft.
-- 3	Omdat BAG historisch is en we eigenlijk alleen de "actuele" gegevens willen zien moeten we besluiten onder welke condities een adres als "actueel" wordt gezien.
-- 	De hier gehanteerde definitie is dat een adresrecord actueel is als er een gerelateerd record is in de "actueelbestaand" view van de volgende 2 combinaties van tabellen:
--
-- Woonplaats EN Openbareruimte EN  Nummeraanduiding EN (Verblijfsobject OF Standplaats OF Ligplaats )
-- Woonplaats EN Openbareruimte EN  Nummeraanduiding EN adresseerbaarobjectnevenadres EN (Verblijfsobject OF Standplaats OF Ligplaats )
--
-- De adres tabel vertoont veel gelijkenis met de adres_full van NL extract. De voornaamste verschillen zijn:
-- 1	Er zitten adressen is zonder postcode
-- 2	Een nummeraanduiding id komt slechts 1x voor  (vermoedelijk was dat bij adres_full ook bedoeling)
-- 3	De combinatie van  postcode, huisnummer, huisletter, huisnummertoevoeging ,openbareruimte_id is uniek. (uniq_key) (NB de openbare ruimte_id is nodig voor adressen zonder postcode maar ook een aantal adressen met Postcode maakt het nog niet uniek.
-- 	voorbeeld: 7572BP 8.  komt voor met OBR_id "173300000124785"  en  "173300000125027")
-- 4	Van ieder adres is aangegeven of de combinatie van Postcode/huisnummer uniek is.
-- 5	Van ieder adres is aangegeven of de combinatie van Postcode/huisnummer/huisletter/huisnummertoevoegin uniek is.
-- 6	Voor iedere gebruiksdoel is een kolom met een waarde 1 of null die aangeeft  of het van toepassing is.
-- 7	Indien het "adres" toe te wijzen is aan 1 pand met een woonfunctie dan wordt het woningtype aangegeven (Hoekhuis, 2onder1kap, vrijstaande woning etc. )
-- 7b	Indien het "adres" toe te wijzen is aan meer dan 1 pand met een woonfunctie en al die panden hebben  het zelfde woningtype dan wordt dat getoond. (Hoekhuis, 2onder1kap, vrijstaande woning etc. )
-- 8	Per openbareruimte ID, postcode en huisnummer wordt een rangorde bepaald. Deze is nodig om een view te kunnen maken waarbij per postcode/huisnummer combinatie het "belangrijkste" adres vast te stellen is.
-- 	Dit laatste is weer nodig om te koppelen met externe adrestabellen die geen BAG conventie aanhouden (postcode, huisnummer, huisletter, huisnummertoevoeging) en veelal wel te koppelen zijn op alleen postcode/huisnummer.
-- 	Mijn ervaring is dat externe adrestabellen vaak wel een huisnummertoeving hebben maar dat deze van dermate slechte kwaliteit is dat ook dat niet te gebruiken is.
--
--
-- Om het script te kunnen draaien heb je de NL_Extract postgis DB dump nodig die na restore een DB oplevert.
-- Daarnaast is het van belang dat je de tablefunct extentie hebt ge activeert. (CREATE extension tablefunc;)
--
--
-- VERSIEBEHEER
-- 2020 mei-juli Peter van Wee
-- Eerste versies.
--
-- 2020 juli Just van den Broecke
-- NLExtract integratie
-- kleine, niet-functionele aanpassingen,, m.n. geen "bagactueel"
-- schema verwijzingen (kan met PG search_path)
--
-- 20210129 Peter van Wee
-- Fouten in adres ontdubbel statements opgelost
-- RANK functie vervangen door ROW_NUM
--
-- vanaf hier voor BAG versie 2
--
-- 20210205 Just van den Broecke
-- File encoding van Windows naar UTF-8 en CRLF naar LF
-- geopunt was Geometry, nu: cast(adres.geopunt AS geometry(PointZ, 28992)),
--
-- 20210318 Just van den Broecke
-- alles 2D (geopunt Point ipv PointZ), verwijder ST_Force3D()
-- inonderzoek kolom bestaat niet meer, commented out
-- extra pand niet-bestaand status: 'Pand ten onrechte opgevoerd'
-- extra pand bestaand status: 'Verbouwing pand'

CREATE EXTENSION IF NOT EXISTS tablefunc;

-- SET search_path TO bagv2,public;
set statement_timeout to 50000000;

-----------------------------------------------------
---- START BLOK1 adresselectie blok------------------
-----------------------------------------------------
-- Stel vast van welke adressen we uiteindelijk een record willen hebben
-- Dat vullen we later aan meer meer gegevens van bv VBO en PND

-- 20220531 dit is nu overbodig
-- BEGIN;
-- -- Omdat NL extract adressen met postcode uitsluit in de view nummeraanduidingactueelbestaand
-- -- maken we eerst een view inclusief de adressen zonder postcode
-- DROP VIEW IF EXISTS nummeraanduidingactueelbestaand_compleet cascade;
-- CREATE OR REPLACE VIEW nummeraanduidingactueelbestaand_compleet AS
-- Select
-- 	NAD.gid,
-- 	NAD.identificatie,
-- 	NAD.aanduidingrecordinactief,
-- 	NAD.voorkomenidentificatie,
-- 	NAD.geconstateerd,
-- 	-- NAD.inonderzoek,
-- 	NAD.documentnummer,
-- 	NAD.documentdatum,
-- 	NAD.huisnummer,
-- 	NAD.huisletter,
-- 	NAD.huisnummertoevoeging,
-- 	NAD.postcode,
-- 	NAD.nummeraanduidingstatus,
-- 	NAD.typeadresseerbaarobject,
-- 	NAD.gerelateerdeopenbareruimte,
-- 	NAD.gerelateerdewoonplaats,
-- 	NAD.begindatumtijdvakgeldigheid,
-- 	NAD.einddatumtijdvakgeldigheid
-- from nummeraanduiding NAD
-- inner join nummeraanduidingactueelbestaand M
--     on NAD.identificatie=M.identificatie and NAD.begindatumtijdvakgeldigheid=m.begindatumtijdvakgeldigheid
-- where NAD.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
--     AND (NAD.einddatumtijdvakgeldigheid is NULL OR NAD.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
--     AND NAD.aanduidingrecordinactief = FALSE
--     AND NAD.nummeraanduidingstatus <> 'Naamgeving ingetrokken';
-- COMMIT;


-- 20220531 dit is nu overbodig
-- BEGIN;
-- -- In de view provincie_gemeenteactueebestaand ontbreken begin van het jaar de gemeentes die ophouden te bestaan op de eerste van het jaar.
-- -- Als dit script gedraaid wordt begin januari gebaseerd op een postgis dump van december
-- -- dan ontbreken opeens die gemeentes. Om dat te voorkomen maak ik een view provincie_gemeenteactueel
-- DROP VIEW IF EXISTS provincie_gemeenteactueel cascade;
-- CREATE OR REPLACE VIEW provincie_gemeenteactueel as
-- select a.* from (
--  SELECT
--    -- 20210129: RANK functie vervangen door row_num
--     pg.*,     row_number() OVER (PARTITION BY gemeentecode ORDER BY  pg.einddatum desc nulls first) as Rangorde
--     FROM provincie_gemeente pg) A
--    where Rangorde =1;
-- /*
-- --- Per woonplaats, gemeente en provincie een aantal gegevens vaststellen die we later voor adres gegevens.
-- --- de lon. lat bepalen adhv  gemiddelde per VBO. Dit omdat de centroid van een geovlak nog wel eens in de zee c.q. markermeer wil belanden.
-- -- eerst per woonplaatscode de locatie (lon , lat)vaststellen obv het "zwaartepunt" van de adresseerbare VBO in die woonplaats
--
--   */
-- DROP TABLE IF EXISTS bag_wpl_actbest_gegevens CASCADE;
-- CREATE TABLE bag_wpl_actbest_gegevens AS
-- SELECT
--     OBR.gerelateerdewoonplaats AS woonplaats_id,
--     WPL.woonplaatsnaam,
--     GEM_WPL.gemeentecode AS gemeente_id,
--     PRV.gemeentenaam,
--     PRV.provinciecode AS provincie_id,
--     prv.provincienaam
--     --,
--     --ROUND(cast(avg(ST_x (ST_Transform (geopunt, 4326)))as numeric),3) as lon,
--     --ROUND(cast(avg(ST_y (ST_Transform (geopunt, 4326)))as numeric),3) as lat,
--     --count(*) as Aantal_VBO
-- FROM
--     nummeraanduidingactueelbestaand NAD,
--     openbareruimteactueelbestaand OBR,
--     verblijfsobjectactueelbestaand VBO,
--     gemeente_woonplaatsactueelbestaand GEM_WPL,
--     provincie_gemeenteactueelbestaand PRV,
--     woonplaatsactueelbestaand WPL
-- WHERE NAD.gerelateerdeopenbareruimte = OBR.identificatie
--   AND VBO.hoofdadres = NAD.identificatie
--   AND prv.gemeentecode = gem_wpl.gemeentecode
--   AND wpl.identificatie = gem_wpl.woonplaatscode
--   AND OBR.gerelateerdewoonplaats = wpl.identificatie
-- GROUP BY
--     OBR.gerelateerdewoonplaats,
--     WPL.woonplaatsnaam,
--     GEM_WPL.gemeentecode,
--     PRV.gemeentenaam,
--     PRV.provinciecode,
--     prv.provincienaam
-- ;
-- COMMIT;
--20200530 Query returned successfully: 2500 rows affected, 02:27 minutes execution time.


BEGIN;
-- Hier maken we de initiele adrestabel. Later worden records verwijderd om adressen uniek te krijgen
-- De actueelbestaand tabellen van NAD, OBR, WPL, LIG, STA en VBO joinen (= hoofdadressen)
-- en deze samenvoegen (union) met actueelbestaand tabellen van NEV, NAD,OBR, WPL, LIG, STA en VBO joinen (= nevenadressen)
DROP TABLE IF EXISTS adresselectie CASCADE;
CREATE TABLE adresselectie AS
SELECT
concat_ws('-', coalesce(NAD.postcode,'0'), NAD.huisnummer::text, coalesce(NAD.huisletter, '0'), coalesce(NAD.huisnummertoevoeging, '0'), NAD.gerelateerdeopenbareruimte) AS uniq_key,
NAD.identificatie AS NAD_ID,
OBR.openbareruimtenaam,
OBR.verkorteopenbareruimtenaam,
OBR.openbareruimtetype,
NAD.huisnummer,
NAD.huisletter,
NAD.huisnummertoevoeging,
NAD.postcode,
WPL.woonplaatsnaam,
WPL.identificatie AS woonplaats_id,
PG.gemeentenaam,
PG.gemeentecode AS gemeente_id,
PG.provincienaam,
PG.provinciecode AS provincie_id,
0 AS Nevenadres,
NAD.nummeraanduidingstatus,
NAD.typeadresseerbaarobject,
CASE
    WHEN VBO.identificatie IS NOT NULL THEN 'VBO'
    WHEN LIG.identificatie IS NOT NULL THEN 'LIG'
    WHEN STA.identificatie IS NOT NULL THEN 'STA'
END AS typeadresseerbaarobjectkort,
OBR.identificatie AS OBR_ID,
NAD.begindatumtijdvakgeldigheid AS NAD_BEGIN,
coalesce(VBO.begindatumtijdvakgeldigheid, LIG.begindatumtijdvakgeldigheid, STA.begindatumtijdvakgeldigheid) AS ADRESSEERBAAROBJECT_BEGIN,
-- coalesce(VBO.inonderzoek, LIG.inonderzoek, STA.inonderzoek) as ADRESSEERBAAROBJECT_inonderzoek,
coalesce(VBO.identificatie, LIG.identificatie, STA.identificatie) AS adresseerbaarobject_id,
coalesce(VBO.verblijfsobjectstatus::text, LIG.ligplaatsstatus::text, STA.standplaatsstatus::text) AS adresseerbaarobject_status,
coalesce(round(cast(ST_Area(ST_Transform(sta.geovlak, 28992)) as numeric), 0), round(cast(ST_Area(ST_Transform(lig.geovlak, 28992)) as numeric), 0), VBO.oppervlakteverblijfsobject) AS opp_adresseerbaarobject_m2,
coalesce(vbo.geopunt, ST_Centroid(lig.geovlak), ST_Centroid(sta.geovlak)) AS geopunt,
coalesce(lig.geovlak, sta.geovlak) AS geovlak,
round(cast(coalesce(ST_X(vbo.geopunt), ST_X(ST_Centroid(lig.geovlak)), ST_X(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision AS X,
round(cast(coalesce(ST_Y(vbo.geopunt), ST_Y(ST_Centroid(lig.geovlak)), ST_Y(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision AS Y,
round(cast(coalesce(ST_X(ST_Transform(vbo.geopunt, 4326)), ST_X(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_X(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision AS lon,
round(cast(coalesce(ST_Y(ST_Transform(vbo.geopunt, 4326)), ST_Y(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_Y(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision AS lat
FROM nummeraanduidingactueelbestaand NAD
LEFT OUTER JOIN verblijfsobjectactueelbestaand VBO ON NAD.identificatie = VBO.hoofdadres
LEFT OUTER JOIN standplaatsactueelbestaand STA ON NAD.identificatie = STA.hoofdadres
LEFT OUTER JOIN ligplaatsactueelbestaand LIG ON NAD.identificatie = LIG.hoofdadres
INNER JOIN openbareruimteactueelbestaand OBR ON NAD.gerelateerdeopenbareruimte = OBR.identificatie
INNER JOIN woonplaatsactueelbestaand WPL ON coalesce(NAD.gerelateerdewoonplaats, OBR.gerelateerdewoonplaats) = WPL.identificatie
INNER JOIN gemeente_woonplaatsactueelbestaand GW ON WPL.identificatie = GW.woonplaatscode
INNER JOIN provincie_gemeenteactueelbestaand PG on GW.gemeentecode = PG.gemeentecode
WHERE VBO.hoofdadres IS NOT NULL
   OR STA.hoofdadres IS NOT NULL
   OR LIG.hoofdadres IS NOT NULL

UNION
-- De actueelbestaand tabellen van NEV< NAD, LIG, STA en VBO joinen (= nevenadressen)
SELECT
concat_ws('-', coalesce(NAD.postcode,'0'), NAD.huisnummer::text, coalesce(NAD.huisletter, '0'), coalesce(NAD.huisnummertoevoeging, '0'), NAD.gerelateerdeopenbareruimte) AS uniq_key,
NAD.identificatie AS NAD_ID,
OBR.openbareruimtenaam,
OBR.verkorteopenbareruimtenaam,
OBR.openbareruimtetype,
NAD.huisnummer,
NAD.huisletter,
NAD.huisnummertoevoeging,
NAD.postcode,
WPL.woonplaatsnaam,
WPL.identificatie AS woonplaats_id,
PG.gemeentenaam,
PG.gemeentecode AS gemeente_id,
PG.provincienaam,
PG.provinciecode AS provincie_id,
1 AS Nevenadres,
NAD.nummeraanduidingstatus,
NAD.typeadresseerbaarobject,
CASE
    WHEN VBO.identificatie IS NOT NULL THEN 'VBO'
    WHEN LIG.identificatie IS NOT NULL THEN 'LIG'
    WHEN STA.identificatie IS NOT NULL THEN 'STA'
END AS typeadresseerbaarobjectkort,
OBR.identificatie AS OBR_ID,
NAD.begindatumtijdvakgeldigheid AS NAD_BEGIN,
coalesce(VBO.begindatumtijdvakgeldigheid, LIG.begindatumtijdvakgeldigheid, STA.begindatumtijdvakgeldigheid) AS ADRESSEERBAAROBJECT_BEGIN,
-- coalesce(VBO.inonderzoek, LIG.inonderzoek, STA.inonderzoek) as ADRESSEERBAAROBJECT_inonderzoek,
coalesce(VBO.identificatie, LIG.identificatie, STA.identificatie) AS adresseerbaarobject_id,
coalesce(VBO.verblijfsobjectstatus::text, LIG.ligplaatsstatus::text, STA.standplaatsstatus::text) AS adresseerbaarobject_status,
coalesce(round(cast(ST_Area(ST_Transform(sta.geovlak, 28992)) as numeric), 0), round(cast(ST_Area(ST_Transform(lig.geovlak, 28992)) as numeric), 0), VBO.oppervlakteverblijfsobject) AS opp_adresseerbaarobject_m2,
coalesce(vbo.geopunt, ST_Centroid(lig.geovlak), ST_Centroid(sta.geovlak)) AS geopunt,
coalesce(lig.geovlak, sta.geovlak) AS geovlak,
round(cast(coalesce(ST_X(vbo.geopunt), ST_X(ST_Centroid(lig.geovlak)), ST_X(ST_Centroid(sta.geovlak))) as numeric(9, 3)), 3)::double precision AS X,
round(cast(coalesce(ST_Y(vbo.geopunt), ST_Y(ST_Centroid(lig.geovlak)), ST_Y(ST_Centroid(sta.geovlak))) as numeric(9, 3)), 3)::double precision AS Y,
round(cast(coalesce(ST_X(ST_Transform(vbo.geopunt, 4326)), ST_X(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_X(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision AS lon,
round(cast(coalesce(ST_Y(ST_Transform(vbo.geopunt, 4326)), ST_Y(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_Y(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision AS lat
FROM adresseerbaarobjectnevenadresactueelbestaand NEV
INNER JOIN nummeraanduidingactueelbestaand NAD ON nev.nevenadres = NAD.identificatie
LEFT OUTER JOIN verblijfsobjectactueelbestaand VBO ON NEV.identificatie = VBO.identificatie
LEFT OUTER JOIN standplaatsactueelbestaand STA ON NEV.identificatie = STA.identificatie
LEFT OUTER JOIN ligplaatsactueelbestaand LIG ON NEV.identificatie = LIG.identificatie
INNER JOIN openbareruimteactueelbestaand OBR ON NAD.gerelateerdeopenbareruimte = OBR.identificatie
INNER JOIN woonplaatsactueelbestaand WPL ON coalesce(NAD.gerelateerdewoonplaats, OBR.gerelateerdewoonplaats) = WPL.identificatie
INNER JOIN gemeente_woonplaatsactueelbestaand GW ON WPL.identificatie = GW.woonplaatscode
INNER JOIN provincie_gemeenteactueelbestaand PG on GW.gemeentecode = PG.gemeentecode
WHERE VBO.identificatie IS NOT NULL
   OR STA.identificatie IS NOT NULL
   OR LIG.identificatie IS NOT NULL
;
--20200530 Query returned successfully: 9354464 rows affected, 05:46 minutes execution time.

CREATE INDEX idx_adresselectie_adrobj_id ON adresselectie USING btree(adresseerbaarobject_id);
CREATE INDEX idx_adresselectie_nad_id ON adresselectie USING btree(nad_id);
CREATE INDEX idx_adresselectie_uniq_key ON adresselectie USING btree(uniq_key);

COMMIT;
-- 20200530 Query returned successfully with no result in 03:28 minutes.

/*
een nummeraanduidig mag slechts 1x voorkomen.
Check: Select nad_id, count(*) from adresselectie  group by nad_id having count(*) > 1;

Dit resultaat (adresselectie) zou idealiter unieke nummeraandudingen moeten hebben
maar dat is niet altijd zo. Helaas geen uniek combinaties van openbareruimte_id,
postcode, huisnummer, huisletter, huisnummertoevoeging en dus zullen we later moeten
ontdubbelen.

Peter van Wee 20210129. Helaas toch weer een nummeraanduiding die meer dan 1x voorkomt.
Om dat op te lossen gaan we records verwijderen met het volgende statement:
*/


-- 20220531 dit is nu overbodig
-- delete from adresselectie
-- --select * from adresselectie
-- where (nad_id, adresseerbaarobject_id) in (
-- Select c.nad_id, c.adresseerbaarobject_id from
-- (
-- Select a.nad_id, a.adresseerbaarobject_id,   row_number() OVER (PARTITION BY  a.nad_id ORDER BY   a.adresseerbaarobject_id desc ) as Rang from adresselectie a
-- inner join (
-- Select nad_id, count(*) from adresselectie  group by nad_id having count(*) > 1) b on A.nad_id=b.nad_id
-- ) c where c.rang <> 1
-- );


-- nu de adressen (uniq_key) ophalen waarvan de uniq_key meer dan 1x voorkomt
BEGIN;
DROP TABLE IF EXISTS  adres_dubbel cascade;
create table adres_dubbel as
    select a.*
    from adresselectie a
    inner join (
        select uniq_key
        from adresselectie
        group by uniq_key
        having count(*) > 1
    ) b
    on a.uniq_key = b.uniq_key
    order by a.uniq_key
;
--- 20200530: Query returned successfully: 22112 rows affected, 03:02 minutes execution time.
COMMIT;


-- Als in  adres_dubbel  een record uniek is  behalve op de kolom ADRESSEERBAAROBJECT_inonderzoek
-- dan gaan we het record waar ADRESSEERBAAROBJECT_inonderzoek=f verwijderen.
-- JvdB: kolom niet in BAG v2
-- BEGIN;
-- delete from adres_dubbel D
-- where D.adresseerbaarobject_id in (
--
-- 	  select distinct adresseerbaarobject_id
-- 	  FROM adres_dubbel group by adresseerbaarobject_id
-- 	  having count (distinct adresseerbaarobject_inonderzoek) > 1)
--
-- and  D.adresseerbaarobject_inonderzoek= 'f';
-- --20200530 Query returned successfully: 0 rows affected, 194 msec execution time.
-- COMMIT;

BEGIN;

-- Voor analyse doeleinden gaan we van de unieke VBO_ID's uit adres-dubbel records (indien VBO)
-- de actuele pandstatus ophalen (dus niet actueelbestaand)
DROP TABLE IF EXISTS  adres_pand1 cascade;
create table adres_pand1 as
SELECT
  VBO_PND.identificatie as VBO_ID,
  count(VBO_PND.gerelateerdpand) as AantalPND_VBO,
  max(VBO_PND.gerelateerdpand) as max_PND_ID,
  max(pnd.pandstatus) as max_PND_STATUS,
  min(pnd.pandstatus) as min_PND_STATUS,
  max(pnd.bouwjaar) as max_bouwjaar,
  min(pnd.bouwjaar) as min_bouwjaar,
  max(pnd.begindatumtijdvakgeldigheid) as max_begin,
  min(pnd.begindatumtijdvakgeldigheid) as min_begin,
  max(case
    when pnd.pandstatus in ('Pand buiten gebruik', 'Sloopvergunning verleend', 'Pand in gebruik', 'Pand in gebruik (niet ingemeten)', 'Bouw gestart', 'Verbouwing pand') then 1
    when pnd.pandstatus in ('Niet gerealiseerd pand', 'Pand gesloopt', 'Bouwvergunning verleend', 'Pand ten onrechte opgevoerd') then 0
    else -1 end) as Pand_bestaand
FROM
  verblijfsobjectpandactueelbestaand VBO_PND
  inner join (select distinct adresseerbaarobject_id from adres_dubbel where typeadresseerbaarobjectkort = 'VBO') A on VBO_PND.identificatie  = A.adresseerbaarobject_id
  inner join verblijfsobjectactueelbestaand VBO on VBO_PND.identificatie = VBO.identificatie
  left outer join pandactueel PND on VBO_PND.gerelateerdpand = PND.identificatie
  group by  VBO_PND.identificatie, vbo.hoofdadres, VBO.verblijfsobjectstatus
  ;
--20200530 Query returned successfully: 21590 rows affected, 28.0 secs execution time.

COMMIT;
BEGIN;
-- van de betreffende panden het geovlak ophalen.
DROP TABLE IF EXISTS  adres_pand2 cascade;
create table adres_pand2 as
Select pnd.geovlak, a.VBO_ID , a.max_PND_ID from adres_pand1 A
inner join pandactueel PND on a.max_PND_ID = pnd.identificatie;
--202005 Query returned successfully: 21590 rows affected, 2.2 secs execution time.
COMMIT;

BEGIN;
--Vaststellen tabel met te ontdubbelen uniq_key records
DROP TABLE IF EXISTS adres_te_ontdubbelen CASCADE;
CREATE TABLE adres_te_ontdubbelen AS
SELECT DISTINCT
    0 as Verwijderen,
    a.uniq_key,
    a.nevenadres,
    a.typeadresseerbaarobjectkort,
    a.nummeraanduidingstatus,
    a.adresseerbaarobject_status,
    b.AantalPND_VBO as Aantal_verbonden_PND,
    b.Pand_bestaand,
    CASE
        WHEN b.AantalPND_VBO = 1 THEN b.min_PND_STATUS::text
        WHEN b.AantalPND_VBO > 1 AND b.min_PND_STATUS = b.max_PND_STATUS THEN b.min_PND_STATUS::text
        WHEN b.AantalPND_VBO > 1 AND b.min_PND_STATUS <> b.max_PND_STATUS THEN 'Diverse_pandstatus'
        WHEN b.AantalPND_VBO IS NULL THEN NULL
        ELSE 'Geen_act_pand'
    END pandstatus,
    b.max_PND_ID as PND_ID,
    CASE
        WHEN b.AantalPND_VBO = 1 THEN b.min_bouwjaar::text
        WHEN b.AantalPND_VBO > 1 AND b.min_bouwjaar = b.max_bouwjaar THEN b.min_bouwjaar::text
        WHEN b.AantalPND_VBO > 1 AND b.min_bouwjaar <> b.max_bouwjaar THEN 'Diverse_bouwjaren'
        WHEN b.AantalPND_VBO IS NULL THEN NULL
        ELSE 'Geen_act_pand'
    END bouwjaar,
    b.max_bouwjaar,
    a.opp_adresseerbaarobject_m2,
    a.geopunt,
    coalesce(a.geovlak, c.geovlak) as geovlak,
    a.nad_id,
    a.nad_begin,
    case
        when b.AantalPND_VBO = 1 then b.min_begin
        when b.AantalPND_VBO > 1 AND b.min_begin = b.max_begin then b.max_begin
        when b.AantalPND_VBO > 1 AND b.min_begin <> b.max_begin then null
        when b.AantalPND_VBO is null then null
    end PND_begin,
    a.adresseerbaarobject_begin,
    a.OBR_ID,
    a.woonplaats_id,
    a.adresseerbaarobject_id,
    a.x,
    a.y,
    a.lon,
    a.lat,
    a.huisnummer,
    a.huisletter,
    a.huisnummertoevoeging,
    a.postcode
FROM adres_dubbel a
LEFT OUTER JOIN adres_pand1 b ON a.adresseerbaarobject_id = b.vbo_id
LEFT OUTER JOIN adres_pand2 c ON a.adresseerbaarobject_id = c.vbo_id
;
--20200530 Query returned successfully: 22112 rows affected, 413 msec execution time.

CREATE INDEX idx_adres_te_ontdubbelen_id ON adres_te_ontdubbelen USING btree(NAD_id);
COMMIT;

BEGIN;
-- Overzicht maken van de adressen die nog geen status verwijderen = 1
-- hebben en die zelfde uniq_key hebben als een ander adres
CREATE OR REPLACE VIEW adres_vergelijk AS
    SELECT
        a.uniq_key as 	  a_uniq_key,
        a.typeadresseerbaarobjectkort as 	  a_typeadresseerbaarobjectkort,
        b.typeadresseerbaarobjectkort as 	  b_typeadresseerbaarobjectkort,
        a.adresseerbaarobject_status as 	  a_adresseerbaarobject_status,
        b.adresseerbaarobject_status as 	  b_adresseerbaarobject_status,
        a.pandstatus as 	  a_pandstatus,
        b.pandstatus as 	  b_pandstatus,
        a.Pand_bestaand as a_Pand_bestaand,
        b.Pand_bestaand as b_Pand_bestaand,
        a.nad_id as 	  a_nad_id,
        b.nad_id as 	  b_nad_id,
        case
          when a.nad_id > b.nad_id then 'a'
          else 'b'
        end NAD_ID_hoogst,
        case
          when a.adresseerbaarobject_id > b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'a'
          when a.adresseerbaarobject_id < b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'b'
          when a.adresseerbaarobject_id = b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'zelfde'
        end AdrObj_ID_hoogst,
        case
            when a.pnd_id  = b.pnd_id  then 'zelfde_pnd'
            when a.pnd_id  < b.pnd_id  then 'b'
            when a.pnd_id  > b.pnd_id  then 'a'
            when a.pnd_id  = b.pnd_id then 'zelfde'
        end pand_ID_Hoogst,
        case
            when   a.nad_begin > b.nad_begin then 'a'
            when   a.nad_begin < b.nad_begin then 'b'
            when   a.nad_begin = b.nad_begin then 'gelijk'
        end NAD_recentst
    FROM adres_te_ontdubbelen a, adres_te_ontdubbelen b
    WHERE a.uniq_key = b.uniq_key
      AND a.nad_id <> b.nad_id
      AND a.verwijderen = 0
      AND b.verwijderen = 0;
--20200530 Query returned successfully: 22572 rows affected, 574 msec execution time.
COMMIT;

BEGIN;
-- Peter van Wee 20210129: maak een view die alleen de uniq_keys selecteert uit
-- adres_te_ontdubbelen die obv de kolom "verwijderen" nog mee genomen moeten worden in de ontdubbeling.
-- Dat zijn dus records waarvan de uniq_key meer dan 1x voorkomt
-- onder de conditie dat de kolom verwijdenen waarde 0 heeft
create or replace view adres_nog_te_ontdubbelen as
    Select uniq_key, count(*) as aantal
    from adres_te_ontdubbelen
    where verwijderen = 0
    group by uniq_key having count(*) > 1
;
COMMIT;

BEGIN;
-- verwijder records van uniq_key met een pand dat niet bestaat
-- indien uniq_key ook een pand heeft dat wel bestaat.
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk
    where a_Pand_bestaand = 0 and b_Pand_bestaand = 1
);
-- 20200530 Query returned successfully: 2999 rows affected, 115 msec execution time.
COMMIT;

BEGIN;
-- Verwijder record van uniq_key met laagste vbo_id
-- indien het een uniq_key is met het zelfde pand.
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk v
    inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key = nog.uniq_key
    where v.a_Pand_bestaand = v.b_Pand_bestaand
      and v.b_typeadresseerbaarobjectkort = 'VBO'
      and v.pand_ID_Hoogst = 'zelfde_pnd'
      and v.adrobj_id_hoogst = 'b'
);
-- 20200530 Query returned successfully: 5893 rows affected, 185 msec execution time.
COMMIT;

BEGIN;
-- Verwijder record van uniq_key met laagste pand_id indien de pandstatus gelijk is.
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk v
    inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key = nog.uniq_key
    where v.a_Pand_bestaand = v.b_Pand_bestaand
      and v.pand_ID_Hoogst = 'b'
);
-- 20200530 Query returned successfully: 1977 rows affected, 75 msec execution time.
COMMIT;

BEGIN;
-- Verwijder record van uniq_key met laagste nummeraanduiding_id
-- indien de status van het adresseerbare object en de pandstatus gelijk zijn.
-- (dus alleen van VBO's want de status van een STA en LIG zijn null en worden niet geevalueerd)
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk v
    inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key = nog.uniq_key
    where v.a_adresseerbaarobject_status = v.b_adresseerbaarobject_status
      and v.a_pandstatus = b_pandstatus
      and nad_id_hoogst = 'b'
);
-- 20200530 Query returned successfully: 804 rows affected, 53 msec execution time.
COMMIT;

BEGIN;
-- verwijder record van LIG of STA indien uniq_key ook een VBO heeft
-- met een pand een status heeft dat het bewoond kan zijn.
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk v
    inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key = nog.uniq_key
    where v.a_typeadresseerbaarobjectkort in ('LIG', 'STA')
      and v.b_typeadresseerbaarobjectkort = 'VBO'
      and v.b_pandstatus in ('Pand in gebruik (niet ingemeten)', 'Pand in gebruik', 'Sloopvergunning verleend', 'Verbouwing pand')
);
-- 20200530 Query returned successfully: 124 rows affected, 54 msec execution time.
COMMIT;

BEGIN;
-- verwijder record van uniq_key met VBO en een gekoppeld LIG of STA
-- indien het VBO met een pand heeft met een status dat het nog niet bewoond is.
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select a_nad_id from adres_vergelijk v
    inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key = nog.uniq_key
    where v.a_typeadresseerbaarobjectkort = 'VBO'
      and v.b_typeadresseerbaarobjectkort in ('LIG', 'STA')
      and v.a_pandstatus in ('Pand buiten gebruik', 'Bouwvergunning verleend', 'Bouw gestart')
);
-- 20200530 Query returned successfully: 119 rows affected, 40 msec execution
COMMIT;

BEGIN;
-- Peter van Wee 20210129 statement hieronder aangepast
-- het aantal nog te ontdubbelen records is nu zo gering dat we nu kiezen voor
-- een dummyproof aanpak door het record te verwijderen met het laagste adresseerbaarobjectid
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id in (
    select v.a_nad_id
    from adres_nog_te_ontdubbelen n
    INNER JOIN adres_vergelijk v on n.uniq_key = v.a_uniq_key
    where v.nad_recentst = 'b'
      or (v.nad_recentst = 'gelijk' and v.nad_id_hoogst = 'b')
);
-- 20200530 Query returned successfully: 10864 rows affected, 370 msec execution time.
COMMIT;

BEGIN;
-- 20220602 Tom Smeitink & Peter Saalbrink
-- Verwijder records waarbij NAD en VBO gelijk zijn,
-- maar VBO een nieuwere status heeft gekregen.
-- Dit is soms nodig voor het verwerken van mutaties
update adres_te_ontdubbelen
set Verwijderen = 1
where (nad_id, adresseerbaarobject_begin) in (
    select a.nad_id, a.adresseerbaarobject_begin
    from adres_te_ontdubbelen a
    inner join adres_te_ontdubbelen b on a.uniq_key = b.uniq_key and a.nad_id = b.nad_id
    where a.verwijderen = 0
      and a.adresseerbaarobject_begin < b.adresseerbaarobject_begin
);
COMMIT;

/*
check op aantal unieke uniq_key met en zonder Verwijderen:
Select count (distinct uniq_key) from adres_te_ontdubbelen ;--  9456
Select count (distinct uniq_key) from adres_te_ontdubbelen where verwijderen = 0;-- 9456
Select count (distinct nad_id) from adres_te_ontdubbelen where verwijderen = 0;  -- 9456
Select count (distinct nad_id) from adres_te_ontdubbelen where verwijderen = 1;  -- 9520
*/
BEGIN;
-- verwijder de records uit adresselectie die inmiddels
-- in adres_te_ontdubbelen het kenmerk verwijderen = 1 hebben.
delete from adresselectie
where nad_id in (
    Select nad_id
    from adres_te_ontdubbelen
    where verwijderen = 1
);
-- 20200530 Query returned successfully: 14005 rows affected, 4.1 secs execution time.
COMMIT;

BEGIN;
-- bepaal per adresserbaarobject (VBO STA LIG) het aantal NAD dat eraan
-- verbonden is. Deze later koppelen bij aanmaken adres-plus
DROP TABLE IF EXISTS adresseerbaarobject_aantal_nad cascade;
create table adresseerbaarobject_aantal_nad as
    select adresseerbaarobject_id, count(nad_id) as aantal
    from adresselectie
    group by adresseerbaarobject_id
;
--20200530 Query returned successfully: 9321129 rows affected, 01:39 minutes execution time.
COMMIT;

BEGIN;
CREATE INDEX idx_adresseerbaarobject_aantal_nad_id
    ON adresseerbaarobject_aantal_nad USING btree(adresseerbaarobject_id);
--20200530 Query returned successfully with no result in 14.2 secs.
COMMIT;

-- maak primary key aan. Indien foutmelding dan hiervoor issue oplossen.
ALTER TABLE adresselectie
  ADD CONSTRAINT uniq_key_adresselectie PRIMARY KEY (uniq_key);
-- 20200531 Query returned successfully with no result in 56.9 secs.

-------------------------------------------------
---- EINDE BLOK1 adresselectie blok------------------
-------------------------------------------------
