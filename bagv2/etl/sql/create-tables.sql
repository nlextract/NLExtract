-- Tabellen voor BAG-Extract v2
-- Min of meer 1-1 met BAG model dus niet geoptimaliseerd
-- Te gebruiken als basis tabellen om specifieke tabellen
-- aan te maken via bijvoorbeeld VIEWs of SQL selecties.
-- Op alfabet.

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
    nevenadresnummeraanduidingref character varying,
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
TABLESPACE pg_default;

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
    openbareruimteref character varying(16),
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
TABLESPACE pg_default;

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
TABLESPACE pg_default;

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
TABLESPACE pg_default;

-- STA
DROP TABLE IF EXISTS standplaats CASCADE;
DROP TYPE IF EXISTS standplaatsStatus CASCADE;
CREATE TYPE standplaatsStatus AS ENUM ('Plaats aangewezen', 'Plaats ingetrokken');
CREATE TABLE standplaats
(
    gid serial,
    identificatie character varying(16),

    hoofdadresnummeraanduidingref character varying(16),
    nevenadresnummeraanduidingref character varying,
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
TABLESPACE pg_default;

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

    gebruiksdoel character varying,
    oppervlakte integer,
    hoofdadresnummeraanduidingref character varying(16),
    nevenadresnummeraanduidingref character varying,
    pandref character varying,
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
TABLESPACE pg_default;

-- WPL
DROP TABLE IF EXISTS woonplaats CASCADE;
DROP TYPE IF EXISTS woonplaatsStatus  CASCADE;
CREATE TYPE woonplaatsStatus AS ENUM ('Woonplaats aangewezen', 'Woonplaats ingetrokken');

CREATE TABLE woonplaats
(
    gid serial,
    identificatie character varying(16),

    naam character varying,
    status character varying,

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
TABLESPACE pg_default;
