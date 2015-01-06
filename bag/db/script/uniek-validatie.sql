-- Check voorkomens
-- Inspired door rutgerw: https://gist.github.com/rutgerw/d65d421cf8d9c61e7d06
--
-- Check of elke combinatie van onderstaande velden maar 1 keer voorkomt
-- identificatie
-- aanduidingrecordinactief
-- aanduidingrecordcorrectie
-- begindatumtijdvakgeldigheid
-- einddatumtijdvakgeldigheid is NULL

SELECT
 'WPL' as object
, COUNT(*)
, identificatie
FROM
woonplaats
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'OPR' as object
, COUNT(*)
, identificatie
FROM
openbareruimte
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'NUM' as object
, COUNT(*)
, identificatie
FROM
nummeraanduiding
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'LIG' as object
, COUNT(*)
, identificatie
FROM
ligplaats
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'STD' as object
, COUNT(*)
, identificatie
FROM
standplaats
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'VBO' as object
, COUNT(*)
, identificatie
FROM
verblijfsobject
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
UNION
SELECT
 'PND' as object
, COUNT(*)
, identificatie
FROM
pand
WHERE einddatumtijdvakgeldigheid is NULL AND NOT aanduidingrecordinactief
GROUP BY identificatie
HAVING COUNT(*) > 1
