-- Author: Just van den Broecke
-- SET search_path TO test,public;

--
-- INDEXEN
--

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('start_indexing', to_char(current_timestamp, 'DD-Mon-IYYY HH24:MI:SS'));

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
DROP INDEX IF EXISTS lig_hoofdadres_key CASCADE;
DROP INDEX IF EXISTS sta_hoofdadres_key CASCADE;
DROP INDEX IF EXISTS vbo_hoofdadres_key CASCADE;
DROP INDEX IF EXISTS pand_key CASCADE;
DROP INDEX IF EXISTS nummeraanduiding_key CASCADE;
DROP INDEX IF EXISTS openbareruimte_key CASCADE;
DROP INDEX IF EXISTS woonplaats_key CASCADE;

CREATE UNIQUE INDEX ligplaats_key ON ligplaats USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX standplaats_key ON standplaats USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX verblijfsobject_key ON verblijfsobject USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX pand_key ON pand USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE INDEX lig_hoofdadres_key ON ligplaats USING btree (hoofdadres);
CREATE INDEX sta_hoofdadres_key ON standplaats USING btree (hoofdadres);
CREATE INDEX vbo_hoofdadres_key ON verblijfsobject USING btree (hoofdadres);
CREATE INDEX pand_key ON pand USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
-- met nummeraanduiding lijkt een probleem als unieke index  (in de gaten houden)
CREATE UNIQUE INDEX nummeraanduiding_key ON nummeraanduiding USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX openbareruimte_key ON openbareruimte USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);
CREATE UNIQUE INDEX woonplaats_key ON woonplaats USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid);

ALTER TABLE ligplaats ADD CONSTRAINT ligplaats_unique UNIQUE USING INDEX ligplaats_key;
ALTER TABLE standplaats ADD CONSTRAINT standplaats_unique UNIQUE USING INDEX standplaats_key;
ALTER TABLE verblijfsobject ADD CONSTRAINT verblijfsobject_unique UNIQUE USING INDEX verblijfsobject_key;
ALTER TABLE pand ADD CONSTRAINT pand_unique UNIQUE USING INDEX pand_key;
ALTER TABLE nummeraanduiding ADD CONSTRAINT nummeraanduiding_unique UNIQUE USING INDEX nummeraanduiding_key;
ALTER TABLE openbareruimte ADD CONSTRAINT openbareruimte_unique UNIQUE USING INDEX openbareruimte_key;
ALTER TABLE woonplaats ADD CONSTRAINT woonplaats_unique UNIQUE USING INDEX woonplaats_key;

-- Overige indexen
DROP INDEX IF EXISTS nummeraanduiding_postcode CASCADE;
DROP INDEX IF EXISTS openbareruimte_naam CASCADE;
DROP INDEX IF EXISTS woonplaats_naam CASCADE;
CREATE INDEX nummeraanduiding_postcode ON nummeraanduiding USING btree (postcode);
CREATE INDEX openbareruimte_naam ON openbareruimte USING btree (naam);
CREATE INDEX woonplaats_naam ON woonplaats USING btree (naam);

DROP INDEX IF EXISTS gem_wpl_woonplaatscode_idx CASCADE;
DROP INDEX IF EXISTS gem_wpl_gemeentecode_datum_idx CASCADE;
CREATE INDEX gem_wpl_woonplaatscode_idx ON gemeente_woonplaats USING btree (woonplaatscode);
CREATE INDEX gem_wpl_gemeentecode_datum_idx ON gemeente_woonplaats USING btree (gemeentecode);

DROP INDEX IF EXISTS prov_gem_gemeentecode_idx CASCADE;
CREATE INDEX prov_gem_gemeentecode_idx ON provincie_gemeente USING btree (gemeentecode);

-- Indexen relatie tabellen
DROP INDEX IF EXISTS verblijfsobjectpandkey CASCADE;
DROP INDEX IF EXISTS verblijfsobjectpand_pand CASCADE;
DROP INDEX IF EXISTS verblijfsobjectgebruiksdoelkey CASCADE;
CREATE UNIQUE INDEX verblijfsobjectpandkey ON verblijfsobjectpand USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid, gerelateerdpand);
CREATE INDEX verblijfsobjectpand_pand ON verblijfsobjectpand USING btree (gerelateerdpand);
CREATE UNIQUE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid, gebruiksdoelverblijfsobject);
ALTER TABLE verblijfsobjectpand ADD CONSTRAINT verblijfsobjectpand_unique UNIQUE USING INDEX verblijfsobjectpandkey;
ALTER TABLE verblijfsobjectgebruiksdoel ADD CONSTRAINT verblijfsobjectgebruiksdoel_unique UNIQUE USING INDEX verblijfsobjectgebruiksdoelkey;

DROP INDEX IF EXISTS adresseerbaarobjectnevenadreskey CASCADE;
CREATE UNIQUE INDEX adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie, voorkomenidentificatie, begindatumtijdvakgeldigheid, nevenadres);
ALTER TABLE adresseerbaarobjectnevenadres ADD CONSTRAINT adresseerbaarobjectnevenadres_unique UNIQUE USING INDEX adresseerbaarobjectnevenadreskey;

DROP INDEX IF EXISTS nlx_bag_info_key CASCADE;
CREATE INDEX nlx_bag_info_key ON nlx_bag_info USING btree (sleutel);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('end_indexing', 'create-indexes.sql');

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('end_base_etl', to_char(current_timestamp, 'DD-Mon-IYYY HH24:MI:SS'));
