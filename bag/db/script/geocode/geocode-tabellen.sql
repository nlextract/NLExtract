--
-- Geocodeer BAG adressen, verrijkt met bestuurlijke eenheden (gemeenten, provincies).
--
-- Auteur: Just van den Broecke
--

-- Maak  een "echte" adressen tabel
DROP TABLE IF EXISTS adres_punt CASCADE;
CREATE TABLE adres_punt (
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
INSERT INTO adres_punt (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
	v.geopunt
FROM
	(SELECT identificatie,  geopunt, hoofdadres from verblijfsobjectactueelbestaand) v,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	v.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO adres_punt (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(l.geovlak))  as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from ligplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO adres_punt (straatnaam, huisnummer, huisletter, toevoeging, postcode, woonplaats, gemeente, provincie, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
    -- Vlak geometrie wordt punt
	ST_Force_3D(ST_Centroid(l.geovlak)) as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from standplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Maak indexen aan na inserten (betere performance)
CREATE INDEX adres_punt_geom_idx ON adres_punt USING gist (geopunt);
select probe_geometry_columns();

DROP SEQUENCE IF EXISTS adres_punt_gid_seq;
CREATE SEQUENCE adres_punt_gid_seq;
ALTER TABLE adres_punt ADD gid integer UNIQUE;
ALTER TABLE adres_punt ALTER COLUMN gid SET DEFAULT NEXTVAL('adres_punt_gid_seq');
UPDATE adres_punt SET gid = NEXTVAL('adres_punt_gid_seq');
ALTER TABLE adres_punt ADD PRIMARY KEY (gid);


--
-- Postcode 6 Tabel
--
DROP TABLE IF EXISTS postcode6_punt CASCADE;

CREATE table postcode6_punt AS
(
  SELECT distinct provincie, gemeente, woonplaats, straatnaam, postcode from adres_punt
);

DROP SEQUENCE IF EXISTS postcode6_punt_id_seq;
CREATE SEQUENCE postcode6_punt_id_seq;

ALTER TABLE postcode6_punt ADD id integer UNIQUE;

ALTER TABLE postcode6_punt ALTER COLUMN id SET DEFAULT
        NEXTVAL('postcode6_punt_id_seq');

UPDATE postcode6_punt SET id = NEXTVAL('postcode6_punt_id_seq');

ALTER TABLE postcode6_punt ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('postcode6_punt','geopunt',28992,'POINT',2);

ALTER TABLE postcode6_punt ADD CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 2));
ALTER TABLE postcode6_punt ADD CONSTRAINT enforce_geotype_punt CHECK (
        ((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL)));
ALTER TABLE postcode6_punt ADD CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992));

DROP INDEX IF EXISTS postcode6_punt_temp_idx;
CREATE INDEX postcode6_punt_temp_idx on adres_punt  USING BTREE (postcode);

update postcode6_punt AS pc6
  set geopunt =
          (SELECT ST_Force_2D(geopunt)
            from adres_punt
            where postcode = pc6.postcode
                    and
                    straatnaam = pc6.straatnaam
                  limit 1);

CREATE INDEX postcode6_punt_sdx on postcode6_punt  USING GIST (geopunt);

ALTER TABLE postcode6_punt
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE postcode6_punt
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE postcode6_punt
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE postcode6_punt
ALTER COLUMN straatnaam SET NOT  NULL;

ALTER TABLE postcode6_punt
ALTER COLUMN postcode SET NOT  NULL;

--
-- Postcode 4 Tabel
--
DROP TABLE IF EXISTS postcode4_punt CASCADE;

CREATE table postcode4_punt AS (
    SELECT distinct provincie, gemeente, woonplaats, substring(postcode for 4) AS postcode from postcode6_punt
);

DROP SEQUENCE IF EXISTS postcode4_punt_id_seq;
CREATE SEQUENCE postcode4_punt_id_seq;

ALTER TABLE postcode4_punt ADD id integer UNIQUE;

ALTER TABLE postcode4_punt ALTER COLUMN id SET DEFAULT NEXTVAL('postcode4_punt_id_seq');

UPDATE postcode4_punt SET id = NEXTVAL('postcode4_punt_id_seq');

ALTER TABLE postcode4_punt ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('postcode4_punt','geopunt',28992,'POINT',2);

DROP INDEX IF EXISTS postcode4_punt_temp_idx;
CREATE INDEX postcode4_punt_temp_idx on postcode6_punt  USING BTREE (substr(postcode,1,4));

update postcode4_punt AS pc4
  set geopunt =
          (SELECT geopunt
            from postcode6_punt
            where substr(postcode,1,4) = pc4.postcode
                  limit 1);

CREATE INDEX postcode4_punt_sdx2 on postcode4_punt  USING GIST (geopunt);

ALTER TABLE postcode4_punt
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE postcode4_punt
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE postcode4_punt
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE postcode6_punt
ALTER COLUMN postcode SET NOT  NULL;

--
-- Straatnaam Tabel
--
DROP TABLE IF EXISTS straatnaam_punt CASCADE;

CREATE table straatnaam_punt AS (
    SELECT distinct provincie, gemeente, woonplaats, straatnaam from postcode6_punt
);

DROP SEQUENCE IF EXISTS straatnaam_punt_id_seq;
CREATE SEQUENCE straatnaam_punt_id_seq;

ALTER TABLE straatnaam_punt ADD id integer UNIQUE;

ALTER TABLE straatnaam_punt ALTER COLUMN id SET DEFAULT NEXTVAL('straatnaam_punt_id_seq');

UPDATE straatnaam_punt SET id = NEXTVAL('straatnaam_punt_id_seq');

ALTER TABLE straatnaam_punt ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('straatnaam_punt','geopunt',28992,'POINT',2);

DROP INDEX IF EXISTS straatnaam_punt_temp_idx;
CREATE INDEX straatnaam_punt_temp_idx on postcode6_punt  USING BTREE (straatnaam);

update straatnaam_punt
  set geopunt =
          (SELECT geopunt
            from postcode6_punt
            where straatnaam = straatnaam_punt.straatnaam
                  limit 1);

-- CREATE INDEX straatnaam_punt_sdx1 on straatnaam_punt  USING GIST (geom);

CREATE INDEX straatnaam_punt_sdx2 on straatnaam_punt  USING GIST (geopunt);

ALTER TABLE straatnaam_punt
ALTER COLUMN provincie SET NOT  NULL;

ALTER TABLE straatnaam_punt
ALTER COLUMN gemeente SET NOT  NULL;

ALTER TABLE straatnaam_punt
ALTER COLUMN woonplaats SET NOT  NULL;

ALTER TABLE straatnaam_punt
ALTER COLUMN straatnaam SET NOT  NULL;

--
-- Woonplaats Tabel
--
DROP TABLE IF EXISTS woonplaats_punt CASCADE;
CREATE TABLE woonplaats_punt (
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
INSERT INTO woonplaats_punt (provincie, gemeente, woonplaats, geopunt)
  SELECT
	p.provincienaam as provincie,
	g.gemeentenaam as gemeente,
	w.woonplaatsnaam as woonplaats,
	ST_Force_2D(ST_Centroid(w.geovlak)) as geopunt
FROM
	(SELECT identificatie, woonplaatsnaam, geovlak from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode, gemeentenaam from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode, provincienaam from gemeente_provincie) p
WHERE
	w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

create index woonplaats_punt_sdx1 on woonplaats_punt using gist (geopunt);

--
-- Gemeente Tabel
--
DROP TABLE IF EXISTS gemeente_punt CASCADE;
CREATE TABLE gemeente_punt (
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
INSERT INTO gemeente_punt (provincie, gemeente, geopunt)
  SELECT
	p.provincienaam as provincie,
	g.gemeentenaam as gemeente,
	ST_Force_2D(ST_Centroid(g.geovlak))  as geopunt
FROM
	(SELECT gemeentecode,gemeentenaam,geovlak from gemeente) g,
	(SELECT gemeentecode, provincienaam from gemeente_provincie) p
WHERE
  g.gemeentecode = p.gemeentecode;

--
-- Provincie Tabel
--
DROP TABLE IF EXISTS provincie_punt CASCADE;
CREATE TABLE provincie_punt (
    provincie text NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO provincie_punt (provincie, geopunt)
  SELECT
	p.provincienaam as provincie,
	ST_Force_2D(ST_Centroid(p.geovlak))as geopunt
FROM
	(SELECT provincienaam, geovlak from provincie) p;
