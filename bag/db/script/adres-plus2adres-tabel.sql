--
-- Maakt en tabel "adres" aan met volledige adressen uit de adres_plus tabel
--
-- De BAG bevat geen echte adressen zoals bijv. ACN (Adres Coordinaten Nederland), dwz
-- een tabel met straat, huisnummer, woonplaats, gemeente, provincie etc.
-- De elementen voor een compleet adres zitten wel in de (verrijkte) BAG.
-- Via SQL scripts hieronder wordt een echte "adres" tabel aangemaakt en gevuld
-- uit adres_plus tabel.
--
-- Auteur: Just van den Broecke
--

DROP TABLE IF EXISTS adres CASCADE;
CREATE TABLE adres AS SELECT
  cast(openbareruimtenaam AS character varying(80)),
  cast(huisnummer AS numeric(5,0)),
  cast(huisletter AS character varying(1)),
  cast(huisnummertoevoeging AS character varying(4)),
  cast(postcode AS character varying(6)),
  cast(woonplaatsnaam AS character varying(80)),
  cast(gemeentenaam AS character varying(80)),
  cast(provincienaam AS character varying(16)),
  cast(CASE
      WHEN typeadresseerbaarobject = 'Verblijfsobject' THEN 'VBO'
      WHEN typeadresseerbaarobject = 'Ligplaats' THEN 'LIG'
      WHEN typeadresseerbaarobject = 'Standplaats' THEN 'STA'
      ELSE ''
  END AS character varying(3)) AS typeadresseerbaarobject,
  cast(adresseerbaarobject_id AS character varying(16)) AS adresseerbaarobject,
  cast(nummeraanduiding_id AS character varying(16)) AS nummeraanduiding,
  cast (nevenadres as BOOLEAN),
  cast(geopunt AS geometry(PointZ, 28992))
FROM adres_plus ORDER BY openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging,woonplaatsnaam;;

-- Vul de text vector kolom voor full text search
ALTER TABLE adres ADD COLUMN textsearchable_adres tsvector;
UPDATE adres set textsearchable_adres = to_tsvector(openbareruimtenaam||' '||huisnummer||' '||trim(coalesce(huisletter,'')||' '||coalesce(huisnummertoevoeging,''))||' '||woonplaatsnaam);

-- Maak indexen aan na inserten (betere performance)
ALTER TABLE adres ADD COLUMN gid SERIAL PRIMARY KEY;

DROP INDEX IF EXISTS adres_geom_idx CASCADE;
DROP INDEX IF EXISTS adres_adresseerbaarobject CASCADE;
DROP INDEX IF EXISTS adres_nummeraanduiding CASCADE;
DROP INDEX IF EXISTS adresvol_idx CASCADE;

CREATE INDEX adres_geom_idx ON adres USING gist (geopunt);
CREATE INDEX adres_adresseerbaarobject ON adres USING btree (adresseerbaarobject);
CREATE INDEX adres_nummeraanduiding ON adres USING btree (nummeraanduiding);
CREATE INDEX adresvol_idx ON adres USING gin (textsearchable_adres);

-- OUD - niet meer nodig
-- Populeert public.geometry_columns
-- Dummy voor PostGIS 2+
-- SELECT public.probe_geometry_columns();

-- DROP SEQUENCE IF EXISTS adres_gid_seq;
-- CREATE SEQUENCE adres_gid_seq;
-- ALTER TABLE adres ADD gid integer UNIQUE;
-- ALTER TABLE adres ALTER COLUMN gid SET DEFAULT NEXTVAL('adres_gid_seq');
-- UPDATE adres SET gid = NEXTVAL('adres_gid_seq');
-- ALTER TABLE adres ADD PRIMARY KEY (gid);
