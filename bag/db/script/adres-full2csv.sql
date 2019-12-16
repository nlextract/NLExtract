-- Simpel SQL script om adres tabel naar CSV te converteren
-- voor specifiek schema: verander public.adres naar mijnschema.adres
-- bijv schema naam zetten via search path met PGOPTIONS in shell script:
-- http://stackoverflow.com/questions/13850564/how-to-change-default-public-schema-on-the-psql-command-line
--    export PGOPTIONS='-c search_path=public,bag8jan2014'
--    psql -h vm-kademodb -U kademo -W -d bag -f /opt/nlextract/git/bag/db/script/adres2csv.sql
--    mv /tmp/bagadres.csv bag8jan2014.csv
-- dump is in /tmp omdat postgres absolute pad wil...daar is vast ook wel iets op te bedenken.
--
-- 18.okt.2015: forceer puntcomma als CSV veld-delimiter, zie  https://github.com/nlextract/NLExtract/issues/147
\COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,nummeraanduiding,verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,adresseerbaarobject as object_id,typeadresseerbaarobject as object_type,nevenadres,pandid,pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat, verkorteopenbareruimtenaam as verkorteopenbareruimte FROM adres_full ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO '/tmp/bagadres-full.csv' WITH CSV HEADER DELIMITER ';'

-- Windows pad:
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,nummeraanduiding,verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,adresseerbaarobject as object_id,typeadresseerbaarobject as object_type,nevenadres,pandid,pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres.csv' WITH CSV HEADER DELIMITER ';'

-- Toevoegen aan einde regel om te exporteren in "Dutch_Netherlands.1252" formaat. (LC_CTYPE staat hier ook op!) Dit is handig omdat Excel niet standaard in UTF-8 formaat inleest.
-- ENCODING 'windows-1252'
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,nummeraanduiding,verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,adresseerbaarobject as object_id,typeadresseerbaarobject as object_type,nevenadres,pandid,pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres.csv' WITH CSV HEADER DELIMITER ';' ENCODING 'windows-1252'

-- Export Filteren op b.v. provincienaam:
-- Voeg tussen "FROM adres_full" en "ORDER BY" toe
-- WHERE provincienaam = 'Groningen'
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,nummeraanduiding,verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,adresseerbaarobject as object_id,typeadresseerbaarobject as object_type,nevenadres,pandid,pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full WHERE provincienaam = 'Groningen' ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres-Groningen.csv' WITH CSV HEADER DELIMITER ';'

-- ID velden aanvullen met voorloop nullen
-- lpad(pandid::text,16,'0')
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,lpad(nummeraanduiding::text,16,'0'),verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,lpad(adresseerbaarobject::text,16,'0') as object_id,typeadresseerbaarobject as object_type,nevenadres,lpad(pandid::text,16,'0'),pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres.csv' WITH CSV HEADER DELIMITER ';'

-- Default nullen als veld leeg (LIG en STA)
-- lpad(coalesce(pandid::text,'0000000000000000'),16,'0')
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,lpad(coalesce(nummeraanduiding::text,'0000000000000000'),16,'0'),verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,lpad(coalesce(adresseerbaarobject::text,'0000000000000000'),16,'0') as object_id,typeadresseerbaarobject as object_type,nevenadres,lpad(coalesce(pandid::text,'0000000000000000'),16,'0'),pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres.csv' WITH CSV HEADER DELIMITER ';'

-- Alles Gecombineerd:
-- \COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,postcode,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie,lpad(coalesce(nummeraanduiding::text,'0000000000000000'),16,'0'),verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,lpad(coalesce(adresseerbaarobject::text,'0000000000000000'),16,'0') as object_id,typeadresseerbaarobject as object_type,nevenadres,lpad(coalesce(pandid::text,'0000000000000000'),16,'0'),pandstatus,pandbouwjaar,ST_X(geopunt) as x,ST_Y(geopunt) as y,ST_X(ST_Transform(geopunt, 4326)) as lon,ST_Y(ST_Transform(geopunt, 4326)) as lat FROM adres_full WHERE provincienaam = 'Groningen' ORDER BY postcode,openbareruimtenaam,huisnummer,huisletter,huisnummertoevoeging) TO 'C:\temp\bagadres-Groningen.csv' WITH CSV HEADER DELIMITER ';' ENCODING 'windows-1252'

-- VBO Velden:
--  openbareruimtenaam
--  huisnummer
--  huisletter
--  huisnummertoevoeging
--  postcode
--  woonplaatsnaam
--  gemeentenaam
--  provincienaam
--  verblijfsobjectgebruiksdoel
--  oppervlakteverblijfsobject
--  verblijfsobjectstatus
--  typeadresseerbaarobject
--  adresseerbaarobject
-- (pand gegevens gerelateerd aan VBO)
--  pandid
--  pandstatus
--  pandbouwjaar
--  nummeraanduiding
--  nevenadres
--  geopunt (RD x,y)
