-- -- Ontdubbelen voorkomens panden
-- create table pand_dubbelevoorkomens as select max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, count(*) aantal from pand group by lokaalid, tijdstipregistratie, lv_publicatiedatum having count(*) > 1 order by lokaalid, tijdstipregistratie, lv_publicatiedatum;
--
-- create table pand_todelete as select p.ogc_fid from pand p join pand_dubbelevoorkomens d on p.lokaalid=d.lokaalid and p.tijdstipregistratie=d.tijdstipregistratie and p.lv_publicatiedatum=d.lv_publicatiedatum and p.ogc_fid!=d.max_fid;
--
-- delete from pand where ogc_fid in (select ogc_fid from pand_todelete);
-- drop table pand_dubbelevoorkomens;
-- drop table pand_todelete;
--
-- -- Ontdubbelen voorkomens wegdeel
-- create table wegdeel_dubbelevoorkomens as select max(ogc_fid) max_fid, lokaalid, tijdstipregistratie, lv_publicatiedatum, count(*) aantal from wegdeel group by lokaalid, tijdstipregistratie, lv_publicatiedatum having count(*) > 1 order by lokaalid, tijdstipregistratie, lv_publicatiedatum;
--
-- create table wegdeel_todelete as select p.ogc_fid from wegdeel p join wegdeel_dubbelevoorkomens d on p.lokaalid=d.lokaalid and p.tijdstipregistratie=d.tijdstipregistratie and p.lv_publicatiedatum=d.lv_publicatiedatum and p.ogc_fid!=d.max_fid;
--
-- delete from wegdeel where ogc_fid in (select ogc_fid from wegdeel_todelete);
-- -- drop table wegdeel_dubbelevoorkomens;
-- -- drop table wegdeel_todelete;
--
-- bak
create index bak_lokaalid on bak(lokaalid);

create table bak_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from bak where lokaalid in (select lokaalid from bak where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update bak_tmp a set eindregistratie=b.tijdstipregistratie from bak_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update bak a set eindregistratie=b.eindregistratie from bak_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table bak_tmp;

create index bak_tijdstipregistratie on bak(tijdstipregistratie);
create table bak_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from bak where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index bak_tmp_lokaalid on bak_tmp(lokaalid);

-- create table bak_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from bak a, bak_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update bak a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from bak_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table bak_tmp;
drop index bak_lokaalid;
drop index bak_tijdstipregistratie;

-- begroeidterreindeel
create index begroeidterreindeel_lokaalid on begroeidterreindeel(lokaalid);

create table begroeidterreindeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from begroeidterreindeel where lokaalid in (select lokaalid from begroeidterreindeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update begroeidterreindeel_tmp a set eindregistratie=b.tijdstipregistratie from begroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update begroeidterreindeel a set eindregistratie=b.eindregistratie from begroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table begroeidterreindeel_tmp;

create index begroeidterreindeel_tijdstipregistratie on begroeidterreindeel(tijdstipregistratie);
create table begroeidterreindeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from begroeidterreindeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index begroeidterreindeel_tmp_lokaalid on begroeidterreindeel_tmp(lokaalid);

-- create table begroeidterreindeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from begroeidterreindeel a, begroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update begroeidterreindeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from begroeidterreindeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table begroeidterreindeel_tmp;
drop index begroeidterreindeel_lokaalid;
drop index begroeidterreindeel_tijdstipregistratie;

-- bord
create index bord_lokaalid on bord(lokaalid);

create table bord_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from bord where lokaalid in (select lokaalid from bord where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update bord_tmp a set eindregistratie=b.tijdstipregistratie from bord_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update bord a set eindregistratie=b.eindregistratie from bord_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table bord_tmp;

create index bord_tijdstipregistratie on bord(tijdstipregistratie);
create table bord_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from bord where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index bord_tmp_lokaalid on bord_tmp(lokaalid);

-- create table bord_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from bord a, bord_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update bord a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from bord_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table bord_tmp;
drop index bord_lokaalid;
drop index bord_tijdstipregistratie;

-- buurt
create index buurt_lokaalid on buurt(lokaalid);

create table buurt_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from buurt where lokaalid in (select lokaalid from buurt where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update buurt_tmp a set eindregistratie=b.tijdstipregistratie from buurt_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update buurt a set eindregistratie=b.eindregistratie from buurt_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table buurt_tmp;

create index buurt_tijdstipregistratie on buurt(tijdstipregistratie);
create table buurt_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from buurt where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index buurt_tmp_lokaalid on buurt_tmp(lokaalid);

-- create table buurt_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from buurt a, buurt_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update buurt a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from buurt_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table buurt_tmp;
drop index buurt_lokaalid;
drop index buurt_tijdstipregistratie;

-- functioneelgebied
create index functioneelgebied_lokaalid on functioneelgebied(lokaalid);

create table functioneelgebied_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from functioneelgebied where lokaalid in (select lokaalid from functioneelgebied where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update functioneelgebied_tmp a set eindregistratie=b.tijdstipregistratie from functioneelgebied_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update functioneelgebied a set eindregistratie=b.eindregistratie from functioneelgebied_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table functioneelgebied_tmp;

create index functioneelgebied_tijdstipregistratie on functioneelgebied(tijdstipregistratie);
create table functioneelgebied_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from functioneelgebied where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index functioneelgebied_tmp_lokaalid on functioneelgebied_tmp(lokaalid);

-- create table functioneelgebied_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from functioneelgebied a, functioneelgebied_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update functioneelgebied a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from functioneelgebied_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table functioneelgebied_tmp;
drop index functioneelgebied_lokaalid;
drop index functioneelgebied_tijdstipregistratie;

-- gebouwinstallatie
create index gebouwinstallatie_lokaalid on gebouwinstallatie(lokaalid);

create table gebouwinstallatie_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from gebouwinstallatie where lokaalid in (select lokaalid from gebouwinstallatie where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update gebouwinstallatie_tmp a set eindregistratie=b.tijdstipregistratie from gebouwinstallatie_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update gebouwinstallatie a set eindregistratie=b.eindregistratie from gebouwinstallatie_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table gebouwinstallatie_tmp;

create index gebouwinstallatie_tijdstipregistratie on gebouwinstallatie(tijdstipregistratie);
create table gebouwinstallatie_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from gebouwinstallatie where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index gebouwinstallatie_tmp_lokaalid on gebouwinstallatie_tmp(lokaalid);

-- create table gebouwinstallatie_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from gebouwinstallatie a, gebouwinstallatie_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update gebouwinstallatie a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from gebouwinstallatie_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table gebouwinstallatie_tmp;
drop index gebouwinstallatie_lokaalid;
drop index gebouwinstallatie_tijdstipregistratie;

-- installatie
create index installatie_lokaalid on installatie(lokaalid);

create table installatie_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from installatie where lokaalid in (select lokaalid from installatie where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update installatie_tmp a set eindregistratie=b.tijdstipregistratie from installatie_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update installatie a set eindregistratie=b.eindregistratie from installatie_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table installatie_tmp;

create index installatie_tijdstipregistratie on installatie(tijdstipregistratie);
create table installatie_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from installatie where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index installatie_tmp_lokaalid on installatie_tmp(lokaalid);

-- create table installatie_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from installatie a, installatie_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update installatie a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from installatie_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table installatie_tmp;
drop index installatie_lokaalid;
drop index installatie_tijdstipregistratie;

-- kast
create index kast_lokaalid on kast(lokaalid);

create table kast_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from kast where lokaalid in (select lokaalid from kast where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update kast_tmp a set eindregistratie=b.tijdstipregistratie from kast_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update kast a set eindregistratie=b.eindregistratie from kast_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table kast_tmp;

create index kast_tijdstipregistratie on kast(tijdstipregistratie);
create table kast_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from kast where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index kast_tmp_lokaalid on kast_tmp(lokaalid);

-- create table kast_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from kast a, kast_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update kast a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from kast_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table kast_tmp;
drop index kast_lokaalid;
drop index kast_tijdstipregistratie;

-- kunstwerkdeel
create index kunstwerkdeel_lokaalid on kunstwerkdeel(lokaalid);

create table kunstwerkdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from kunstwerkdeel where lokaalid in (select lokaalid from kunstwerkdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update kunstwerkdeel_tmp a set eindregistratie=b.tijdstipregistratie from kunstwerkdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update kunstwerkdeel a set eindregistratie=b.eindregistratie from kunstwerkdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table kunstwerkdeel_tmp;

create index kunstwerkdeel_tijdstipregistratie on kunstwerkdeel(tijdstipregistratie);
create table kunstwerkdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from kunstwerkdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index kunstwerkdeel_tmp_lokaalid on kunstwerkdeel_tmp(lokaalid);

-- create table kunstwerkdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from kunstwerkdeel a, kunstwerkdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update kunstwerkdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from kunstwerkdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table kunstwerkdeel_tmp;
drop index kunstwerkdeel_lokaalid;
drop index kunstwerkdeel_tijdstipregistratie;

-- mast
create index mast_lokaalid on mast(lokaalid);

create table mast_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from mast where lokaalid in (select lokaalid from mast where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update mast_tmp a set eindregistratie=b.tijdstipregistratie from mast_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update mast a set eindregistratie=b.eindregistratie from mast_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table mast_tmp;

create index mast_tijdstipregistratie on mast(tijdstipregistratie);
create table mast_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from mast where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index mast_tmp_lokaalid on mast_tmp(lokaalid);

-- create table mast_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from mast a, mast_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update mast a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from mast_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table mast_tmp;
drop index mast_lokaalid;
drop index mast_tijdstipregistratie;

-- onbegroeidterreindeel
create index onbegroeidterreindeel_lokaalid on onbegroeidterreindeel(lokaalid);

create table onbegroeidterreindeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from onbegroeidterreindeel where lokaalid in (select lokaalid from onbegroeidterreindeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update onbegroeidterreindeel_tmp a set eindregistratie=b.tijdstipregistratie from onbegroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update onbegroeidterreindeel a set eindregistratie=b.eindregistratie from onbegroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table onbegroeidterreindeel_tmp;

create index onbegroeidterreindeel_tijdstipregistratie on onbegroeidterreindeel(tijdstipregistratie);
create table onbegroeidterreindeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from onbegroeidterreindeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index onbegroeidterreindeel_tmp_lokaalid on onbegroeidterreindeel_tmp(lokaalid);

-- create table onbegroeidterreindeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from onbegroeidterreindeel a, onbegroeidterreindeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update onbegroeidterreindeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from onbegroeidterreindeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table onbegroeidterreindeel_tmp;
drop index onbegroeidterreindeel_lokaalid;
drop index onbegroeidterreindeel_tijdstipregistratie;

-- ondersteunendwaterdeel
create index ondersteunendwaterdeel_lokaalid on ondersteunendwaterdeel(lokaalid);

create table ondersteunendwaterdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from ondersteunendwaterdeel where lokaalid in (select lokaalid from ondersteunendwaterdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update ondersteunendwaterdeel_tmp a set eindregistratie=b.tijdstipregistratie from ondersteunendwaterdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update ondersteunendwaterdeel a set eindregistratie=b.eindregistratie from ondersteunendwaterdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table ondersteunendwaterdeel_tmp;

create index ondersteunendwaterdeel_tijdstipregistratie on ondersteunendwaterdeel(tijdstipregistratie);
create table ondersteunendwaterdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from ondersteunendwaterdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index ondersteunendwaterdeel_tmp_lokaalid on ondersteunendwaterdeel_tmp(lokaalid);

-- create table ondersteunendwaterdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from ondersteunendwaterdeel a, ondersteunendwaterdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update ondersteunendwaterdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from ondersteunendwaterdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table ondersteunendwaterdeel_tmp;
drop index ondersteunendwaterdeel_lokaalid;
drop index ondersteunendwaterdeel_tijdstipregistratie;

-- ondersteunendwegdeel
create index ondersteunendwegdeel_lokaalid on ondersteunendwegdeel(lokaalid);

create table ondersteunendwegdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from ondersteunendwegdeel where lokaalid in (select lokaalid from ondersteunendwegdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update ondersteunendwegdeel_tmp a set eindregistratie=b.tijdstipregistratie from ondersteunendwegdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update ondersteunendwegdeel a set eindregistratie=b.eindregistratie from ondersteunendwegdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table ondersteunendwegdeel_tmp;

create index ondersteunendwegdeel_tijdstipregistratie on ondersteunendwegdeel(tijdstipregistratie);
create table ondersteunendwegdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from ondersteunendwegdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index ondersteunendwegdeel_tmp_lokaalid on ondersteunendwegdeel_tmp(lokaalid);

-- create table ondersteunendwegdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from ondersteunendwegdeel a, ondersteunendwegdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update ondersteunendwegdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from ondersteunendwegdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table ondersteunendwegdeel_tmp;
drop index ondersteunendwegdeel_lokaalid;
drop index ondersteunendwegdeel_tijdstipregistratie;

-- ongeclassificeerdobject
create index ongeclassificeerdobject_lokaalid on ongeclassificeerdobject(lokaalid);

create table ongeclassificeerdobject_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from ongeclassificeerdobject where lokaalid in (select lokaalid from ongeclassificeerdobject where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update ongeclassificeerdobject_tmp a set eindregistratie=b.tijdstipregistratie from ongeclassificeerdobject_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update ongeclassificeerdobject a set eindregistratie=b.eindregistratie from ongeclassificeerdobject_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table ongeclassificeerdobject_tmp;

create index ongeclassificeerdobject_tijdstipregistratie on ongeclassificeerdobject(tijdstipregistratie);
create table ongeclassificeerdobject_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from ongeclassificeerdobject where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index ongeclassificeerdobject_tmp_lokaalid on ongeclassificeerdobject_tmp(lokaalid);

-- create table ongeclassificeerdobject_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from ongeclassificeerdobject a, ongeclassificeerdobject_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update ongeclassificeerdobject a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from ongeclassificeerdobject_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table ongeclassificeerdobject_tmp;
drop index ongeclassificeerdobject_lokaalid;
drop index ongeclassificeerdobject_tijdstipregistratie;

-- openbareruimte
create index openbareruimte_lokaalid on openbareruimte(lokaalid);

create table openbareruimte_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from openbareruimte where lokaalid in (select lokaalid from openbareruimte where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update openbareruimte_tmp a set eindregistratie=b.tijdstipregistratie from openbareruimte_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update openbareruimte a set eindregistratie=b.eindregistratie from openbareruimte_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table openbareruimte_tmp;

create index openbareruimte_tijdstipregistratie on openbareruimte(tijdstipregistratie);
create table openbareruimte_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from openbareruimte where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index openbareruimte_tmp_lokaalid on openbareruimte_tmp(lokaalid);

-- create table openbareruimte_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from openbareruimte a, openbareruimte_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update openbareruimte a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from openbareruimte_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table openbareruimte_tmp;
drop index openbareruimte_lokaalid;
drop index openbareruimte_tijdstipregistratie;

-- openbareruimtelabel
create index openbareruimtelabel_lokaalid on openbareruimtelabel(lokaalid);
create index openbareruimtelabel_tijdstipregistratie on openbareruimtelabel(tijdstipregistratie);

create table openbareruimtelabel_unique as
select distinct namespace, lokaalid, objectbegintijd, objecteindtijd, tijdstipregistratie, eindregistratie, lv_publicatiedatum from openbareruimtelabel;

create table openbareruimtelabel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from openbareruimtelabel_unique where lokaalid in (select lokaalid from openbareruimtelabel_unique where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update openbareruimtelabel_tmp a set eindregistratie=b.tijdstipregistratie from openbareruimtelabel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update openbareruimtelabel a set eindregistratie=b.eindregistratie from openbareruimtelabel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table openbareruimtelabel_tmp;

create table openbareruimtelabel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from openbareruimtelabel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index openbareruimtelabel_tmp_lokaalid on openbareruimtelabel_tmp(lokaalid);

-- create table openbareruimtelabel_tofix as select distinct a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from openbareruimtelabel a, openbareruimtelabel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update openbareruimtelabel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from openbareruimtelabel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table openbareruimtelabel_tmp;
drop table openbareruimtelabel_unique;
drop index openbareruimtelabel_lokaalid;
drop index openbareruimtelabel_tijdstipregistratie;

-- overbruggingsdeel
create index overbruggingsdeel_lokaalid on overbruggingsdeel(lokaalid);

create table overbruggingsdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from overbruggingsdeel where lokaalid in (select lokaalid from overbruggingsdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update overbruggingsdeel_tmp a set eindregistratie=b.tijdstipregistratie from overbruggingsdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update overbruggingsdeel a set eindregistratie=b.eindregistratie from overbruggingsdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table overbruggingsdeel_tmp;

create index overbruggingsdeel_tijdstipregistratie on overbruggingsdeel(tijdstipregistratie);
create table overbruggingsdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from overbruggingsdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index overbruggingsdeel_tmp_lokaalid on overbruggingsdeel_tmp(lokaalid);

-- create table overbruggingsdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from overbruggingsdeel a, overbruggingsdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update overbruggingsdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from overbruggingsdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table overbruggingsdeel_tmp;
drop index overbruggingsdeel_lokaalid;
drop index overbruggingsdeel_tijdstipregistratie;

-- overigbouwwerk
create index overigbouwwerk_lokaalid on overigbouwwerk(lokaalid);

create table overigbouwwerk_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from overigbouwwerk where lokaalid in (select lokaalid from overigbouwwerk where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update overigbouwwerk_tmp a set eindregistratie=b.tijdstipregistratie from overigbouwwerk_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update overigbouwwerk a set eindregistratie=b.eindregistratie from overigbouwwerk_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table overigbouwwerk_tmp;

create index overigbouwwerk_tijdstipregistratie on overigbouwwerk(tijdstipregistratie);
create table overigbouwwerk_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from overigbouwwerk where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index overigbouwwerk_tmp_lokaalid on overigbouwwerk_tmp(lokaalid);

-- create table overigbouwwerk_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from overigbouwwerk a, overigbouwwerk_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update overigbouwwerk a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from overigbouwwerk_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table overigbouwwerk_tmp;
drop index overigbouwwerk_lokaalid;
drop index overigbouwwerk_tijdstipregistratie;

-- overigescheiding
create index overigescheiding_lokaalid on overigescheiding(lokaalid);

create table overigescheiding_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from overigescheiding where lokaalid in (select lokaalid from overigescheiding where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update overigescheiding_tmp a set eindregistratie=b.tijdstipregistratie from overigescheiding_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update overigescheiding a set eindregistratie=b.eindregistratie from overigescheiding_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table overigescheiding_tmp;

create index overigescheiding_tijdstipregistratie on overigescheiding(tijdstipregistratie);
create table overigescheiding_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from overigescheiding where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index overigescheiding_tmp_lokaalid on overigescheiding_tmp(lokaalid);

-- create table overigescheiding_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from overigescheiding a, overigescheiding_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update overigescheiding a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from overigescheiding_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table overigescheiding_tmp;
drop index overigescheiding_lokaalid;
drop index overigescheiding_tijdstipregistratie;

-- paal
create index paal_lokaalid on paal(lokaalid);

create table paal_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from paal where lokaalid in (select lokaalid from paal where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update paal_tmp a set eindregistratie=b.tijdstipregistratie from paal_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update paal a set eindregistratie=b.eindregistratie from paal_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table paal_tmp;

create index paal_tijdstipregistratie on paal(tijdstipregistratie);
create table paal_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from paal where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index paal_tmp_lokaalid on paal_tmp(lokaalid);

-- create table paal_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from paal a, paal_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update paal a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from paal_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table paal_tmp;
drop index paal_lokaalid;
drop index paal_tijdstipregistratie;

-- pand
create index pand_lokaalid on pand(lokaalid);

create table pand_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from pand where lokaalid in (select lokaalid from pand where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update pand_tmp a set eindregistratie=b.tijdstipregistratie from pand_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update pand a set eindregistratie=b.eindregistratie from pand_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table pand_tmp;

create index pand_tijdstipregistratie on pand(tijdstipregistratie);
create table pand_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from pand where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index pand_tmp_lokaalid on pand_tmp(lokaalid);

-- create table pand_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from pand a, pand_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update pand a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from pand_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table pand_tmp;
drop index pand_lokaalid;
drop index pand_tijdstipregistratie;

-- put
create index put_lokaalid on put(lokaalid);

create table put_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from put where lokaalid in (select lokaalid from put where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update put_tmp a set eindregistratie=b.tijdstipregistratie from put_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update put a set eindregistratie=b.eindregistratie from put_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table put_tmp;

create index put_tijdstipregistratie on put(tijdstipregistratie);
create table put_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from put where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index put_tmp_lokaalid on put_tmp(lokaalid);

-- create table put_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from put a, put_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update put a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from put_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table put_tmp;
drop index put_lokaalid;
drop index put_tijdstipregistratie;

-- scheiding
create index scheiding_lokaalid on scheiding(lokaalid);

create table scheiding_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from scheiding where lokaalid in (select lokaalid from scheiding where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update scheiding_tmp a set eindregistratie=b.tijdstipregistratie from scheiding_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update scheiding a set eindregistratie=b.eindregistratie from scheiding_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table scheiding_tmp;

create index scheiding_tijdstipregistratie on scheiding(tijdstipregistratie);
create table scheiding_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from scheiding where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index scheiding_tmp_lokaalid on scheiding_tmp(lokaalid);

-- create table scheiding_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from scheiding a, scheiding_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update scheiding a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from scheiding_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table scheiding_tmp;
drop index scheiding_lokaalid;
drop index scheiding_tijdstipregistratie;

-- sensor
create index sensor_lokaalid on sensor(lokaalid);

create table sensor_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from sensor where lokaalid in (select lokaalid from sensor where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update sensor_tmp a set eindregistratie=b.tijdstipregistratie from sensor_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update sensor a set eindregistratie=b.eindregistratie from sensor_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table sensor_tmp;

create index sensor_tijdstipregistratie on sensor(tijdstipregistratie);
create table sensor_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from sensor where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index sensor_tmp_lokaalid on sensor_tmp(lokaalid);

-- create table sensor_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from sensor a, sensor_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update sensor a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from sensor_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table sensor_tmp;
drop index sensor_lokaalid;
drop index sensor_tijdstipregistratie;

-- spoor
create index spoor_lokaalid on spoor(lokaalid);

create table spoor_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from spoor where lokaalid in (select lokaalid from spoor where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update spoor_tmp a set eindregistratie=b.tijdstipregistratie from spoor_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update spoor a set eindregistratie=b.eindregistratie from spoor_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table spoor_tmp;

create index spoor_tijdstipregistratie on spoor(tijdstipregistratie);
create table spoor_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from spoor where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index spoor_tmp_lokaalid on spoor_tmp(lokaalid);

-- create table spoor_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from spoor a, spoor_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update spoor a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from spoor_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table spoor_tmp;
drop index spoor_lokaalid;
drop index spoor_tijdstipregistratie;

-- stadsdeel
create index stadsdeel_lokaalid on stadsdeel(lokaalid);

create table stadsdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from stadsdeel where lokaalid in (select lokaalid from stadsdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update stadsdeel_tmp a set eindregistratie=b.tijdstipregistratie from stadsdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update stadsdeel a set eindregistratie=b.eindregistratie from stadsdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table stadsdeel_tmp;

create index stadsdeel_tijdstipregistratie on stadsdeel(tijdstipregistratie);
create table stadsdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from stadsdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index stadsdeel_tmp_lokaalid on stadsdeel_tmp(lokaalid);

-- create table stadsdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from stadsdeel a, stadsdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update stadsdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from stadsdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table stadsdeel_tmp;
drop index stadsdeel_lokaalid;
drop index stadsdeel_tijdstipregistratie;

-- straatmeubilair
create index straatmeubilair_lokaalid on straatmeubilair(lokaalid);

create table straatmeubilair_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from straatmeubilair where lokaalid in (select lokaalid from straatmeubilair where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update straatmeubilair_tmp a set eindregistratie=b.tijdstipregistratie from straatmeubilair_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update straatmeubilair a set eindregistratie=b.eindregistratie from straatmeubilair_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table straatmeubilair_tmp;

create index straatmeubilair_tijdstipregistratie on straatmeubilair(tijdstipregistratie);
create table straatmeubilair_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from straatmeubilair where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index straatmeubilair_tmp_lokaalid on straatmeubilair_tmp(lokaalid);

-- create table straatmeubilair_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from straatmeubilair a, straatmeubilair_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update straatmeubilair a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from straatmeubilair_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table straatmeubilair_tmp;
drop index straatmeubilair_lokaalid;
drop index straatmeubilair_tijdstipregistratie;

-- tunneldeel
create index tunneldeel_lokaalid on tunneldeel(lokaalid);

create table tunneldeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from tunneldeel where lokaalid in (select lokaalid from tunneldeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update tunneldeel_tmp a set eindregistratie=b.tijdstipregistratie from tunneldeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update tunneldeel a set eindregistratie=b.eindregistratie from tunneldeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table tunneldeel_tmp;

create index tunneldeel_tijdstipregistratie on tunneldeel(tijdstipregistratie);
create table tunneldeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from tunneldeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index tunneldeel_tmp_lokaalid on tunneldeel_tmp(lokaalid);

-- create table tunneldeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from tunneldeel a, tunneldeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update tunneldeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from tunneldeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table tunneldeel_tmp;
drop index tunneldeel_lokaalid;
drop index tunneldeel_tijdstipregistratie;

-- vegetatieobject
create index vegetatieobject_lokaalid on vegetatieobject(lokaalid);

create table vegetatieobject_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from vegetatieobject where lokaalid in (select lokaalid from vegetatieobject where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update vegetatieobject_tmp a set eindregistratie=b.tijdstipregistratie from vegetatieobject_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update vegetatieobject a set eindregistratie=b.eindregistratie from vegetatieobject_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table vegetatieobject_tmp;

create index vegetatieobject_tijdstipregistratie on vegetatieobject(tijdstipregistratie);
create table vegetatieobject_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from vegetatieobject where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index vegetatieobject_tmp_lokaalid on vegetatieobject_tmp(lokaalid);

-- create table vegetatieobject_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from vegetatieobject a, vegetatieobject_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update vegetatieobject a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from vegetatieobject_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table vegetatieobject_tmp;
drop index vegetatieobject_lokaalid;
drop index vegetatieobject_tijdstipregistratie;

-- waterdeel
create index waterdeel_lokaalid on waterdeel(lokaalid);

create table waterdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from waterdeel where lokaalid in (select lokaalid from waterdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update waterdeel_tmp a set eindregistratie=b.tijdstipregistratie from waterdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update waterdeel a set eindregistratie=b.eindregistratie from waterdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table waterdeel_tmp;

create index waterdeel_tijdstipregistratie on waterdeel(tijdstipregistratie);
create table waterdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from waterdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index waterdeel_tmp_lokaalid on waterdeel_tmp(lokaalid);

-- create table waterdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from waterdeel a, waterdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update waterdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from waterdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table waterdeel_tmp;
drop index waterdeel_lokaalid;
drop index waterdeel_tijdstipregistratie;

-- waterinrichtingselement
create index waterinrichtingselement_lokaalid on waterinrichtingselement(lokaalid);

create table waterinrichtingselement_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from waterinrichtingselement where lokaalid in (select lokaalid from waterinrichtingselement where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update waterinrichtingselement_tmp a set eindregistratie=b.tijdstipregistratie from waterinrichtingselement_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update waterinrichtingselement a set eindregistratie=b.eindregistratie from waterinrichtingselement_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table waterinrichtingselement_tmp;

create index waterinrichtingselement_tijdstipregistratie on waterinrichtingselement(tijdstipregistratie);
create table waterinrichtingselement_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from waterinrichtingselement where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index waterinrichtingselement_tmp_lokaalid on waterinrichtingselement_tmp(lokaalid);

-- create table waterinrichtingselement_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from waterinrichtingselement a, waterinrichtingselement_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update waterinrichtingselement a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from waterinrichtingselement_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table waterinrichtingselement_tmp;
drop index waterinrichtingselement_lokaalid;
drop index waterinrichtingselement_tijdstipregistratie;

-- waterschap
create index waterschap_lokaalid on waterschap(lokaalid);

create table waterschap_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from waterschap where lokaalid in (select lokaalid from waterschap where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update waterschap_tmp a set eindregistratie=b.tijdstipregistratie from waterschap_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update waterschap a set eindregistratie=b.eindregistratie from waterschap_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table waterschap_tmp;

create index waterschap_tijdstipregistratie on waterschap(tijdstipregistratie);
create table waterschap_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from waterschap where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index waterschap_tmp_lokaalid on waterschap_tmp(lokaalid);

-- create table waterschap_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from waterschap a, waterschap_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update waterschap a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from waterschap_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table waterschap_tmp;
drop index waterschap_lokaalid;
drop index waterschap_tijdstipregistratie;

-- wegdeel
create index wegdeel_lokaalid on wegdeel(lokaalid);

create table wegdeel_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from wegdeel where lokaalid in (select lokaalid from wegdeel where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update wegdeel_tmp a set eindregistratie=b.tijdstipregistratie from wegdeel_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update wegdeel a set eindregistratie=b.eindregistratie from wegdeel_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table wegdeel_tmp;

create index wegdeel_tijdstipregistratie on wegdeel(tijdstipregistratie);
create table wegdeel_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from wegdeel where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index wegdeel_tmp_lokaalid on wegdeel_tmp(lokaalid);

-- create table wegdeel_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from wegdeel a, wegdeel_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update wegdeel a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from wegdeel_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table wegdeel_tmp;
drop index wegdeel_lokaalid;
drop index wegdeel_tijdstipregistratie;

-- weginrichtingselement
create index weginrichtingselement_lokaalid on weginrichtingselement(lokaalid);

create table weginrichtingselement_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from weginrichtingselement where lokaalid in (select lokaalid from weginrichtingselement where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update weginrichtingselement_tmp a set eindregistratie=b.tijdstipregistratie from weginrichtingselement_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update weginrichtingselement a set eindregistratie=b.eindregistratie from weginrichtingselement_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table weginrichtingselement_tmp;

create index weginrichtingselement_tijdstipregistratie on weginrichtingselement(tijdstipregistratie);
create table weginrichtingselement_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from weginrichtingselement where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index weginrichtingselement_tmp_lokaalid on weginrichtingselement_tmp(lokaalid);

-- create table weginrichtingselement_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from weginrichtingselement a, weginrichtingselement_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update weginrichtingselement a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from weginrichtingselement_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table weginrichtingselement_tmp;
drop index weginrichtingselement_lokaalid;
drop index weginrichtingselement_tijdstipregistratie;

-- wijk
create index wijk_lokaalid on wijk(lokaalid);

create table wijk_tmp as select row_number() over (order by lokaalid, tijdstipregistratie) id, lokaalid, tijdstipregistratie, eindregistratie from wijk where lokaalid in (select lokaalid from wijk where eindregistratie is null group by lokaalid having count(*) > 1) order by lokaalid, tijdstipregistratie;

update wijk_tmp a set eindregistratie=b.tijdstipregistratie from wijk_tmp b where a.lokaalid=b.lokaalid and b.id=a.id+1 and a.eindregistratie is null;

update wijk a set eindregistratie=b.eindregistratie from wijk_tmp b where a.lokaalid=b.lokaalid and a.tijdstipregistratie=b.tijdstipregistratie and a.eindregistratie is null and b.eindregistratie is not null;
drop table wijk_tmp;

create index wijk_tijdstipregistratie on wijk(tijdstipregistratie);
create table wijk_tmp as select lokaalid, max(objecteindtijd) objecteindtijd, max(eindregistratie) eindregistratie from wijk where objecteindtijd is not null and eindregistratie is not null group by lokaalid;
create index wijk_tmp_lokaalid on wijk_tmp(lokaalid);

-- create table wijk_tofix as select a.lokaalid, a.tijdstipregistratie, a.lv_publicatiedatum, a.objecteindtijd, a.eindregistratie from wijk a, wijk_tmp b where a.lokaalid=b.lokaalid and a.eindregistratie is null;

update wijk a
set objecteindtijd=b.objecteindtijd, eindregistratie=b.eindregistratie
from wijk_tmp b
where a.lokaalid=b.lokaalid and a.eindregistratie is null;

drop table wijk_tmp;
drop index wijk_lokaalid;
drop index wijk_tijdstipregistratie;
