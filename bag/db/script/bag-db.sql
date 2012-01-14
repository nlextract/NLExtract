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
INSERT INTO bagextractinfo (sleutel,waarde) VALUES ('schema_versie', '1.0.1');
INSERT INTO bagextractinfo (sleutel,waarde) VALUES ('software_versie', '1.0.0');

-- BAG tabellen

DROP VIEW IF EXISTS ligplaatsactueelbestaand;
DROP VIEW IF EXISTS ligplaatsactueel;

DROP TABLE IF EXISTS ligplaats;
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
    CONSTRAINT enforce_geotype_geometrie CHECK (((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
    CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);
/*
CREATE VIEW ligplaatsactueel AS
    SELECT (ligplaats.oid)::character varying AS oid, ligplaats.identificatie, ligplaats.aanduidingrecordinactief, ligplaats.aanduidingrecordcorrectie, ligplaats.officieel, ligplaats.inonderzoek, ligplaats.documentnummer, ligplaats.documentdatum, ligplaats.hoofdadres, ligplaats.ligplaatsstatus, ligplaats.begindatumtijdvakgeldigheid, ligplaats.einddatumtijdvakgeldigheid, ligplaats.geovlak FROM ligplaats WHERE (((ligplaats.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (ligplaats.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((ligplaats.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW ligplaatsactueelbestaand AS
    SELECT (ligplaats.oid)::character varying AS oid, ligplaats.identificatie, ligplaats.aanduidingrecordinactief, ligplaats.aanduidingrecordcorrectie, ligplaats.officieel, ligplaats.inonderzoek, ligplaats.documentnummer, ligplaats.documentdatum, ligplaats.hoofdadres, ligplaats.ligplaatsstatus, ligplaats.begindatumtijdvakgeldigheid, ligplaats.einddatumtijdvakgeldigheid, ligplaats.geovlak FROM ligplaats WHERE ((((ligplaats.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (ligplaats.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((ligplaats.aanduidingrecordinactief)::text = 'N'::text)) AND ((ligplaats.ligplaatsstatus)::text <> 'Plaats ingetrokken'::text));
*/
DROP VIEW IF EXISTS nummeraanduidingactueel;
DROP VIEW IF EXISTS nummeraanduidingactueelbestaand;

DROP TABLE IF EXISTS nummeraanduiding;
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
/*
CREATE VIEW nummeraanduidingactueel AS
    SELECT nummeraanduiding.identificatie, nummeraanduiding.aanduidingrecordinactief, nummeraanduiding.aanduidingrecordcorrectie, nummeraanduiding.officieel, nummeraanduiding.inonderzoek, nummeraanduiding.documentnummer, nummeraanduiding.documentdatum, nummeraanduiding.huisnummer, nummeraanduiding.huisletter, nummeraanduiding.huisnummertoevoeging, nummeraanduiding.postcode, nummeraanduiding.nummeraanduidingstatus, nummeraanduiding.typeadresseerbaarobject, nummeraanduiding.gerelateerdeopenbareruimte, nummeraanduiding.gerelateerdewoonplaats, nummeraanduiding.begindatumtijdvakgeldigheid, nummeraanduiding.einddatumtijdvakgeldigheid FROM nummeraanduiding WHERE (((nummeraanduiding.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (nummeraanduiding.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((nummeraanduiding.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW nummeraanduidingactueelbestaand AS
    SELECT nummeraanduiding.identificatie, nummeraanduiding.aanduidingrecordinactief, nummeraanduiding.aanduidingrecordcorrectie, nummeraanduiding.officieel, nummeraanduiding.inonderzoek, nummeraanduiding.documentnummer, nummeraanduiding.documentdatum, nummeraanduiding.huisnummer, nummeraanduiding.huisletter, nummeraanduiding.huisnummertoevoeging, nummeraanduiding.postcode, nummeraanduiding.nummeraanduidingstatus, nummeraanduiding.typeadresseerbaarobject, nummeraanduiding.gerelateerdeopenbareruimte, nummeraanduiding.gerelateerdewoonplaats, nummeraanduiding.begindatumtijdvakgeldigheid, nummeraanduiding.einddatumtijdvakgeldigheid FROM nummeraanduiding WHERE ((((nummeraanduiding.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (nummeraanduiding.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((nummeraanduiding.aanduidingrecordinactief)::text = 'N'::text)) AND ((nummeraanduiding.nummeraanduidingstatus)::text <> 'Naamgeving ingetrokken'::text));
*/
DROP VIEW IF EXISTS openbareruimteactueel;
DROP VIEW IF EXISTS openbareruimteactueelbestaand;

DROP TABLE IF EXISTS openbareruimte;
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
/*
CREATE VIEW openbareruimteactueel AS
    SELECT openbareruimte.identificatie, openbareruimte.aanduidingrecordinactief, openbareruimte.aanduidingrecordcorrectie, openbareruimte.officieel, openbareruimte.inonderzoek, openbareruimte.documentnummer, openbareruimte.documentdatum, openbareruimte.openbareruimtenaam, openbareruimte.openbareruimtestatus, openbareruimte.openbareruimtetype, openbareruimte.gerelateerdewoonplaats, openbareruimte.verkorteopenbareruimtenaam, openbareruimte.begindatumtijdvakgeldigheid, openbareruimte.einddatumtijdvakgeldigheid FROM openbareruimte WHERE (((openbareruimte.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (openbareruimte.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((openbareruimte.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW openbareruimteactueelbestaand AS
    SELECT openbareruimte.identificatie, openbareruimte.aanduidingrecordinactief, openbareruimte.aanduidingrecordcorrectie, openbareruimte.officieel, openbareruimte.inonderzoek, openbareruimte.documentnummer, openbareruimte.documentdatum, openbareruimte.openbareruimtenaam, openbareruimte.openbareruimtestatus, openbareruimte.openbareruimtetype, openbareruimte.gerelateerdewoonplaats, openbareruimte.verkorteopenbareruimtenaam, openbareruimte.begindatumtijdvakgeldigheid, openbareruimte.einddatumtijdvakgeldigheid FROM openbareruimte WHERE ((((openbareruimte.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (openbareruimte.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((openbareruimte.aanduidingrecordinactief)::text = 'N'::text)) AND ((openbareruimte.openbareruimtestatus)::text <> 'Naamgeving ingetrokken'::text));
*/
DROP VIEW IF EXISTS pandactueel;
DROP VIEW IF EXISTS pandactueelbestaand;

DROP TABLE IF EXISTS pand;
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
    CONSTRAINT enforce_geotype_geometrie CHECK (((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
    CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);

/*
CREATE VIEW pandactueel AS
    SELECT (pand.oid)::character varying AS oid, pand.identificatie, pand.aanduidingrecordinactief, pand.aanduidingrecordcorrectie, pand.officieel, pand.inonderzoek, pand.documentnummer, pand.documentdatum, pand.pandstatus, pand.bouwjaar, pand.begindatumtijdvakgeldigheid, pand.einddatumtijdvakgeldigheid, pand.geometrie FROM pand WHERE (((pand.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (pand.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((pand.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW pandactueelbestaand AS
    SELECT (pand.oid)::character varying AS oid, pand.identificatie, pand.aanduidingrecordinactief, pand.aanduidingrecordcorrectie, pand.officieel, pand.inonderzoek, pand.documentnummer, pand.documentdatum, pand.pandstatus, pand.bouwjaar, pand.begindatumtijdvakgeldigheid, pand.einddatumtijdvakgeldigheid, pand.geometrie FROM pand WHERE (((((pand.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (pand.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((pand.aanduidingrecordinactief)::text = 'N'::text)) AND ((pand.pandstatus)::text <> 'Niet gerealiseerd pand'::text)) AND ((pand.pandstatus)::text <> 'Pand gesloopt'::text));
*/
DROP VIEW IF EXISTS standplaatsactueel;
DROP VIEW IF EXISTS standplaatsactueelbestaand;

DROP TABLE IF EXISTS standplaats;
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
    CONSTRAINT enforce_geotype_geometrie CHECK (((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
    CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
);
/*
CREATE VIEW standplaatsactueel AS
    SELECT (standplaats.oid)::character varying AS oid, standplaats.identificatie, standplaats.aanduidingrecordinactief, standplaats.aanduidingrecordcorrectie, standplaats.officieel, standplaats.inonderzoek, standplaats.documentnummer, standplaats.documentdatum, standplaats.hoofdadres, standplaats.standplaatsstatus, standplaats.begindatumtijdvakgeldigheid, standplaats.einddatumtijdvakgeldigheid, standplaats.geovlak FROM standplaats WHERE (((standplaats.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (standplaats.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((standplaats.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW standplaatsactueelbestaand AS
    SELECT (standplaats.oid)::character varying AS oid, standplaats.identificatie, standplaats.aanduidingrecordinactief, standplaats.aanduidingrecordcorrectie, standplaats.officieel, standplaats.inonderzoek, standplaats.documentnummer, standplaats.documentdatum, standplaats.hoofdadres, standplaats.standplaatsstatus, standplaats.begindatumtijdvakgeldigheid, standplaats.einddatumtijdvakgeldigheid, standplaats.geovlak FROM standplaats WHERE ((((standplaats.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (standplaats.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((standplaats.aanduidingrecordinactief)::text = 'N'::text)) AND ((standplaats.standplaatsstatus)::text <> 'Plaats ingetrokken'::text));
*/
DROP VIEW IF EXISTS verblijfsobjectactueel;
DROP VIEW IF EXISTS verblijfsobjectactueelbestaand;

DROP TABLE IF EXISTS verblijfsobject;
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
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992)),

    CONSTRAINT enforce_dims_vlak CHECK ((st_ndims(geovlak) = 3)),
    CONSTRAINT enforce_geotype_vlak CHECK (((geometrytype(geovlak) = 'POLYGON'::text) OR (geovlak IS NULL))),
    CONSTRAINT enforce_srid_vlak CHECK ((st_srid(geovlak) = 28992))
);

/*
CREATE VIEW verblijfsobjectactueel AS
    SELECT (verblijfsobject.oid)::character varying AS oid, verblijfsobject.identificatie, verblijfsobject.aanduidingrecordinactief, verblijfsobject.aanduidingrecordcorrectie, verblijfsobject.officieel, verblijfsobject.inonderzoek, verblijfsobject.documentnummer, verblijfsobject.documentdatum, verblijfsobject.hoofdadres, verblijfsobject.verblijfsobjectstatus, verblijfsobject.oppervlakteverblijfsobject, verblijfsobject.begindatumtijdvakgeldigheid, verblijfsobject.einddatumtijdvakgeldigheid, verblijfsobject.geopunt FROM verblijfsobject WHERE (((verblijfsobject.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (verblijfsobject.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((verblijfsobject.aanduidingrecordinactief)::text = 'N'::text));

CREATE VIEW verblijfsobjectactueelbestaand AS
    SELECT (verblijfsobject.oid)::character varying AS oid, verblijfsobject.identificatie, verblijfsobject.aanduidingrecordinactief, verblijfsobject.aanduidingrecordcorrectie, verblijfsobject.officieel, verblijfsobject.inonderzoek, verblijfsobject.documentnummer, verblijfsobject.documentdatum, verblijfsobject.hoofdadres, verblijfsobject.verblijfsobjectstatus, verblijfsobject.oppervlakteverblijfsobject, verblijfsobject.begindatumtijdvakgeldigheid, verblijfsobject.einddatumtijdvakgeldigheid, verblijfsobject.geopunt FROM verblijfsobject WHERE (((((verblijfsobject.begindatumtijdvakgeldigheid <= ('now'::text)::date) AND (verblijfsobject.einddatumtijdvakgeldigheid >= ('now'::text)::date)) AND ((verblijfsobject.aanduidingrecordinactief)::text = 'N'::text)) AND ((verblijfsobject.verblijfsobjectstatus)::text <> 'Niet gerealiseerd verblijfsobject'::text)) AND ((verblijfsobject.verblijfsobjectstatus)::text <> 'Verblijfsobject ingetrokken'::text));
*/


DROP TABLE IF EXISTS woonplaats;
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
    CONSTRAINT enforce_geotype_geometrie CHECK (((geometrytype(geovlak) = 'MULTIPOLYGON'::text) OR (geovlak IS NULL))),
    CONSTRAINT enforce_srid_geometrie CHECK ((st_srid(geovlak) = 28992))
)WITH (
  OIDS=TRUE
);

-- Relatie tabellen
DROP TABLE IF EXISTS verblijfsobjectgebruiksdoel;

CREATE TABLE verblijfsobjectgebruiksdoel (
    gid serial,
    identificatie numeric(16,0),
    aanduidingrecordinactief boolean,
    aanduidingrecordcorrectie integer,
    begindatumtijdvakgeldigheid timestamp without time zone,
    gebruiksdoelverblijfsobject character varying(50),
    PRIMARY KEY (gid)
);


DROP TABLE IF EXISTS verblijfsobjectpand;

CREATE TABLE verblijfsobjectpand (
    gid serial,
    identificatie numeric(16,0),
    aanduidingrecordinactief boolean,
    aanduidingrecordcorrectie integer,
    begindatumtijdvakgeldigheid timestamp without time zone,
    gerelateerdpand numeric(16,0),
    PRIMARY KEY (gid)
);

DROP TABLE IF EXISTS adresseerbaarobjectnevenadres;

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
CREATE INDEX adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, begindatumtijdvakgeldigheid, nevenadres);

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