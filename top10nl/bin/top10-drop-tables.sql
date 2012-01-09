DROP TABLE IF EXISTS 	wegdeel_vlak;
DROP TABLE IF EXISTS 	wegdeel_lijn;
DROP TABLE IF EXISTS 	wegdeel_punt;
DROP TABLE IF EXISTS 	wegdeel_hartlijn;
DROP TABLE IF EXISTS 	wegdeel_hartpunt;
DROP TABLE IF EXISTS 	functioneelgebied_punt;
DROP TABLE IF EXISTS 	gebouw_vlak;
DROP TABLE IF EXISTS	terrein_vlak;
DROP TABLE IF EXISTS	waterdeel_lijn;
DROP TABLE IF EXISTS	waterdeel_vlak;

DROP TABLE IF EXISTS	geografischgebied_punt;
DROP TABLE IF EXISTS	hoogteofdiepte_punt;
DROP TABLE IF EXISTS	hoogteverschilhz_lijn;
DROP TABLE IF EXISTS	hoogteverschillz_lijn;
DROP TABLE IF EXISTS	isohoogte_lijn;
DROP TABLE IF EXISTS	kadeofwal_lijn;
DROP TABLE IF EXISTS	registratiefgebied_vlak;
DROP TABLE IF EXISTS	spoorbaandeel_lijn;
DROP TABLE IF EXISTS	spoorbaandeel_punt;

DROP TABLE IF EXISTS	waterdeel;
DROP TABLE IF EXISTS	wegdeel;
DROP TABLE IF EXISTS	functioneelgebied;
DROP TABLE IF EXISTS	gebouw;
DROP TABLE IF EXISTS	terrein;
DELETE FROM geometry_columns;

