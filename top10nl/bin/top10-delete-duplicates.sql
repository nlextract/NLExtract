-- Auteur: Frank Steggink
-- Doel: script om dubbele records te verwijderen, middels een hulptabel

drop table if exists blah;

--functioneelgebied_punt
create table blah as select ogc_fid, identificatie from functioneelgebied_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from functioneelgebied_punt group by identificatie order by identificatie) as x where aantal>1);
delete from functioneelgebied_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--functioneelgebied_vlak
create table blah as select ogc_fid, identificatie from functioneelgebied_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from functioneelgebied_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from functioneelgebied_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--gebouw_vlak
create table blah as select ogc_fid, identificatie from gebouw_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from gebouw_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from gebouw_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--geografischgebied_punt
create table blah as select ogc_fid, identificatie from geografischgebied_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from geografischgebied_punt group by identificatie order by identificatie) as x where aantal>1);
delete from geografischgebied_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--geografischgebied_vlak
create table blah as select ogc_fid, identificatie from geografischgebied_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from geografischgebied_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from geografischgebied_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--hoogteofdiepte_punt
create table blah as select ogc_fid, identificatie from hoogteofdiepte_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from hoogteofdiepte_punt group by identificatie order by identificatie) as x where aantal>1);
delete from hoogteofdiepte_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--hoogteverschilhz_lijn
create table blah as select ogc_fid, identificatie from hoogteverschilhz_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from hoogteverschilhz_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from hoogteverschilhz_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--hoogteverschillz_lijn
create table blah as select ogc_fid, identificatie from hoogteverschillz_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from hoogteverschillz_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from hoogteverschillz_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--inrichtingselement_lijn
create table blah as select ogc_fid, identificatie from inrichtingselement_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from inrichtingselement_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from inrichtingselement_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--inrichtingselement_punt
create table blah as select ogc_fid, identificatie from inrichtingselement_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from inrichtingselement_punt group by identificatie order by identificatie) as x where aantal>1);
delete from inrichtingselement_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--isohoogte_lijn
create table blah as select ogc_fid, identificatie from isohoogte_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from isohoogte_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from isohoogte_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--kadeofwal_lijn
create table blah as select ogc_fid, identificatie from kadeofwal_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from kadeofwal_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from kadeofwal_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--overigrelief_lijn
create table blah as select ogc_fid, identificatie from overigrelief_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from overigrelief_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from overigrelief_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--overigrelief_punt
create table blah as select ogc_fid, identificatie from overigrelief_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from overigrelief_punt group by identificatie order by identificatie) as x where aantal>1);
delete from overigrelief_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--registratiefgebied_punt
create table blah as select ogc_fid, identificatie from registratiefgebied_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from registratiefgebied_punt group by identificatie order by identificatie) as x where aantal>1);
delete from registratiefgebied_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--registratiefgebied_vlak
create table blah as select ogc_fid, identificatie from registratiefgebied_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from registratiefgebied_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from registratiefgebied_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--spoorbaandeel_lijn
create table blah as select ogc_fid, identificatie from spoorbaandeel_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from spoorbaandeel_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from spoorbaandeel_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--spoorbaandeel_punt
create table blah as select ogc_fid, identificatie from spoorbaandeel_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from spoorbaandeel_punt group by identificatie order by identificatie) as x where aantal>1);
delete from spoorbaandeel_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--terrein_vlak
create table blah as select ogc_fid, identificatie from terrein_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from terrein_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from terrein_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--waterdeel_lijn
create table blah as select ogc_fid, identificatie from waterdeel_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from waterdeel_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from waterdeel_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--waterdeel_punt
create table blah as select ogc_fid, identificatie from waterdeel_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from waterdeel_punt group by identificatie order by identificatie) as x where aantal>1);
delete from waterdeel_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--waterdeel_vlak
create table blah as select ogc_fid, identificatie from waterdeel_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from waterdeel_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from waterdeel_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--wegdeel_hartlijn
create table blah as select ogc_fid, identificatie from wegdeel_hartlijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from wegdeel_hartlijn group by identificatie order by identificatie) as x where aantal>1);
delete from wegdeel_hartlijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--wegdeel_hartpunt
create table blah as select ogc_fid, identificatie from wegdeel_hartpunt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from wegdeel_hartpunt group by identificatie order by identificatie) as x where aantal>1);
delete from wegdeel_hartpunt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--wegdeel_lijn
create table blah as select ogc_fid, identificatie from wegdeel_lijn where identificatie in (select identificatie from (select identificatie, count(*) as aantal from wegdeel_lijn group by identificatie order by identificatie) as x where aantal>1);
delete from wegdeel_lijn where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--wegdeel_punt
create table blah as select ogc_fid, identificatie from wegdeel_punt where identificatie in (select identificatie from (select identificatie, count(*) as aantal from wegdeel_punt group by identificatie order by identificatie) as x where aantal>1);
delete from wegdeel_punt where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

--wegdeel_vlak
create table blah as select ogc_fid, identificatie from wegdeel_vlak where identificatie in (select identificatie from (select identificatie, count(*) as aantal from wegdeel_vlak group by identificatie order by identificatie) as x where aantal>1);
delete from wegdeel_vlak where ogc_fid in (select ogc_fid from blah where ogc_fid not in (select min(ogc_fid) from blah group by identificatie));
drop table if exists blah;

