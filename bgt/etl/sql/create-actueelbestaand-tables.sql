-- Bijdrage van Willem Hoffmans - 18 jan 2022
-- NB: Gaat ervan uit dat schema 'bgt' heet!

-- Opschonen BGT (en BAG?) NLExtract dumps.
-- Alle historie eruit gooien, zodat je alleen actueelbestaand overhoudt
-- Alle 'actueel' en 'actueelbestaand' views eruit gooien, die zijn dan overbodig.

-- Dit werkt met een loopje vanuit de systeemtabellen, is een stuk efficiënter qua code.
DO LANGUAGE plpgsql
$$
DECLARE
  currenttabel record;
  tabelnaam VARCHAR;
BEGIN
  FOR currenttabel IN
  SELECT c.relname AS tabel
  FROM pg_namespace AS n JOIN pg_class AS c ON n.oid = c.relnamespace
  WHERE n.nspname = 'bgt' and c.relkind = 'r'
  ORDER BY tabel
  LOOP
    BEGIN
      RAISE NOTICE 'Verwerken tabel %', currenttabel.tabel;
      -- Historie leeghalen
      EXECUTE FORMAT ('DELETE FROM bgt.%s WHERE NOT (eindregistratie IS NULL AND bgt_status::text = ''bestaand''::text AND plus_status::text <> ''plan''::text AND plus_status::text <> ''historie''::text);', currenttabel.tabel);
      -- Views weggooien
      EXECUTE FORMAT ('DROP VIEW IF EXISTS bgt.%sactueel CASCADE;DROP VIEW IF EXISTS bgt.%sactueelbestaand CASCADE;', currenttabel.tabel, currenttabel.tabel);
      EXCEPTION
      WHEN OTHERS THEN
      RAISE NOTICE 'Foutje in tabel %', currenttabel.tabel;
      END;
  END LOOP;
END;
$$;
