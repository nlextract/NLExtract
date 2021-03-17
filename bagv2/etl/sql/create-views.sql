-- Views voor BAG tabellen
-- BAG Objecten kunnen niet-actueel of zelfs niet bestaand (beeindigd) zijn
-- Via Views kunnen actuele en bestaande objecten uitgefilterd worden.
-- Author: Just van den Broecke

-- Feitelijk is de "acteel" definitie:
-- begingeldigheid <= now()
--  AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
--  AND (tijdstipinactief is NULL)
--  AND (tijdstipnietbaglv is NULL)

-- SET search_path TO test,public;
-- LIG
DROP VIEW IF EXISTS ligplaatsactueel;
CREATE VIEW ligplaatsactueel AS
    SELECT * FROM ligplaats
    WHERE
      beginDatumTijdvakGeldigheid <= now()
      AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
      AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS ligplaatsactueelbestaand;
CREATE VIEW ligplaatsactueelbestaand AS
    SELECT * FROM ligplaats
    WHERE
        beginDatumTijdvakGeldigheid <= now()
        AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
        AND aanduidingrecordinactief is FALSE
        AND ligplaatsStatus <> 'Plaats ingetrokken'::ligplaatsStatus;

-- NUM
DROP VIEW IF EXISTS nummeraanduidingactueel;
CREATE VIEW nummeraanduidingactueel AS
    SELECT *
    FROM nummeraanduiding
    WHERE
      beginDatumTijdvakGeldigheid <= now()
      AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
      AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS nummeraanduidingactueelbestaand;
CREATE VIEW nummeraanduidingactueelbestaand AS
    SELECT * FROM nummeraanduiding
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE
    AND nummeraanduidingStatus <> 'Naamgeving ingetrokken'::nummeraanduidingStatus;

-- OPR
DROP VIEW IF EXISTS openbareruimteactueel;
CREATE VIEW openbareruimteactueel AS
    SELECT * FROM openbareruimte
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS openbareruimteactueelbestaand;
CREATE VIEW openbareruimteactueelbestaand AS
    SELECT * FROM openbareruimte
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE
    AND openbareruimteStatus <> 'Naamgeving ingetrokken'::openbareRuimteStatus;

-- PND
DROP VIEW IF EXISTS pandactueel;
CREATE VIEW pandactueel AS
    SELECT * FROM pand
    WHERE
      beginDatumTijdvakGeldigheid <= now()
      AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
      AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS pandactueelbestaand;
CREATE VIEW pandactueelbestaand AS
    SELECT * FROM pand
    WHERE
     beginDatumTijdvakGeldigheid <= now()
     AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
     AND aanduidingrecordinactief is FALSE
     AND (pandStatus <> 'Niet gerealiseerd pand'::pandStatus
     AND pandStatus <> 'Pand gesloopt'::pandStatus
     AND pandStatus <> 'Bouwvergunning verleend'::pandStatus
     AND pandStatus <> 'Pand ten onrechte opgevoerd'::pandStatus );

-- STA
DROP VIEW IF EXISTS standplaatsactueel;
CREATE VIEW standplaatsactueel AS
    SELECT * FROM standplaats
    WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS standplaatsactueelbestaand;
CREATE VIEW standplaatsactueelbestaand AS
    SELECT * FROM standplaats
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE
    AND standplaatsStatus <> 'Plaats ingetrokken'::standplaatsStatus;

-- VBO
DROP VIEW IF EXISTS verblijfsobjectactueel;
CREATE VIEW verblijfsobjectactueel AS
    SELECT * FROM verblijfsobject
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE;


DROP VIEW IF EXISTS verblijfsobjectactueelbestaand;
CREATE VIEW verblijfsobjectactueelbestaand AS
    SELECT * FROM verblijfsobject
    WHERE
      beginDatumTijdvakGeldigheid <= now()
      AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
      AND aanduidingrecordinactief is FALSE
      AND (verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject'::verblijfsobjectStatus
      AND verblijfsobjectStatus  <> 'Verblijfsobject ingetrokken'::verblijfsobjectStatus
      AND verblijfsobjectStatus  <> 'Verblijfsobject ten onrechte opgevoerd'::verblijfsobjectStatus);

-- JvdB removed AND status  <> 'Verblijfsobject gevormd', see issue #173
-- https://github.com/nlextract/NLExtract/issues/173  23.3.16
--

-- WPL
DROP VIEW IF EXISTS woonplaatsactueel;
CREATE VIEW woonplaatsactueel AS
  SELECT * FROM woonplaats
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE;

DROP VIEW IF EXISTS woonplaatsactueelbestaand;
CREATE VIEW woonplaatsactueelbestaand AS
  SELECT * FROM woonplaats
  WHERE
    beginDatumTijdvakGeldigheid <= now()
    AND (eindDatumTijdvakGeldigheid is NULL OR eindDatumTijdvakGeldigheid >= now())
    AND aanduidingrecordinactief is FALSE
    AND woonplaatsStatus  <> 'Woonplaats ingetrokken'::woonplaatsStatus;

-- KOPPELTABELLEN

DROP VIEW IF EXISTS gemeente_woonplaatsactueelbestaand;
CREATE VIEW gemeente_woonplaatsactueelbestaand AS
    SELECT  gw.gid,
            gw.beginDatumTijdvakGeldigheid,
            gw.eindDatumTijdvakGeldigheid,
            gw.woonplaatscode,
            gw.gemeentecode,
            gw.status
    FROM gemeente_woonplaats as gw
  WHERE
    gw.beginDatumTijdvakGeldigheid <= now()
    AND (gw.eindDatumTijdvakGeldigheid is NULL OR gw.eindDatumTijdvakGeldigheid >= now())
    AND gw.status = 'definitief';

-- Is nu altijd actueel
DROP VIEW IF EXISTS provincie_gemeenteactueelbestaand;
CREATE VIEW provincie_gemeenteactueelbestaand AS
    SELECT  pg.provinciecode,
            pg.provincienaam,
            pg.gemeentecode,
            pg.gemeentenaam
    FROM provincie_gemeente AS pg
;


-- START RELATIE TABELLEN

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueel;
CREATE VIEW adresseerbaarobjectnevenadresactueel AS
    SELECT *
    FROM adresseerbaarobjectnevenadres as aon
  WHERE
    aon.beginDatumTijdvakGeldigheid <= now()
    AND (aon.eindDatumTijdvakGeldigheid is NULL OR aon.eindDatumTijdvakGeldigheid >= now())
    AND (aon.tijdstipinactief is NULL OR aon.tijdstipinactief >= now());

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueelbestaand;
CREATE VIEW adresseerbaarobjectnevenadresactueelbestaand AS
    SELECT *
    FROM adresseerbaarobjectnevenadres as aon
  WHERE
    aon.beginDatumTijdvakGeldigheid <= now()
    AND (aon.eindDatumTijdvakGeldigheid is NULL OR aon.eindDatumTijdvakGeldigheid >= now())
    AND (aon.tijdstipinactief is NULL OR aon.tijdstipinactief >= now())
    AND ((aon.ligplaatsstatus <> 'Plaats ingetrokken' OR aon.ligplaatsstatus is NULL) AND
         (aon.standplaatsstatus <> 'Plaats ingetrokken' OR aon.standplaatsstatus is NULL) AND
         ((aon.verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject' AND
           aon.verblijfsobjectStatus <> 'Verblijfsobject ingetrokken' AND
           aon.verblijfsobjectStatus <> 'Verblijfsobject ten onrechte opgevoerd') OR
          aon.verblijfsobjectStatus is NULL));

-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, beginDatumTijdvakGeldigheid, eindDatumTijdvakGeldigheid,verblijfsobjectStatus from adresseerbaarobjectnevenadresactueel;
-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, beginDatumTijdvakGeldigheid, eindDatumTijdvakGeldigheid,verblijfsobjectStatus from adresseerbaarobjectnevenadresactueelbestaand;

DROP VIEW IF EXISTS verblijfsobjectpandactueel;
CREATE VIEW verblijfsobjectpandactueel AS
    SELECT *
    FROM verblijfsobjectpand as vbop
  WHERE
    vbop.beginDatumTijdvakGeldigheid <= now()
    AND (vbop.eindDatumTijdvakGeldigheid is NULL OR vbop.eindDatumTijdvakGeldigheid >= now())
    AND (vbop.tijdstipinactief is NULL OR vbop.tijdstipinactief >= now());

DROP VIEW IF EXISTS verblijfsobjectpandactueelbestaand;
CREATE VIEW verblijfsobjectpandactueelbestaand AS
    SELECT *
    FROM verblijfsobjectpand as vbop
  WHERE
    vbop.beginDatumTijdvakGeldigheid <= now()
    AND (vbop.eindDatumTijdvakGeldigheid is NULL OR vbop.eindDatumTijdvakGeldigheid >= now())
    AND (vbop.tijdstipinactief is NULL OR vbop.tijdstipinactief >= now())
    AND ((vbop.verblijfsobjectStatus <> 'Niet gerealiseerd verblijfsobject' AND
          vbop.verblijfsobjectStatus <> 'Verblijfsobject ingetrokken' AND
         vbop.verblijfsobjectStatus <> 'Verblijfsobject ten onrechte opgevoerd') OR
         vbop.verblijfsobjectStatus is NULL);


DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueel;
CREATE VIEW verblijfsobjectgebruiksdoelactueel AS
    SELECT *
    FROM verblijfsobjectgebruiksdoel as vog
  WHERE
    vog.beginDatumTijdvakGeldigheid <= now()
    AND (vog.eindDatumTijdvakGeldigheid is NULL OR vog.eindDatumTijdvakGeldigheid >= now())
    AND (vog.tijdstipinactief is NULL OR vog.tijdstipinactief >= now());

DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand;
CREATE VIEW verblijfsobjectgebruiksdoelactueelbestaand AS
    SELECT *
    FROM verblijfsobjectgebruiksdoel as vog
  WHERE
    vog.beginDatumTijdvakGeldigheid <= now()
    AND (vog.eindDatumTijdvakGeldigheid is NULL OR vog.eindDatumTijdvakGeldigheid >= now())
    AND (vog.tijdstipinactief is NULL OR vog.tijdstipinactief >= now())
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
