-- Schema sizes
SELECT schema, pg_size_pretty(total_size) AS "total_size"
FROM (
  SELECT nspname AS "schema", SUM(pg_total_relation_size(C.oid))::bigint AS "total_size"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE C.relkind <> 'i'
    AND nspname !~ '^pg_toast'  AND nspname !~ '^pg_catalog'  AND nspname !~ '^information_schema'
  GROUP BY nspname)
AS schemasizes
ORDER BY schema;


-- Row counts per tabel, maar heeft search path nodig als PG schemas worden gebruikt
-- SET search_path TO bagimport,public;

CREATE OR REPLACE FUNCTION table_row_count () RETURNS void AS $$
DECLARE
	the_table RECORD;
	the_count TEXT;
BEGIN
FOR the_table IN SELECT table_name as name FROM information_schema.tables
        WHERE table_type IN ('BASE TABLE') AND table_schema NOT IN ('pg_catalog', 'information_schema') ORDER BY name
LOOP
	EXECUTE 'SELECT COUNT(*) FROM ' || the_table.name INTO the_count;
	RAISE NOTICE '% : %', the_table.name, the_count;
END LOOP;
RETURN;
END;
$$ LANGUAGE plpgsql;


select table_row_count ();

-- Schema overzicht
SELECT nspname AS "schema"
  FROM pg_class C
  LEFT JOIN pg_namespace N ON (N.oid = C.relnamespace)
  WHERE C.relkind <> 'i'
    AND nspname !~ '^pg_toast'  AND nspname !~ '^pg_catalog'  AND nspname !~ '^information_schema'
  GROUP BY nspname;
