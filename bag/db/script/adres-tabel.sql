--
-- Maakt en vult afgeleide tabel "adres" aan met volledige adressen
--
-- De BAG bevat geen echte adressen zoals bijv. ACN (Adres Coordinaten Nederland), dwz
-- een tabel met straat, huisnummer, woonplaats, gemeente, provincie etc.
-- De elementen voor een compleet adres zitten wel in de (verrijkte) BAG.
-- Via SQL scripts hieronder wordt een echte "adres" tabel aangemaakt en gevuld
-- uit de BAG basistabellen.
--
-- Auteur: Just van den Broecke
--

-- Maak  een "echte" adressen tabel
DROP TABLE IF EXISTS adres CASCADE;
CREATE TABLE adres (
    openbareruimtenaam character varying(80),
    huisnummer numeric(5,0),
    huisletter character varying(1),
    huisnummertoevoeging character varying(4),
    postcode character varying(6),
    woonplaatsnaam character varying(80),
    gemeentenaam character varying(80),
    provincienaam character varying(16),
    typeadresseerbaarobject character varying(3),
    adresseerbaarobject numeric(16,0),
    nummeraanduiding numeric(16,0),
    geopunt geometry,
    textsearchable_adres tsvector,
    CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam,
        provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
-- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
    (CASE
      WHEN wp2.woonplaatsnaam IS NULL THEN w.woonplaatsnaam ELSE wp2.woonplaatsnaam END),
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
       WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'VBO' as typeadresseerbaarobject,
    v.identificatie as adresseerbaarobject,
    n.identificatie as nummeraanduiding,
    v.geopunt
   FROM verblijfsobjectactueelbestaand v
    JOIN nummeraanduidingactueelbestaand n
    ON (n.identificatie = v.hoofdadres)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand  g
    ON (g.woonplaatscode = w.identificatie)
    JOIN gemeente_provincie p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN gemeente_provincie p2
    ON (g2.gemeentecode = p2.gemeentecode);

      -- 26.06.12 JvdB Vervangen implicit JOINs by real JOINs n.a.v. https://github.com/opengeogroep/NLExtract/issues/54
       -- FROM
        -- 	(SELECT identificatie,  geopunt, hoofdadres from verblijfsobjectactueelbestaand) v,
        -- 	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte, gerelateerdewoonplaats from nummeraanduidingactueelbestaand) n,
        -- 	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
        -- 	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
        -- 	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaatsactueelbestaand  where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
        -- 	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
        -- WHERE
        -- 	v.hoofdadres = n.identificatie
        -- 	and n.gerelateerdeopenbareruimte = o.identificatie
        -- 	and o.gerelateerdewoonplaats = w.identificatie
        -- 	and w.identificatie = g.woonplaatscode
        -- 	and g.gemeentecode = p.gemeentecode;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
   -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
    (CASE
      WHEN wp2.woonplaatsnaam IS NULL THEN w.woonplaatsnaam ELSE wp2.woonplaatsnaam END),
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
       WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'LIG' as typeadresseerbaarobject,
	l.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(l.geovlak))  as geopunt
  FROM ligplaatsactueelbestaand l
   JOIN nummeraanduidingactueelbestaand n
   ON (n.identificatie = l.hoofdadres)
   JOIN openbareruimteactueelbestaand o
   ON (n.gerelateerdeopenbareruimte = o.identificatie)
   JOIN woonplaatsactueelbestaand w
   ON (o.gerelateerdewoonplaats = w.identificatie)
   JOIN gemeente_woonplaatsactueelbestaand  g
   ON (g.woonplaatscode = w.identificatie)
   JOIN gemeente_provincie p
   ON (g.gemeentecode = p.gemeentecode)
   -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
   LEFT OUTER JOIN woonplaatsactueelbestaand wp2
   ON (n.gerelateerdewoonplaats = wp2.identificatie)
   LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
   ON (g2.woonplaatscode = wp2.identificatie)
   LEFT OUTER JOIN gemeente_provincie p2
   ON (g2.gemeentecode = p2.gemeentecode);


 -- 26.06.12 JvdB Vervangen implicit JOINs by real JOINs n.a.v. https://github.com/opengeogroep/NLExtract/issues/54
 -- FROM
-- 	(SELECT identificatie,  geovlak, hoofdadres from ligplaatsactueelbestaand) l,
-- 	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
-- 	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
-- 	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
-- 	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaatsactueelbestaand  where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
-- 	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
-- WHERE
-- 	l.hoofdadres = n.identificatie
-- 	and n.gerelateerdeopenbareruimte = o.identificatie
-- 	and o.gerelateerdewoonplaats = w.identificatie
-- 	and w.identificatie = g.woonplaatscode
-- 	and g.gemeentecode = p.gemeentecode;

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
   -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
    (CASE
     WHEN wp2.woonplaatsnaam IS NULL THEN w.woonplaatsnaam ELSE wp2.woonplaatsnaam END),
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
      WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'STA' as typeadresseerbaarobject,
	s.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(s.geovlak)) as geopunt
  FROM standplaatsactueelbestaand s
   JOIN nummeraanduidingactueelbestaand n
   ON (n.identificatie = s.hoofdadres)
   JOIN openbareruimteactueelbestaand o
   ON (n.gerelateerdeopenbareruimte = o.identificatie)
   JOIN woonplaatsactueelbestaand w
   ON (o.gerelateerdewoonplaats = w.identificatie)
   JOIN gemeente_woonplaatsactueelbestaand  g
   ON (g.woonplaatscode = w.identificatie)
   JOIN gemeente_provincie p
   ON (g.gemeentecode = p.gemeentecode)
   -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/opengeogroep/NLExtract/issues/54
   LEFT OUTER JOIN woonplaatsactueelbestaand wp2
   ON (n.gerelateerdewoonplaats = wp2.identificatie)
   LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
   ON (g2.woonplaatscode = wp2.identificatie)
   LEFT OUTER JOIN gemeente_provincie p2
   ON (g2.gemeentecode = p2.gemeentecode);

-- FROM
-- 	(SELECT identificatie,  geovlak, hoofdadres from standplaatsactueelbestaand) l,
-- 	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
-- 	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
-- 	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
-- 	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaatsactueelbestaand  where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
-- 	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
-- WHERE
-- 	l.hoofdadres = n.identificatie
-- 	and n.gerelateerdeopenbareruimte = o.identificatie
-- 	and o.gerelateerdewoonplaats = w.identificatie
-- 	and w.identificatie = g.woonplaatscode
-- 	and g.gemeentecode = p.gemeentecode;

-- Vul de text vector kolom voor full text search
UPDATE adres set textsearchable_adres = to_tsvector(openbareruimtenaam||' '||huisnummer||' '||trim(coalesce(huisletter,'')||' '||coalesce(huisnummertoevoeging,''))||' '||woonplaatsnaam);

-- Maak indexen aan na inserten (betere performance)
CREATE INDEX adres_geom_idx ON adres USING gist (geopunt);
CREATE INDEX adres_adreseerbaarobject ON adres USING btree (adresseerbaarobject );
CREATE INDEX adres_nummeraanduiding ON adres USING btree (nummeraanduiding );
CREATE INDEX adresvol_idx ON adres USING gin (textsearchable_adres );

-- Vult de geometry_columns alleen bij PostGIS 1.x versies (dus niet in 2.x+)
select case when cast(substring(postgis_lib_version()  from 1 for 1) as numeric) < 2 then probe_geometry_columns() end;

DROP SEQUENCE IF EXISTS adres_gid_seq;
CREATE SEQUENCE adres_gid_seq;
ALTER TABLE adres ADD gid integer UNIQUE;
ALTER TABLE adres ALTER COLUMN gid SET DEFAULT NEXTVAL('adres_gid_seq');
UPDATE adres SET gid = NEXTVAL('adres_gid_seq');
ALTER TABLE adres ADD PRIMARY KEY (gid);




