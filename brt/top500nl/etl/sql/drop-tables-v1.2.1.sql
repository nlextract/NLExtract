-- Auteur: Frank Steggink
-- Doel: script om TOP500NL tabellen te verwijderen.
-- Zowel de originele als de opgesplitste tabellen worden hiermee verwijderd.

SET search_path={schema},public;

DROP TABLE IF EXISTS	functioneelgebied;
DROP TABLE IF EXISTS	functioneelgebied_punt;
DROP TABLE IF EXISTS	functioneelgebied_vlak;

DROP TABLE IF EXISTS	gebouw;
DROP TABLE IF EXISTS	gebouw_punt;

DROP TABLE IF EXISTS	geografischgebied;
DROP TABLE IF EXISTS	geografischgebied_punt;
DROP TABLE IF EXISTS	geografischgebied_vlak;

DROP TABLE IF EXISTS	hoogte;
DROP TABLE IF EXISTS	hoogte_lijn;
DROP TABLE IF EXISTS	hoogte_punt;

DROP TABLE IF EXISTS	inrichtingselement;
DROP TABLE IF EXISTS	inrichtingselement_lijn;
DROP TABLE IF EXISTS	inrichtingselement_punt;

DROP TABLE IF EXISTS	plaats;
DROP TABLE IF EXISTS	plaats_punt;
DROP TABLE IF EXISTS	plaats_vlak;

DROP TABLE IF EXISTS	plantopografie;
DROP TABLE IF EXISTS	plantopografie_lijn;
DROP TABLE IF EXISTS	plantopografie_punt;
DROP TABLE IF EXISTS	plantopografie_vlak;

DROP TABLE IF EXISTS	registratiefgebied;
DROP TABLE IF EXISTS	registratiefgebied_vlak;

DROP TABLE IF EXISTS	relief;
DROP TABLE IF EXISTS	relief_lijn;

DROP TABLE IF EXISTS	spoorbaandeel;
DROP TABLE IF EXISTS	spoorbaandeel_lijn;

DROP TABLE IF EXISTS	terrein;
DROP TABLE IF EXISTS	terrein_vlak;

DROP TABLE IF EXISTS	waterdeel;
DROP TABLE IF EXISTS	waterdeel_lijn;
DROP TABLE IF EXISTS	waterdeel_vlak;

DROP TABLE IF EXISTS	wegdeel;
DROP TABLE IF EXISTS	wegdeel_lijn;
DROP TABLE IF EXISTS	wegdeel_punt;

SET search_path="$user",public;
