--
-- Maakt en tabel "adres full" (Uitgebreid) aan met volledige adressen uit de adres_plus tabel
--
-- De BAG bevat geen echte adressen zoals bijv. ACN (Adres Coordinaten Nederland), dwz
-- een tabel met straat, huisnummer, woonplaats, gemeente, provincie etc.
-- De elementen voor een compleet adres zitten wel in de (verrijkte) BAG.
-- Via SQL scripts hieronder wordt een echte "adres_full" tabel aangemaakt en gevuld
-- uit adres_plus tabel.
--
-- Auteur: Just van den Broecke
--

-- huisnummer ,
-- huisletter character varying(1) COLLATE pg_catalog."default",
-- huisnummertoevoeging character varying(4) COLLATE pg_catalog."default",
-- postcode character varying(6) COLLATE pg_catalog."default",
-- woonplaatsnaam character varying(80) COLLATE pg_catalog."default",
-- gemeentenaam character varying(80) COLLATE pg_catalog."default",
-- provincienaam character varying(16) COLLATE pg_catalog."default",
-- verblijfsobjectgebruiksdoel character varying COLLATE pg_catalog."default",
-- oppervlakteverblijfsobject numeric(6,0) DEFAULT 0,
-- verblijfsobjectstatus character varying COLLATE pg_catalog."default",
-- typeadresseerbaarobject character varying(3) COLLATE pg_catalog."default",
-- adresseerbaarobject character varying(16) COLLATE pg_catalog."default",
-- pandid character varying(16) COLLATE pg_catalog."default",
-- pandstatus character varying COLLATE pg_catalog."default",
-- pandbouwjaar numeric(4,0),
-- nummeraanduiding character varying(16) COLLATE pg_catalog."default",
-- nevenadres boolean DEFAULT false,
-- geopunt geometry(PointZ,28992),
-- textsearchable_adres tsvector,
-- verkorteopenbareruimtenaam character varying(24) COLLATE pg_catalog."default" DEFAULT NULL::character varying,

DROP TABLE IF EXISTS adres_full CASCADE;
CREATE TABLE adres_full AS SELECT
   cast(openbareruimtenaam AS character varying(80)),
   cast(huisnummer AS numeric(5,0)),
   cast(huisletter AS character varying(1)),
   cast(huisnummertoevoeging AS character varying(4)),
   cast(postcode AS character varying(6)),
   cast(woonplaatsnaam AS character varying(80)),
   cast(gemeentenaam AS character varying(80)),
   cast(provincienaam AS character varying(16)),
   -- https://stackoverflow.com/questions/33743900/concatenating-multiple-boolean-columns-to-single-varchar-column
  concat_ws(',',
       CASE
           WHEN woonfunctie = 1 THEN 'woonfunctie'
	END,
       CASE
            WHEN bijeenkomstfunctie = 1 THEN 'bijeenkomstfunctie'
	END,
        CASE
           WHEN celfunctie = 1 THEN 'celfunctie'
	END,
       CASE
           WHEN gezondheidszorgfunctie = 1 THEN 'gezondheidszorgfunctie'
	END,
       CASE
           WHEN industriefunctie = 1 THEN 'industriefunctie'
	END,
       CASE
           WHEN kantoorfunctie = 1 THEN 'kantoorfunctie'
	END,
       CASE
           WHEN logiesfunctie = 1 THEN 'logiesfunctie'
	END,
       CASE
           WHEN onderwijsfunctie = 1 THEN 'onderwijsfunctie'
	END,
       CASE
           WHEN sportfunctie = 1 THEN 'sportfunctie'
	END,
       CASE
           WHEN winkelfunctie = 1 THEN 'winkelfunctie'
	END,
       CASE
           WHEN overige_gebruiksfunctie = 1 THEN 'overige gebruiksfunctie'
	END)
      AS verblijfsobjectgebruiksdoel,
   cast(opp_adresseerbaarobject_m2 AS numeric(6,0)) AS oppervlakteadresseerbaarobject,
   cast(adresseerbaarobject_status AS character varying) AS adresseerbaarobjectstatus,
   cast(CASE
       WHEN typeadresseerbaarobject = 'Verblijfsobject' THEN 'VBO'
       WHEN typeadresseerbaarobject = 'Ligplaats' THEN 'LIG'
       WHEN typeadresseerbaarobject = 'Standplaats' THEN 'STA'
       ELSE ''
   END AS character varying(3)) AS typeadresseerbaarobject,
   cast(adresseerbaarobject_id AS character varying(16)) AS adresseerbaarobject,
   cast(pand_id AS character varying(16)) AS pandid,
   cast(pandstatus AS character varying),
   cast(bouwjaar AS numeric(4,0)) AS pandbouwjaar,
   cast(nummeraanduiding_id AS character varying(16)) AS nummeraanduiding,
   cast(nevenadres AS BOOLEAN),
   cast(geopunt AS geometry(Point, 28992)),
   cast(verkorteopenbareruimtenaam AS character varying(24))
FROM adres_plus ORDER BY openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging,woonplaatsnaam;

-- Vul de text vector kolom voor full text search
ALTER TABLE adres_full ADD COLUMN textsearchable_adres tsvector;
-- Vul de text vector kolom voor full text search
UPDATE adres_full set textsearchable_adres = to_tsvector(openbareruimtenaam||' '||huisnummer||' '||trim(coalesce(huisletter,'')||' '||coalesce(huisnummertoevoeging,''))||' '||woonplaatsnaam);

ALTER TABLE adres_full ADD COLUMN gid SERIAL PRIMARY KEY;

-- Maak indexen aan na inserten
DROP INDEX IF EXISTS adres_full_geom_idx CASCADE;
DROP INDEX IF EXISTS adres_full_adresseerbaarobject CASCADE;
DROP INDEX IF EXISTS adres_full_nummeraanduiding CASCADE;
DROP INDEX IF EXISTS adres_full_pandid CASCADE;
DROP INDEX IF EXISTS adres_full_idx CASCADE;
CREATE INDEX adres_full_geom_idx ON adres_full USING gist (geopunt);
CREATE INDEX adres_full_adresseerbaarobject ON adres_full USING btree (adresseerbaarobject);
CREATE INDEX adres_full_nummeraanduiding ON adres_full USING btree (nummeraanduiding);
CREATE INDEX adres_full_pandid ON adres_full USING btree (pandid);
CREATE INDEX adres_full_idx ON adres_full USING gin (textsearchable_adres);
