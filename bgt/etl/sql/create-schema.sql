-- Maak schema aan indien deze nog niet bestaat.
-- Doe niets voor schema 'public'
-- CREATE OR REPLACE FUNCTION _nlx_createschema(schemaname VARCHAR)
-- RETURNS void AS
-- $$
-- BEGIN
--
--     IF schemaname = 'public' THEN
--         RETURN;
--     END IF;
--
--     IF EXISTS(
--         SELECT schema_name
--         FROM information_schema.schemata
--         WHERE schema_name = $1
--     )
--     THEN
--         EXECUTE 'DROP SCHEMA ' || $1 || ' CASCADE;';
--     END IF;
--     -- EXECUTE 'DROP SCHEMA IF EXISTS ' || $1 || ';';
--     EXECUTE 'CREATE SCHEMA ' || $1 || ';';
--
-- END;
-- $$
-- LANGUAGE plpgsql;

DROP SCHEMA IF EXISTS {schema} CASCADE;
CREATE SCHEMA {schema};

-- SELECT _nlx_createschema('{schema}');
--
-- DROP FUNCTION _nlx_createschema(schemaname VARCHAR);

