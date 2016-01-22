-- Create final tables in BGT schema

-- Bak
create table bak_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bak_2d_tmp;

alter table bak_2d add primary key (ogc_fid);
create index bak_2d_wkb_geometry_geom_idx on bak_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view bak_2dactueel as select * from bak_2d where eindregistratie is null;
create or replace view bak_2dactueelbestaand as select * from bak_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bak_2d_tmp;

-- Begroeid terreindeel
create table begroeidterreindeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(begroeidterreindeeloptalud as boolean) from begroeidterreindeel_2d_tmp;

alter table begroeidterreindeel_2d add primary key (ogc_fid);
create index begroeidterreindeel_2d_wkb_geometry_geom_idx on begroeidterreindeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view begroeidterreindeel_2dactueel as select * from begroeidterreindeel_2d where eindregistratie is null;
create or replace view begroeidterreindeel_2dactueelbestaand as select * from begroeidterreindeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table begroeidterreindeel_2d_tmp;

-- Begroeid terreindeel (kruinlijn)
create table begroeidterreindeel_kruinlijn as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(begroeidterreindeeloptalud as boolean) from begroeidterreindeel_kruinlijn_tmp;

alter table begroeidterreindeel_kruinlijn add primary key (ogc_fid);
create index begroeidterreindeel_kruinlijn_wkb_geometry_geom_idx on begroeidterreindeel_kruinlijn using gist((wkb_geometry::geometry(LINESTRING, 28992)));

create or replace view begroeidterreindeel_kruinlijnactueel as select * from begroeidterreindeel_kruinlijn where eindregistratie is null;
create or replace view begroeidterreindeel_kruinlijnactueelbestaand as select * from begroeidterreindeel_kruinlijn where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table begroeidterreindeel_kruinlijn_tmp;

-- Bord
create table bord_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bord_2d_tmp;

alter table bord_2d add primary key (ogc_fid);
create index bord_2d_wkb_geometry_geom_idx on bord_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view bord_2dactueel as select * from bord_2d where eindregistratie is null;
create or replace view bord_2dactueelbestaand as select * from bord_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bord_2d_tmp;

-- Buurt
create table buurt_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from buurt_2d_tmp;

alter table buurt_2d add primary key (ogc_fid);
create index buurt_2d_wkb_geometry_geom_idx on buurt_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view buurt_2dactueel as select * from buurt_2d where eindregistratie is null;
create or replace view buurt_2dactueelbestaand as select * from buurt_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table buurt_2d_tmp;

-- Functioneel gebied
create table functioneelgebied_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type, naam from functioneelgebied_2d_tmp;

alter table functioneelgebied_2d add primary key (ogc_fid);
create index functioneelgebied_2d_wkb_geometry_geom_idx on functioneelgebied_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view functioneelgebied_2dactueel as select * from functioneelgebied_2d where eindregistratie is null;
create or replace view functioneelgebied_2dactueelbestaand as select * from functioneelgebied_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table functioneelgebied_2d_tmp;

-- Gebouwinstallatie
create table gebouwinstallatie_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from gebouwinstallatie_2d_tmp;

alter table gebouwinstallatie_2d add primary key (ogc_fid);
create index gebouwinstallatie_2d_wkb_geometry_geom_idx on gebouwinstallatie_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view gebouwinstallatie_2dactueel as select * from gebouwinstallatie_2d where eindregistratie is null;
create or replace view gebouwinstallatie_2dactueelbestaand as select * from gebouwinstallatie_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table gebouwinstallatie_2d_tmp;

-- Installatie
create table installatie_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from installatie_2d_tmp;

alter table installatie_2d add primary key (ogc_fid);
create index installatie_2d_wkb_geometry_geom_idx on installatie_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view installatie_2dactueel as select * from installatie_2d where eindregistratie is null;
create or replace view installatie_2dactueelbestaand as select * from installatie_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table installatie_2d_tmp;

-- Kast
create table kast_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kast_2d_tmp;

alter table kast_2d add primary key (ogc_fid);
create index kast_2d_wkb_geometry_geom_idx on kast_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view kast_2dactueel as select * from kast_2d where eindregistratie is null;
create or replace view kast_2dactueelbestaand as select * from kast_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kast_2d_tmp;

-- Kunstwerkdeel
create table kunstwerkdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kunstwerkdeel_2d_tmp;

alter table kunstwerkdeel_2d add primary key (ogc_fid);
create index kunstwerkdeel_2d_wkb_geometry_geom_idx on kunstwerkdeel_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view kunstwerkdeel_2dactueel as select * from kunstwerkdeel_2d where eindregistratie is null;
create or replace view kunstwerkdeel_2dactueelbestaand as select * from kunstwerkdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kunstwerkdeel_2d_tmp;

-- Mast
create table mast_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from mast_2d_tmp;

alter table mast_2d add primary key (ogc_fid);
create index mast_2d_wkb_geometry_geom_idx on mast_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view mast_2dactueel as select * from mast_2d where eindregistratie is null;
create or replace view mast_2dactueelbestaand as select * from mast_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table mast_2d_tmp;

-- Nummeraanduidingreeks
alter table nummeraanduidingreeks alter ogc_fid drop default;
drop sequence nummeraanduidingreeks_ogc_fid_seq;

-- Onbegroeid terreindeel
create table onbegroeidterreindeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(onbegroeidterreindeeloptalud as boolean) from onbegroeidterreindeel_2d_tmp;

alter table onbegroeidterreindeel_2d add primary key (ogc_fid);
create index onbegroeidterreindeel_2d_wkb_geometry_geom_idx on onbegroeidterreindeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view onbegroeidterreindeel_2dactueel as select * from onbegroeidterreindeel_2d where eindregistratie is null;
create or replace view onbegroeidterreindeel_2dactueelbestaand as select * from onbegroeidterreindeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table onbegroeidterreindeel_2d_tmp;

-- Onbegroeid terreindeel (kruinlijn)
create table onbegroeidterreindeel_kruinlijn as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(onbegroeidterreindeeloptalud as boolean) from onbegroeidterreindeel_kruinlijn_tmp;

alter table onbegroeidterreindeel_kruinlijn add primary key (ogc_fid);
create index onbegroeidterreindeel_kruinlijn_wkb_geometry_geom_idx on onbegroeidterreindeel_kruinlijn using gist((wkb_geometry::geometry(LINESTRING, 28992)));

create or replace view onbegroeidterreindeel_kruinlijnactueel as select * from onbegroeidterreindeel_kruinlijn where eindregistratie is null;
create or replace view onbegroeidterreindeel_kruinlijnactueelbestaand as select * from onbegroeidterreindeel_kruinlijn where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table onbegroeidterreindeel_kruinlijn_tmp;

-- Ondersteunend waterdeel
create table ondersteunendwaterdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from ondersteunendwaterdeel_2d_tmp;

alter table ondersteunendwaterdeel_2d add primary key (ogc_fid);
create index ondersteunendwaterdeel_2d_wkb_geometry_geom_idx on ondersteunendwaterdeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view ondersteunendwaterdeel_2dactueel as select * from ondersteunendwaterdeel_2d where eindregistratie is null;
create or replace view ondersteunendwaterdeel_2dactueelbestaand as select * from ondersteunendwaterdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwaterdeel_2d_tmp;

-- Ondersteunend wegdeel
create table ondersteunendwegdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(ondersteunendwegdeeloptalud as boolean) from ondersteunendwegdeel_2d_tmp;

alter table ondersteunendwegdeel_2d add primary key (ogc_fid);
create index ondersteunendwegdeel_2d_wkb_geometry_geom_idx on ondersteunendwegdeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view ondersteunendwegdeel_2dactueel as select * from ondersteunendwegdeel_2d where eindregistratie is null;
create or replace view ondersteunendwegdeel_2dactueelbestaand as select * from ondersteunendwegdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwegdeel_2d_tmp;

-- Ondersteunend wegdeel (kruinlijn)
create table ondersteunendwegdeel_kruinlijn as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(ondersteunendwegdeeloptalud as boolean) from ondersteunendwegdeel_kruinlijn_tmp;

alter table ondersteunendwegdeel_kruinlijn add primary key (ogc_fid);
create index ondersteunendwegdeel_kruinlijn_wkb_geometry_geom_idx on ondersteunendwegdeel_kruinlijn using gist((wkb_geometry::geometry(LINESTRING, 28992)));

create or replace view ondersteunendwegdeel_kruinlijnactueel as select * from ondersteunendwegdeel_kruinlijn where eindregistratie is null;
create or replace view ondersteunendwegdeel_kruinlijnactueelbestaand as select * from ondersteunendwegdeel_kruinlijn where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwegdeel_kruinlijn_tmp;

-- Ongeclassificeerd object
create table ongeclassificeerdobject_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from ongeclassificeerdobject_2d_tmp;

alter table ongeclassificeerdobject_2d add primary key (ogc_fid);
create index ongeclassificeerdobject_2d_wkb_geometry_geom_idx on ongeclassificeerdobject_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view ongeclassificeerdobject_2dactueel as select * from ongeclassificeerdobject_2d where eindregistratie is null;
create or replace view ongeclassificeerdobject_2dactueelbestaand as select * from ongeclassificeerdobject_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ongeclassificeerdobject_2d_tmp;

-- Openbare ruimte
create table openbareruimte_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from openbareruimte_2d_tmp;

alter table openbareruimte_2d add primary key (ogc_fid);
create index openbareruimte_2d_wkb_geometry_geom_idx on openbareruimte_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view openbareruimte_2dactueel as select * from openbareruimte_2d where eindregistratie is null;
create or replace view openbareruimte_2dactueelbestaand as select * from openbareruimte_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimte_2d_tmp;

-- Openbare-ruimtelabel
create table openbareruimtelabel as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagopr, tekst, hoek, openbareruimtetype from openbareruimtelabel_tmp;

alter table openbareruimtelabel add primary key (ogc_fid);
create index openbareruimtelabel_wkb_geometry_geom_idx on openbareruimtelabel using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view openbareruimtelabelactueel as select * from openbareruimtelabel where eindregistratie is null;
create or replace view openbareruimtelabelactueelbestaand as select * from openbareruimtelabel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimtelabel_tmp;

-- Overbruggingsdeel
create table overbruggingsdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, typeoverbruggingsdeel, hoortbijtypeoverbrugging, cast(overbruggingisbeweegbaar as boolean) from overbruggingsdeel_2d_tmp;

alter table overbruggingsdeel_2d add primary key (ogc_fid);
create index overbruggingsdeel_2d_wkb_geometry_geom_idx on overbruggingsdeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view overbruggingsdeel_2dactueel as select * from overbruggingsdeel_2d where eindregistratie is null;
create or replace view overbruggingsdeel_2dactueelbestaand as select * from overbruggingsdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overbruggingsdeel_2d_tmp;

-- Overig bouwwerk
create table overigbouwwerk_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from overigbouwwerk_2d_tmp;

alter table overigbouwwerk_2d add primary key (ogc_fid);
create index overigbouwwerk_2d_wkb_geometry_geom_idx on overigbouwwerk_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view overigbouwwerk_2dactueel as select * from overigbouwwerk_2d where eindregistratie is null;
create or replace view overigbouwwerk_2dactueelbestaand as select * from overigbouwwerk_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigbouwwerk_2d_tmp;

-- Overige scheiding
create table overigescheiding_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from overigescheiding_2d_tmp;

alter table overigescheiding_2d add primary key (ogc_fid);
create index overigescheiding_2d_wkb_geometry_geom_idx on overigescheiding_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view overigescheiding_2dactueel as select * from overigescheiding_2d where eindregistratie is null;
create or replace view overigescheiding_2dactueelbestaand as select * from overigescheiding_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigescheiding_2d_tmp;

-- Paal
create table paal_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from paal_2d_tmp;

alter table paal_2d add primary key (ogc_fid);
create index paal_2d_wkb_geometry_geom_idx on paal_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view paal_2dactueel as select * from paal_2d where eindregistratie is null;
create or replace view paal_2dactueelbestaand as select * from paal_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table paal_2d_tmp;

-- Pand
create table pand_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagpnd from pand_2d_tmp;

alter table pand_2d add primary key (ogc_fid);
create index pand_2d_wkb_geometry_geom_idx on pand_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view pand_2dactueel as select * from pand_2d where eindregistratie is null;
create or replace view pand_2dactueelbestaand as select * from pand_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table pand_2d_tmp;

-- Plaatsbepalingspunt
create table plaatsbepalingspunt as select ogc_fid, wkb_geometry, namespace, lokaalid, nauwkeurigheid, cast(datuminwinning as date), inwinnendeinstantie, inwinningsmethode from plaatsbepalingspunt_tmp;

alter table plaatsbepalingspunt add primary key (ogc_fid);
create index plaatsbepalingspunt_wkb_geometry_geom_idx on plaatsbepalingspunt using gist((wkb_geometry::geometry(POINT, 28992)));

drop table plaatsbepalingspunt_tmp;

-- Put
create table put_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from put_2d_tmp;

alter table put_2d add primary key (ogc_fid);
create index put_2d_wkb_geometry_geom_idx on put_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view put_2dactueel as select * from put_2d where eindregistratie is null;
create or replace view put_2dactueelbestaand as select * from put_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table put_2d_tmp;

-- Scheiding
create table scheiding_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from scheiding_2d_tmp;

alter table scheiding_2d add primary key (ogc_fid);
create index scheiding_2d_wkb_geometry_geom_idx on scheiding_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view scheiding_2dactueel as select * from scheiding_2d where eindregistratie is null;
create or replace view scheiding_2dactueelbestaand as select * from scheiding_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table scheiding_2d_tmp;

-- Sensor
create table sensor_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from sensor_2d_tmp;

alter table sensor_2d add primary key (ogc_fid);
create index sensor_2d_wkb_geometry_geom_idx on sensor_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view sensor_2dactueel as select * from sensor_2d where eindregistratie is null;
create or replace view sensor_2dactueelbestaand as select * from sensor_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table sensor_2d_tmp;

-- Spoor
create table spoor_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie from spoor_2d_tmp;

alter table spoor_2d add primary key (ogc_fid);
create index spoor_2d_wkb_geometry_geom_idx on spoor_2d using gist((wkb_geometry::geometry(LINESTRING, 28992)));

create or replace view spoor_2dactueel as select * from spoor_2d where eindregistratie is null;
create or replace view spoor_2dactueelbestaand as select * from spoor_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table spoor_2d_tmp;

-- Stadsdeel
create table stadsdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from stadsdeel_2d_tmp;

alter table stadsdeel_2d add primary key (ogc_fid);
create index stadsdeel_2d_wkb_geometry_geom_idx on stadsdeel_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view stadsdeel_2dactueel as select * from stadsdeel_2d where eindregistratie is null;
create or replace view stadsdeel_2dactueelbestaand as select * from stadsdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table stadsdeel_2d_tmp;

-- Straatmeubilair
create table straatmeubilair_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from straatmeubilair_2d_tmp;

alter table straatmeubilair_2d add primary key (ogc_fid);
create index straatmeubilair_2d_wkb_geometry_geom_idx on straatmeubilair_2d using gist((wkb_geometry::geometry(POINT, 28992)));

create or replace view straatmeubilair_2dactueel as select * from straatmeubilair_2d where eindregistratie is null;
create or replace view straatmeubilair_2dactueelbestaand as select * from straatmeubilair_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table straatmeubilair_2d_tmp;

-- Tunneldeel
create table tunneldeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from tunneldeel_2d_tmp;

alter table tunneldeel_2d add primary key (ogc_fid);
create index tunneldeel_2d_wkb_geometry_geom_idx on tunneldeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view tunneldeel_2dactueel as select * from tunneldeel_2d where eindregistratie is null;
create or replace view tunneldeel_2dactueelbestaand as select * from tunneldeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table tunneldeel_2d_tmp;

-- Vegetatieobject
create table vegetatieobject_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from vegetatieobject_2d_tmp;

alter table vegetatieobject_2d add primary key (ogc_fid);
create index vegetatieobject_2d_wkb_geometry_geom_idx on vegetatieobject_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view vegetatieobject_2dactueel as select * from vegetatieobject_2d where eindregistratie is null;
create or replace view vegetatieobject_2dactueelbestaand as select * from vegetatieobject_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table vegetatieobject_2d_tmp;

-- Waterdeel
create table waterdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterdeel_2d_tmp;

alter table waterdeel_2d add primary key (ogc_fid);
create index waterdeel_2d_wkb_geometry_geom_idx on waterdeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view waterdeel_2dactueel as select * from waterdeel_2d where eindregistratie is null;
create or replace view waterdeel_2dactueelbestaand as select * from waterdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterdeel_2d_tmp;

-- Waterinrichtingselement
create table waterinrichtingselement_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterinrichtingselement_2d_tmp;

alter table waterinrichtingselement_2d add primary key (ogc_fid);
create index waterinrichtingselement_2d_wkb_geometry_geom_idx on waterinrichtingselement_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view waterinrichtingselement_2dactueel as select * from waterinrichtingselement_2d where eindregistratie is null;
create or replace view waterinrichtingselement_2dactueelbestaand as select * from waterinrichtingselement_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterinrichtingselement_2d_tmp;

-- Waterschap
create table waterschap_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from waterschap_2d_tmp;

alter table waterschap_2d add primary key (ogc_fid);
create index waterschap_2d_wkb_geometry_geom_idx on waterschap_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view waterschap_2dactueel as select * from waterschap_2d where eindregistratie is null;
create or replace view waterschap_2dactueelbestaand as select * from waterschap_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterschap_2d_tmp;

-- Wegdeel
create table wegdeel_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(wegdeeloptalud as boolean) from wegdeel_2d_tmp;

alter table wegdeel_2d add primary key (ogc_fid);
create index wegdeel_2d_wkb_geometry_geom_idx on wegdeel_2d using gist((wkb_geometry::geometry(POLYGON, 28992)));

create or replace view wegdeel_2dactueel as select * from wegdeel_2d where eindregistratie is null;
create or replace view wegdeel_2dactueelbestaand as select * from wegdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wegdeel_2d_tmp;

-- Wegdeel (kruinlijn)
create table wegdeel_kruinlijn as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(wegdeeloptalud as boolean) from wegdeel_kruinlijn_tmp;

alter table wegdeel_kruinlijn add primary key (ogc_fid);
create index wegdeel_kruinlijn_wkb_geometry_geom_idx on wegdeel_kruinlijn using gist((wkb_geometry::geometry(LINESTRING, 28992)));

create or replace view wegdeel_kruinlijnactueel as select * from wegdeel_kruinlijn where eindregistratie is null;
create or replace view wegdeel_kruinlijnactueelbestaand as select * from wegdeel_kruinlijn where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wegdeel_kruinlijn_tmp;

-- Weginrichtingselement
create table weginrichtingselement_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from weginrichtingselement_2d_tmp;

alter table weginrichtingselement_2d add primary key (ogc_fid);
create index weginrichtingselement_2d_wkb_geometry_geom_idx on weginrichtingselement_2d using gist((wkb_geometry::geometry(GEOMETRY, 28992)));

create or replace view weginrichtingselement_2dactueel as select * from weginrichtingselement_2d where eindregistratie is null;
create or replace view weginrichtingselement_2dactueelbestaand as select * from weginrichtingselement_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table weginrichtingselement_2d_tmp;

-- Wijk
create table wijk_2d as select ogc_fid, wkb_geometry, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamp), cast(eindregistratie as timestamp), cast(lv_publicatiedatum as timestamp), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from wijk_2d_tmp;

alter table wijk_2d add primary key (ogc_fid);
create index wijk_2d_wkb_geometry_geom_idx on wijk_2d using gist((wkb_geometry::geometry(MULTIPOLYGON, 28992)));

create or replace view wijk_2dactueel as select * from wijk_2d where eindregistratie is null;
create or replace view wijk_2dactueelbestaand as select * from wijk_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wijk_2d_tmp;
