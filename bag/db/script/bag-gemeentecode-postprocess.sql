--
-- Postprocessing van de gemeentecode
-- 
-- De gemeentecode in de brontabel worden als numeriek opgegeven, maar uiteindelijk
-- willen we ze beschikbaar hebben als string met voorloopnullen.
--
-- Auteur: Rob van Loon

UPDATE provincie_gemeente SET gemeentecode = LPAD(gemeentecode, 4, '0');
