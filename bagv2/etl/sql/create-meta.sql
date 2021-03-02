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
INSERT INTO nlx_bag_info (sleutel,waarde)
        VALUES ('bag_xsd_versie', '20200601');


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

INSERT INTO nlx_bag_log (actie, bestand) VALUES ('log tabel aangemaakt', 'create-meta.sql');
