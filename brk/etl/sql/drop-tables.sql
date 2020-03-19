-- Auteur: Frank Steggink
-- Doel: script om BRK tabellen te verwijderen.

SET search_path={schema},public;

DROP TABLE IF EXISTS    pand;
DROP TABLE IF EXISTS    pand_nummeraanduiding;
DROP TABLE IF EXISTS    openbareruimtelabel;
DROP TABLE IF EXISTS    kadastralegrens;
DROP TABLE IF EXISTS    perceel;

SET search_path="$user",public;
