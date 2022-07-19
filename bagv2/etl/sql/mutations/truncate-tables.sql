DO
$$
    BEGIN

        IF EXISTS(
                SELECT *
                FROM pg_tables tbl
                WHERE tbl.tablename = 'mutaties_pand'
            )
        THEN
            TRUNCATE TABLE mutaties_ligplaats;
            TRUNCATE TABLE mutaties_nummeraanduiding;
            TRUNCATE TABLE mutaties_openbareruimte;
            TRUNCATE TABLE mutaties_pand;
            TRUNCATE TABLE mutaties_standplaats;
            TRUNCATE TABLE mutaties_verblijfsobject;
            TRUNCATE TABLE mutaties_woonplaats;
        END IF;

    END;
$$
LANGUAGE plpgsql;
