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

CREATE INDEX ligplaats_geom_idx ON ligplaats USING gist (wkb_geometry);
CREATE INDEX pand_geom_idx ON pand USING gist (wkb_geometry);
CREATE INDEX standplaats_geom_idx ON standplaats USING gist (wkb_geometry);
CREATE INDEX verblijfsobject_punt_idx ON verblijfsobject USING gist (wkb_geometry);
CREATE INDEX woonplaats_vlak_idx ON woonplaats USING gist (wkb_geometry);

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
CREATE INDEX verblijfsobjectpandkey ON verblijfsobjectpand USING btree (identificatie,voorkomenidentificatie, begingeldigheid, gerelateerdpand);
CREATE INDEX verblijfsobjectpand_pand ON verblijfsobjectpand USING btree (gerelateerdpand);
CREATE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie,voorkomenidentificatie, begingeldigheid, gebruiksdoelverblijfsobject);

DROP INDEX IF EXISTS adresseerbaarobjectnevenadreskey CASCADE;
CREATE INDEX
        adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie,voorkomenidentificatie, begingeldigheid, nevenadres);

DROP INDEX IF EXISTS nlx_bag_info_key CASCADE;
CREATE INDEX nlx_bag_info_key ON nlx_bag_info USING btree (sleutel);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('end_indexing', 'create-indexes.sql');

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('end_base_etl', to_char(current_timestamp, 'DD-Mon-IYYY HH24:MI:SS'));
