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

-- SET search_path TO bagactueel,public;
set statement_timeout to 50000000;

-- maak een functie die te gebruiken is om een bericht over betreffend statement te laten zien in bv PgAdmin message box.
CREATE OR REPLACE FUNCTION PRINT_NOTICE(msg text)
  RETURNS integer AS
$$
DECLARE
BEGIN
    RAISE NOTICE USING MESSAGE = msg;
    RETURN null;
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE;

-----------------------------------------------------
---- START BLOK1 Adresselectie blok------------------
-----------------------------------------------------
-- Stel vast van welke adressen we uiteindelijk een record willen hebben
-- Dat vullen we later aan meer meer gegevens van bv VBO en PND
BEGIN;
SELECT PRINT_NOTICE('start: 1 nummeraanduidingactueelbestaand_compleet: '||current_time);
-- Omdat NL extract adressen met postcode uitsluit in de view nummeraanduidingactueelbestaand maken we eerst een view inclusief de adressen zonder postcode
DROP VIEW IF EXISTS nummeraanduidingactueelbestaand_compleet cascade;
CREATE OR REPLACE VIEW nummeraanduidingactueelbestaand_compleet AS
Select
	NAD.gid,
	NAD.identificatie,
	NAD.aanduidingrecordinactief,
	NAD.voorkomenidentificatie,
	NAD.geconstateerd,
	-- NAD.inonderzoek,
	NAD.documentnummer,
	NAD.documentdatum,
	NAD.huisnummer,
	NAD.huisletter,
	NAD.huisnummertoevoeging,
	NAD.postcode,
	NAD.nummeraanduidingstatus,
	NAD.typeadresseerbaarobject,
	NAD.gerelateerdeopenbareruimte,
	NAD.gerelateerdewoonplaats,
	NAD.begindatumtijdvakgeldigheid,
	NAD.einddatumtijdvakgeldigheid
from nummeraanduiding NAD
inner join (
Select identificatie, max(begindatumtijdvakgeldigheid) as begindatumtijdvakgeldigheid from nummeraanduiding NAD
where     NAD.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (NAD.einddatumtijdvakgeldigheid is NULL OR NAD.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND NAD.aanduidingrecordinactief = FALSE
    and NAD.nummeraanduidingstatus <> 'Naamgeving ingetrokken'
    group by identificatie) M
    on NAD.identificatie=M.identificatie and NAD.begindatumtijdvakgeldigheid=m.begindatumtijdvakgeldigheid
    where NAD.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (NAD.einddatumtijdvakgeldigheid is NULL OR NAD.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND NAD.aanduidingrecordinactief = FALSE
    AND NAD.nummeraanduidingstatus <> 'Naamgeving ingetrokken';
COMMIT;



BEGIN;
--  In de view provincie_gemeenteactueebestaand ontbreken begin van het jaar de gemeentes die ophouden te bestaan op de eerste van het jaar. Als dit script gedraaid wordt begin januari gebaseerd op een postgis dump van december
-- dan ontbreken opeens die gemeentes. Om dat te voorkomen maak ik een view provincie_gemeenteactueel
SELECT PRINT_NOTICE('start: 2 provincie_gemeenteactueel: '||current_time);
DROP VIEW IF EXISTS provincie_gemeenteactueel cascade;
CREATE OR REPLACE VIEW provincie_gemeenteactueel as
select a.* from (
 SELECT
   -- 20210129: RANK functie vervangen door row_num
    pg.*,     row_number() OVER (PARTITION BY gemeentecode ORDER BY  pg.einddatum desc nulls first) as Rangorde
    FROM provincie_gemeente pg) A
   where Rangorde =1;
/*
--- Per woonplaats, gemeente en provincie een aantal gegevens vaststellen die we later voor adres gegevens.
--- de lon. lat bepalen adhv  gemiddelde per VBO. Dit omdat de centroid van een geovlak nog wel eens in de zee c.q. markermeer wil belanden.
-- eerst per woonplaatscode de locatie (lon , lat)vaststellen obv het "zwaartepunt" van de adresseerbare VBO in die woonplaats

  */
SELECT PRINT_NOTICE('start: 3 BAG_WPL_ACTBEST_gegevens: '||current_time);
DROP TABLE  IF EXISTS BAG_WPL_ACTBEST_gegevens cascade;
create table BAG_WPL_ACTBEST_gegevens as
SELECT
OBR.gerelateerdewoonplaats as woonplaats_id, WPL.woonplaatsnaam , GEM_WPL.gemeentecode as gemeente_id, PRV.gemeentenaam ,   PRV.provinciecode as provincie_id,   prv.provincienaam
--,
--ROUND(cast(avg(ST_x (ST_Transform (geopunt, 4326)))as numeric),3) as lon,
--ROUND(cast(avg(ST_y (ST_Transform (geopunt, 4326)))as numeric),3) as lat,
--count(*) as Aantal_VBO
FROM
  nummeraanduidingactueelbestaand NAD,
  openbareruimteactueelbestaand OBR,
  verblijfsobjectactueelbestaand VBO,
  gemeente_woonplaatsactueelbestaand GEM_WPL,
  provincie_gemeenteactueel  PRV,
  woonplaatsactueelbestaand WPL
WHERE
  NAD.gerelateerdeopenbareruimte = OBR.identificatie AND
  VBO.hoofdadres = NAD.identificatie and   prv.gemeentecode = gem_wpl.gemeentecode AND
  wpl.identificatie = gem_wpl.woonplaatscode and OBR.gerelateerdewoonplaats = wpl.identificatie
  group by     OBR.gerelateerdewoonplaats, WPL.woonplaatsnaam , GEM_WPL.gemeentecode , PRV.gemeentenaam ,   PRV.provinciecode ,   prv.provincienaam ;
COMMIT;
--20200530 Query returned successfully: 2500 rows affected, 02:27 minutes execution time.


BEGIN;
-- Hier maken we de initiele adrestabel. LAter worden records verwijderd om adressen uniek te krijgen
-- De actueelbestaand tabellen van NAD, OBR, WPL, LIG, STA en VBO joinen (= hoofdadressen)
-- en deze samenvoegen (union) met actueelbestaand tabellen van NEV, NAD,OBR, WPL, LIG, STA en VBO joinen (= nevenadressen)
SELECT PRINT_NOTICE('start: 4 Adresselectie: '||current_time);
DROP TABLE IF EXISTS  Adresselectie cascade;
create table Adresselectie as
-- Peter van Wee 210128 toegevvoegd distinct
SELECT distinct
coalesce(NAD.postcode,'0') ||'-'||NAD.huisnummer::text||'-'|| coalesce(NAD.huisletter, '0')||'-'|| coalesce(NAD.huisnummertoevoeging, '0') as PCHNHLHT,
coalesce(NAD.postcode,'0') ||'-'||NAD.huisnummer::text||'-'|| coalesce(NAD.huisletter, '0')||'-'|| coalesce(NAD.huisnummertoevoeging, '0')||'-'||  NAD.gerelateerdeopenbareruimte as uniq_key,
case when NAD.postcode is null then  null else 1 end pchn_UNIEK,
case when NAD.postcode is null then null else 1 end pchnhlht_UNIEK,
NAD.identificatie as NAD_ID,
OBR.openbareruimtenaam,
OBR.verkorteopenbareruimtenaam,
OBR.openbareruimtetype,
NAD.huisnummer,
NAD.huisletter,
NAD.huisnummertoevoeging,
NAD.postcode,
WPL.woonplaatsnaam,
WPL.woonplaats_id,
WPL.gemeentenaam,
WPL.gemeente_id,
WPL.provincienaam,
WPL.provincie_id,
0 as Nevenadres,
NAD.nummeraanduidingstatus,
NAD.typeadresseerbaarobject,
Case
when VBO.identificatie is not null then 'VBO'
when LIG.identificatie is not null then 'LIG'
when STA.identificatie is not null then 'STA'
end typeadresseerbaarobjectkort,
OBR.identificatie as OBR_ID,
NAD.begindatumtijdvakgeldigheid as NAD_BEGIN,
coalesce( VBO.begindatumtijdvakgeldigheid ,LIG.begindatumtijdvakgeldigheid, STA.begindatumtijdvakgeldigheid) as ADRESSEERBAAROBJECT_BEGIN,
-- coalesce( VBO.inonderzoek ,LIG.inonderzoek, STA.inonderzoek) as ADRESSEERBAAROBJECT_inonderzoek,
coalesce(VBO.identificatie ,   LIG.identificatie, STA.identificatie) as adresseerbaarobject_id,
Coalesce (  VBO.verblijfsobjectstatus::text,  LIG.ligplaatsstatus::text,   STA.standplaatsstatus::text) as adresseerbaarobject_status,
coalesce(round(cast(ST_Area(ST_Transform(sta.geovlak,28992) )as numeric),0),    round(cast(ST_Area(ST_Transform(lig.geovlak,28992) )as numeric),0),VBO.oppervlakteverblijfsobject) as opp_adresseerbaarobject_m2,
coalesce (  vbo.geopunt, ST_Centroid(lig.geovlak) ,ST_Centroid(sta.geovlak))   as geopunt,
coalesce (  lig.geovlak,sta.geovlak )   as geovlak,
ROUND(cast(coalesce ( ST_X(vbo.geopunt), ST_X(ST_Centroid(lig.geovlak)),ST_X(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision as X,
ROUND(cast(coalesce ( ST_Y(vbo.geopunt), ST_Y(ST_Centroid(lig.geovlak)),ST_Y(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision as Y,
ROUND(cast(coalesce ( ST_X(ST_Transform(vbo.geopunt, 4326)),ST_X(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_X(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision as lon,
ROUND(cast(coalesce ( ST_Y(ST_Transform(vbo.geopunt, 4326)),ST_Y(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_Y(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision as lat
FROM
nummeraanduidingactueelbestaand_compleet NAD
left outer join   verblijfsobjectactueelbestaand VBO
on    NAD.identificatie  =VBO.hoofdadres
left outer join  standplaatsactueelbestaand STA
on NAD.identificatie =  STA.hoofdadres
left outer join  ligplaatsactueelbestaand LIG
-- 20200606 vervangen
on NAD.identificatie = LIG.hoofdadres ,  BAG_WPL_ACTBEST_gegevens WPL,
  openbareruimteactueelbestaand OBR
WHERE
(VBO.hoofdadres is not null or   STA.hoofdadres is not null or   LIG.hoofdadres is not null)  and   coalesce(NAD.gerelateerdewoonplaats, OBR.gerelateerdewoonplaats) = WPL.woonplaats_id and
  NAD.gerelateerdeopenbareruimte = OBR.identificatie

union
-- De actueelbestaand tabellen van NEV< NAD, LIG, STA en VBO joinen (= nevenadressen)

-- Peter van Wee 210128 toegevvoegd distinct
SELECT distinct
coalesce(NAD.postcode,'0')||'-'||NAD.huisnummer::text||'-'|| coalesce(NAD.huisletter, '0')||'-'|| coalesce(NAD.huisnummertoevoeging, '0') as PCHNHLHT,
coalesce(NAD.postcode,'0') ||'-'||NAD.huisnummer::text||'-'|| coalesce(NAD.huisletter, '0')||'-'|| coalesce(NAD.huisnummertoevoeging, '0')|| '-'|| NAD.gerelateerdeopenbareruimte as uniq_key,
case when NAD.postcode is null then  null else 1 end pchn_UNIEK,
case when NAD.postcode is null then null else 1 end pchnhlht_UNIEK,
NAD.identificatie as NAD_ID,
OBR.openbareruimtenaam,
OBR.verkorteopenbareruimtenaam,
OBR.openbareruimtetype,
NAD.huisnummer,
NAD.huisletter,
NAD.huisnummertoevoeging,
NAD.postcode,
WPL.woonplaatsnaam,
WPL.woonplaats_id,
WPL.gemeentenaam,
WPL.gemeente_id,
WPL.provincienaam,
WPL.provincie_id,
1 as Nevenadres,
NAD.nummeraanduidingstatus,
NAD.typeadresseerbaarobject,
Case
when VBO.identificatie is not null then 'VBO'
when LIG.identificatie is not null then 'LIG'
when STA.identificatie is not null then 'STA'
end typeadresseerbaarobjectkort,
OBR.identificatie as OBR_ID,
NAD.begindatumtijdvakgeldigheid as NAD_BEGIN,
coalesce( VBO.begindatumtijdvakgeldigheid ,LIG.begindatumtijdvakgeldigheid, STA.begindatumtijdvakgeldigheid) as ADRESSEERBAAROBJECT_BEGIN,
-- coalesce( VBO.inonderzoek ,LIG.inonderzoek, STA.inonderzoek) as ADRESSEERBAAROBJECT_inonderzoek,
coalesce(VBO.identificatie ,   LIG.identificatie, STA.identificatie) as adresseerbaarobject_id,
Coalesce (  VBO.verblijfsobjectstatus::text,  LIG.ligplaatsstatus::text,   STA.standplaatsstatus::text) as adresseerbaarobject_status,
coalesce(round(cast(ST_Area(ST_Transform(sta.geovlak,28992) )as numeric),0),    round(cast(ST_Area(ST_Transform(lig.geovlak,28992) )as numeric),0),VBO.oppervlakteverblijfsobject) as opp_adresseerbaarobject_m2,
coalesce (  vbo.geopunt, ST_Centroid(lig.geovlak) , ST_Centroid(sta.geovlak))   as geopunt,
coalesce (  lig.geovlak,sta.geovlak )   as geovlak,
ROUND(cast(coalesce ( ST_X(vbo.geopunt), ST_X(ST_Centroid(lig.geovlak)),ST_X(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision as X,
ROUND(cast(coalesce ( ST_Y(vbo.geopunt), ST_Y(ST_Centroid(lig.geovlak)),ST_Y(ST_Centroid(sta.geovlak))) as numeric(9,3)), 3)::double precision as Y,
ROUND(cast(coalesce ( ST_X(ST_Transform(vbo.geopunt, 4326)),ST_X(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_X(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision as lon,
ROUND(cast(coalesce ( ST_Y(ST_Transform(vbo.geopunt, 4326)),ST_Y(ST_Transform(ST_Centroid(lig.geovlak), 4326)), ST_Y(ST_Transform(ST_Centroid(sta.geovlak), 4326))) as numeric), 8)::double precision as lat
FROM
adresseerbaarobjectnevenadresactueelbestaand NEV
inner join
nummeraanduidingactueelbestaand_compleet NAD
on nev.nevenadres=NAD.identificatie
left outer join   verblijfsobjectactueelbestaand VBO
on NEV.identificatie  =VBO.identificatie
left outer join  standplaatsactueelbestaand STA
on NEV.identificatie =  STA.identificatie
left outer join  ligplaatsactueelbestaand LIG
on NEV.identificatie = LIG.identificatie ,BAG_WPL_ACTBEST_gegevens WPL,
  openbareruimteactueelbestaand OBR
WHERE
(VBO.identificatie is not null or   STA.identificatie is not null or   LIG.identificatie is not null) and   coalesce(NAD.gerelateerdewoonplaats, OBR.gerelateerdewoonplaats) = WPL.woonplaats_id and
  NAD.gerelateerdeopenbareruimte = OBR.identificatie
;
--20200530 Query returned successfully: 9354464 rows affected, 05:46 minutes execution time.



CREATE INDEX idx_adresselectie_adrobj_id ON adresselectie USING btree(adresseerbaarobject_id);
CREATE INDEX idx_adresselectie_nad_id ON adresselectie USING btree(nad_id);
CREATE INDEX idx_adresselectie_uniq_key ON adresselectie USING btree(uniq_key);

COMMIT;
-- 20200530 Query returned successfully with no result in 03:28 minutes.

/*
een nummeraanduidig mag slechts 1x voorkomen.
Check: Select nad_id, count(*) from Adresselectie  group by nad_id having count(*) > 1;
-- Dit resultaat (Adresselectie) zou idealiter unieke nummeraandudingen moeten hebben maar dat is niet altijd zo.
-- Helaas geen uniek combinaties van  openbareruimte_id, postcode, huisnummer, huisletter, huisnummertoevoeging en dus zullen we later moeten ontdubbelen
-- Peter van Wee 20210129. Helaas toch weer een nummeraanduiding die meer dan 1x voorkomt. Om dat op te lossen gaan we records verwijderen met het volgende statement
*/


SELECT PRINT_NOTICE('start: 4b Delete_dubbele nummeraanduidingen1 '||current_time);
delete from Adresselectie
--select * from Adresselectie
where (nad_id, adresseerbaarobject_id) in (
Select c.nad_id, c.adresseerbaarobject_id from
(
Select a.nad_id, a.adresseerbaarobject_id,   row_number() OVER (PARTITION BY  a.nad_id ORDER BY   a.adresseerbaarobject_id desc ) as Rang from Adresselectie a
inner join (
Select nad_id, count(*) from Adresselectie  group by nad_id having count(*) > 1) b on A.nad_id=b.nad_id
) c where c.rang <> 1
);


-- nu de adressen (uniq_key) ophalen waarvan de uniq_key meer dan 1x voorkomt
BEGIN;
SELECT PRINT_NOTICE('start: 5 adres_dubbel: '||current_time);
DROP TABLE IF EXISTS  adres_dubbel cascade;
create table adres_dubbel as
Select A.* , B.aantaldubbel from Adresselectie A
inner join
(
Select uniq_key, count(*) as aantaldubbel from Adresselectie
group by uniq_key
having count(*) > 1
) b
on A.uniq_key = B.uniq_key
order by uniq_key;
--- 20200530: Query returned successfully: 22112 rows affected, 03:02 minutes execution time.
COMMIT;


-- Als in  adres_dubbel  een record uniek is  behalve op de kolom ADRESSEERBAAROBJECT_inonderzoek  dan gaan we het record waar ADRESSEERBAAROBJECT_inonderzoek=f verwijderen.
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

-- Voor analyse doeleinden gaan we van de unieke VBO_ID's uit adres-dubbel records (indien VBO) de actuele pandstatus ophalen (dus niet actueelbestaand)
  SELECT PRINT_NOTICE('start: 6 adres_pand1: '||current_time);
DROP TABLE IF EXISTS  adres_pand1 cascade;
create table adres_pand1 as
SELECT
  VBO_PND.identificatie as VBO_ID,
  count(VBO_PND.gerelateerdpand) as AantalPND_VBO, max(VBO_PND.gerelateerdpand) as max_PND_ID, max(pnd.pandstatus) as max_PND_STATUS, min(pnd.pandstatus) as min_PND_STATUS,
  max(pnd.bouwjaar) as max_bouwjaar,  min(pnd.bouwjaar) as min_bouwjaar, max(pnd.begindatumtijdvakgeldigheid) as max_begin, min(pnd.begindatumtijdvakgeldigheid) as min_begin,

max(case
when pnd.pandstatus in (  'Pand buiten gebruik','Sloopvergunning verleend','Pand in gebruik','Pand in gebruik (niet ingemeten)','Bouw gestart', 'Verbouwing pand') then 1
when pnd.pandstatus in (  'Niet gerealiseerd pand','Pand gesloopt','Bouwvergunning verleend', 'Pand ten onrechte opgevoerd') then 0
else  -1 end) as Pand_bestaand
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
SELECT PRINT_NOTICE('start: 7 adres_pand2: '||current_time);
DROP TABLE IF EXISTS  adres_pand2 cascade;
create table adres_pand2 as
Select pnd.geovlak, a.VBO_ID , a.max_PND_ID from adres_pand1 A
inner join pandactueel PND on a.max_PND_ID = pnd.identificatie;
--202005 Query returned successfully: 21590 rows affected, 2.2 secs execution time.
COMMIT;

BEGIN;
--Vaststellen tabel met te ontdubbelen uniq_key records
SELECT PRINT_NOTICE('start: 8 adres_te_ontdubbelen: '||current_time);
 DROP TABLE IF EXISTS  adres_te_ontdubbelen cascade;
create table adres_te_ontdubbelen as
SELECT distinct
0 as Verwijderen,
0 as intersects,
  a.uniq_key,
  row_number() OVER (PARTITION BY a.uniq_key ORDER BY   a.nad_id desc ) as Rangorde_uniq_key,
  a.aantaldubbel,
  a.nevenadres,
  a.typeadresseerbaarobjectkort,
  a.nummeraanduidingstatus,
  a.adresseerbaarobject_status,
  b.AantalPND_VBO  as Aantal_verbonden_PND,
  b.Pand_bestaand,
  case
	when b.AantalPND_VBO = 1 then  b.min_PND_STATUS::text
	when b.AantalPND_VBO > 1 and  b.min_PND_STATUS  = b.max_PND_STATUS then b.min_PND_STATUS::text
	when b.AantalPND_VBO > 1 and   b.min_PND_STATUS  <> b.max_PND_STATUS  then 'Diverse_pandstatus'
	when  b.AantalPND_VBO  is null then null
	else 'Geen_act_pand' end pandstatus,
 b.max_PND_ID as PND_ID,
  case
	when b.AantalPND_VBO = 1 then  b.min_bouwjaar::text
	when b.AantalPND_VBO > 1 and  b.min_bouwjaar  = b.max_bouwjaar then b.min_bouwjaar::text
	when b.AantalPND_VBO > 1 and   b.min_bouwjaar  <> b.max_bouwjaar  then 'Diverse_bouwjaren'
	when  b.AantalPND_VBO  is null then null
	else 'Geen_act_pand' end bouwjaar,
  b.max_bouwjaar,
  a.opp_adresseerbaarobject_m2,
  a.geopunt,
  coalesce(a.geovlak, c.geovlak) as geovlak,
  a.nad_id,
  a.nad_begin,
    case
	when b.AantalPND_VBO = 1 then  b.min_begin
	when b.AantalPND_VBO > 1 and  b.min_begin  = b.max_begin then b.max_begin
	when b.AantalPND_VBO > 1 and   b.min_begin  <> b.max_begin  then null
	when  b.AantalPND_VBO  is null then null
	else null end PND_begin,
  a.adresseerbaarobject_begin,
  a.OBR_ID,
  a.woonplaats_id,
  a.adresseerbaarobject_id,
  -- a.adresseerbaarobject_inonderzoek,
  a.x,
  a.y,
  a.lon,
  a.lat,
  a.huisnummer,
  a.huisletter,
  a.huisnummertoevoeging,
  a.postcode
FROM
  adres_dubbel a
left outer join adres_pand1  b
on A.adresseerbaarobject_id = B.VBO_ID
left outer join adres_pand2  C
on A.adresseerbaarobject_id = C.VBO_ID;
--20200530 Query returned successfully: 22112 rows affected, 413 msec execution time.

CREATE INDEX idx_adres_te_ontdubbelen_id ON adres_te_ontdubbelen USING btree(NAD_id);
COMMIT;


BEGIN;
-- Toevoegen om evt. te kijken of geometrien van zelfde uniq_key overlappen. Indien dan zorgen dat er maximaal 1 overblijft

update adres_te_ontdubbelen
set intersects = 1 where NAD_ID in
(
SELECT  distinct
  a.nad_id
FROM
  adres_te_ontdubbelen a,
  adres_te_ontdubbelen b
WHERE
  b.uniq_key = a.uniq_key  and st_intersects(a.geovlak, b.geovlak) = TRUE AND A.NAD_ID <>  B.NAD_ID);
-- 202005 Query returned successfully: 18003 rows affected, 4.4 secs execution time.
COMMIT;


BEGIN;
-- Overzicht maken van de adressen die nog geen status verwijderen = 1 hebben en die zelfde uniq_key hebben als een ander adres
SELECT PRINT_NOTICE('start: 9 adres_vergelijk: '||current_time);
 --DROP TABLE IF EXISTS  adres_vergelijk cascade;
CREATE or replace view adres_vergelijk AS
 SELECT
  a.uniq_key as 	  a_uniq_key,
  a.aantaldubbel as 	  a_aantaldubbel,
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
case when a.nad_id > b.nad_id then 'a' else 'b' end NAD_ID_hoogst,
  a.adresseerbaarobject_id as 	  a_adresseerbaarobject_id,
  b.adresseerbaarobject_id as 	  b_adresseerbaarobject_id,
--   a.adresseerbaarobject_inonderzoek as 	  a_adresseerbaarobject_inonderzoek,
--   b.adresseerbaarobject_inonderzoek as 	  b_adresseerbaarobject_inonderzoek,
  case when   a.adresseerbaarobject_id >   b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'a'
  when   a.adresseerbaarobject_id <   b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'b'
  when   a.adresseerbaarobject_id =   b.adresseerbaarobject_id and a.typeadresseerbaarobjectkort = b.typeadresseerbaarobjectkort then 'zelfde'
  else null end AdrObj_ID_hoogst,
  a.pnd_id as A_pnd_id,
  b.pnd_id as b_pnd_id,
  case when a.pnd_id  = b.pnd_id  then 'zelfde_pnd'
  when a.pnd_id  < b.pnd_id  then 'b'
  when a.pnd_id  > b.pnd_id  then 'a'
  when a.pnd_id  = b.pnd_id then 'zelfde'
  else null end pand_ID_Hoogst,
  a.adresseerbaarobject_begin as 	  a_adresseerbaarobject_begin,
  b.adresseerbaarobject_begin as 	  b_adresseerbaarobject_begin,
  a.pnd_begin as 	  a_pnd_begin,
  b.pnd_begin as 	  b_pnd_begin,
  a.verwijderen as 	  a_verwijderen,
  b.verwijderen as 	  b_verwijderen,
  a.intersects as 	  a_intersects,
  b.intersects as 	  b_intersects,
  a.nevenadres as 	  a_nevenadres,
  b.nevenadres as 	  b_nevenadres,
  a.nummeraanduidingstatus as 	  a_nummeraanduidingstatus,
  b.nummeraanduidingstatus as 	  b_nummeraanduidingstatus,
  a.aantal_verbonden_pnd as 	  a_aantal_verbonden_pnd,
  b.aantal_verbonden_pnd as 	  b_aantal_verbonden_pnd,
  a.bouwjaar as 	  a_bouwjaar,
  b.bouwjaar as 	  b_bouwjaar,
  a.max_bouwjaar as 	  a_max_bouwjaar,
  b.max_bouwjaar as 	  b_max_bouwjaar,
  a.opp_adresseerbaarobject_m2 as 	  a_opp_adresseerbaarobject_m2,
  b.opp_adresseerbaarobject_m2 as 	  b_opp_adresseerbaarobject_m2,
  a.geopunt as 	  a_geopunt,
  b.geopunt as 	  b_geopunt,
  a.geovlak as 	  a_geovlak,
  b.geovlak as 	  b_geovlak,
  a.nad_begin as 	  a_nad_begin,
  b.nad_begin as 	  b_nad_begin,
  case when   a.nad_begin > b.nad_begin then 'a'
  when   a.nad_begin < b.nad_begin then 'b'
  when   a.nad_begin = b.nad_begin then 'gelijk'
  else null end NAD_recentst,
  case when   a.pnd_begin > b.pnd_begin then 'a'
  when   a.pnd_begin < b.pnd_begin then 'b'
  when   a.pnd_begin = b.pnd_begin then 'gelijk'
  else null end PND_recentst,
  case when   a.adresseerbaarobject_begin > b.adresseerbaarobject_begin then 'a'
  when   a.adresseerbaarobject_begin < b.adresseerbaarobject_begin then 'b'
  when   a.adresseerbaarobject_begin = b.adresseerbaarobject_begin then 'gelijk'
  else null end adresseerbaarobject_recentst,
  a.OBR_ID as 	  a_OBR_ID,
  b.OBR_ID as 	  b_OBR_ID,
  a.woonplaats_id as a_woonplaats_id,
  b.woonplaats_id as 	  b_woonplaats_id,
  a.x as 	  a_x,
  b.x as 	  b_x,
  a.y as 	  a_y,
  b.y as 	  b_y,
  a.lon as 	  a_lon,
  b.lon as 	  b_lon,
  a.lat as 	  a_lat,
  b.lat as 	  b_lat,
  a.huisnummer as 	  a_huisnummer,
  b.huisnummer as 	  b_huisnummer,
  a.huisletter as 	  a_huisletter,
  b.huisletter as 	  b_huisletter,
  a.huisnummertoevoeging as 	  a_huisnummertoevoeging,
  b.huisnummertoevoeging as 	  b_huisnummertoevoeging,
  a.postcode	  a_postcode,
  b.postcode	  b_postcode,
  b.uniq_key as 	  b_uniq_key,
  b.aantaldubbel as 	  b_aantaldubbel
  FROM adres_te_ontdubbelen a,
  adres_te_ontdubbelen b
  WHERE a.uniq_key = b.uniq_key AND a.nad_id <> b.nad_id AND a.verwijderen = 0 AND b.verwijderen = 0;
--20200530 Query returned successfully: 22572 rows affected, 574 msec execution time.
COMMIT;


BEGIN;
--Peter van Wee 20210129: maak een view die alleen de uniq_keys selecteert uit adres_te_ontdubbelen die obv de kolom "verwijderen" nog mee genomen moeten worden in de ontdubbeling
--dat zijn dus records waarvan de uniq_key meer dan 1x voorkomt onder de conditie dat de kolom verwijdenen waarde 0 heeft
create or replace view adres_nog_te_ontdubbelen as
Select uniq_key,  count(*) as aantal from adres_te_ontdubbelen where verwijderen = 0 group by uniq_key having count(*) > 1
;

COMMIT;



BEGIN;
-- update adres_te_ontdubbelen
-- verwijder records van uniq_key met een pand dat niet bestaat indien uniq_key ook een pand heeft dat wel bestaat.
SELECT PRINT_NOTICE('start: 10 Update_1 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk
where
  (
  ( a_Pand_bestaand = 0 and  b_Pand_bestaand = 1)
  )
) ;
-- 20200530 Query returned successfully: 2999 rows affected, 115 msec execution time.
COMMIT;

BEGIN;
-- update
-- Verwijder record van uniq_key met laagste VBO_id indien het een uniq_key is met het zelfde pand.
SELECT PRINT_NOTICE('start: 11 Update_2 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk v inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key  = nog.uniq_key
where
  v.a_Pand_bestaand =  v.b_Pand_bestaand  and  v.b_typeadresseerbaarobjectkort='VBO' and  v.pand_ID_Hoogst = 'zelfde_pnd' and v.adrobj_id_hoogst = 'b'
) ;
-- 20200530 Query returned successfully: 5893 rows affected, 185 msec execution time.
COMMIT;

BEGIN;
-- update
-- Verwijder record van uniq_key met laagste pand_id indien de pandstatus gelijk is.
SELECT PRINT_NOTICE('start: 12 Update_3 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk v inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key  = nog.uniq_key
where
  (
   (v.a_Pand_bestaand =  v.b_Pand_bestaand  and v.pand_ID_Hoogst = 'b' )
  )
) ;

-- 20200530 Query returned successfully: 1977 rows affected, 75 msec execution time.
COMMIT;
BEGIN;

-- update
-- Verwijder record van uniq_key met laagste nummeraanduding_id  indien de status van het adresseerbare object  en de pandstatus gelijk zijn. (dus alleen van VBO's want de status van een STA en LIG zijn null en worden niet geevalueerd) )
SELECT PRINT_NOTICE('start: 13 Update_4 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk v inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key  = nog.uniq_key
where
  (
   (v.a_adresseerbaarobject_status=v.b_adresseerbaarobject_status and v.a_pandstatus=b_pandstatus and nad_id_hoogst = 'b')
  )
) ;
-- 20200530 Query returned successfully: 804 rows affected, 53 msec execution time.
COMMIT;
BEGIN;
--update
-- verwijder record van LIG of STA indien uniq_key ook een VBO heeft met een pand een status heeft dat het bewoond kan zijn.
SELECT PRINT_NOTICE('start: 14 Update_5 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk v inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key  = nog.uniq_key
where
  (
   (v.a_typeadresseerbaarobjectkort in ('LIG','STA') and v.b_typeadresseerbaarobjectkort='VBO' and v.b_pandstatus in ('Pand in gebruik (niet ingemeten)','Pand in gebruik', 'Sloopvergunning verleend', 'Verbouwing pand'))
  )
) ;
-- 20200530 Query returned successfully: 124 rows affected, 54 msec execution time.


COMMIT;
BEGIN;
--update
-- verwijder record van uniq_key met VBO en een gekoppeld LIG of STA indien het VBO  met een pand heeft met een statua dat het noig niet bewoond is.
SELECT PRINT_NOTICE('start: 15 Update_6 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where nad_id
in(
select distinct a_nad_id from adres_vergelijk v inner join adres_nog_te_ontdubbelen nog on v.a_uniq_key  = nog.uniq_key
where
  (
  ( v.a_typeadresseerbaarobjectkort='VBO' and v.b_typeadresseerbaarobjectkort in ('LIG','STA') and v.a_pandstatus in ('Pand buiten gebruik','Bouwvergunning verleend' , 'Bouw gestart'))
  )
) ;
-- 20200530 Query returned successfully: 119 rows affected, 40 msec execution

COMMIT;
-- Peter van Wee 20210129 statement hieronder aangepast
BEGIN;
-- het aantal nog te ondubellen records is nu zo gering dat we nu kiezen voor een dummyproof aanpak door het record te verwijderen met het  laagste adresseerbaarobject nr.
SELECT PRINT_NOTICE('start: 16 Update_7 '||current_time);
update adres_te_ontdubbelen
set Verwijderen = 1
where (nad_id,rangorde_uniq_key)
in(
select o.nad_id, o.rangorde_uniq_key  from adres_nog_te_ontdubbelen N
inner join adres_te_ontdubbelen o on n.uniq_key= o.uniq_key
left join (
select o.uniq_key, min(rangorde_uniq_key) as rangorde from adres_nog_te_ontdubbelen N
inner join adres_te_ontdubbelen o on n.uniq_key= o.uniq_key
group by o.uniq_key
) M on o.uniq_key=m.uniq_key
where o.rangorde_uniq_key <> m.rangorde
) ;

-- 20200530 Query returned successfully: 10864 rows affected, 370 msec execution time.

COMMIT;
BEGIN;

/*
-- check op aantal unieke uniq_key met en zonder Verwijderen

Select count (distinct uniq_key) from adres_te_ontdubbelen ;--  9456
Select count (distinct uniq_key) from adres_te_ontdubbelen where verwijderen = 0;-- 9456
Select count (distinct nad_id) from adres_te_ontdubbelen where verwijderen = 0;  -- 9456
Select count (distinct nad_id) from adres_te_ontdubbelen where verwijderen = 1;  -- 9520
*/

-- verwijdere de records uit Adresselectie  die inmiddels in adres_te_ontdubbelen het kenmerk verwijderen = 1 hebben.
SELECT PRINT_NOTICE('start: 17 Delete_1 '||current_time);
delete from Adresselectie
--select * from Adresselectie
where nad_id in (
Select  nad_id from adres_te_ontdubbelen where verwijderen = 1
);

-- 20200530 Query returned successfully: 14005 rows affected, 4.1 secs execution time.

COMMIT;
BEGIN;
-- het komt voor dat er meerdere records zijn met de zelfde combinatie van postcode, huisnummer, huisletter en huisnummertoeveoging. Die gaan we nu earmarken.
SELECT PRINT_NOTICE('start: 18 Update_8 '||current_time);
update Adresselectie
set pchnhlht_UNIEK = 0 where pchnhlht in (
select pchnhlht  from Adresselectie  where postcode is not null group by pchnhlht having count(*) > 1);
--20200530 Query returned successfully: 62 rows affected, 01:38 minutes execution time.
COMMIT;
BEGIN;


-- het komt veel voor dat de combinatie postcode, huisnummer niet uniek is  Die gaan we nu earmarken.
SELECT PRINT_NOTICE('start: 19 Update_9 '||current_time);
update Adresselectie
set pchn_UNIEK = 0 where ( postcode, huisnummer )in (
select postcode, huisnummer from Adresselectie  where postcode is not null group by postcode, huisnummer having count(*) > 1);
--20200531 Query returned successfully: 1910580 rows affected, 04:12 minutes execution time.
COMMIT;

-- bepaal per adresserbaarobject (VBO STA LIG) het aantal NAD dat er aan verbonden is. Deze later koppelen bij aanmaken adres -plus
BEGIN;
SELECT PRINT_NOTICE('start: 20 ADRESSEERBAAROBJECT_aantal_NAD '||current_time);
 DROP TABLE IF EXISTS  ADRESSEERBAAROBJECT_aantal_NAD cascade;
create table ADRESSEERBAAROBJECT_aantal_NAD  as
select adresseerbaarobject_id, count(nad_id) as aantal from  Adresselectie  group by adresseerbaarobject_id;
--20200530 Query returned successfully: 9321129 rows affected, 01:39 minutes execution time.
COMMIT;

BEGIN;
CREATE INDEX idx_ADRESSEERBAAROBJECT_aantal_NAD_id ON ADRESSEERBAAROBJECT_aantal_NAD USING btree(adresseerbaarobject_id);
--20200530 Query returned successfully with no result in 14.2 secs.
COMMIT;



-- maak primary key aan. Indien foutmelding dan hiervoor issue oplossen.
ALTER TABLE Adresselectie
  ADD CONSTRAINT  uniq_key_Adresselectie  PRIMARY KEY (uniq_key);
-- 20200531 Query returned successfully with no result in 56.9 secs.

-------------------------------------------------
---- EINDE BLOK1 Adresselectie blok------------------
-------------------------------------------------

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--  START BLOK2  waarbij het gebruiksdoel wordt ge-pivot. Dus per VBO 1 regele met alle gebruiksdoelen er achtern
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- Hiervoor is van belang dat de tablefunc (1 malig ) is gedefinieerd
-- CREATE extension tablefunc;



BEGIN;
  SELECT PRINT_NOTICE('start: 22 verblijfsobjectgebruiksdoelactueelbestaand_PIVOT: '||current_time);
DROP TABLE IF EXISTS  verblijfsobjectgebruiksdoelactueelbestaand_PIVOT;
create table verblijfsobjectgebruiksdoelactueelbestaand_PIVOT as
select VBO_ID,
coalesce(woonfunctie,0) as woonfunctie ,
coalesce(bijeenkomstfunctie,0) as bijeenkomstfunctie ,
coalesce(celfunctie,0) as celfunctie ,
coalesce(gezondheidszorgfunctie,0) as gezondheidszorgfunctie ,
coalesce(industriefunctie,0) as industriefunctie ,
coalesce(kantoorfunctie,0) as kantoorfunctie ,
coalesce(logiesfunctie,0) as logiesfunctie ,
coalesce(onderwijsfunctie,0) as onderwijsfunctie ,
coalesce(sportfunctie,0) as sportfunctie ,
coalesce(winkelfunctie,0) as winkelfunctie ,
coalesce(overige_gebruiksfunctie,0) as overige_gebruiksfunctie
from crosstab (
  'SELECT
  VBOGBD.identificatie as VBO_ID,   VBOGBD.gebruiksdoelverblijfsobject, 1 as Aantal
FROM
  verblijfsobjectgebruiksdoelactueelbestaand VBOGBD
  group by   VBOGBD.identificatie ,   VBOGBD.gebruiksdoelverblijfsobject
 ',

  'select distinct gebruiksdoelverblijfsobject from   verblijfsobjectgebruiksdoelactueelbestaand order by 1'
 )
 AS (
   VBO_ID character varying,

"woonfunctie"  integer,
"bijeenkomstfunctie" integer,
"celfunctie" integer,
"gezondheidszorgfunctie" integer,
"industriefunctie" integer,
"kantoorfunctie" integer,
"logiesfunctie" integer,
"onderwijsfunctie" integer,
"sportfunctie" integer,
"winkelfunctie" integer,
"overige_gebruiksfunctie" integer
 ) ;
-- 20200531 Query returned successfully: 9295812 rows affected, 01:13 minutes execution time.



-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE verblijfsobjectgebruiksdoelactueelbestaand_PIVOT
  ADD CONSTRAINT  PK_VBO_GBD_PIVOT_VBO  PRIMARY KEY (VBO_ID);
COMMIT;
--20200531 Query returned successfully with no result in 13.6 secs.

/*



----------------------------------------------------------------------------------------------------------------
--  EINDE BLOK2  waarbij het gebruiksdoel wordt ge-pivot. Dus per VBO 1 regele met alle gebruiksdoelen er achtern
----------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------
--- START BLOK3 Woningtype vaststellen per PND, NAD en VBO.
----------------------------------------------------------------------------------------------------------------

Woningtype vaststellen per PND,  VBO.
Restultaat zijn de tabellen:

pandactueelbestaand_plus_woningtype
VBO_woningtype_ontdubbeld


Hier een aantal statements om gegevens vast te stellen van NAD, VBO en PND die betrekking hebben op de woonfunctie.


Hiervoor geldt dat we alleen kijken naar adressen uit Adresselectie en actueel bestaand van alle relevante tabellen dus verblijfsobjectpandactueelbestaand en pandactueelbestaand
Omdat een verblijfsobject (VBO) altijd gekoppeld is aan een pand zijn er mogelijkheden om van een pand vast te stellen (indien het een woning is)  wat voor type woning het betreft
Denk aan hoekwoning, tussenwoning, vrijstaand etc. Methode van afleiden is gebaseerd op de wijze die het Kadaster ook hanteert
https://www.kadaster.nl/documents/20838/88047/Productbeschrijving+Woningtypering/a72e071a-e7af-4b93-aef2-a211de0f2056
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------




-- omdat adressen zijn vastgesteld obv actueelbestaand van NAD, (VBO< LIG,STA) kan het bij een VBO voorkomen dat het pand er nog niet is maar dat er al wel een vergunning is verleend.(bv nieuwbaouw)
-- van dergelijke adressen willen we wel gegevens van het pand zien (w.o.  status) . Daarom maken we eerst een tabel waarin ook de panden zijn opgenomen met een vergunning die verleend is.
-- deze tabel van alle "actuele" panden gaan we aanvullen met woninggegevens indien van toepassing.


*/
-- Query returned successfully with no result in 33.7 secs.
BEGIN;
SELECT PRINT_NOTICE('start: 23 pandactueelbestaand_plus '||current_time);
 DROP TABLE IF EXISTS  pandactueelbestaand_plus cascade;
CREATE table pandactueelbestaand_plus AS
 SELECT pand.gid,
	pand.identificatie,
	pand.aanduidingrecordinactief,
	pand.voorkomenidentificatie,
	pand.geconstateerd,
	-- pand.inonderzoek,
	pand.documentnummer,
	pand.documentdatum,
	pand.pandstatus,
	--  ik heb bouwjaren < 1000 bekeken en daar klopt er niet 1 van. Om de datumrange te verkleinen zet ik deze op 1000
	-- als bouwjaar te ver in de toekomst (bv 9999) dan aanpassen naar iets recenters (in de toekomst)
	case when pand.bouwjaar < 1000 then 1000 when pand.bouwjaar  > date_part('year', CURRENT_DATE) + 5  then  date_part('year', CURRENT_DATE) + 5  else pand.bouwjaar  end as bouwjaar,
	round(cast(ST_Area(ST_Transform(pand.geovlak,28992) )as numeric),0) as opp_pand,
	round(cast(ST_Perimeter(ST_Transform(pand.geovlak,28992) )as numeric),0) as Omtrek_Pand,
	pand.begindatumtijdvakgeldigheid,
	pand.einddatumtijdvakgeldigheid,
	pand.geovlak
   FROM pand
  WHERE pand.begindatumtijdvakgeldigheid <= 'now'::text::timestamp without time zone AND (pand.einddatumtijdvakgeldigheid IS NULL OR pand.einddatumtijdvakgeldigheid >= 'now'::text::timestamp without time zone) AND pand.aanduidingrecordinactief = false AND pand.geom_valid = true AND
  pand.pandstatus <> 'Niet gerealiseerd pand'::pandstatus AND pand.pandstatus <> 'Pand gesloopt'::pandstatus AND pand.pandstatus <> 'Pand ten onrechte opgevoerd'::pandstatus;
  --20200603 Query returned successfully: 10331821 rows affected, 01:14 minutes execution time.
COMMIT;


---20200531  toch maar geen index aanmaken. Kijken of dat sneller is.

BEGIN;
  CREATE INDEX idx_pandactueelbestaand_plus_id ON pandactueelbestaand_plus  USING btree(identificatie);
  --20200531 Query returned successfully with no result in 42.5 secs.;
COMMIT;


BEGIN;
CREATE INDEX idx_GEOM_pandactueelbestaand_plus_idl on pandactueelbestaand_plus  USING gist (geovlak);
---20200531 Query returned successfully with no result in 01:44 minutes.
COMMIT;



-- als een pand voorkomt met inonderzoek = f en ook t dan hier de F verwijderen
-- JvdB: kolom niet in BAG v2
-- BEGIN;
-- delete from pandactueelbestaand_plus D
-- where D.identificatie in (
--
-- select distinct identificatie from pandactueelbestaand_plus  group by   identificatie
--  having count(*) > 1  )
--
-- and  D.inonderzoek= 'f';
--
-- COMMIT;

/*
het komt voor dat een pand meer dan 1x voorkomt
--select identificatie, count(*) from  pandactueelbestaand_plus group by identificatie having count(*) >1;
om die reden gaan we zorgen dat alleen het recod overblijft met de hoogste begindatumtijdvakgeldigheid
--select * from pandactueelbestaand_plus  where identificatie = '0513100011124025';   -- komt helaas 2x voor dus
*/


BEGIN;
SELECT PRINT_NOTICE('start: 24 pandontdubbel'||current_time);
 DROP TABLE IF EXISTS  pandontdubbel cascade;
CREATE table pandontdubbel AS
Select 1 as te_verwijderen, pnd.* from pandactueelbestaand_plus pnd
inner join
(
select identificatie, count(*) from  pandactueelbestaand_plus group by identificatie having count(*) >1
) A on pnd.identificatie = A.identificatie;
-- 20200531 Query returned successfully: 0 rows affected, 10.0 secs execution time.
COMMIT;

-- select * from pandontdubbel;
BEGIN;
SELECT PRINT_NOTICE('start: 24b pandontdubbel update'||current_time);
update pandontdubbel  set te_verwijderen = 0
where (identificatie, begindatumtijdvakgeldigheid) in (
select identificatie, max(begindatumtijdvakgeldigheid) as begindatumtijdvakgeldigheid from pandontdubbel group by identificatie);
--20200531 Query returned successfully: 0 rows affected, 17 msec execution time.
COMMIT;


BEGIN;
delete from pandactueelbestaand_plus D
where D.gid in (select gid from pandontdubbel where te_verwijderen =1 );
--20200531 Query returned successfully: 0 rows affected, 38 msec execution time.
COMMIT;





-- nu hebben we een tabel met unieke panden maar dat zijn dus ook panden die geen woning zijn.
-- Nu gaan we van de combinatie NAD, VBO en PND met een woonfuntie een aantal tabellen maken die nodig zijn om woningtype per NAD vast te stellen



---20200523-- statement om vast te stellen bij welk pand met (woonfunctie)  de NAD (met woonfunctie) hoort. Meestal is dat helder maar soms hoort een NAD bij een VBO dat bij 2 panden hoort
-- daarom ook nog obv spacial query uitzoeken in welk pand het ligt.
-- deze tabel bevat dus NAD_ID, VBO_ID en PND_ID en een extra gegeven of het NAD "binnen" een pand valt.
-- Geen van de ID-s hoeft dus uniek te zijn maar bevat wel alle NAD_ID met een woonfunctie die gekoppeld zijn aan aan een pand (geen
BEGIN;
SELECT PRINT_NOTICE('start: 25 woning_NAD_VBO_PND: '||current_time);
DROP TABLE IF EXISTS  woning_NAD_VBO_PND cascade;
create table woning_NAD_VBO_PND as
SELECT
VBOPND.gerelateerdpand as PND_ID,
 ADR.NAD_ID,
 VBOPND.identificatie as VBO_ID,
 case when ST_Contains(PND.geovlak , ADR.geopunt) then 1 else 0 end as NAD_IN_PAND, pnd.documentdatum as pnd_documentdatum

FROM
  verblijfsobjectgebruiksdoelactueelbestaand VBOGBD,
  Adresselectie ADR,
  verblijfsobjectpandactueelbestaand VBOPND,
  pandactueelbestaand_plus PND
WHERE
  ADR.adresseerbaarobject_id = VBOGBD.identificatie AND
  ADR.adresseerbaarobject_id = VBOPND.identificatie  and  VBOPND.gerelateerdpand = pnd.identificatie and   VBOGBD.gebruiksdoelverblijfsobject = 'woonfunctie'
  -- and ST_Contains(PND.geovlak , ADR.geopunt) --deze voorwaarde niet toepassen want anders krijgen we niet de NAD behorend bij een pand waar het NAD niet in ligt
    ;
--20200531 Query returned successfully: 8114013 rows affected, 03:43 minutes execution time.
COMMIT;


BEGIN;
  CREATE INDEX idx_woning_NAD_VBO_PND_NAD ON woning_NAD_VBO_PND  USING btree(NAD_ID);
  --20200531 Query returned successfully with no result in 05:48 minutes.
COMMIT;


-- bepaal de van NAD met (via VBO ) woonfunctie wat gegevens
BEGIN;
SELECT PRINT_NOTICE('start: 26 woning_NAD_gegevens: '||current_time);
DROP TABLE IF EXISTS  woning_NAD_gegevens cascade;
create table woning_NAD_gegevens as
Select nad_id, count(distinct VBO_ID) as Woon_aantal_VBO_per_NAD, count(distinct PND_ID) as Woon_aantal_PND_per_NAD,
case when count(VBO_ID)= count(PND_ID) and count(PND_ID) = 1 then 1 else 0 end WOON_NAD_1_op_1_VBO_PND
from woning_NAD_VBO_PND group by nad_id;
--20200531 Query returned successfully: 8101004 rows affected, 01:26 minutes execution time.
COMMIT;


-- bepaal per VBO met woonfunctie wat gegevens
BEGIN;
SELECT PRINT_NOTICE('start: 27 woning_VBO_gegevens: '||current_time);
DROP TABLE IF EXISTS  woning_VBO_gegevens cascade;
create table woning_VBO_gegevens as
Select VBO_id, count(distinct NAD_ID) as Woon_aantal_NAD_per_VBO, count(distinct PND_ID) as Woon_aantal_PND_per_VBO,
case when count(NAD_ID)= count(PND_ID) and count(PND_ID) = 1 then 1 else 0 end WOON_VBO_1_op_1_NAD_PND
from woning_NAD_VBO_PND group by VBO_id;
--20200531 Query returned successfully: 8098663 rows affected, 01:26 minutes execution time.
COMMIT;


BEGIN;
SELECT PRINT_NOTICE('start: 28 woning_PND_Extra_gegevens: '||current_time);
DROP TABLE IF EXISTS  woning_PND_Extra_gegevens cascade;
create table woning_PND_Extra_gegevens as
Select
PND_id, count(distinct NAD_ID) as Woon_aantal_NAD_per_PND,
count(distinct VBO_ID) as Woon_aantal_VBO_per_PND,
case when count(NAD_ID)= count(VBO_ID) and count(VBO_ID) = 1 then 1 else 0 end WOON_PND_1_op_1_NAD_VBO
from woning_NAD_VBO_PND group by PND_id;
--20200603  Query returned successfully: 5556791 rows affected, 01:04 minutes execution time.
COMMIT;


BEGIN;
ALTER TABLE woning_PND_Extra_gegevens
  ADD CONSTRAINT  PAND_EXTRA_ID  PRIMARY KEY (PND_ID);
COMMIT;


-- Woning NAD PND combinaties
BEGIN;
SELECT PRINT_NOTICE('start: 29 woning_NAD_PND_gegevens1: '||current_time);
DROP TABLE IF EXISTS  woning_NAD_PND_gegevens1 cascade;
create table woning_NAD_PND_gegevens1 as
Select  nad_id, PND_ID , max(nad_in_pand) as nad_in_pand, max(PND_documentdatum) as PND_documentdatum
from woning_NAD_VBO_PND
group by nad_id, PND_ID ;
--20200531 Query returned successfully: 8114013 rows affected, 01:06 minutes execution time.

-- Woning VBO_PND combinaties
SELECT PRINT_NOTICE('start: 30 woning_VBO_PND_gegevens: '||current_time);
DROP TABLE IF EXISTS  woning_VBO_PND_gegevens cascade;
create table woning_VBO_PND_gegevens as
Select  VBO_id, PND_ID , max(nad_in_pand) as nad_in_pand
from woning_NAD_VBO_PND
group by VBO_id, PND_ID;
-- Query returned successfully: 8111423 rows affected, 01:05 minutes execution time.
COMMIT;

--- 20200523 toegevoegd unieke panden met woonfunctie
--- 20200529  deze zou weg kunnen en daar waar PND_WOON gebrukt wordt kan ik pandactueelbestaand_plus gebruiken


-- bepaal met een spacial query van alle woon-panden aan welke ander woon-pand het verbonden is (30cm). Dit is minimaal 1 omdat dit het eigen pand is.
-- de 30cm is uiteraard arbitrair maar gekozen omdat de BAG niet altijd even nauwkeurig is.
BEGIN;
 SELECT PRINT_NOTICE('start: 31 PND_WOON_RELATIES: '||current_time);
 DROP TABLE IF EXISTS  PND_WOON_RELATIES cascade;
create table PND_WOON_RELATIES as
SELECT
  PND1.identificatie as PND_ID1,
  PND2.identificatie as PND_ID2
FROM
  pandactueelbestaand_plus PND1, woning_PND_Extra_gegevens W1,woning_PND_Extra_gegevens W2,
  pandactueelbestaand_plus PND2
WHERE
   ST_DWithin(pnd1.geovlak, pnd2.geovlak, 0.3) and pnd1.identificatie=w1.pnd_id and pnd2.identificatie=W2.pnd_id ;
   --20200603 Query returned successfully: 12638123 rows affected, 09:14 minutes execution time.
COMMIT;



BEGIN;
-- stel per pand met een woonfunctie vast hoeveel panden met woonfunctie er "vast" zitten aan dat pand.
SELECT PRINT_NOTICE('start: 32 PND_WOON_RELATIES_aantal: '||current_time);
 DROP TABLE IF EXISTS  PND_WOON_RELATIES_aantal cascade;
create table PND_WOON_RELATIES_aantal as
Select PND_ID1 , count(*) as aantal_gerelateerde_PND from PND_WOON_RELATIES
group by PND_ID1;
--20200531 Query returned successfully: 5556791 rows affected, 10.2 secs execution time.
COMMIT;

/*

Van alle panden gaan we gegevens ophalen maar tevens van de panden waar het mee verbonden is om verschil tussen hoekwoning en 2 onder 1 kap vast te kunnen stellen.
Een hoekwoning is verbonden met een pand dat zelf met 2 andere panden verbonden is. Een 2onder1kap is verbonden aan een pand dat slechts met 1 ander pand verbonden is.
*/

BEGIN;
-- stel per pand met een woonfunctie vast hoeveel panden met woonfunctie er "vast" zitten aan dat pand.
SELECT PRINT_NOTICE('start: 33 PND_WOON_type: '||current_time);
 DROP TABLE IF EXISTS  PND_WOON_type cascade;
create table PND_WOON_type as
select A.PND_ID, substring(A.woningtype,3,30) as woningtype
from
(
SELECT
PWR.pnd_id1 as PND_ID,

	min(
	case
	when AANTNAD.Woon_aantal_NAD_per_PND > 1 then 0
	when AANT1.aantal_gerelateerde_pnd = 1 then 1
	when AANT1.aantal_gerelateerde_pnd > 2 then 2
	when   PWR.pnd_id1 <>   PWR.pnd_id2 and AANT1.aantal_gerelateerde_pnd = 2  and  AANT2.aantal_gerelateerde_pnd = 2 then 3
	when  PWR.pnd_id1 <>   PWR.pnd_id2 and AANT1.aantal_gerelateerde_pnd = 2  and  AANT2.aantal_gerelateerde_pnd > 2 then 4
	else 5 end ) as woningcode,

	min( case when AANTNAD.Woon_aantal_NAD_per_PND > 1 then '0 Appartement'
	when AANT1.aantal_gerelateerde_pnd = 1 then '1 Vrijstaande woning'
	when AANT1.aantal_gerelateerde_pnd > 2 then '2 Tussen of geschakelde woning'
	when   PWR.pnd_id1 <>   PWR.pnd_id2 and AANT1.aantal_gerelateerde_pnd = 2  and  AANT2.aantal_gerelateerde_pnd = 2 then '3 Tweeonder1kap'
	when  PWR.pnd_id1 <>   PWR.pnd_id2 and AANT1.aantal_gerelateerde_pnd = 2  and  AANT2.aantal_gerelateerde_pnd > 2 then '4 Hoekwoning'
	else '5 onbekend' end ) as woningtype
FROM
  pnd_woon_relaties PWR, -- dit zijn alle woonpand-woonpand combinaties die spacial zijn verbonden. Dus minimaal 1 record per pand wegens verbonden met zichzelf
  pnd_woon_relaties_aantal AANT2, --- dit zijn het aantal panden waar een pand spacial mee verbonden is
  pnd_woon_relaties_aantal AANT1, --- dit zijn het aantal panden waar een pand spacial mee verbonden is
  woning_PND_Extra_gegevens AANTNAD  --- dit zijn het aantal NAD waar een pand mee verbonden is
WHERE
  PWR.pnd_id1 = AANT1.pnd_id1 AND
  PWR.pnd_id2 = AANT2.pnd_id1 and AANTNAD.pnd_id = PWR.pnd_id1
  group by   PWR.pnd_id1
)A;
--20200603 Query returned successfully: 5556791 rows affected, 02:11 minutes execution time.
COMMIT;




BEGIN;
ALTER TABLE PND_WOON_type
  ADD CONSTRAINT  PAND_ID  PRIMARY KEY (PND_ID);
COMMIT;

-- maak een tabel van alle actuele panden en vul die aan met kenmerken
BEGIN;
SELECT PRINT_NOTICE('start: 33b pandactueelbestaand_plus_woningtype '||current_time);
 DROP TABLE IF EXISTS  pandactueelbestaand_plus_woningtype cascade;
 create table pandactueelbestaand_plus_woningtype  as
 SELECT P.* ,
w.woningtype,
case when w.woningtype is not null then 1 else 0 end pand_is_woning,
E.Woon_aantal_NAD_per_PND,
E.Woon_aantal_VBO_per_PND,
E.WOON_PND_1_op_1_NAD_VBO
from pandactueelbestaand_plus p
left join PND_WOON_type W on p.identificatie  =w.pnd_id
left join woning_PND_Extra_gegevens E on E.pnd_id=p.identificatie;
COMMIT;


BEGIN;
  CREATE INDEX idx_pandactueelbestaand_plus_woningtypeid ON pandactueelbestaand_plus_woningtype  USING btree(identificatie);
  --20200531 Query returned successfully with no result in 42.5 secs.;
COMMIT;



-- vaststellen woningtype per VBO
-- Voor bijna alle VBO gaat dat gewoon goed omdat die aan 1 pand gerelateerd zijn. Daar waar een VBO aan meer dan 1 pand gerelateerd is en het woningtype van de panden is verschillend
-- kunnen we het niet vaststellen. De krijgt dan ook  '99 Verschillend' als VBO_woningtype


BEGIN;
SELECT PRINT_NOTICE('start: 34 VBO_woningtype: '||current_time);
DROP TABLE IF EXISTS  VBO_woningtype  cascade;
create table VBO_woningtype as
Select VBO.VBO_ID,
case when  min(woningtype) =  max(woningtype) then  max(woningtype) else max ( 'Verschillend')  end Woningtype, count(distinct VBO.PND_ID) as VBO_AANTAL_PANDWONING
From woning_VBO_PND_gegevens VBO , pandactueelbestaand_plus_woningtype PND_woningtype
where VBO.PND_ID = PND_woningtype.identificatie
group by VBO.VBO_ID
;
--20200531 Query returned successfully: 8098663 rows affected, 01:49 minutes execution time.
-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE VBO_woningtype
  ADD CONSTRAINT  PK_VBO_woningtype  PRIMARY KEY (VBO_ID);
--20200531 Query returned successfully with no result in 12.1 secs.

COMMIT;

--Nu gaan we proberen het aantal VBO met woningtype = 'Verschillend' te beperken en dat gaat lukken ;)
--Hoeveel adressen hebben Verschillend woningtype
--Select count(*) from adres_plus where woningtype = 'Verschillend';-- 3422
--select count(*) from VBO_woningtype  where Woningtype = '9 Verschillend'  -- 3422  en dat is logisch

-- bepaal van de VBO die als woningtpye 'Verschillend' hebben alle panden waar het bijbehorende NAD in ligt.
-- Als al die panden zelfde woningtype hebben zet dan dat woningtype als woningtype in tabel VBO_woningtype.
--Er blijven dan nog maar stuk of 40 VBO over waarvan niet vast te stellen is wat het woningtype is
BEGIN;
SELECT PRINT_NOTICE('start: 35 VBO_woningtype_ontdubbeld: '||current_time);
DROP TABLE IF EXISTS  VBO_woningtype_ontdubbeld  cascade;
create table VBO_woningtype_ontdubbeld  as
Select   vbo.vbo_id, min(x.pnd_id) as minpnd_id,
max(x.pnd_id) as maxpnd_id,
case when max(w.woningtype) = min(w.woningtype) then max(w.woningtype) else 'Verschillend' end as Ontdubbeld_woningtype,
min(w.woningtype) as min_woningtype, max(w.woningtype) as max_woningtype , count(*) as aantal from VBO_woningtype vbo inner join woning_NAD_VBO_PND X
inner join pandactueelbestaand_plus_woningtype W on x.pnd_id=w.identificatie
on X.vbo_id=vbo.VBO_id and vbo.Woningtype = 'Verschillend' and x.nad_in_pand = 1
group by vbo.vbo_id
order by count(*) desc
;
--20200531 Query returned successfully: 3422 rows affected, 3.4 secs execution time.
-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE VBO_woningtype_ontdubbeld
  ADD CONSTRAINT  PK_VBO_woningtype_ontdubbeld PRIMARY KEY (VBO_ID);
 --20200531 Query returned successfully with no result in 32 msec.
COMMIT;


BEGIN;
SELECT PRINT_NOTICE('start: 36 VBO_woningtype: '||current_time);
update VBO_woningtype
set woningtype = B.Ontdubbeld_woningtype from VBO_woningtype_ontdubbeld B
where VBO_woningtype.vbo_id=B.vbo_id
;
--20200531 Query returned successfully: 3422 rows affected, 348 msec execution time.
COMMIT;
/*


-- select VBO_woningtype.*, length( VBO_Woningtype) as lengte , right(VBO_Woningtype,length( VBO_Woningtype)-2)  as type  from VBO_woningtype limit 100
 -- select  VBO_Woningtype, count(*) as aantal from VBO_woningtype  group by VBO_Woningtype order by count(*) desc;

----------------------------------------------------------------------------------------------------------------
--- EINDE BLOK3 Woningtype vaststellen per PND en VBO.
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
--- START BLOK4 Per VBO een aantal gegevens vaststellen (dus niet alleen VBO met Woonfucntie maar allen)
----------------------------------------------------------------------------------------------------------------
Resultaat is de tabel "VBO_PANDGEGEVENS"

Nu we alle adressen te pakken hebben is het de bedoeling dat we die adressen van het type verblijfsobject (VBO) gaan verrijken met gegevens over het gerelateerde pand c.q. de gerelateerde panden.
Van deze panden willen we de oppervlakte weten  en daarnaast willen we weten of een VBO er 1 van de velen is die bij het zelfde pand behoren (bv appartementcomplex) of dat het een VBO is dat hangt
aan 1 pand waarvan dit VBO de enige is. (meeste huizen). Heel soms is 1 VBO gerealteerd aan meer dan 1 pand. Ook dat willen we weten. Om dit te kunnen moeten we wat tabellen/views voor bereiden


-------------------------------------------------------------------------------------------------------------
--- Bepaal per VBO ID (uit Adresselectie) het aantal verbonden panden dus ongeacht of de VBO een woonfunctie heeft
--- Basis hiervoor is de view verblijfsobjectpandactueelbestaand.  Omdat daarin records voor kunnen komen zonder gerelateerd
--- record in  verblijfsobjectactueelbestaand  en/of pandactueelbestaand  maken we daarmee ook een inner join.
--- we zien dus alleen resultaten als in zowel verblijfsobjectpandactueelbestaand als verblijfsobjectactueelbestaand als pandactueelbestaand_plus_woningtype een gerelateerd record zit
-------------------------------------------------------------------------------------------------------------

--
*/


-- haal uit de tabel verblijfsobjectpandactueelbestaand (=relatietabel tussen VBO en PAND) per VBO een aantal gegevens op en vul dat aan met Woningtype
BEGIN;
SELECT PRINT_NOTICE('start: 37a VBO_Actueelbestaand_met_aantal_verbonden_PND: '||current_time);
DROP TABLE   if exists VBO_Actueelbestaand_met_aantal_verbonden_PND cascade;
Create table VBO_Actueelbestaand_met_aantal_verbonden_PND as
SELECT
  VBO_PND.identificatie as VBO_ID,VBO.verblijfsobjectstatus, text 'VBO' as typeadresseerbaarobject  ,
  count(VBO_PND.gerelateerdpand) as AantalPND_VBO, max(VBO_PND.gerelateerdpand) as max_PND_ID, max(vbo.hoofdadres) as hoofdadres, max(VBO.oppervlakteverblijfsobject) as opp_verblijfsobject_m2
FROM
  verblijfsobjectpandactueelbestaand VBO_PND
  inner join verblijfsobjectactueelbestaand VBO on VBO_PND.identificatie = VBO.identificatie
   inner join (select distinct adresseerbaarobject_id from Adresselectie) ADR on VBO.identificatie = ADR.adresseerbaarobject_id
  left outer join pandactueelbestaand_plus_woningtype PND on VBO_PND.gerelateerdpand = PND.identificatie
  group by  VBO_PND.identificatie, vbo.hoofdadres, VBO.verblijfsobjectstatus;
--20200531: Query returned successfully: 9282292 rows affected, 04:59 minutes execution time.

CREATE INDEX VBO_Actueelbestaand_met_aantal_verbonden_PND_ID ON  VBO_Actueelbestaand_met_aantal_verbonden_PND USING btree (VBO_ID);
-- 20200531 Query returned successfully with no result in 13.5 secs.
COMMIT;


--- Bepaal per PND ID het aantal verbonden VBO's (uit Adresselectie) ongeacht of die VBO een woonfunctie heeft
BEGIN;
SELECT PRINT_NOTICE('start: 37b PND_Actueelbestaand_met_aantal_verbonden_VBO: '||current_time);
 DROP TABLE  if exists  PND_actueelbestaand_met_aantal_VBO cascade;
create table PND_actueelbestaand_met_aantal_VBO as
SELECT
  VBO_PND.gerelateerdpand as PND_ID,
  count(VBO_PND.identificatie) as AantalVBO_PND, max(VBO_PND.identificatie) as max_VBO_ID, sum(ADR.opp_adresseerbaarobject_m2) as Sum_Oppervlakte_alle_VBO_in_PAND
FROM
  verblijfsobjectpandactueelbestaand VBO_PND
 inner join Adresselectie ADR on VBO_PND.identificatie = ADR.adresseerbaarobject_id
 inner join pandactueelbestaand_plus_woningtype PND on VBO_PND.gerelateerdpand = PND.identificatie
 group by  VBO_PND.gerelateerdpand;
--20200531: Query returned successfully: 6323693 rows affected, 02:11 minutes execution time.

-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE PND_actueelbestaand_met_aantal_VBO
  ADD CONSTRAINT  PK_PND_actueelbestaand_met_aantal_VBO  PRIMARY KEY (PND_ID);
COMMIT;
--20200531:Query returned successfully with no result in 8.4 secs.


BEGIN;
  SELECT PRINT_NOTICE('start: 37c VBO_PANDGEGEVENS: '||current_time);
drop  table if exists  VBO_PANDGEGEVENS;
create table VBO_PANDGEGEVENS as
SELECT
	VBO.vbo_id,
	VBO.typeadresseerbaarobject,
	VBO.verblijfsobjectstatus,
	VBO.aantalpnd_vbo as Aantal_pand_relaties_dit_VBO,
	vbo.hoofdadres,
	vbo.opp_verblijfsobject_m2,
	VBO_WOON.woningtype as VBO_woningtype,
	PND_act.woningtype,
	case when VBO.aantalpnd_vbo = 1 then PND.pnd_id else  null end PND_ID_UNIEK,
	case when VBO.aantalpnd_vbo = 1 then  PND.aantalvbo_pnd else  null end aantal_vbo_relaties_dit_PND,
	case when VBO.aantalpnd_vbo = 1  and  PND.aantalvbo_pnd = 1 then  1 else  0 end VBO_PND_1_op_1,
	case when VBO.aantalpnd_vbo = 1  and  PND.aantalvbo_pnd = 1 then   PND.max_vbo_id else  null end VBO_ID_PND_VBO_1_op_1,
	case when VBO.aantalpnd_vbo = 1  then  pnd_act.opp_pand else null end as opp_pand,
	case when VBO.aantalpnd_vbo = 1  and pnd_act.opp_pand  >0 then  round(pnd.Sum_Oppervlakte_alle_VBO_in_PAND/pnd_act.opp_pand ,2) else null end Verhouding_OPP_VBO_OPP_PND,
	case when VBO.aantalpnd_vbo = 1  then  PND_ACT.Omtrek_Pand else null end Omtrek_Pand,
	case when VBO.aantalpnd_vbo = 1 THEN PND_ACT.pandstatus ELSE NULL END pandstatus ,
	case when VBO.aantalpnd_vbo = 1 then PND_ACT.bouwjaar else null end bouwjaar
FROM
	vbo_actueelbestaand_met_aantal_verbonden_pnd VBO
	left outer join   pnd_actueelbestaand_met_aantal_vbo PND on    VBO.max_pnd_id = PND.pnd_id
	left outer join   pandactueelbestaand_plus_woningtype PND_ACT on PND.pnd_id = PND_ACT.identificatie
	left outer join   vbo_woningtype VBO_WOON  on VBO_WOON.VBO_id =  VBO.vbo_id;
  --20200531: Query returned successfully: 9282292 rows affected, 01:15 minutes execution time.
COMMIT;


-- en een index hierop maken
BEGIN;
  SELECT PRINT_NOTICE('start: 38 VBO_Pandgegevens_VBO_ID: '||current_time);
CREATE INDEX VBO_Pandgegevens_VBO_ID ON  VBO_PANDGEGEVENS USING btree (vbo_id);
--20200531 Query returned successfully with no result in 51.7 secs.
COMMIT;

----------------------------------------------------------------------------------------------------------------
--- EINDE BLOK4 Per VBO een aantal gegevens vaststellen (dus niet allen VBO met Woonfucntie maar allen)
----------------------------------------------------------------------------------------------------------------


----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- START BLOK5 AANMAKEN TABEL adres_plus inclusief een paar aanpassingen
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- De adres tabel maken met een groot aantal gegevens. Tevens een rangorde per postcode huisnummer toevoegen om later een tabel/view te kunnen maken waar per PC/HN maar 1 record in zit. Dit ivm match externe adressen die niet de BAG conventie volgen.


BEGIN;
  SELECT PRINT_NOTICE('start: 39 adres_plus: '||current_time);
DROP TABLE IF EXISTS   adres_plus cascade;
create table adres_plus as
SELECT
  adres.openbareruimtenaam, adres.verkorteopenbareruimtenaam ,
  adres.obr_id as openbareruimte_id,
  adres.huisnummer,
  adres.huisletter,
  adres.huisnummertoevoeging,
  adres.postcode,
  adres.nad_id as nummeraanduiding_ID,
  adres.woonplaatsnaam,
  adres.woonplaats_id as woonplaatscode,
  adres.gemeentenaam,
  adres.gemeente_id as gemeentecode,
  adres.provincienaam,
  adres.provincie_id as provinciecode,
  adres.nevenadres,
  adres.typeadresseerbaarobject,
  adres.adresseerbaarobject_status,
  adres.opp_adresseerbaarobject_m2,
  ADR_NAD.aantal as aantal_NAD_per_Adresobject,
  adres.adresseerbaarobject_id,
  cast(adres.geopunt AS geometry(Point, 28992)),
  adres.x,
  adres.y,
  adres.lon,
  adres.lat,
  VBO_GBD.woonfunctie,
  VBO_GBD.bijeenkomstfunctie,
  VBO_GBD.celfunctie,
  VBO_GBD.gezondheidszorgfunctie,
  VBO_GBD.industriefunctie,
  VBO_GBD.kantoorfunctie,
  VBO_GBD.logiesfunctie,
  VBO_GBD.onderwijsfunctie,
  VBO_GBD.sportfunctie,
  VBO_GBD.winkelfunctie,
  VBO_GBD.overige_gebruiksfunctie,
  VBO_PND.aantal_pand_relaties_dit_vbo,
  VBO_PND.pnd_id_uniek as pand_id ,
  VBO_PND.aantal_vbo_relaties_dit_pnd,
  VBO_PND.vbo_pnd_1_op_1,
  VBO_PND.opp_pand,
  vbo_woningtype.Woningtype,
  VBO_PND.omtrek_pand,
  VBO_PND.Verhouding_OPP_VBO_OPP_PND,
  VBO_PND.pandstatus,
  VBO_PND.bouwjaar,
  adres.uniq_key,
  adres.pchnhlht,
  adres.pchnhlht_UNIEK,
  adres.pchn_UNIEK,
  -- de rangorder toevoegen zodat we later in de view "adres_compleet_PCHN_Uniek" per postcode/huisnummer slechts 1 record krijgen met rang 1. Idealiter zou de order by alleen op postcode, huisnummer, huisletter en huisnummertoevoeging moeten gaan maar omdat
  --  er een beperkt aantal adressen zijn waarbij deze 4 kolommen identiek zijn voeg ik nog een woonfunctie , openbareruimte_id toe zodat we maar 1 record (per PC HN ) op rang 1 krijgen
  -- 20210129: RANK functie vervangen door row_num
  row_number() OVER (PARTITION BY adres.postcode,adres.huisnummer ORDER BY  VBO_GBD.woonfunctie desc nulls last  , adres.huisletter nulls first, adres.huisnummertoevoeging nulls first,   adres.NAD_ID desc ) as Rangorde_PCHN
 FROM
  adresselectie ADRES
  --  voeg toe alle gebruiksdoelen aan het adres indien het een VBO betreft
  left outer join   verblijfsobjectgebruiksdoelactueelbestaand_pivot VBO_GBD on ADRES.adresseerbaarobject_id = VBO_GBD.vbo_id
  --  voeg toe alle pandgegevens aan het adres indien het een VBO betreft dat aan slechts 1 pand gekoppeld is
  left outer join   vbo_pandgegevens VBO_PND on ADRES.adresseerbaarobject_id = VBO_PND.vbo_id
  left outer join   vbo_woningtype  on vbo_woningtype.VBO_ID = ADRES.adresseerbaarobject_id
 left outer join ADRESSEERBAAROBJECT_aantal_NAD ADR_NAD on adres.adresseerbaarobject_id = ADR_NAD.adresseerbaarobject_id

  ;
  -- 20200604: Query returned successfully: 9340457 rows affected, 12:04 minutes execution time.
COMMIT;



-----------------------------------------------------------------------------------
-- START: optioneel een aantal gegevens aanpassen b.v. wegens vreemde invoer-------
-----------------------------------------------------------------------------------

--Een aantal bronhouders vult bij oppervlakte maar iets in. Bv 999999 (bij verblijfsobject gevormd) en terwijl er nog geen actueel pand is.


BEGIN;
  SELECT PRINT_NOTICE('start: 40 UPDATEN van adres_plus: '||current_time);
update adres_plus adres  set opp_adresseerbaarobject_m2 = 0
 where   adres.opp_adresseerbaarobject_m2 = 999999 and  adres.adresseerbaarobject_status = 'Verblijfsobject gevormd' and adres.pandstatus is null;
 --20200531 Query returned successfully: 0 rows affected, 4.0 secs execution time.


----------------------------------------------------------------------------
-- EINDE optioneel een aantal gegevens aanpassen b.v. wegens vreemde invoer-------
----------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- EINDE BLOK5 AANMAKEN TABEL adres_plus
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

/*
select count(*) from  adres_plus; "count" 9406967
select count(*) from  adresselectie;   "count" 9406967
*/
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



BEGIN;

--  eN nu alle tijdelijket tabellen/views verwijderen
drop view  IF EXISTS  adres_nog_te_ontdubbelen cascade;
DROP TABLE  IF EXISTS   BAG_WPL_ACTBEST_gegevens cascade;
DROP TABLE IF EXISTS    adresselectie  cascade ;
DROP TABLE IF EXISTS    adres_dubbel  cascade ;
DROP TABLE IF EXISTS    adres_pand1  cascade ;
DROP TABLE IF EXISTS    adres_pand2  cascade ;
DROP TABLE IF EXISTS    adres_te_ontdubbelen  cascade ;
DROP VIEW IF EXISTS    adres_vergelijk  cascade ;
DROP TABLE IF EXISTS    ADRESSEERBAAROBJECT_aantal_NAD  cascade ;
DROP TABLE IF EXISTS    woning_NAD_gegevens cascade;
DROP TABLE IF EXISTS    woning_VBO_gegevens cascade;
DROP TABLE IF EXISTS    woning_NAD_PND_gegevens1 cascade;
DROP TABLE IF EXISTS    woning_VBO_PND_gegevens cascade;
DROP TABLE IF EXISTS    pnd_woon_relaties  cascade ;
DROP TABLE IF EXISTS    pandontdubbel  cascade ;
DROP TABLE IF EXISTS    woning_nad_vbo_pnd  cascade ;
DROP TABLE IF EXISTS    pnd_woon_relaties_aantal  cascade ;
DROP TABLE IF EXISTS    vbo_woningtype  cascade ;
DROP TABLE IF EXISTS    verblijfsobjectgebruiksdoelactueelbestaand_pivot  cascade ;
DROP TABLE IF EXISTS    vbo_actueelbestaand_met_aantal_verbonden_pnd  cascade ;
DROP TABLE IF EXISTS    pnd_actueelbestaand_met_aantal_vbo  cascade ;
DROP TABLE IF EXISTS    vbo_pandgegevens  cascade ;
DROP TABLE IF EXISTS    pandactueelbestaand_plus  cascade;
DROP TABLE IF EXISTS    VBO_woningtype_ontdubbeld cascade;
DROP TABLE IF EXISTS    woning_PND_Extra_gegevens cascade;
DROP TABLE IF EXISTS    pnd_woon_type cascade;
COMMIT;
