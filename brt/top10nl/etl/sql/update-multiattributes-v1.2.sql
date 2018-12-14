-- Bijwerken multiattributen gebouw
update gebouw set typegebouw='(2:gemeentehuis,huizenblok)' where typegebouw='(2:huizenblok,gemeentehuis)';
update gebouw set typegebouw='(1:stationsgebouw)' where typegebouw='(2:stationsgebouw,stationsgebouw)';
update gebouw set typegebouw='(2:kasteel,toren)' where typegebouw='(2:toren,kasteel)';
update gebouw set typegebouw='(2:stationsgebouw,toren)' where typegebouw='(2:toren,stationsgebouw)';
update gebouw set typegebouw='(2:parkeerdak, parkeerdek, parkeergarage,stationsgebouw)' where typegebouw='(3:stationsgebouw,parkeerdak, parkeerdek, parkeergarage,stationsgebouw)';

-- Bijwerken multiattributen terrein
update terrein set voorkomen='(2:dras, moerassig,met riet)' where voorkomen='(2:met riet,dras, moerassig)';
