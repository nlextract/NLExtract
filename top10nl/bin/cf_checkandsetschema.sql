CREATE OR REPLACE FUNCTION nlextract.checkandsetschema(schemaname VARCHAR)
RETURNS void AS
$$
BEGIN

    IF schemaname = 'public' THEN
        SET search_path TO public;
        RETURN;
    END IF;

    IF NOT EXISTS(
        SELECT schema_name
        FROM information_schema.schemata
        WHERE schema_name = $1
    )
    THEN
        EXECUTE FORMAT('CREATE SCHEMA %I;', $1);
    END IF;

    EXECUTE FORMAT('SET search_path TO %I,public;', $1);

END;
$$
LANGUAGE plpgsql;
