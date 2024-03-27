----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
--  START BLOK2  waarbij het gebruiksdoel wordt ge-pivot. Dus per VBO 1 regele met alle gebruiksdoelen er achtern
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------

-- Hiervoor is van belang dat de tablefunc (1 malig ) is gedefinieerd
-- CREATE extension tablefunc;

BEGIN;
DROP TABLE IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand_pivot;
CREATE TABLE verblijfsobjectgebruiksdoelactueelbestaand_pivot AS
SELECT vbo_id,
  coalesce(woonfunctie, 0) AS woonfunctie,
  coalesce(bijeenkomstfunctie, 0) AS bijeenkomstfunctie,
  coalesce(celfunctie, 0) AS celfunctie,
  coalesce(gezondheidszorgfunctie, 0) AS gezondheidszorgfunctie,
  coalesce(industriefunctie, 0) AS industriefunctie,
  coalesce(kantoorfunctie, 0) AS kantoorfunctie,
  coalesce(logiesfunctie, 0) AS logiesfunctie,
  coalesce(onderwijsfunctie, 0) AS onderwijsfunctie,
  coalesce(sportfunctie, 0) AS sportfunctie,
  coalesce(winkelfunctie, 0) AS winkelfunctie,
  coalesce(overige_gebruiksfunctie, 0) AS overige_gebruiksfunctie
FROM crosstab(
  $$
    SELECT
      vbogbd.identificatie AS VBO_ID,
      vbogbd.gebruiksdoelverblijfsobject,
      count(vbogbd.*) AS aantal
    FROM
      verblijfsobjectgebruiksdoelactueelbestaand vbogbd
    GROUP BY
      VBOGBD.identificatie,
      VBOGBD.gebruiksdoelverblijfsobject
    ORDER BY
     vbogbd.identificatie
  $$,
  $$
    SELECT
      DISTINCT gebruiksdoelverblijfsobject
    FROM
      verblijfsobjectgebruiksdoelactueelbestaand
    ORDER BY
     1
  $$
  )
  AS (
    vbo_id character varying,
    woonfunctie  integer,
    bijeenkomstfunctie integer,
    celfunctie integer,
    gezondheidszorgfunctie integer,
    industriefunctie integer,
    kantoorfunctie integer,
    logiesfunctie integer,
    onderwijsfunctie integer,
    sportfunctie integer,
    winkelfunctie integer,
    overige_gebruiksfunctie integer
  );
-- 20200531 Query returned successfully: 9295812 rows affected, 01:13 minutes execution time.

-- maak PK aan. Indien foutmelding dan hiervoor corrigeren
ALTER TABLE verblijfsobjectgebruiksdoelactueelbestaand_pivot
  ADD CONSTRAINT pk_vbo_gbd_pivot_vbo PRIMARY KEY (vbo_id);
COMMIT;
--20200531 Query returned successfully with no result in 13.6 secs.

----------------------------------------------------------------------------------------------------------------
--  EINDE BLOK2  waarbij het gebruiksdoel wordt ge-pivot. Dus per VBO 1 regele met alle gebruiksdoelen er achtern
----------------------------------------------------------------------------------------------------------------
