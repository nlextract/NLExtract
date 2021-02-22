-- Views voor BAG tabellen
-- BAG Objecten kunnen niet-actueel of zelfs niet bestaand (beeindigd) zijn
-- Via Views kunnen actuele en bestaande objecten uitgefilterd worden.
-- SET search_path TO test,public;
-- LIG
DROP VIEW IF EXISTS ligplaatsactueel;
CREATE VIEW ligplaatsactueel AS
    SELECT * FROM ligplaats
    WHERE
      begingeldigheid <= now()
      AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
      AND tijdstipregistratie <= now()
      AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS ligplaatsactueelbestaand;
CREATE VIEW ligplaatsactueelbestaand AS
    SELECT * FROM ligplaats
    WHERE
        begingeldigheid <= now()
        AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
        AND tijdstipregistratie <= now()
        AND (eindregistratie is NULL OR eindregistratie >= now())
        AND status <> 'Plaats ingetrokken';

-- NUM
DROP VIEW IF EXISTS nummeraanduidingactueel;
CREATE VIEW nummeraanduidingactueel AS
    SELECT *
    FROM nummeraanduiding
    WHERE
      begingeldigheid <= now()
      AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
      AND tijdstipregistratie <= now()
      AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS nummeraanduidingactueelbestaand;
CREATE VIEW nummeraanduidingactueelbestaand AS
    SELECT * FROM nummeraanduiding
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now())
    AND status <> 'Naamgeving ingetrokken';

-- OPR
DROP VIEW IF EXISTS openbareruimteactueel;
CREATE VIEW openbareruimteactueel AS
    SELECT * FROM openbareruimte
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS openbareruimteactueelbestaand;
CREATE VIEW openbareruimteactueelbestaand AS
    SELECT * FROM openbareruimte
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now())
    AND status <> 'Naamgeving ingetrokken';

-- PND
DROP VIEW IF EXISTS pandactueel;
CREATE VIEW pandactueel AS
    SELECT * FROM pand
    WHERE
      begingeldigheid <= now()
      AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
      AND tijdstipregistratie <= now()
      AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS pandactueelbestaand;
CREATE VIEW pandactueelbestaand AS
    SELECT * FROM pand
    WHERE
     begingeldigheid <= now()
     AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
     AND tijdstipregistratie <= now()
     AND (eindregistratie is NULL OR eindregistratie >= now())
     AND (status <> 'Niet gerealiseerd pand' 
     AND status <> 'Pand gesloopt'
     AND status <> 'Bouwvergunning verleend'
     AND status <> 'Pand ten onrechte opgevoerd');

-- STA
DROP VIEW IF EXISTS standplaatsactueel;
CREATE VIEW standplaatsactueel AS
    SELECT * FROM standplaats
    WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS standplaatsactueelbestaand;
CREATE VIEW standplaatsactueelbestaand AS
    SELECT * FROM standplaats
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now())
    AND status <> 'Plaats ingetrokken';

-- VBO
DROP VIEW IF EXISTS verblijfsobjectactueel;
CREATE VIEW verblijfsobjectactueel AS
    SELECT * FROM verblijfsobject
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now());


DROP VIEW IF EXISTS verblijfsobjectactueelbestaand;
CREATE VIEW verblijfsobjectactueelbestaand AS
    SELECT * FROM verblijfsobject
    WHERE
      begingeldigheid <= now()
      AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
      AND tijdstipregistratie <= now()
      AND (eindregistratie is NULL OR eindregistratie >= now())
      AND (status <> 'Niet gerealiseerd verblijfsobject'
      AND status  <> 'Verblijfsobject ingetrokken'
      AND status  <> 'Verblijfsobject ten onrechte opgevoerd');

-- JvdB removed AND status  <> 'Verblijfsobject gevormd', see issue #173
-- https://github.com/nlextract/NLExtract/issues/173  23.3.16
--

-- WPL
DROP VIEW IF EXISTS woonplaatsactueel;
CREATE VIEW woonplaatsactueel AS
  SELECT * FROM woonplaats
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now());

DROP VIEW IF EXISTS woonplaatsactueelbestaand;
CREATE VIEW woonplaatsactueelbestaand AS
  SELECT * FROM woonplaats
  WHERE
    begingeldigheid <= now()
    AND (eindgeldigheid is NULL OR eindgeldigheid >= now())
    AND tijdstipregistratie <= now()
    AND (eindregistratie is NULL OR eindregistratie >= now())
    AND status  <> 'Woonplaats ingetrokken';

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
  WHERE
    gw.begingeldigheid <= now()
    AND (gw.eindgeldigheid is NULL OR gw.eindgeldigheid >= now())
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


-- DROP VIEW IF EXISTS verblijfsobjectpandactueel;
-- CREATE VIEW verblijfsobjectpandactueel AS
--     SELECT vbop.gid,
--             vbop.identificatie,
--             vbop.aanduidingrecordinactief,
--             vbop.aanduidingrecordcorrectie,
--             vbop.begingeldigheid,
--             vbop.eindgeldigheid,
--             vbop.gerelateerdpand,
--             vbop.status,
--     FROM verblijfsobjectpand as vbop
--   WHERE
--     vbop.begingeldigheid <= now()
--     AND (vbop.eindgeldigheid is NULL OR vbop.eindgeldigheid >= now())
--     AND vbop.aanduidingrecordinactief = FALSE;
-- 
-- DROP VIEW IF EXISTS verblijfsobjectpandactueelbestaand;
-- CREATE VIEW verblijfsobjectpandactueelbestaand AS
--     SELECT vbop.gid,
--             vbop.identificatie,
--             vbop.aanduidingrecordinactief,
--             vbop.aanduidingrecordcorrectie,
--             vbop.begingeldigheid,
--             vbop.eindgeldigheid,
--             vbop.gerelateerdpand,
--             vbop.status,
--     FROM verblijfsobjectpand as vbop
--   WHERE
--     vbop.begingeldigheid <= now()
--     AND (vbop.eindgeldigheid is NULL OR vbop.eindgeldigheid >= now())
--     AND vbop.aanduidingrecordinactief = FALSE
--     AND ((vbop.status <> 'Niet gerealiseerd verblijfsobject' AND
--           vbop.status <> 'Verblijfsobject ingetrokken') OR
--          vbop.status is NULL);
-- 
-- DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueel;
-- CREATE VIEW adresseerbaarobjectnevenadresactueel AS
--     SELECT aon.gid,
--             aon.identificatie,
--             aon.aanduidingrecordinactief,
--             aon.aanduidingrecordcorrectie,
--             aon.begingeldigheid,
--             aon.eindgeldigheid,
--             aon.nevenadres,
--             aon.ligplaatsstatus,
--             aon.standplaatsstatus,
--             aon.status,
--     FROM adresseerbaarobjectnevenadres as aon
--   WHERE
--     aon.begingeldigheid <= now()
--     AND (aon.eindgeldigheid is NULL OR aon.eindgeldigheid >= now())
--     AND aon.aanduidingrecordinactief = FALSE;
-- 
-- DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueelbestaand;
-- CREATE VIEW adresseerbaarobjectnevenadresactueelbestaand AS
--     SELECT aon.gid,
--             aon.identificatie,
--             aon.aanduidingrecordinactief,
--             aon.aanduidingrecordcorrectie,
--             aon.begingeldigheid,
--             aon.eindgeldigheid,
--             aon.nevenadres,
--             aon.ligplaatsstatus,
--             aon.standplaatsstatus,
--             aon.status,
--     FROM adresseerbaarobjectnevenadres as aon
--   WHERE
--     aon.begingeldigheid <= now()
--     AND (aon.eindgeldigheid is NULL OR aon.eindgeldigheid >= now())
--     AND aon.aanduidingrecordinactief = FALSE
--     AND ((aon.ligplaatsstatus <> 'Plaats ingetrokken' OR aon.ligplaatsstatus is NULL) AND
--          (aon.standplaatsstatus <> 'Plaats ingetrokken' OR aon.standplaatsstatus is NULL) AND
--          ((aon.status <> 'Niet gerealiseerd verblijfsobject' AND
--            aon.status <> 'Verblijfsobject ingetrokken') OR
--           aon.status is NULL));
-- 
-- DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueel;
-- CREATE VIEW verblijfsobjectgebruiksdoelactueel AS
--     SELECT vog.gid,
--             vog.identificatie,
--             vog.aanduidingrecordinactief,
--             vog.aanduidingrecordcorrectie,
--             vog.begingeldigheid,
--             vog.eindgeldigheid,
--             vog.gebruiksdoelverblijfsobject,
--             vog.status,
--     FROM verblijfsobjectgebruiksdoel as vog
--   WHERE
--     vog.begingeldigheid <= now()
--     AND (vog.eindgeldigheid is NULL OR vog.eindgeldigheid >= now())
--     AND vog.aanduidingrecordinactief = FALSE;
-- 
-- DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand;
-- CREATE VIEW verblijfsobjectgebruiksdoelactueelbestaand AS
--     SELECT vog.gid,
--             vog.identificatie,
--             vog.aanduidingrecordinactief,
--             vog.aanduidingrecordcorrectie,
--             vog.begingeldigheid,
--             vog.eindgeldigheid,
--             vog.gebruiksdoelverblijfsobject,
--             vog.status,
--     FROM verblijfsobjectgebruiksdoel as vog
--   WHERE
--     vog.begingeldigheid <= now()
--     AND (vog.eindgeldigheid is NULL OR vog.eindgeldigheid >= now())
--     AND vog.aanduidingrecordinactief = FALSE
--     AND ((vog.status <> 'Niet gerealiseerd verblijfsobject' AND
--           vog.status <> 'Verblijfsobject ingetrokken') OR
--          vog.status is NULL);
-- 
--

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('views aangemaakt', 'create-views.sql');
