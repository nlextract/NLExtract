-- Auteur: Frank Steggink
-- Doel: script om BRK tabellen te verwijderen.

SET search_path={schema},public;

DROP TABLE IF EXISTS    kwaliteit CASCADE;
DROP TABLE IF EXISTS    pand CASCADE;
DROP TABLE IF EXISTS    pand_nummeraanduiding CASCADE;
DROP TABLE IF EXISTS    openbareruimtelabel CASCADE;
DROP TABLE IF EXISTS    kadastralegrens CASCADE;
DROP TABLE IF EXISTS    perceel CASCADE;

SET search_path="$user",public;
