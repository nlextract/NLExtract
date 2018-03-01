-- Bijwerken multiattributen gebouw
update gebouw set typegebouw='(2:religieus gebouw,school)' where typegebouw='(2:school,religieus gebouw)';
update gebouw set typegebouw='(2:religieus gebouw,sporthal)' where typegebouw='(2:sporthal,religieus gebouw)';
update gebouw set typegebouw='(2:religieus gebouw,toren)' where typegebouw='(2:toren,religieus gebouw)';
update gebouw set typegebouw='(3:religieus gebouw,sporthal,zwembad)' where typegebouw='(3:sporthal,zwembad,religieus gebouw)';
