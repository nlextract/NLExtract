-- Tabellen voor BAGExtract+
-- Min of meer 1-1 met BAG model dus niet geoptimaliseerd
-- Te gebruiken als basis tabellen om specifieke tabellen
-- aan te maken via bijvoorbeeld views of SQL selecties.
--

-- TODO optimaliseren !!

-- Systeem tabellen
DROP TABLE IF EXISTS bagextractpluslog;
/*
-- Niet meer loggen in de database
CREATE TABLE bagextractpluslog (
    datum date,
    actie character varying(1000),
    bestand character varying(1000),
    logfile character varying(1000)
);
*/

DROP TABLE IF EXISTS bagextractinfo;
CREATE TABLE bagextractinfo (
  gid serial,
  sleutel character varying (25),
  waarde character varying (100)
);
INSERT INTO bagextractinfo (sleutel,waarde)
        VALUES ('schema_versie', '1.0.1');
INSERT INTO bagextractinfo (sleutel,waarde)
        VALUES ('software_versie', '1.0.0');

-- BAG tabellen
DROP TABLE IF EXISTS ligplaats CASCADE;
CREATE TABLE ligplaats (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  hoofdadres numeric(16,0),
  ligplaatsstatus character varying(80),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  geovlak geometry,
  PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geometrie CHECK ((st_ndims(geovlak) = 3)),
  CONSTRAINT enforce_geotype_geometrie CHECK (
          ((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
  CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);

DROP TABLE IF EXISTS nummeraanduiding CASCADE;
CREATE TABLE nummeraanduiding (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  huisnummer numeric(5,0),
  huisletter character varying(1),
  huisnummertoevoeging character varying(4),
  postcode character varying(6),
  nummeraanduidingstatus character varying(80),
  typeadresseerbaarobject character varying(20),
  gerelateerdeopenbareruimte numeric(16,0),
  gerelateerdewoonplaats numeric(16,0),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS openbareruimte CASCADE;
CREATE TABLE openbareruimte (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  openbareruimtenaam character varying(80),
  openbareruimtestatus character varying(80),
  openbareruimtetype character varying(40),
  gerelateerdewoonplaats numeric(16,0),
  verkorteopenbareruimtenaam character varying(80),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS pand CASCADE;
CREATE TABLE pand (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  pandstatus character varying(80),
  bouwjaar numeric(4,0),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  geovlak geometry,
  PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geometrie CHECK ((st_ndims(geovlak) = 3)),
  CONSTRAINT enforce_geotype_geometrie CHECK (
          ((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
  CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);

DROP TABLE IF EXISTS standplaats CASCADE;
CREATE TABLE standplaats (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  hoofdadres numeric(16,0),
  standplaatsstatus character varying(80),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  geovlak geometry,
  PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geometrie CHECK ((st_ndims(geovlak) = 3)),
  CONSTRAINT enforce_geotype_geometrie CHECK (
          ((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
  CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);

DROP TABLE IF EXISTS verblijfsobject CASCADE;
CREATE TABLE verblijfsobject (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  hoofdadres numeric(16,0),
  verblijfsobjectstatus character varying(80),
  oppervlakteverblijfsobject numeric(6,0),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  geopunt geometry,
  geovlak geometry,
  PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
  CONSTRAINT enforce_geotype_punt CHECK (
          ((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
  CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992)),

  CONSTRAINT enforce_dims_vlak CHECK ((st_ndims(geovlak) = 3)),
  CONSTRAINT enforce_geotype_vlak CHECK (
          ((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
  CONSTRAINT enforce_srid_vlak CHECK ((st_srid(geovlak) = 28992))
);

DROP TABLE IF EXISTS woonplaats CASCADE;
CREATE TABLE woonplaats (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  officieel boolean,
  inonderzoek boolean,
  documentnummer character varying(20),
  documentdatum date,
  woonplaatsnaam character varying(80),
  woonplaatsstatus character varying(80),
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumtijdvakgeldigheid timestamp without time zone,
  geovlak geometry,
  PRIMARY KEY (gid),
  CONSTRAINT enforce_dims_geometrie CHECK ((st_ndims(geovlak) = 2)),
  CONSTRAINT enforce_geotype_geometrie CHECK (
          ((geometrytype(geovlak) = 'MULTIPOLYGON'::text) OR (geovlak IS NULL))),
  CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
)WITH (
        OIDS=TRUE
);

-- Relatie tabellen
DROP TABLE IF EXISTS verblijfsobjectgebruiksdoel CASCADE;

CREATE TABLE verblijfsobjectgebruiksdoel (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  begindatumtijdvakgeldigheid timestamp without time zone,
  gebruiksdoelverblijfsobject character varying(50),
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS verblijfsobjectpand CASCADE;

CREATE TABLE verblijfsobjectpand (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  begindatumtijdvakgeldigheid timestamp without time zone,
  gerelateerdpand numeric(16,0),
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS adresseerbaarobjectnevenadres CASCADE;

CREATE TABLE adresseerbaarobjectnevenadres (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  begindatumtijdvakgeldigheid timestamp without time zone,
  nevenadres numeric(16,0),
  PRIMARY KEY (gid)
);

-- Maak geometrie indexen
CREATE INDEX ligplaats_geom_idx ON ligplaats USING gist (geovlak);
CREATE INDEX pand_geom_idx ON pand USING gist (geovlak);
CREATE INDEX standplaats_geom_idx ON standplaats USING gist (geovlak);
CREATE INDEX verblijfsobject_punt_idx ON verblijfsobject USING gist (geopunt);
CREATE INDEX verblijfsobject_vlak_idx ON verblijfsobject USING gist (geovlak);
CREATE INDEX woonplaats_vlak_idx ON woonplaats USING gist (geovlak);

-- Unieke key indexen
CREATE UNIQUE INDEX ligplaats_key ON ligplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX standplaats_key ON standplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX verblijfsobject_key ON verblijfsobject USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX pand_key ON pand USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
-- met nummeraanduiding lijkt een probleem als unieke index
CREATE UNIQUE INDEX nummeraanduiding_key ON nummeraanduiding USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX openbareruimte_key ON openbareruimte USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX woonplaats_key ON woonplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);

-- Overige indexen
CREATE INDEX nummeraanduiding_postcode ON nummeraanduiding USING btree (postcode);
CREATE INDEX openbareruimte_naam ON openbareruimte USING btree (openbareruimtenaam);
CREATE INDEX woonplaats_naam ON woonplaats USING btree (woonplaatsnaam);

-- Indexen relatie tabellen
CREATE INDEX verblijfsobjectpandkey ON verblijfsobjectpand USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, gerelateerdpand);
CREATE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, gebruiksdoelverblijfsobject);
CREATE INDEX
        adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, nevenadres);

DROP TABLE IF EXISTS gemeente_woonplaats;
CREATE TABLE gemeente_woonplaats (
  gid serial,
  woonplaatsnaam character varying(80),
  woonplaatscode numeric(4),
  begindatum_woonplaats date,
  einddatum_woonplaats date,
  gemeentenaam character varying(80),
  gemeentecode numeric(4),
  begindatum_gemeente date,
  aansluitdatum_gemeente date,
  bijzonderheden text,
  gemeentecode_nieuw numeric(4),
  einddatum_gemeente date,
  behandeld character varying(1),
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS gemeente_provincie;
CREATE TABLE gemeente_provincie (
  gid serial,
  gemeentecode numeric(4),
  gemeentenaam character varying(80),
  provinciecode numeric(4),
  provincienaam character varying(80),
  PRIMARY KEY (gid)
);