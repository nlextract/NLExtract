-- Auteur: Frank Steggink
-- Doel: script om de definitieve BGT / IMGeo tabellen te verwijderen.
-- Dit script kan desgewenst achterwege gelaten worden. Dan worden de betreffende tabellen pas bij create-final-tables
-- opgeruimd.

SET search_path={schema},public;

DROP TABLE IF EXISTS bak CASCADE;
DROP TABLE IF EXISTS begroeidterreindeel CASCADE;
DROP TABLE IF EXISTS bord CASCADE;
DROP TABLE IF EXISTS buurt CASCADE;
DROP TABLE IF EXISTS functioneelgebied CASCADE;
DROP TABLE IF EXISTS gebouwinstallatie CASCADE;
DROP TABLE IF EXISTS installatie CASCADE;
DROP TABLE IF EXISTS kast CASCADE;
DROP TABLE IF EXISTS kunstwerkdeel CASCADE;
DROP TABLE IF EXISTS mast CASCADE;
DROP TABLE IF EXISTS onbegroeidterreindeel CASCADE;
DROP TABLE IF EXISTS ondersteunendwaterdeel CASCADE;
DROP TABLE IF EXISTS ondersteunendwegdeel CASCADE;
DROP TABLE IF EXISTS ongeclassificeerdobject CASCADE;
DROP TABLE IF EXISTS openbareruimte CASCADE;
DROP TABLE IF EXISTS openbareruimtelabel CASCADE;
DROP TABLE IF EXISTS overbruggingsdeel CASCADE;
DROP TABLE IF EXISTS overigbouwwerk CASCADE;
DROP TABLE IF EXISTS overigescheiding CASCADE;
DROP TABLE IF EXISTS paal CASCADE;
DROP TABLE IF EXISTS pand CASCADE;
DROP TABLE IF EXISTS plaatsbepalingspunt CASCADE;
DROP TABLE IF EXISTS put CASCADE;
DROP TABLE IF EXISTS scheiding CASCADE;
DROP TABLE IF EXISTS sensor CASCADE;
DROP TABLE IF EXISTS spoor CASCADE;
DROP TABLE IF EXISTS stadsdeel CASCADE;
DROP TABLE IF EXISTS straatmeubilair CASCADE;
DROP TABLE IF EXISTS tunneldeel CASCADE;
DROP TABLE IF EXISTS vegetatieobject CASCADE;
DROP TABLE IF EXISTS waterdeel CASCADE;
DROP TABLE IF EXISTS waterinrichtingselement CASCADE;
DROP TABLE IF EXISTS waterschap CASCADE;
DROP TABLE IF EXISTS wegdeel CASCADE;
DROP TABLE IF EXISTS weginrichtingselement CASCADE;
DROP TABLE IF EXISTS wijk CASCADE;

SET search_path="$user",public;
