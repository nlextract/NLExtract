-- Views voor BAG tabellen
-- BAG Objecten kunnen niet-actueel of zelfs niet bestaand (beeindigd) zijn
-- Via Views kunnen actuele en bestaande objecten uitgefilterd worden.
-- Author: Just van den Broecke

-- Gebruik BAG stand datum in plaats van NOW/LOCALTIMESTAMP
CREATE VIEW extract_datum AS
  SELECT waarde::timestamp
  FROM nlx_bag_info
  WHERE sleutel = 'extract_datum';

-- Feitelijk is de "actueel" definitie:
-- begingeldigheid <= extract_datum()
--  AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
--  AND (tijdstipinactief is NULL)
--  AND (tijdstipnietbaglv is NULL)

-- SET search_path TO test,public;
-- LIG
DROP VIEW IF EXISTS ligplaatsactueel;
CREATE VIEW ligplaatsactueel AS
  SELECT lig.* FROM ligplaats lig
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS ligplaatsactueelbestaand;
CREATE VIEW ligplaatsactueelbestaand AS
  SELECT lig.* FROM ligplaats lig
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND status != 'Plaats ingetrokken';

-- NUM
DROP VIEW IF EXISTS nummeraanduidingactueel;
CREATE VIEW nummeraanduidingactueel AS
  SELECT num.*
  FROM nummeraanduiding num
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS nummeraanduidingactueelbestaand;
CREATE VIEW nummeraanduidingactueelbestaand AS
  SELECT num.* FROM nummeraanduiding num
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND status != 'Naamgeving ingetrokken';

-- OPR
DROP VIEW IF EXISTS openbareruimteactueel;
CREATE VIEW openbareruimteactueel AS
  SELECT opr.* FROM openbareruimte opr
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS openbareruimteactueelbestaand;
CREATE VIEW openbareruimteactueelbestaand AS
  SELECT opr.* FROM openbareruimte opr
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND status != 'Naamgeving ingetrokken';

-- PND
DROP VIEW IF EXISTS pandactueel;
CREATE VIEW pandactueel AS
  SELECT pnd.* FROM pand pnd
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS pandactueelbestaand;
CREATE VIEW pandactueelbestaand AS
  SELECT pnd.* FROM pand pnd
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND (status != 'Niet gerealiseerd pand'
    AND status != 'Pand gesloopt'
    AND status != 'Bouwvergunning verleend'
    AND status != 'Pand ten onrechte opgevoerd' )
;

-- STA
DROP VIEW IF EXISTS standplaatsactueel;
CREATE VIEW standplaatsactueel AS
  SELECT sta.* FROM standplaats sta
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS standplaatsactueelbestaand;
CREATE VIEW standplaatsactueelbestaand AS
  SELECT sta.* FROM standplaats sta
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND status != 'Plaats ingetrokken';

-- VBO
DROP VIEW IF EXISTS verblijfsobjectactueel;
CREATE VIEW verblijfsobjectactueel AS
  SELECT vbo.* FROM verblijfsobject vbo
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;


DROP VIEW IF EXISTS verblijfsobjectactueelbestaand;
CREATE VIEW verblijfsobjectactueelbestaand AS
  SELECT vbo.* FROM verblijfsobject vbo
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND (status != 'Niet gerealiseerd verblijfsobject'
    AND status  != 'Verblijfsobject ingetrokken'
    AND status  != 'Verblijfsobject ten onrechte opgevoerd');

-- JvdB removed AND status  <> 'Verblijfsobject gevormd', see issue #173
-- https://github.com/nlextract/NLExtract/issues/173  23.3.16
--

-- WPL
DROP VIEW IF EXISTS woonplaatsactueel;
CREATE VIEW woonplaatsactueel AS
  SELECT wpl.* FROM woonplaats wpl
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
;

DROP VIEW IF EXISTS woonplaatsactueelbestaand;
CREATE VIEW woonplaatsactueelbestaand AS
  SELECT wpl.* FROM woonplaats wpl
  JOIN extract_datum ON 1=1
  WHERE
    begingeldigheid <= extract_datum()
    AND (eindgeldigheid is NULL OR eindgeldigheid > extract_datum())
    AND status  != 'Woonplaats ingetrokken';

-- KOPPELTABELLEN

DROP VIEW IF EXISTS gemeente_woonplaatsactueelbestaand;
CREATE VIEW gemeente_woonplaatsactueelbestaand AS
  SELECT  gw.gid,
          gw.begingeldigheid,
          gw.eindgeldigheid,
          gw.woonplaatscode,
          gw.gemeentecode,
          gw.status
  FROM gemeente_woonplaats as gw
  JOIN extract_datum ON 1=1
  WHERE
    gw.begingeldigheid <= extract_datum()
    AND (gw.eindgeldigheid is NULL OR gw.eindgeldigheid > extract_datum())
    AND gw.status = 'definitief';

DROP VIEW IF EXISTS provincie_gemeenteactueelbestaand;
CREATE VIEW provincie_gemeenteactueelbestaand AS
  SELECT  pg.gid,
          pg.provinciecode,
          pg.provincienaam,
          pg.gemeentecode,
          pg.gemeentenaam,
          pg.begindatum,
          pg.einddatum
  FROM provincie_gemeente AS pg
  JOIN extract_datum ON 1=1
  WHERE
    pg.begindatum <= extract_datum.waarde
    AND (pg.einddatum IS NULL OR pg.einddatum > extract_datum.waarde);


-- START RELATIE TABELLEN

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueel;
CREATE VIEW adresseerbaarobjectnevenadresactueel AS
  SELECT aon.*
  FROM adresseerbaarobjectnevenadres as aon
  JOIN extract_datum ON 1=1
  WHERE
    aon.begingeldigheid <= extract_datum()
    AND (aon.eindgeldigheid is NULL OR aon.eindgeldigheid > extract_datum())
    AND (aon.tijdstipinactief is NULL OR aon.tijdstipinactief > extract_datum.waarde);

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueelbestaand;
CREATE VIEW adresseerbaarobjectnevenadresactueelbestaand AS
  SELECT aon.*
  FROM adresseerbaarobjectnevenadres as aon
  JOIN extract_datum ON 1=1
  WHERE
    aon.begingeldigheid <= extract_datum()
    AND (aon.eindgeldigheid is NULL OR aon.eindgeldigheid > extract_datum())
    AND (aon.tijdstipinactief is NULL OR aon.tijdstipinactief > extract_datum.waarde)
    AND ((aon.ligplaatsstatus <> 'Plaats ingetrokken' OR aon.ligplaatsstatus is NULL) AND
         (aon.standplaatsstatus <> 'Plaats ingetrokken' OR aon.standplaatsstatus is NULL) AND
         ((aon.verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject' AND
           aon.verblijfsobjectStatus <> 'Verblijfsobject ingetrokken' AND
           aon.verblijfsobjectStatus <> 'Verblijfsobject ten onrechte opgevoerd') OR
          aon.verblijfsobjectStatus is NULL));

-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, begingeldigheid, eindgeldigheid, verblijfsobjectStatus from adresseerbaarobjectnevenadresactueel;
-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, begingeldigheid, eindgeldigheid, verblijfsobjectStatus from adresseerbaarobjectnevenadresactueelbestaand;

DROP VIEW IF EXISTS verblijfsobjectpandactueel;
CREATE VIEW verblijfsobjectpandactueel AS
  SELECT vbop.*
  FROM verblijfsobjectpand as vbop
  JOIN extract_datum ON 1=1
  WHERE
    vbop.begingeldigheid <= extract_datum()
    AND (vbop.eindgeldigheid is NULL OR vbop.eindgeldigheid > extract_datum())
    AND (vbop.tijdstipinactief is NULL OR vbop.tijdstipinactief > extract_datum.waarde);

DROP VIEW IF EXISTS verblijfsobjectpandactueelbestaand;
CREATE VIEW verblijfsobjectpandactueelbestaand AS
  SELECT vbop.*
  FROM verblijfsobjectpand as vbop
  JOIN extract_datum ON 1=1
  WHERE
    vbop.begingeldigheid <= extract_datum()
    AND (vbop.eindgeldigheid is NULL OR vbop.eindgeldigheid > extract_datum())
    AND (vbop.tijdstipinactief is NULL OR vbop.tijdstipinactief > extract_datum.waarde)
    AND ((vbop.verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject' AND
          vbop.verblijfsobjectStatus <> 'Verblijfsobject ingetrokken' AND
         vbop.verblijfsobjectStatus <> 'Verblijfsobject ten onrechte opgevoerd') OR
         vbop.verblijfsobjectStatus is NULL);


DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueel;
CREATE VIEW verblijfsobjectgebruiksdoelactueel AS
  SELECT vog.*
  FROM verblijfsobjectgebruiksdoel as vog
  JOIN extract_datum ON 1=1
  WHERE
    vog.begingeldigheid <= extract_datum()
    AND (vog.eindgeldigheid is NULL OR vog.eindgeldigheid > extract_datum())
    AND (vog.tijdstipinactief is NULL OR vog.tijdstipinactief > extract_datum.waarde);

DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand;
CREATE VIEW verblijfsobjectgebruiksdoelactueelbestaand AS
  SELECT vog.*
  FROM verblijfsobjectgebruiksdoel as vog
  JOIN extract_datum ON 1=1
  WHERE
    vog.begingeldigheid <= extract_datum()
    AND (vog.eindgeldigheid is NULL OR vog.eindgeldigheid > extract_datum())
    AND (vog.tijdstipinactief is NULL OR vog.tijdstipinactief > extract_datum.waarde)
    AND ((vog.verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject' AND
          vog.verblijfsobjectStatus <> 'Verblijfsobject ingetrokken' AND
          vog.verblijfsobjectStatus <> 'Verblijfsobject ten onrechte opgevoerd') OR
         vog.verblijfsobjectStatus is NULL);



----------------------------------------------------------------------------------
-- Extra definitie voor GeoServer om om te gaan met VIEWs
----------------------------------------------------------------------------------
-- http://getsatisfaction.com/opengeo/topics/postgis_index_in_opengeo

-- Table: gt_pk_metadata
-- NOG NODIG???

DROP TABLE IF EXISTS gt_pk_metadata;

CREATE TABLE gt_pk_metadata
(
  table_schema character varying(32) NOT NULL,
  table_name character varying(32) NOT NULL,
  pk_column character varying(32) NOT NULL,
  pk_column_idx integer,
  pk_policy character varying(32),
  pk_sequence character varying(64),
  CONSTRAINT gt_pk_metadata_table_schema_key UNIQUE (table_schema, table_name, pk_column),
  CONSTRAINT gt_pk_metadata_pk_policy_check CHECK (pk_policy::text = ANY (ARRAY['sequence'::character varying::text, 'assigned'::character varying::text, 'autoincrement'::character varying::text]))
);

--NOTICE:  CREATE TABLE / UNIQUE will create implicit index "gt_pk_metadata_table_schema_key" for table "gt_pk_metadata"
--Vraag succesvol terug met leeg resultaat in 31 ms.

-- Insert record in view hulp tabel (example)
-- Naam schema waar view aanwezig is
-- Naam view
-- Naam primary key in the tabel
INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'ligplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'ligplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'standplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'standplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'verblijfplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'verblijfplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'woonplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'woonplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'pandactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'pandactueelbestaand', 'gid', null, null, null);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('views aangemaakt', 'create-views.sql');
