-- Simpel SQL script om adres tabel naar CSV te converteren
-- bijv met script:
-- psql -d bag -f adres2csv.sql
-- mv /tmp/bagadres.csv .
-- dump is in /tmp omdat postgres absolute pad wil...
-- voor specifiek schema: verander public.adres naar mijnschema.adres
\COPY (SELECT openbareruimtenaam as openbareruimte,huisnummer,huisletter,huisnummertoevoeging,woonplaatsnaam as woonplaats,gemeentenaam as gemeente,provincienaam as provincie, adresseerbaarobject as object_id,typeadresseerbaarobject as object_type,nevenadres,ST_X(geopunt) as x,ST_Y(geopunt) as y, ST_X(ST_Transform(geopunt, 4326)) as lon, ST_Y(ST_Transform(geopunt, 4326)) as lat  FROM adres ORDER BY openbareruimtenaam) TO '/tmp/bagadres.csv' WITH CSV HEADER
