-- gedoneerd door - marijn at - hippoline.nl - 15 juli 2014
-- doel script: een tabel met een samenvatting van de gebruiksdoelen die in 1 pand voorkomen.
--
-- "Ik ben er inmiddels in geslaagd de tabel grotendeels te reproduceren.
-- In mijn query heb ik overigens vanuit het pand geredeneerd; hier kunnen meerdere
-- verschillende gebruiksdoelen in zitten met daaraan meerdere verblijfsobjecten.
-- De oppervlakten en aantal vbo's worden per pand en per gebruiksdoel in een array
-- weergegeven. Op het moment dat een vbo meerdere gebruiksdoelen heeft kun je de
-- oppervlakte niet sommeren (bijv 100 m2 winkel en 100 m2 kantoor) en wordt deze 1 keer geteld.
-- De query is wellicht nog wat rommelig en kan nog geoptimaliseerd worden, maar
-- hij voldoet voor mij nu. Heb de query toegevoegd als bijlage als donatie en
-- inspiratie voor andere gebruikers hier."


--frisse start:

--benodigde data uit brontabellen
SELECT
  vp.gerelateerdpand             AS identificatie,
  v.identificatie                AS vbo_id,
  vg.gebruiksdoelverblijfsobject AS gebruiksdoelen,
  v.oppervlakteverblijfsobject   AS oppervlakte

INTO
  temp1

FROM
    verblijfsobjectgebruiksdoel AS vg,
    verblijfsobjectpand AS vp,
    verblijfsobject AS v,
    pand AS p

WHERE
  vg.identificatie = vp.identificatie
  AND
  vp.identificatie = v.identificatie
  AND
  vp.gerelateerdpand = p.identificatie

  --alleen bestaande panden etc
  AND
  v.einddatumtijdvakgeldigheid IS NULL
  AND
  (v.verblijfsobjectstatus = 'Verblijfsobject in gebruik' OR
   v.verblijfsobjectstatus = 'Verblijfsobject in gebruik (niet ingemeten)')
  AND
  vg.einddatumtijdvakgeldigheid IS NULL
  AND
  vp.einddatumtijdvakgeldigheid IS NULL
  AND
  (p.pandstatus = 'Pand in gebruik' OR p.pandstatus = 'Pand in gebruik (niet ingemeten)')
  AND
  p.geom_valid = TRUE
  AND
  p.einddatumtijdvakgeldigheid IS NULL

;


--distinct uit temp1 halen--

SELECT
  DISTINCT *
INTO temp2
FROM temp1
;

DROP TABLE temp1;

--aantal gebruiksdoelen per functie


SELECT
  DISTINCT
  identificatie,
  gebruiksdoelen,
  sum(oppervlakte)      AS totaal_oppervlakte,
  count(gebruiksdoelen) AS aantal_gebruiksdoelen

INTO
  temp3

FROM
  temp2

GROUP BY identificatie, gebruiksdoelen;


--oppervlakte per functie


SELECT
  identificatie,
  gebruiksdoelen,
  sum(oppervlakte) AS totaal_oppervlakte
INTO
  temp_functie
FROM
  temp2
GROUP BY identificatie, gebruiksdoelen;


--bij meerdere oppervlaktes per vbo: gemiddelde

SELECT
  identificatie,
  vbo_id,
  round(avg(oppervlakte)) AS oppervlakte_pervbo
INTO temp_totaalopp1
FROM temp2
GROUP BY identificatie, vbo_id
ORDER BY identificatie;

--sommering oppervlaktes van vbo's per pand

SELECT
  identificatie,
  round(sum(oppervlakte_pervbo)) AS oppervlakte_perpand
INTO temp_totaalopp2
FROM temp_totaalopp1
GROUP BY identificatie
ORDER BY identificatie;

DROP TABLE temp_totaalopp1;

--array sum functie
CREATE OR REPLACE FUNCTION array_sum(DOUBLE PRECISION [])
  RETURNS DOUBLE PRECISION AS $$
SELECT
  sum(v)
FROM unnest($1) g(v)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION idx(ANYARRAY, ANYELEMENT)
  RETURNS INT AS $$
SELECT
  i
FROM (SELECT
        generate_subscripts($1, 1) i,
        unnest($1)                 v) s
WHERE v = $2
LIMIT 1
$$ LANGUAGE SQL;





--arrays klaarzetten
SELECT
  DISTINCT
  identificatie,
  array_agg(text(gebruiksdoelen)) AS gebruiksdoelen,
  array_agg(totaal_oppervlakte)   AS totaal_oppervlakte
INTO temp_functie2
FROM temp_functie
GROUP BY identificatie
;

DROP TABLE temp_functie;


--uiteindelijke tabel
DROP TABLE pandgebruiksdoelen;

SELECT
  tf.identificatie,
  count(DISTINCT tt.gebruiksdoelen)                       AS aantal_functies,
  array_sum(array_agg(DISTINCT tt.aantal_gebruiksdoelen)) AS totaal_aantal_gebruiksdoelen,
  array_agg(tt.aantal_gebruiksdoelen)                     AS aantal_gebruiksdoelen,
  tf.gebruiksdoelen                                       AS gebruiksdoelen,
  tf.totaal_oppervlakte                                   AS oppervlakten,
  round(avg(te.oppervlakte_perpand))                      AS totaal_oppervlakte

INTO
  pandgebruiksdoelen

FROM
    temp_totaalopp2 AS te,
    temp3 AS tt,
    temp_functie2 AS tf

WHERE
  tt.identificatie = te.identificatie
  AND
  tf.identificatie = tt.identificatie

GROUP BY
  tf.identificatie, tf.gebruiksdoelen, tf.totaal_oppervlakte
;


--opschonen
DROP TABLE temp2;
DROP TABLE temp3;
DROP TABLE temp_functie2;
DROP TABLE temp_totaalopp2;

--indexes
CREATE INDEX pandgebruiksdoelen_identificatie ON pandgebruiksdoelen USING BTREE (identificatie);
