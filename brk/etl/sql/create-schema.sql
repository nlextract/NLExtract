-- Maak schema aan indien deze nog niet bestaat.
-- Doe niets voor schema 'public'
CREATE OR REPLACE FUNCTION _nlx_createschema(schemaname VARCHAR)
RETURNS void AS
$$
BEGIN

    IF schemaname = 'public' THEN
        RETURN;
    END IF;

    IF NOT EXISTS(
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name = $1
    )
    THEN
        EXECUTE 'CREATE SCHEMA ' || $1 || ';';
    END IF;

END;
$$
LANGUAGE plpgsql;

SELECT _nlx_createschema('{schema}');

DROP FUNCTION _nlx_createschema(schemaname VARCHAR);

