-- SET search_path TO test,public;

ALTER TABLE gemeente_woonplaats
  ALTER COLUMN begingeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING begingeldigheid::timestamp with time zone;

ALTER TABLE gemeente_woonplaats
  ALTER COLUMN eindgeldigheid
   TYPE TIMESTAMP WITH TIME ZONE
     USING eindgeldigheid::timestamp with time zone;
