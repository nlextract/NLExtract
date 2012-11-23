--
-- Geogecodeerde BAG adressen -en elementen, verrijkt met bestuurlijke eenheden (gemeenten, provincies).
--
-- Auteur: Just van den Broecke
--
-- De tabellen hieronder zijn afgeleid van de BAG import tabellen
-- met als doel om tabellen te bieden waarop (reverse) geocoding kan worden
-- toegepast. Geocoding hulp- functies staan in het bijbehorende
-- SQL bestand geocode-functies.
--
-- Gebruik:
-- * BAG importeren via bag-extract -e <bag-levering>
-- * BAG verrijken met gemeenten en provincies  bag-extract -q db/script/gemeente-provincie-tabel.sql
-- * geocoding tabellen laden: bag-extract -q geocode-tabellen.sql
-- * geocoding functies laden: bag-extract -q geocode-functies.sql
-- * functies aanroepen bijv. select * from  nlx_adres_voor_xy(118566, 480606);
--
-- Tip: houdt de bag import data en geocoding tabellen gescheiden
-- door gebruik PostgreSQL schema's. Het beste is om de BAG in te lezen in apart schema
-- bijv. "bag_import" en vervolgens de geocode-tabellen in een nieuw schema "bag_geocode".
-- In extract.conf kan ook een schema search path worden aangegeven door bijv:
--  schema = bag_geocode,bag_import,public
--

-- Volledig adres
DROP TABLE IF EXISTS geo_adres CASCADE;
CREATE TABLE geo_adres (
    straatnaam character varying(80),
    huisnummer numeric(5,0),
    huisletter character varying(1),
    toevoeging character varying(4),
    postcode character varying(6),
    woonplaats character varying(80),
    gemeente character varying(80),
    provincie character varying(16),
    geopunt geometry,
    CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_adres (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	p.gemeentenaam,
	p.provincienaam,
	v.geopunt
FROM
	(SELECT identificatie,  geopunt, hoofdadres from verblijfsobjectactueelbestaand) v,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode from gemeente_woonplaatsactueelbestaand) g,
	(SELECT gemeentenaam, gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	v.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO geo_adres (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	p.gemeentenaam,
	p.provincienaam,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(l.geovlak))  as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from ligplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode from gemeente_woonplaatsactueelbestaand) g,
	(SELECT gemeentenaam, gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO geo_adres (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	p.gemeentenaam,
	p.provincienaam,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(l.geovlak)) as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from standplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode from gemeente_woonplaatsactueelbestaand) g,
	(SELECT gemeentenaam, gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Maak indexen aan na inserten (betere performance)
CREATE INDEX geo_adres_geom_idx ON geo_adres USING gist (geopunt);

DROP SEQUENCE IF EXISTS geo_adres_gid_seq;
CREATE SEQUENCE geo_adres_gid_seq;
ALTER TABLE geo_adres ADD gid integer UNIQUE;
ALTER TABLE geo_adres ALTER COLUMN gid SET DEFAULT NEXTVAL('geo_adres_gid_seq');
UPDATE geo_adres SET gid = NEXTVAL('geo_adres_gid_seq');
ALTER TABLE geo_adres ADD PRIMARY KEY (gid);

CREATE INDEX geo_adres_postcode_huisnummer_idx ON geo_adres USING btree (postcode,huisnummer);


--
-- Postcode 6 Tabel
--
DROP TABLE IF EXISTS geo_postcode6 CASCADE;

CREATE table geo_postcode6 AS
(
  SELECT distinct provincie, gemeente, woonplaats, straatnaam, postcode from geo_adres
);

DROP SEQUENCE IF EXISTS geo_postcode6_id_seq;
CREATE SEQUENCE geo_postcode6_id_seq;

ALTER TABLE geo_postcode6 ADD id integer UNIQUE;

ALTER TABLE geo_postcode6 ALTER COLUMN id SET DEFAULT
        NEXTVAL('geo_postcode6_id_seq');

UPDATE geo_postcode6 SET id = NEXTVAL('geo_postcode6_id_seq');

ALTER TABLE geo_postcode6 ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('geo_postcode6','geopunt',28992,'POINT',2);

ALTER TABLE geo_postcode6 ADD CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 2));
ALTER TABLE geo_postcode6 ADD CONSTRAINT enforce_geotype_punt CHECK (
        ((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL)));
ALTER TABLE geo_postcode6 ADD CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992));

DROP INDEX IF EXISTS geo_postcode6_temp_idx;
CREATE INDEX geo_postcode6_temp_idx on geo_adres  USING BTREE (postcode);
CREATE INDEX geo_postcode6_postcode_idx ON geo_postcode6 USING btree (postcode);
CREATE INDEX geo_postcode6_woonplaats_idx ON geo_postcode6 USING btree (woonplaats);
CREATE INDEX geo_postcode6_gemeente_idx ON geo_postcode6 USING btree (gemeente);
CREATE INDEX geo_postcode6_straatnaam_idx ON geo_postcode6 USING btree (straatnaam);

update geo_postcode6 AS pc6
  set geopunt =
          (SELECT ST_Force_2D(geopunt)
            from geo_adres
            where postcode = pc6.postcode
                    and
                    straatnaam = pc6.straatnaam
                  limit 1);

CREATE INDEX geo_postcode6_sdx on geo_postcode6  USING GIST (geopunt);

ALTER TABLE geo_postcode6
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN straatnaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN postcode SET NOT  NULL;

--
-- Postcode 4 Tabel
--
DROP TABLE IF EXISTS geo_postcode4 CASCADE;

CREATE table geo_postcode4 AS (
    SELECT distinct provincie, gemeente, woonplaats, substring(postcode for 4) AS postcode from geo_postcode6
);

DROP SEQUENCE IF EXISTS geo_postcode4_id_seq;
CREATE SEQUENCE geo_postcode4_id_seq;

ALTER TABLE geo_postcode4 ADD id integer UNIQUE;

ALTER TABLE geo_postcode4 ALTER COLUMN id SET DEFAULT NEXTVAL('geo_postcode4_id_seq');

UPDATE geo_postcode4 SET id = NEXTVAL('geo_postcode4_id_seq');

ALTER TABLE geo_postcode4 ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('geo_postcode4','geopunt',28992,'POINT',2);

DROP INDEX IF EXISTS geo_postcode4_temp_idx;
CREATE INDEX geo_postcode64_temp_idx on geo_postcode6  USING BTREE (substr(postcode,1,4));
CREATE INDEX geo_postcode4_postcode_idx ON geo_postcode4 USING btree (postcode);
CREATE INDEX geo_postcode4_woonplaats_idx ON geo_postcode4 USING btree (woonplaats);
CREATE INDEX geo_postcode4_gemeente_idx ON geo_postcode4 USING btree (gemeente);

update geo_postcode4 AS pc4
  set geopunt =
          (SELECT geopunt
            from geo_postcode6
            where substr(postcode,1,4) = pc4.postcode
                  limit 1);

CREATE INDEX geo_postcode4_sdx2 on geo_postcode4  USING GIST (geopunt);

ALTER TABLE geo_postcode4
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE geo_postcode4
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE geo_postcode4
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN postcode SET NOT  NULL;

--
-- Straatnaam Tabel
--
DROP TABLE IF EXISTS geo_straatnaam CASCADE;

CREATE table geo_straatnaam AS (
    SELECT distinct provincie, gemeente, woonplaats, straatnaam from geo_postcode6
);

DROP SEQUENCE IF EXISTS geo_straatnaam_id_seq;
CREATE SEQUENCE geo_straatnaam_id_seq;

ALTER TABLE geo_straatnaam ADD id integer UNIQUE;

ALTER TABLE geo_straatnaam ALTER COLUMN id SET DEFAULT NEXTVAL('geo_straatnaam_id_seq');

UPDATE geo_straatnaam SET id = NEXTVAL('geo_straatnaam_id_seq');

ALTER TABLE geo_straatnaam ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('geo_straatnaam','geopunt',28992,'POINT',2);

DROP INDEX IF EXISTS geo_straatnaam_temp_idx;
CREATE INDEX geo_straatnaam_temp_idx on geo_postcode6  USING BTREE (straatnaam);
CREATE INDEX geo_straatnaam_straatnaamidx ON geo_straatnaam USING btree (straatnaam);
CREATE INDEX geo_straatnaam_gemeente_idx ON geo_straatnaam USING btree (gemeente);
CREATE INDEX geo_straatnaam_woonplaats_idx ON geo_straatnaam USING btree (woonplaats);

update geo_straatnaam
  set geopunt =
          (SELECT geopunt
            from geo_postcode6
            where straatnaam = geo_straatnaam.straatnaam
                  limit 1);

-- CREATE INDEX geo_straatnaam_sdx1 on geo_straatnaam  USING GIST (geom);

CREATE INDEX geo_straatnaam_sdx2 on geo_straatnaam  USING GIST (geopunt);

ALTER TABLE geo_straatnaam
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE geo_straatnaam
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE geo_straatnaam
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE geo_straatnaam
ALTER COLUMN straatnaam SET NOT  NULL;

--
-- Woonplaats Tabel
--
DROP TABLE IF EXISTS geo_woonplaats CASCADE;
CREATE TABLE geo_woonplaats (
    provincie text NOT NULL,
    gemeente character varying(250) NOT NULL,
    woonplaats character varying(250) NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.st_ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.st_srid(geopunt) = 28992))
);


-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_woonplaats (provincie, gemeente, woonplaats, geopunt)
  SELECT
	p.provincienaam as provincie,
	p.gemeentenaam as gemeente,
	w.woonplaatsnaam as woonplaats,
	ST_Force_2D(ST_Centroid(w.geovlak)) as geopunt
FROM
	(SELECT identificatie, woonplaatsnaam, geovlak from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode from gemeente_woonplaatsactueelbestaand) g,
	(SELECT  gemeentenaam, gemeentecode, provincienaam from gemeente_provincie) p
WHERE
	w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

create index geo_woonplaats_sidx1 on geo_woonplaats using gist (geopunt);
CREATE INDEX geo_woonplaats_woonplaats_idx ON geo_woonplaats USING btree (woonplaats);
CREATE INDEX geo_woonplaats_woonplaats_gem_idx ON geo_woonplaats USING btree (gemeente,woonplaats);

--
-- Gemeente Tabel
--
DROP TABLE IF EXISTS geo_gemeente CASCADE;
CREATE TABLE geo_gemeente (
    provincie text NOT NULL,
    gemeente character varying(250) NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.srid(geopunt) = 28992))
);


-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_gemeente (provincie, gemeente, geopunt)
  SELECT
	p.provincienaam as provincie,
	g.gemeentenaam as gemeente,
	ST_Force_2D(ST_Centroid(g.geovlak))  as geopunt
FROM
	(SELECT gemeentecode,gemeentenaam,geovlak from gemeente) g,
	(SELECT gemeentecode, provincienaam from gemeente_provincie) p
WHERE
  g.gemeentecode = p.gemeentecode;

CREATE INDEX geo_gemeente_geopunt_idx ON geo_gemeente USING gist (geopunt);
CREATE INDEX geo_gemeente_gemeente_idx ON geo_gemeente USING btree (gemeente);

--
-- Provincie Tabel
--
DROP TABLE IF EXISTS geo_provincie CASCADE;
CREATE TABLE geo_provincie (
    provincie text NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_provincie (provincie, geopunt)
  SELECT
	p.provincienaam as provincie,
	ST_Force_2D(ST_Centroid(p.geovlak))as geopunt
FROM
	(SELECT provincienaam, geovlak from provincie) p;

CREATE INDEX geo_provincie_geopunt_idx ON geo_provincie USING gist (geopunt);

