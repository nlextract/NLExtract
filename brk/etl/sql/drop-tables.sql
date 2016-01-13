-- Auteur: Frank Steggink
-- Doel: script om BRK tabellen te verwijderen.

SET search_path={schema},public;

DROP TABLE IF EXISTS    annotatie;
DROP TABLE IF EXISTS    bebouwing;
DROP TABLE IF EXISTS    kadastralegrens;
DROP TABLE IF EXISTS    perceel;

SET search_path="$user",public;
