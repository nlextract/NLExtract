-- Auteur: Just van den Broecke
-- Doel: diverse aanpassingen tabellen

SET search_path={schema},public;

-- Function to conditionally rename a column
CREATE OR REPLACE FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR)
RETURNS bool AS
$$
BEGIN

    IF EXISTS (SELECT 1
            FROM information_schema.columns
            WHERE table_schema='{schema}' AND table_name=tbl AND column_name=oldname) THEN
        EXECUTE FORMAT('ALTER TABLE %s RENAME COLUMN %s TO %s', tbl, oldname, newname);
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$$
LANGUAGE plpgsql;


select _nlx_renamecolumn('kadastralegrens', 'wkb_geometry', 'grenslijn');

-- Mogelijk later: unieke kad_key
-- cast(gemeente || sectie || lpad(cast(perceelnummer as character varying(5)), 5, '00000') || 'G0000' as character varying(256)) as kad_key,
