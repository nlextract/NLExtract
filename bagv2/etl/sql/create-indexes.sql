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
DROP INDEX IF EXISTS pand_key CASCADE;
DROP INDEX IF EXISTS nummeraanduiding_key CASCADE;
DROP INDEX IF EXISTS openbareruimte_key CASCADE;
DROP INDEX IF EXISTS woonplaats_key CASCADE;

CREATE INDEX ligplaats_key ON ligplaats USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
CREATE INDEX standplaats_key ON standplaats USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
CREATE INDEX verblijfsobject_key ON verblijfsobject USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
CREATE INDEX pand_key ON pand USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
-- met nummeraanduiding lijkt een probleem als unieke index  (in de gaten houden)
CREATE INDEX nummeraanduiding_key ON nummeraanduiding USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
CREATE INDEX openbareruimte_key ON openbareruimte USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);
CREATE INDEX woonplaats_key ON woonplaats USING btree (identificatie,voorkomenidentificatie,begindatumTijdvakGeldigheid);

-- Overige indexen
DROP INDEX IF EXISTS nummeraanduiding_postcode CASCADE;
DROP INDEX IF EXISTS openbareruimte_naam CASCADE;
DROP INDEX IF EXISTS woonplaats_naam CASCADE;
CREATE INDEX nummeraanduiding_postcode ON nummeraanduiding USING btree (postcode);
CREATE INDEX openbareruimte_naam ON openbareruimte USING btree (openbareruimtenaam );
CREATE INDEX woonplaats_naam ON woonplaats USING btree (woonplaatsNaam);

DROP INDEX IF EXISTS gem_wpl_woonplaatscode_idx CASCADE;
DROP INDEX IF EXISTS gem_wpl_gemeentecode_datum_idx CASCADE;
CREATE INDEX gem_wpl_woonplaatscode_idx ON gemeente_woonplaats USING btree (woonplaatscode);
CREATE INDEX gem_wpl_gemeentecode_datum_idx ON gemeente_woonplaats USING btree (gemeentecode);

-- Indexen relatie tabellen
-- CREATE INDEX verblijfsobjectpandkey ON verblijfsobjectpand USING btree (identificatie,voorkomenidentificatie, begindatumTijdvakGeldigheid, gerelateerdpand);
-- CREATE INDEX verblijfsobjectpand_pand ON verblijfsobjectpand USING btree (gerelateerdpand);
-- CREATE INDEX verblijfsobjectgebruiksdoelkey ON verblijfsobjectgebruiksdoel USING btree (identificatie,voorkomenidentificatie, begindatumTijdvakGeldigheid, gebruiksdoelverblijfsobject);
DROP INDEX IF EXISTS adresseerbaarobjectnevenadreskey CASCADE;
CREATE INDEX
        adresseerbaarobjectnevenadreskey ON adresseerbaarobjectnevenadres USING btree (identificatie,voorkomenidentificatie, begindatumTijdvakGeldigheid, nevenadres);

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('end_indexing', 'create-indexes.sql');

INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('end_base_etl', to_char(current_timestamp, 'DD-Mon-IYYY HH24:MI:SS'));
