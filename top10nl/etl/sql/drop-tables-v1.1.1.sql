-- Auteur: Frank Steggink
-- Doel: script om Top10NL tabellen te verwijderen.
-- Zowel de originele als de opgesplitste tabellen worden hiermee verwijderd.

SET search_path={schema},public;

DROP TABLE IF EXISTS	functioneelgebied;
DROP TABLE IF EXISTS	functioneelgebied_punt;
DROP TABLE IF EXISTS	functioneelgebied_vlak;

DROP TABLE IF EXISTS	gebouw;
DROP TABLE IF EXISTS	gebouw_vlak;

DROP TABLE IF EXISTS	geografischgebied;
DROP TABLE IF EXISTS	geografischgebied_punt;
DROP TABLE IF EXISTS	geografischgebied_vlak;

DROP TABLE IF EXISTS	hoogteofdiepte_punt;
DROP TABLE IF EXISTS	hoogteofdieptepunt;

DROP TABLE IF EXISTS	hoogteverschil;
DROP TABLE IF EXISTS	hoogteverschilhz_lijn;
DROP TABLE IF EXISTS	hoogteverschillz_lijn;

DROP TABLE IF EXISTS	inrichtingselement;
DROP TABLE IF EXISTS	inrichtingselement_lijn;
DROP TABLE IF EXISTS	inrichtingselement_punt;

DROP TABLE IF EXISTS	isohoogte;
DROP TABLE IF EXISTS	isohoogte_lijn;

DROP TABLE IF EXISTS	kadeofwal;
DROP TABLE IF EXISTS	kadeofwal_lijn;

DROP TABLE IF EXISTS	overigrelief;
DROP TABLE IF EXISTS	overigrelief_lijn;
DROP TABLE IF EXISTS	overigrelief_punt;

DROP TABLE IF EXISTS	registratiefgebied;
DROP TABLE IF EXISTS	registratiefgebied_vlak;
DROP TABLE IF EXISTS	registratiefgebied_punt;

DROP TABLE IF EXISTS	spoorbaandeel;
DROP TABLE IF EXISTS	spoorbaandeel_lijn;
DROP TABLE IF EXISTS	spoorbaandeel_punt;

DROP TABLE IF EXISTS	terrein;
DROP TABLE IF EXISTS	terrein_vlak;

DROP TABLE IF EXISTS	waterdeel;
DROP TABLE IF EXISTS	waterdeel_lijn;
DROP TABLE IF EXISTS	waterdeel_punt;
DROP TABLE IF EXISTS	waterdeel_vlak;

DROP TABLE IF EXISTS	wegdeel;
DROP TABLE IF EXISTS	wegdeel_hartlijn;
DROP TABLE IF EXISTS	wegdeel_hartpunt;
DROP TABLE IF EXISTS	wegdeel_lijn;
DROP TABLE IF EXISTS	wegdeel_punt;
DROP TABLE IF EXISTS	wegdeel_vlak;

SET search_path="$user",public;
