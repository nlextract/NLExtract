SET search_path TO test,public;

--
-- INDEXEN
--
-- Geometrie indexen
DROP INDEX IF EXISTS ligplaats_geom_idx CASCADE;
DROP INDEX IF EXISTS pand_geom_idx CASCADE;
DROP INDEX IF EXISTS standplaats_geom_idx CASCADE;
DROP INDEX IF EXISTS verblijfsobject_punt_idx CASCADE;
DROP INDEX IF EXISTS woonplaats_vlak_idx CASCADE;

CREATE INDEX ligplaats_geom_idx ON ligplaats USING gist (geovlak);
CREATE INDEX pand_geom_idx ON pand USING gist (geovlak);
CREATE INDEX standplaats_geom_idx ON standplaats USING gist (geovlak);
CREATE INDEX verblijfsobject_punt_idx ON verblijfsobject USING gist (geopunt);
CREATE INDEX woonplaats_vlak_idx ON woonplaats USING gist (geovlak);

-- Unieke key indexen
DROP INDEX IF EXISTS ligplaats_key CASCADE;
DROP INDEX IF EXISTS standplaats_key CASCADE;
DROP INDEX IF EXISTS verblijfsobject_key CASCADE;
DROP INDEX IF EXISTS pand_key CASCADE;
DROP INDEX IF EXISTS nummeraanduiding_key CASCADE;
DROP INDEX IF EXISTS openbareruimte_key CASCADE;
DROP INDEX IF EXISTS woonplaats_key CASCADE;

CREATE INDEX ligplaats_key ON ligplaats USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
CREATE INDEX standplaats_key ON standplaats USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
CREATE INDEX verblijfsobject_key ON verblijfsobject USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
CREATE INDEX pand_key ON pand USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
-- met nummeraanduiding lijkt een probleem als unieke index  (in de gaten houden)
CREATE INDEX nummeraanduiding_key ON nummeraanduiding USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
CREATE INDEX openbareruimte_key ON openbareruimte USING btree (identificatie,voorkomenidentificatie,begingeldigheid);
CREATE INDEX woonplaats_key ON woonplaats USING btree (identificatie,voorkomenidentificatie,begingeldigheid);

-- Overige indexen
DROP INDEX IF EXISTS nummeraanduiding_postcode CASCADE;
DROP INDEX IF EXISTS openbareruimte_naam CASCADE;
DROP INDEX IF EXISTS woonplaats_naam CASCADE;

CREATE INDEX nummeraanduiding_postcode ON nummeraanduiding USING btree (postcode);
CREATE INDEX openbareruimte_naam ON openbareruimte USING btree (naam);
CREATE INDEX woonplaats_naam ON woonplaats USING btree (naam);

-- Indexen relatie tabellen
-- CREATE INDEX verblijfsobjectpandkey ON verblijfsobjectpand USING btree (identificatie,voorkomenidentificatie, begingeldigheid, gerelateerdpand);
-- CREATE INDEX verblijfsobjectpand_pand ON verblijfsobjectpand USING btree (gerelateerdpand);
-- CREATE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie,voorkomenidentificatie, begingeldigheid, gebruiksdoelverblijfsobject);
-- CREATE INDEX
--         adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie,voorkomenidentificatie, begingeldigheid, nevenadres);

-- Systeem tabellen
-- Meta informatie, handig om te weten, wat en wanneer is ingelezen
-- bagextract.py zal bijv leverings info en BAG leverings datum inserten
DROP TABLE IF EXISTS nlx_bag_info CASCADE;
CREATE TABLE nlx_bag_info (
  gid serial,
  tijdstempel timestamptz default current_timestamp,
  sleutel character varying (25),
  waarde text
);

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('schema_versie', '2.1.0');
INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('software_versie', '1.5.2');
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

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('schema aangemaakt', 'create-tables.sql');

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

