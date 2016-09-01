-- Tabellen voor BAG-Extract
-- Min of meer 1-1 met BAG model dus niet geoptimaliseerd
-- Te gebruiken als basis tabellen om specifieke tabellen
-- aan te maken via bijvoorbeeld views of SQL selecties.
--

-- TODO optimaliseren !!

-- Systeem tabellen
-- Meta informatie, handig om te weten, wat en wanneer is ingelezen
-- bagextract.py zal bijv leverings info en BAG leverings datum inserten
DROP TABLE IF EXISTS nlx_bag_info CASCADE;
CREATE TABLE nlx_bag_info (
  gid serial,
  tijdstempel timestamp default current_timestamp,
  sleutel character varying (25),
  waarde text
);

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('schema_versie', '1.2.0');
INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('software_versie', '1.1.4');
INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('schema_creatie', to_char(current_timestamp, 'DD-Mon-IYYY HH24:MI:SS'));

-- Systeem tabellen
-- Actie log, handig om fouten en timings te analyseren
-- en iha voortgang op afstand te monitoren
DROP TABLE IF EXISTS nlx_bag_log CASCADE;
CREATE TABLE nlx_bag_log (
  gid serial,
  tijdstempel timestamp default current_timestamp,
  actie character varying (25),
  bestand text default 'n.v.t.',
  bericht text default 'geen',
  error boolean default false
);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('schema aangemaakt', 'bag-db.sql');


-- BAG _ruwe import tabellen
DROP TABLE IF EXISTS woonplaats CASCADE;
DROP TYPE IF EXISTS woonplaatsStatus CASCADE;
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
  geom_valid BOOLEAN,
  geovlak geometry(MultiPolygon, 28992),
  PRIMARY KEY (gid)
) ;

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
  verkorteOpenbareRuimteNaam VARCHAR(80),
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS nummeraanduiding CASCADE;
DROP TYPE IF EXISTS nummeraanduidingStatus  CASCADE;
CREATE TYPE nummeraanduidingStatus AS ENUM ('Naamgeving uitgegeven', 'Naamgeving ingetrokken');
DROP TYPE IF EXISTS typeAdresseerbaarObject  CASCADE;
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
  gerelateerdeWoonplaats NUMERIC(16),
  PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS ligplaats CASCADE;
DROP TYPE IF EXISTS ligplaatsStatus  CASCADE;
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
  geom_valid BOOLEAN,
  geovlak geometry(PolygonZ, 28992),
  PRIMARY KEY (gid)
) ;

DROP TABLE IF EXISTS standplaats CASCADE;
DROP TYPE IF EXISTS standplaatsStatus CASCADE;
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
  geom_valid BOOLEAN,
  geovlak geometry(PolygonZ, 28992),
  PRIMARY KEY (gid)
) ;

DROP TABLE IF EXISTS verblijfsobject CASCADE;
DROP TYPE IF EXISTS verblijfsobjectStatus CASCADE;
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
  geom_valid BOOLEAN,
  geopunt geometry(PointZ, 28992),
  geovlak geometry(PolygonZ, 28992),
  PRIMARY KEY (gid)
) ;

DROP TABLE IF EXISTS pand CASCADE;
DROP TYPE IF EXISTS pandStatus CASCADE;
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
  geom_valid BOOLEAN,
  geovlak geometry(PolygonZ, 28992),
  PRIMARY KEY (gid)

) ;
-- UPDATE pand SET geom_valid = ST_IsValid(geovlak);


--
-- START - Relatie tabellen
--

-- Verblijfsobject kan meerdere gebruiksdoelen hebben.
DROP TABLE IF EXISTS verblijfsobjectpand CASCADE;
CREATE TABLE verblijfsobjectpand (
  gid SERIAL,
  identificatie NUMERIC(16),
  aanduidingRecordInactief BOOLEAN,
  aanduidingRecordCorrectie INTEGER,
  begindatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  verblijfsobjectStatus verblijfsobjectStatus,
  geom_valid BOOLEAN,
  gerelateerdpand NUMERIC(16),
  PRIMARY KEY (gid)
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
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  ligplaatsStatus ligplaatsStatus,
  standplaatsStatus standplaatsStatus,
  verblijfsobjectStatus verblijfsobjectStatus,
  geom_valid BOOLEAN,
  nevenadres NUMERIC(16),
  PRIMARY KEY (gid)
);

-- Een Verblijfsobject kan meerdere gebruiksdoelen hebben
DROP TABLE IF EXISTS verblijfsobjectgebruiksdoel CASCADE;
DROP TYPE IF EXISTS gebruiksdoelVerblijfsobject CASCADE;
CREATE TYPE gebruiksdoelVerblijfsobject AS ENUM (
'woonfunctie','bijeenkomstfunctie','celfunctie','gezondheidszorgfunctie','industriefunctie','kantoorfunctie',
'logiesfunctie','onderwijsfunctie','sportfunctie','winkelfunctie','overige gebruiksfunctie'
);
CREATE TABLE verblijfsobjectgebruiksdoel (
  gid serial,
  identificatie numeric(16,0),
  aanduidingrecordinactief boolean,
  aanduidingrecordcorrectie integer,
  begindatumtijdvakgeldigheid timestamp without time zone,
  einddatumTijdvakGeldigheid TIMESTAMP WITHOUT TIME ZONE,
  verblijfsobjectStatus verblijfsobjectStatus,
  geom_valid BOOLEAN,
  gebruiksdoelverblijfsobject gebruiksdoelVerblijfsobject,
  PRIMARY KEY (gid)
);

--
-- END - Relatie tabellen
--

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
CREATE INDEX verblijfsobjectpand_pand ON verblijfsobjectpand USING btree (gerelateerdpand);
CREATE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, gebruiksdoelverblijfsobject);
CREATE INDEX
        adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, nevenadres);

-- Moet in de pas lopen met CSV ../data/kadaster-gemeente-woonplaats-<datum>.csv
-- Vesie van 6 maart heeft CSV header
-- Woonplaats;Woonplaats code;Ingangsdatum WPL;Einddatum WPL;Gemeente;Gemeente code;
--     Ingangsdatum nieuwe gemeente;Gemeente beeindigd per
DROP TABLE IF EXISTS gemeente_woonplaats CASCADE;
DROP TYPE IF EXISTS gemeenteWoonplaatsStatus CASCADE;
CREATE TYPE gemeenteWoonplaatsStatus AS ENUM (
'voorlopig','definitief'
);
CREATE TABLE gemeente_woonplaats (
  gid serial,
  begindatumtijdvakgeldigheid TIMESTAMP WITHOUT TIME ZONE,
  einddatumtijdvakgeldigheid TIMESTAMP WITHOUT TIME ZONE,
  woonplaatscode numeric(4),
  gemeentecode numeric(4),
  status gemeenteWoonplaatsStatus,
  PRIMARY KEY (gid)
);

CREATE INDEX gem_wpl_woonplaatscode_idx ON gemeente_woonplaats USING btree (woonplaatscode);
CREATE INDEX gem_wpl_gemeentecode_datum_idx ON gemeente_woonplaats USING btree (gemeentecode);

DROP TABLE IF EXISTS gemeente_provincie CASCADE;

DROP TABLE IF EXISTS provincie_gemeente CASCADE;
CREATE TABLE provincie_gemeente (
  gid serial,
  provinciecode numeric(4),
  provincienaam character varying(80),
  gemeentecode numeric(4),
  gemeentenaam character varying(80),
  begindatum TIMESTAMP WITHOUT TIME ZONE,
  einddatum TIMESTAMP WITHOUT TIME ZONE,
  PRIMARY KEY (gid)
);

-- Functie om lege probe_geometry_columns() functie aan te maken voor PostGIS 2+
-- probe_geometry_columns() is namelijk niet aanwezig in PostGIS 2+.
CREATE OR REPLACE FUNCTION public._nlx_add_fn_probe_geometry_columns() RETURNS void AS $$
BEGIN
  IF postgis_lib_version() >= '2' THEN
    CREATE OR REPLACE FUNCTION public.probe_geometry_columns() RETURNS varchar AS
      'BEGIN RETURN NULL; END;' LANGUAGE plpgsql;
  END IF;
END;
$$ LANGUAGE plpgsql;
SELECT public._nlx_add_fn_probe_geometry_columns();

-- Populeert public.geometry_columns
-- Dummy voor PostGIS 2+
SELECT public.probe_geometry_columns();
