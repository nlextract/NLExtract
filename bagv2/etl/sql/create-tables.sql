-- Tabellen voor BAG-Extract v2
-- Min of meer 1-1 met BAG model dus niet geoptimaliseerd
-- Te gebruiken als basis tabellen om specifieke tabellen
-- aan te maken via bijvoorbeeld VIEWs of SQL selecties.
-- Op alfabet.
-- Author: Just van den Broecke

-- Common
DROP TYPE IF EXISTS statusNaamgeving  CASCADE;
CREATE TYPE statusNaamgeving AS ENUM ('Naamgeving uitgegeven', 'Naamgeving ingetrokken');

-- LIG
DROP TABLE IF EXISTS ligplaats CASCADE;
DROP TYPE IF EXISTS ligplaatsStatus  CASCADE;
CREATE TYPE ligplaatsStatus AS ENUM ('Plaats aangewezen', 'Plaats ingetrokken');

CREATE TABLE ligplaats
(
    gid serial,
    identificatie character varying(16),

    hoofdadresnummeraanduidingref character varying(16),
    nevenadresnummeraanduidingref character varying(16) ARRAY,
    status ligplaatsStatus,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    geovlak geometry(Polygon, 28992),

    PRIMARY KEY (gid)
)
;

-- NUM
DROP TABLE IF EXISTS nummeraanduiding CASCADE;
DROP TYPE IF EXISTS typeAdresseerbaarObject  CASCADE;
CREATE TYPE typeAdresseerbaarObject AS ENUM ('Verblijfsobject', 'Standplaats', 'Ligplaats');

CREATE TABLE nummeraanduiding
(
    gid serial,
    identificatie character varying(16),

    huisnummer integer,
    huisletter character varying(1),
    huisnummertoevoeging character varying(4),
    postcode character varying(6),
    typeadresseerbaarobject typeAdresseerbaarObject,
    openbareruimteref character varying(16) not null,
    woonplaatsref character varying(16),
    status statusNaamgeving,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    PRIMARY KEY (gid)
)
;

-- OPR
DROP TABLE IF EXISTS openbareruimte CASCADE;
DROP TYPE IF EXISTS openbareRuimteType  CASCADE;
CREATE TYPE openbareRuimteType AS ENUM (
    'Weg',
    'Water',
    'Spoorbaan',
    'Terrein',
    'Kunstwerk',
    'Landschappelijk gebied',
    'Administratief gebied');

CREATE TABLE openbareruimte
(
    gid serial,
    identificatie character varying(16),

    naam character varying(80),
    verkorteNaam character varying(24),
    type openbareRuimteType,
    woonplaatsref character varying(16),
    status statusNaamgeving,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    PRIMARY KEY (gid)
)
;

-- PND
DROP TABLE IF EXISTS pand CASCADE;
DROP TYPE IF EXISTS pandStatus  CASCADE;

-- 2 nieuwe statussen t.o.v. BAG v1:
-- 'Verbouwing pand','Pand ten onrechte opgevoerd'
CREATE TYPE pandStatus AS ENUM (
    'Bouwvergunning verleend',
    'Niet gerealiseerd pand',
    'Bouw gestart',
    'Verbouwing pand',
    'Pand in gebruik (niet ingemeten)',
    'Pand in gebruik',
    'Sloopvergunning verleend',
    'Pand gesloopt',
    'Pand buiten gebruik',
    'Pand ten onrechte opgevoerd'
    );

CREATE TABLE pand
(
    gid serial,
    identificatie character varying(16),
    oorspronkelijkbouwjaar integer,
    status pandStatus,
    
    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    geovlak geometry(MultiPolygon, 28992),

    PRIMARY KEY (gid)
)
;

-- STA
DROP TABLE IF EXISTS standplaats CASCADE;
DROP TYPE IF EXISTS standplaatsStatus CASCADE;
CREATE TYPE standplaatsStatus AS ENUM ('Plaats aangewezen', 'Plaats ingetrokken');
CREATE TABLE standplaats
(
    gid serial,
    identificatie character varying(16),

    hoofdadresnummeraanduidingref character varying(16),
    nevenadresnummeraanduidingref character varying(16) ARRAY,
    status standplaatsStatus,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    geovlak geometry(Polygon, 28992),

    PRIMARY KEY (gid)
)
;

-- VBO
DROP TABLE IF EXISTS verblijfsobject CASCADE;
DROP TYPE IF EXISTS gebruiksdoelVerblijfsobject CASCADE;
DROP TYPE IF EXISTS verblijfsobjectStatus CASCADE;

CREATE TYPE gebruiksdoelVerblijfsobject AS ENUM (
'woonfunctie','bijeenkomstfunctie','celfunctie','gezondheidszorgfunctie','industriefunctie','kantoorfunctie',
'logiesfunctie','onderwijsfunctie','sportfunctie','winkelfunctie','overige gebruiksfunctie'
);

-- Nieuw in v2: 'Verbouwing verblijfsobject','Verblijfsobject ten onrechte opgevoerd'
CREATE TYPE verblijfsobjectStatus AS ENUM (
    'Verblijfsobject gevormd',
    'Niet gerealiseerd verblijfsobject',
    'Verblijfsobject in gebruik (niet ingemeten)',
    'Verblijfsobject in gebruik',
    'Verbouwing verblijfsobject',
    'Verblijfsobject ingetrokken',
    'Verblijfsobject buiten gebruik',
    'Verblijfsobject ten onrechte opgevoerd'
    );

CREATE TABLE verblijfsobject
(
    gid serial,
    identificatie character varying(16),

    gebruiksdoel character varying ARRAY,
    oppervlakte integer,
    hoofdadresnummeraanduidingref character varying(16),
    nevenadresnummeraanduidingref character varying(16) ARRAY,
    pandref character varying(16) ARRAY,
    status verblijfsobjectStatus,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    geopunt geometry(Point,28992),

    PRIMARY KEY (gid)
)
;

-- WPL
DROP TABLE IF EXISTS woonplaats CASCADE;
DROP TYPE IF EXISTS woonplaatsStatus  CASCADE;
CREATE TYPE woonplaatsStatus AS ENUM ('Woonplaats aangewezen', 'Woonplaats ingetrokken');

CREATE TABLE woonplaats
(
    gid serial,
    identificatie character varying(16),

    naam character varying,
    status woonplaatsStatus,

    geconstateerd boolean,
    documentdatum date,
    documentnummer character varying(40),
    voorkomenidentificatie integer,
    begingeldigheid timestamp with time zone,
    eindgeldigheid timestamp with time zone,
    tijdstipregistratie timestamp with time zone,
    eindregistratie timestamp with time zone,
    tijdstipinactief timestamp with time zone,
    tijdstipregistratielv timestamp with time zone,
    tijdstipeindregistratielv timestamp with time zone,
    tijdstipinactieflv timestamp with time zone,
    tijdstipnietbaglv timestamp with time zone,

    geovlak geometry(MultiPolygon, 28992),

    PRIMARY KEY (gid)
);

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
  begingeldigheid timestamp with time zone,
  eindgeldigheid timestamp with time zone,
  woonplaatscode varchar(4),
  gemeentecode varchar(4),
  status gemeenteWoonplaatsStatus,
  geometry geometry(Point,28992),
  PRIMARY KEY (gid)
);

CREATE INDEX gem_wpl_woonplaatscode_idx ON gemeente_woonplaats USING btree (woonplaatscode);
CREATE INDEX gem_wpl_gemeentecode_datum_idx ON gemeente_woonplaats USING btree (gemeentecode);

DROP TABLE IF EXISTS gemeente_provincie CASCADE;

DROP TABLE IF EXISTS provincie_gemeente CASCADE;
CREATE TABLE provincie_gemeente (
  -- follows CBS XLS/CSV column-naming,

--   provinciecode numeric(4),
--   provincienaam character varying(80),
--   gemeentecode varchar(4),
--   gemeentenaam character varying(80),
--   begindatum timestamp with time zone,
--   einddatum timestamp with time zone,

  gemeentecode character varying(4),
  gemeentecodegm character varying(80),
  gemeentenaam character varying(80),
  provinciecode numeric(2),
  provinciecodepv character varying(4),
  provincienaam character varying(80),

  PRIMARY KEY (gemeentecode)
);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('tabellen aangemaakt', 'create-tables.sql');
