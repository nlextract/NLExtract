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
    verblijfsobjectgebruiksdoel character varying,
    verblijfsobjectstatus character varying,
    adresseerbaarobject numeric(16,0),
    typeadresseerbaarobject character varying(3),
    nummeraanduiding numeric(16,0),
    nevenadres BOOLEAN DEFAULT FALSE,
    pandid numeric(16,0),
    pandstatus character varying,
    pandbouwjaar numeric(4,0),
    openbareruimtenaam character varying(80),
    huisnummer numeric(5,0),
    huisletter character varying(1),
    huisnummertoevoeging character varying(4),
    postcode character varying(6),
    woonplaatsnaam character varying(80),
    gemeentenaam character varying(80),
    provincienaam character varying(16),
    geopunt geometry,
    CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	v.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	ARRAY_TO_STRING(ARRAY_AGG(d.gebruiksdoelverblijfsobject ORDER BY gebruiksdoelverblijfsobject), ', ') AS verblijfsobjectgebruiksdoel,
	v.verblijfsobjectstatus,
	'VBO', -- typeadresseerbaarobject
	pv.identificatie as pandid,
	pv.pandstatus,
	pv.bouwjaar as pandbouwjaar,
	v.geopunt
FROM
	verblijfsobjectactueel v
	JOIN nummeraanduidingactueel n
	ON (n.identificatie = v.hoofdadres)
	LEFT OUTER JOIN verblijfsobjectgebruiksdoelactueel d
	ON (v.identificatie = d.identificatie)
	LEFT OUTER JOIN verblijfsobjectpandactueel vp
	ON (v.identificatie = vp.identificatie)
	LEFT OUTER JOIN pandactueel pv
	ON (vp.gerelateerdpand = pv.identificatie)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode)

GROUP BY
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	adresseerbaarobject,
	nummeraanduiding,
	v.verblijfsobjectstatus,
	typeadresseerbaarobject,
	pandid,
	pv.pandstatus,
	pandbouwjaar,
	geopunt;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	l.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	'Ligplaats', -- verblijfsobjectgebruiksdoel
	l.ligplaatsstatus, -- verblijfsobjectstatus
  'LIG', -- typeadresseerbaarobject
	NULL, -- pandid
	'', -- pandstatus
	NULL, -- pandbouwjaar
    -- Vlak geometrie wordt punt
    -- ST_Force3D is Postgis 2.x, gebruik st_force_3d voor Postgis 1.x
	ST_Force3D(ST_Centroid(l.geovlak))  as geopunt
FROM
	ligplaatsactueel l
	JOIN nummeraanduidingactueel n
	ON (n.identificatie = l.hoofdadres)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand  g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode);

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	s.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	'Standplaats', -- verblijfsobjectgebruiksdoel
	s.standplaatsstatus, -- verblijfsobjectstatus
  'STA', -- typeadresseerbaarobject
	NULL, -- pandid
	'', -- pandstatus
	NULL, -- pandbouwjaar
    -- Vlak geometrie wordt punt
    -- ST_Force3D is Postgis 2.x, gebruik st_force_3d voor Postgis 1.x
	ST_Force3D(ST_Centroid(s.geovlak)) as geopunt
FROM
	standplaatsactueel s
	JOIN nummeraanduidingactueel n
	ON (n.identificatie = s.hoofdadres)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand  g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Verblijfplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	aon.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	TRUE, -- nevenadres
	ARRAY_TO_STRING(ARRAY_AGG(d.gebruiksdoelverblijfsobject ORDER BY gebruiksdoelverblijfsobject), ', ') AS verblijfsobjectgebruiksdoel,
	v.verblijfsobjectstatus,
  'VBO', -- typeadresseerbaarobject
	pv.identificatie as pandid,
	pv.pandstatus,
	pv.bouwjaar as pandbouwjaar,
	v.geopunt
FROM
	adresseerbaarobjectnevenadresactueel aon
	JOIN nummeraanduidingactueel n
	ON (aon.nevenadres = n.identificatie)
	JOIN verblijfsobjectactueel v
	ON (aon.identificatie = v.identificatie)
	LEFT OUTER JOIN verblijfsobjectgebruiksdoelactueel d
	ON (v.identificatie = d.identificatie)
	LEFT OUTER JOIN verblijfsobjectpandactueel vp
	ON (v.identificatie = vp.identificatie)
	LEFT OUTER JOIN pandactueel pv
	ON (vp.gerelateerdpand = pv.identificatie)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode)
GROUP BY
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	adresseerbaarobject,
	nummeraanduiding,
	v.verblijfsobjectstatus,
	typeadresseerbaarobject,
	pandid,
	pv.pandstatus,
	pandbouwjaar,
	geopunt;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Ligplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	aon.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	TRUE, -- nevenadres
	'Ligplaats', -- verblijfsobjectgebruiksdoel
	l.ligplaatsstatus, -- verblijfsobjectstatus
	'LIG', -- typeadresseerbaarobject
	NULL, -- pandid
	'', -- pandstatus
	NULL, -- pandbouwjaar
    -- Vlak geometrie wordt punt
    -- ST_Force3D is Postgis 2.x, gebruik st_force_3d voor Postgis 1.x
	ST_Force3D(ST_Centroid(l.geovlak))  as geopunt
FROM
	adresseerbaarobjectnevenadresactueel aon
	JOIN nummeraanduidingactueel n
	ON (aon.nevenadres = n.identificatie AND n.typeadresseerbaarobject = 'Ligplaats')
	JOIN ligplaatsactueel l
	ON (aon.identificatie = l.identificatie)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Standplaats
INSERT INTO geo_adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, adresseerbaarobject, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, typeadresseerbaarobject, pandid, pandstatus, pandbouwjaar, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
	COALESCE(p2.gemeentenaam,p.gemeentenaam),
	COALESCE(p2.provincienaam,p.provincienaam),
	aon.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
	TRUE, -- nevenadres
	'Standplaats', -- verblijfsobjectgebruiksdoel
	s.standplaatsstatus, -- verblijfsobjectstatus
  'STA', -- typeadresseerbaarobject
	NULL, -- pandid
	'', -- pandstatus
	NULL, -- pandbouwjaar
  -- Vlak geometrie wordt punt
  -- ST_Force3D is Postgis 2.x, gebruik st_force_3d voor Postgis 1.x
	ST_Force3D(ST_Centroid(s.geovlak))  as geopunt
FROM
	adresseerbaarobjectnevenadresactueel aon
	JOIN nummeraanduidingactueel n
	ON (aon.nevenadres = n.identificatie AND n.typeadresseerbaarobject = 'Standplaats')
	JOIN standplaatsactueel s
	ON (aon.identificatie = s.identificatie)
	JOIN openbareruimteactueel o
	ON (n.gerelateerdeopenbareruimte = o.identificatie)
	JOIN woonplaatsactueel w
	ON (o.gerelateerdewoonplaats = w.identificatie)
	JOIN gemeente_woonplaatsactueelbestaand g
	ON (g.woonplaatscode = w.identificatie)
	JOIN provincie_gemeenteactueelbestaand p
	ON (g.gemeentecode = p.gemeentecode)
	-- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
	-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
	LEFT OUTER JOIN woonplaatsactueel wp2
	ON (n.gerelateerdewoonplaats = wp2.identificatie)
	LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
	ON (g2.woonplaatscode = wp2.identificatie)
	LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
	ON (g2.gemeentecode = p2.gemeentecode);

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
  SELECT distinct provincienaam, gemeentenaam, woonplaatsnaam, openbareruimtenaam, postcode from geo_adres
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

CREATE INDEX geo_postcode6_postcode_idx ON geo_postcode6 USING btree (postcode);
CREATE INDEX geo_postcode6_woonplaatsnaam_idx ON geo_postcode6 USING btree (woonplaatsnaam);
CREATE INDEX geo_postcode6_gemeentenaam_idx ON geo_postcode6 USING btree (gemeentenaam);
CREATE INDEX geo_postcode6_openbareruimtenaam_idx ON geo_postcode6 USING btree (openbareruimtenaam);

update geo_postcode6 AS pc6
  set geopunt =
          (SELECT ST_Force2D(geopunt)
            from geo_adres
            where postcode = pc6.postcode
                    and
                    openbareruimtenaam = pc6.openbareruimtenaam
                  limit 1);

CREATE INDEX geo_postcode6_sdx on geo_postcode6  USING GIST (geopunt);

ALTER TABLE geo_postcode6
ALTER COLUMN provincienaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN gemeentenaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN woonplaatsnaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN openbareruimtenaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN postcode SET NOT  NULL;

--
-- Postcode 4 Tabel
--
DROP TABLE IF EXISTS geo_postcode4 CASCADE;

CREATE table geo_postcode4 AS (
    SELECT distinct provincienaam, gemeentenaam, woonplaatsnaam, substring(postcode for 4) AS postcode from geo_postcode6
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
CREATE INDEX geo_postcode4_woonplaatsnaam_idx ON geo_postcode4 USING btree (woonplaatsnaam);
CREATE INDEX geo_postcode4_gemeentenaam_idx ON geo_postcode4 USING btree (gemeentenaam);

update geo_postcode4 AS pc4
  set geopunt =
          (SELECT geopunt
            from geo_postcode6
            where substr(postcode,1,4) = pc4.postcode
                  limit 1);

CREATE INDEX geo_postcode4_sdx2 on geo_postcode4  USING GIST (geopunt);

ALTER TABLE geo_postcode4
ALTER COLUMN provincienaam SET NOT  NULL;

ALTER TABLE geo_postcode4
ALTER COLUMN gemeentenaam SET NOT  NULL;

ALTER TABLE geo_postcode4
ALTER COLUMN woonplaatsnaam SET NOT  NULL;

ALTER TABLE geo_postcode6
ALTER COLUMN postcode SET NOT  NULL;

--
-- openbareruimtenaam Tabel
--
DROP TABLE IF EXISTS geo_openbareruimtenaam CASCADE;

CREATE table geo_openbareruimtenaam AS (
    SELECT distinct provincienaam, gemeentenaam, woonplaatsnaam, openbareruimtenaam from geo_postcode6
);

DROP SEQUENCE IF EXISTS geo_openbareruimtenaam_id_seq;
CREATE SEQUENCE geo_openbareruimtenaam_id_seq;

ALTER TABLE geo_openbareruimtenaam ADD id integer UNIQUE;

ALTER TABLE geo_openbareruimtenaam ALTER COLUMN id SET DEFAULT NEXTVAL('geo_openbareruimtenaam_id_seq');

UPDATE geo_openbareruimtenaam SET id = NEXTVAL('geo_openbareruimtenaam_id_seq');

ALTER TABLE geo_openbareruimtenaam ADD PRIMARY KEY (id);

SELECT AddGeometryColumn('geo_openbareruimtenaam','geopunt',28992,'POINT',2);

DROP INDEX IF EXISTS geo_openbareruimtenaam_temp_idx;
CREATE INDEX geo_openbareruimtenaam_temp_idx on geo_postcode6  USING BTREE (openbareruimtenaam);
CREATE INDEX geo_openbareruimtenaam_openbareruimtenaamidx ON geo_openbareruimtenaam USING btree (openbareruimtenaam);
CREATE INDEX geo_openbareruimtenaam_gemeentenaam_idx ON geo_openbareruimtenaam USING btree (gemeentenaam);
CREATE INDEX geo_openbareruimtenaam_woonplaatsnaam_idx ON geo_openbareruimtenaam USING btree (woonplaatsnaam);

UPDATE geo_openbareruimtenaam
  SET geopunt =
          (SELECT geopunt
            FROM geo_postcode6
            WHERE openbareruimtenaam = geo_openbareruimtenaam.openbareruimtenaam 
	    AND woonplaatsnaam = geo_openbareruimtenaam.woonplaatsnaam
		AND gemeentenaam = geo_openbareruimtenaam.gemeentenaam
		AND provincienaam = geo_openbareruimtenaam.provincienaam
                  limit 1);

-- CREATE INDEX geo_openbareruimtenaam_sdx1 on geo_openbareruimtenaam  USING GIST (geom);

CREATE INDEX geo_openbareruimtenaam_sdx2 on geo_openbareruimtenaam  USING GIST (geopunt);

ALTER TABLE geo_openbareruimtenaam
ALTER COLUMN provincienaam SET NOT  NULL;

ALTER TABLE geo_openbareruimtenaam
ALTER COLUMN gemeentenaam SET NOT  NULL;

ALTER TABLE geo_openbareruimtenaam
ALTER COLUMN woonplaatsnaam SET NOT  NULL;

ALTER TABLE geo_openbareruimtenaam
ALTER COLUMN openbareruimtenaam SET NOT  NULL;

--
-- woonplaatsnaam Tabel
--
DROP TABLE IF EXISTS geo_woonplaatsnaam CASCADE;
CREATE TABLE geo_woonplaatsnaam (
    provincienaam text NOT NULL,
    gemeentenaam character varying(250) NOT NULL,
    woonplaatsnaam character varying(250) NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.st_ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.st_srid(geopunt) = 28992))
);


-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_woonplaatsnaam (provincienaam, gemeentenaam, woonplaatsnaam, geopunt)
  SELECT
	p.provincienaam as provincienaam,
	p.gemeentenaam as gemeentenaam,
	w.woonplaatsnaam as woonplaatsnaam,
	ST_Force2D(ST_Centroid(w.geovlak)) as geopunt
FROM
	(SELECT identificatie, woonplaatsnaam, geovlak from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentecode from gemeente_woonplaatsactueelbestaand) g,
	(SELECT  gemeentenaam, gemeentecode, provincienaam from provincie_gemeenteactueelbestaand) p
WHERE
	w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

create index geo_woonplaatsnaam_sidx1 on geo_woonplaatsnaam using gist (geopunt);
CREATE INDEX geo_woonplaatsnaam_woonplaatsnaam_idx ON geo_woonplaatsnaam USING btree (woonplaatsnaam);
CREATE INDEX geo_woonplaatsnaam_woonplaatsnaam_gem_idx ON geo_woonplaatsnaam USING btree (gemeentenaam,woonplaatsnaam);

--
-- gemeentenaam Tabel
--
DROP TABLE IF EXISTS geo_gemeentenaam CASCADE;
CREATE TABLE geo_gemeentenaam (
    provincienaam text NOT NULL,
    gemeentenaam character varying(250) NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.st_ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.st_srid(geopunt) = 28992))
);


-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_gemeentenaam (provincienaam, gemeentenaam, geopunt)
  SELECT
	p.provincienaam as provincienaam,
	g.gemeentenaam as gemeentenaam,
	ST_Force2D(ST_Centroid(g.geovlak))  as geopunt
FROM
	(SELECT gemeentecode,gemeentenaam,geovlak from gemeente) g,
	(SELECT gemeentecode, provincienaam from provincie_gemeenteactueelbestaand) p
WHERE
  g.gemeentecode = p.gemeentecode;

CREATE INDEX geo_gemeentenaam_geopunt_idx ON geo_gemeentenaam USING gist (geopunt);
CREATE INDEX geo_gemeentenaam_gemeentenaam_idx ON geo_gemeentenaam USING btree (gemeentenaam);

--
-- provincienaam Tabel
--
DROP TABLE IF EXISTS geo_provincienaam CASCADE;
CREATE TABLE geo_provincienaam (
    provincienaam text NOT NULL,
    id serial,
    geopunt geometry,
    PRIMARY KEY (id),
    CONSTRAINT enforce_dims_geopunt CHECK ((public.st_ndims(geopunt) = 2)),
    CONSTRAINT enforce_geotype_geopunt CHECK (((public.geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_geopunt CHECK ((public.st_srid(geopunt) = 28992))
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO geo_provincienaam (provincienaam, geopunt)
  SELECT
	p.provincienaam as provincienaam,
	ST_Force2D(ST_Centroid(p.geovlak))as geopunt
FROM
	(SELECT provincienaam, geovlak from provincie) p;

CREATE INDEX geo_provincienaam_geopunt_idx ON geo_provincienaam USING gist (geopunt);

-- Vult de geometry_columns alleen bij PostGIS 1.x versies (dus niet in 2.x+)
-- Deze file is PostGIS 2.x compatible, voor PostGIS 1.x onderstaande regel activeren
-- select case when cast(substring(postgis_lib_version()  from 1 for 1) as numeric) < 2 then probe_geometry_columns() end;

