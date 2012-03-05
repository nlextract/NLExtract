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
        VALUES ('schema_versie', '1.0.2');
INSERT INTO bagextractinfo (sleutel,waarde)
        VALUES ('software_versie', '1.0.0');

-- Relatie tabellen
-- Verblijfsobject kan meerdere gebruiksdoelen hebben.
DROP TABLE IF EXISTS verblijfsobjectpand CASCADE;
CREATE TABLE verblijfsobjectpand (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  gerelateerdpand NUMERIC(16)
);


-- Verblijfsobjecten maken altijd deel uit van een of meerdere panden.
-- Panden hoeven geen verblijfsobjecten te bevatten.
DROP TABLE IF EXISTS adresseerbaarobjectnevenadres CASCADE;
CREATE TABLE adresseerbaarobjectnevenadres (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  nevenadres NUMERIC(16)
);


DROP TABLE IF EXISTS verblijfsobjectgebruiksdoel CASCADE;
CREATE TABLE verblijfsobjectgebruiksdoel (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  gebruiksdoelverblijfsobject VARCHAR(50)
);


-- BAG _ruwe import tabellen
DROP TABLE IF EXISTS woonplaats CASCADE;
DROP TYPE IF EXISTS woonplaatsStatus;
CREATE TYPE woonplaatsStatus AS ENUM ('Woonplaats aangewezen', 'Woonplaats ingetrokken');
CREATE TABLE woonplaats (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  woonplaatsNaam VARCHAR(80),
  woonplaatsStatus woonplaatsStatus,
  geom_valid BOOLEAN
) WITH (OIDS=true);
SELECT AddGeometryColumn('public', 'woonplaats', 'geovlak', 28992, 'MULTIPOLYGON', 2);


DROP TABLE IF EXISTS openbareruimte CASCADE;
DROP TYPE IF EXISTS openbareRuimteStatus;
CREATE TYPE openbareRuimteStatus AS ENUM ('Naamgeving uitgegeven', 'Naamgeving ingetrokken');
DROP TYPE IF EXISTS openbareRuimteType;
CREATE TYPE openbareRuimteType AS ENUM ('Weg', 'Water', 'Spoorbaan', 'Terrein', 'Kunstwerk', 'Landschappelijk gebied', 'Administratief gebied');
CREATE TABLE openbareruimte (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  openbareRuimteNaam VARCHAR(80),
  openbareRuimteStatus openbareRuimteStatus,
  openbareRuimteType openbareRuimteType,
  gerelateerdeWoonplaats NUMERIC(16),
  verkorteOpenbareRuimteNaam VARCHAR(80)
);


DROP TABLE IF EXISTS nummeraanduiding CASCADE;
DROP TYPE IF EXISTS nummeraanduidingStatus;
CREATE TYPE nummeraanduidingStatus AS ENUM ('Naamgeving uitgegeven', 'Naamgeving ingetrokken');
DROP TYPE IF EXISTS typeAdresseerbaarObject;
CREATE TYPE typeAdresseerbaarObject AS ENUM ('Verblijfsobject', 'Standplaats', 'Ligplaats');
CREATE TABLE nummeraanduiding (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  huisnummer NUMERIC(5),
  huisletter VARCHAR(1),
  huisnummertoevoeging VARCHAR(4),
  postcode VARCHAR(6),
  nummeraanduidingStatus nummeraanduidingStatus,
  typeAdresseerbaarObject typeAdresseerbaarObject,
  gerelateerdeOpenbareRuimte NUMERIC(16),
  gerelateerdeWoonplaats NUMERIC(16)
);


DROP TABLE IF EXISTS ligplaats CASCADE;
DROP TYPE IF EXISTS ligplaatsStatus;
CREATE TYPE ligplaatsStatus AS ENUM ('Plaats aangewezen', 'Plaats ingetrokken');
CREATE TABLE ligplaats (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  hoofdadres NUMERIC(16),
  ligplaatsStatus ligplaatsStatus,
  geom_valid BOOLEAN
) WITH (OIDS=true);
SELECT AddGeometryColumn('public', 'ligplaats', 'geovlak', 28992, 'POLYGON', 3);


DROP TABLE IF EXISTS standplaats CASCADE;
DROP TYPE IF EXISTS standplaatsStatus;
CREATE TYPE standplaatsStatus AS ENUM ('Plaats aangewezen', 'Plaats ingetrokken');
CREATE TABLE standplaats (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  hoofdadres NUMERIC(16),
  standplaatsStatus standplaatsStatus,
  geom_valid BOOLEAN
) WITH (OIDS=true);
SELECT AddGeometryColumn('public', 'standplaats', 'geovlak', 28992, 'POLYGON', 3);


DROP TABLE IF EXISTS verblijfsobject CASCADE;
DROP TYPE IF EXISTS verblijfsobjectStatus;
CREATE TYPE verblijfsobjectStatus AS ENUM ('Verblijfsobject gevormd', 'Niet gerealiseerd verblijfsobject', 'Verblijfsobject in gebruik (niet ingemeten)', 'Verblijfsobject in gebruik', 'Verblijfsobject ingetrokken', 'Verblijfsobject buiten gebruik');
CREATE TABLE verblijfsobject (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  hoofdadres NUMERIC(16),
  verblijfsobjectStatus verblijfsobjectStatus,
  oppervlakteVerblijfsobject NUMERIC(6),
  geom_valid BOOLEAN
) WITH (OIDS=true);
SELECT AddGeometryColumn('public', 'verblijfsobject', 'geopunt', 28992, 'POINT', 3);
SELECT AddGeometryColumn('public', 'verblijfsobject', 'geovlak', 28992, 'POLYGON', 3);


DROP TABLE IF EXISTS pand CASCADE;
DROP TYPE IF EXISTS pandStatus;
CREATE TYPE pandStatus AS ENUM ('Bouwvergunning verleend', 'Niet gerealiseerd pand', 'Bouw gestart', 'Pand in gebruik (niet ingemeten)', 'Pand in gebruik', 'Sloopvergunning verleend', 'Pand gesloopt', 'Pand buiten gebruik');
CREATE TABLE pand (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  officieel BOOLEAN,
  inOnderzoek BOOLEAN,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  documentnummer VARCHAR(20),
  documentdatum DATE,
  pandStatus pandStatus,
  bouwjaar NUMERIC(4),
  geom_valid BOOLEAN
) WITH (OIDS=true);
SELECT AddGeometryColumn('public', 'pand', 'geovlak', 28992, 'POLYGON', 3);


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

-- Maak geometrie indexen
CREATE INDEX ligplaats_geom_idx ON ligplaats USING gist (geovlak);
CREATE INDEX pand_geom_idx ON pand USING gist (geovlak);
CREATE INDEX standplaats_geom_idx ON standplaats USING gist (geovlak);
CREATE INDEX verblijfsobject_punt_idx ON verblijfsobject USING gist (geopunt);
CREATE INDEX verblijfsobject_vlak_idx ON verblijfsobject USING gist (geovlak);
CREATE INDEX woonplaats_vlak_idx ON woonplaats USING gist (geovlak);

-- Unieke key indexen
CREATE INDEX ligplaats_key ON ligplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE INDEX standplaats_key ON standplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE INDEX verblijfsobject_key ON verblijfsobject USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE INDEX pand_key ON pand USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
-- met nummeraanduiding lijkt een probleem als unieke index  (in de gaten houden)
CREATE INDEX nummeraanduiding_key ON nummeraanduiding USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE INDEX openbareruimte_key ON openbareruimte USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);
CREATE INDEX woonplaats_key ON woonplaats USING btree (identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid);

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

select probe_geometry_columns();
