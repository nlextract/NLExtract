-- De entries in koppeltabel voor gemeente Ronde Venen uit
-- ../kadaster-woonplaats-gemeente-24jan2012.csv zijn:
--
-- Abcoude;1332;;;De Ronde Venen;0736;20110101;
-- Amstelhoek;1932;;;De Ronde Venen;0736;;
-- Baambrugge;1333;;;De Ronde Venen;0736;20110101;
-- De Hoef;1934;;;De Ronde Venen;0736;;
-- Mijdrecht;1929;;;De Ronde Venen;0736;;
-- Vinkeveen;1930;;;De Ronde Venen;0736;;
-- Waverveen;1933;;;De Ronde Venen;0736;;
-- Wilnis;1931;;;De Ronde Venen;0736;;

-- Uit BAG woonplaatsactueelbestaand VIEW
-- pdok=> select woonplaatsnaam,identificatie from bag.woonplaatsactueelbestaand
--  where woonplaatsnaam in ('Abcoude', 'Amstelhoek', 'Baambrugge', 'de Hoef', 'Mijdrecht','Vinkeveen', 'Waverveen','Wilnis');
---
-- woonplaatsnaam | identificatie
-- ---------------+--------------
-- Abcoude | 1332
-- Baambrugge | 1333
-- Wilnis | 1931
-- Amstelhoek | 3547
-- de Hoef | 3548
-- Mijdrecht | 3549
-- Vinkeveen | 3550
-- Waverveen | 3551
--
-- Dus Amstelhoek, de Hoef, Mijdrecht, Vinkeveen, Waverveen moeten aangepast in koppeltabel

UPDATE gemeente_woonplaats SET woonplaatscode = 3547 WHERE woonplaatsnaam = 'Amstelhoek';
UPDATE gemeente_woonplaats SET woonplaatscode = 3548 WHERE woonplaatsnaam = 'de Hoef';
UPDATE gemeente_woonplaats SET woonplaatscode = 3549 WHERE woonplaatsnaam = 'Mijdrecht';
UPDATE gemeente_woonplaats SET woonplaatscode = 3550 WHERE woonplaatsnaam = 'Vinkeveen';
UPDATE gemeente_woonplaats SET woonplaatscode = 3551 WHERE woonplaatsnaam = 'Waverveen';
