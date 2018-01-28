-- Create final tables in BGT schema
set time zone 'Europe/Amsterdam';

-- Bak
create table bak_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bak_2d_tmp;

alter table bak_2d add primary key (ogc_fid);
create index bak_2d_geometry_punt_geom_idx on bak_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index bak_2d_eindregistratie_idx on bak_2d (eindregistratie);
create index bak_2d_bgt_status_idx on bak_2d (bgt_status);
create index bak_2d_plus_status_idx on bak_2d (plus_status);

create or replace view bak_2dactueel as select * from bak_2d where eindregistratie is null;
create or replace view bak_2dactueelbestaand as select * from bak_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bak_2d_tmp;

-- Begroeid terreindeel
create table begroeidterreindeel_2d as select ogc_fid, geometry_vlak, geometry_kruinlijn, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(begroeidterreindeeloptalud as boolean) from begroeidterreindeel_2d_tmp;

alter table begroeidterreindeel_2d add primary key (ogc_fid);
create index begroeidterreindeel_2d_geometry_vlak_geom_idx on begroeidterreindeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index begroeidterreindeel_2d_geometry_kruinlijn_geom_idx on begroeidterreindeel_2d using gist((geometry_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index begroeidterreindeel_2d_eindregistratie_idx on begroeidterreindeel_2d (eindregistratie);
create index begroeidterreindeel_2d_bgt_status_idx on begroeidterreindeel_2d (bgt_status);
create index begroeidterreindeel_2d_plus_status_idx on begroeidterreindeel_2d (plus_status);

create or replace view begroeidterreindeel_2dactueel as select * from begroeidterreindeel_2d where eindregistratie is null;
create or replace view begroeidterreindeel_2dactueelbestaand as select * from begroeidterreindeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table begroeidterreindeel_2d_tmp;

-- Bord
create table bord_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bord_2d_tmp;

alter table bord_2d add primary key (ogc_fid);
create index bord_2d_geometry_punt_geom_idx on bord_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index bord_2d_eindregistratie_idx on bord_2d (eindregistratie);
create index bord_2d_bgt_status_idx on bord_2d (bgt_status);
create index bord_2d_plus_status_idx on bord_2d (plus_status);

create or replace view bord_2dactueel as select * from bord_2d where eindregistratie is null;
create or replace view bord_2dactueelbestaand as select * from bord_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bord_2d_tmp;

-- Buurt
create table buurt_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from buurt_2d_tmp;

alter table buurt_2d add primary key (ogc_fid);
create index buurt_2d_geometry_vlak_geom_idx on buurt_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index buurt_2d_eindregistratie_idx on buurt_2d (eindregistratie);
create index buurt_2d_bgt_status_idx on buurt_2d (bgt_status);
create index buurt_2d_plus_status_idx on buurt_2d (plus_status);

create or replace view buurt_2dactueel as select * from buurt_2d where eindregistratie is null;
create or replace view buurt_2dactueelbestaand as select * from buurt_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table buurt_2d_tmp;

-- Functioneel gebied
create table functioneelgebied_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type, naam from functioneelgebied_2d_tmp;

alter table functioneelgebied_2d add primary key (ogc_fid);
create index functioneelgebied_2d_geometry_vlak_geom_idx on functioneelgebied_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index functioneelgebied_2d_eindregistratie_idx on functioneelgebied_2d (eindregistratie);
create index functioneelgebied_2d_bgt_status_idx on functioneelgebied_2d (bgt_status);
create index functioneelgebied_2d_plus_status_idx on functioneelgebied_2d (plus_status);

create or replace view functioneelgebied_2dactueel as select * from functioneelgebied_2d where eindregistratie is null;
create or replace view functioneelgebied_2dactueelbestaand as select * from functioneelgebied_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table functioneelgebied_2d_tmp;

-- Gebouwinstallatie
create table gebouwinstallatie_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from gebouwinstallatie_2d_tmp;

alter table gebouwinstallatie_2d add primary key (ogc_fid);
create index gebouwinstallatie_2d_geometry_vlak_geom_idx on gebouwinstallatie_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index gebouwinstallatie_2d_eindregistratie_idx on gebouwinstallatie_2d (eindregistratie);
create index gebouwinstallatie_2d_bgt_status_idx on gebouwinstallatie_2d (bgt_status);
create index gebouwinstallatie_2d_plus_status_idx on gebouwinstallatie_2d (plus_status);

create or replace view gebouwinstallatie_2dactueel as select * from gebouwinstallatie_2d where eindregistratie is null;
create or replace view gebouwinstallatie_2dactueelbestaand as select * from gebouwinstallatie_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table gebouwinstallatie_2d_tmp;

-- Installatie
create table installatie_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from installatie_2d_tmp;

alter table installatie_2d add primary key (ogc_fid);
create index installatie_2d_geometry_punt_geom_idx on installatie_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index installatie_2d_eindregistratie_idx on installatie_2d (eindregistratie);
create index installatie_2d_bgt_status_idx on installatie_2d (bgt_status);
create index installatie_2d_plus_status_idx on installatie_2d (plus_status);

create or replace view installatie_2dactueel as select * from installatie_2d where eindregistratie is null;
create or replace view installatie_2dactueelbestaand as select * from installatie_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table installatie_2d_tmp;

-- Kast
create table kast_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kast_2d_tmp;

alter table kast_2d add primary key (ogc_fid);
create index kast_2d_geometry_punt_geom_idx on kast_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index kast_2d_eindregistratie_idx on kast_2d (eindregistratie);
create index kast_2d_bgt_status_idx on kast_2d (bgt_status);
create index kast_2d_plus_status_idx on kast_2d (plus_status);

create or replace view kast_2dactueel as select * from kast_2d where eindregistratie is null;
create or replace view kast_2dactueelbestaand as select * from kast_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kast_2d_tmp;

-- Kunstwerkdeel
-- Note that some hoogspanningsmast features are curve polygons, and some other features are multi
-- surfaces. This is invalid, but these geometries are converted nonetheless. This should be
-- reported though;
create table kunstwerkdeel_2d as select ogc_fid, case when st_geometrytype(wkb_geometry) = 'ST_MultiPoint' then wkb_geometry::geometry(MULTIPOINT, 28992) else null end geometry_multipunt, case when st_geometrytype(wkb_geometry) = 'ST_MultiPolygon' or st_geometrytype(wkb_geometry) = 'ST_MultiSurface' then st_forcecurve(wkb_geometry)::geometry(MULTISURFACE, 28992) else null end geometry_multivlak, case when st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) when st_geometrytype(wkb_geometry) = 'ST_CompoundCurve' or st_geometrytype(wkb_geometry) = 'ST_LineString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_geometrytype(wkb_geometry) = 'ST_CurvePolygon' or st_geometrytype(wkb_geometry) = 'ST_Polygon' then st_forcecurve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null end geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kunstwerkdeel_2d_tmp;

alter table kunstwerkdeel_2d add primary key (ogc_fid);
create index kunstwerkdeel_2d_geometry_multipunt_geom_idx on kunstwerkdeel_2d using gist((geometry_multipunt::geometry(MULTIPOINT, 28992)));
create index kunstwerkdeel_2d_geometry_multivlak_geom_idx on kunstwerkdeel_2d using gist((geometry_multivlak::geometry(MULTISURFACE, 28992)));
create index kunstwerkdeel_2d_geometry_lijn_geom_idx on kunstwerkdeel_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index kunstwerkdeel_2d_geometry_vlak_geom_idx on kunstwerkdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index kunstwerkdeel_2d_eindregistratie_idx on kunstwerkdeel_2d (eindregistratie);
create index kunstwerkdeel_2d_bgt_status_idx on kunstwerkdeel_2d (bgt_status);
create index kunstwerkdeel_2d_plus_status_idx on kunstwerkdeel_2d (plus_status);

create or replace view kunstwerkdeel_2dactueel as select * from kunstwerkdeel_2d where eindregistratie is null;
create or replace view kunstwerkdeel_2dactueelbestaand as select * from kunstwerkdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kunstwerkdeel_2d_tmp;

-- Report invalid geometry types for kunstwerkdeel
select bgt_type, st_geometrytype(geometry_multipunt), count(*) from kunstwerkdeel_2d where bgt_type <> 'hoogspanningsmast' and geometry_multipunt is not null group by bgt_type, st_geometrytype(geometry_multipunt)
union all
select bgt_type, st_geometrytype(geometry_multivlak), count(*) from kunstwerkdeel_2d where bgt_type <> 'hoogspanningsmast' and geometry_multivlak is not null group by bgt_type, st_geometrytype(geometry_multivlak)
union all
select bgt_type, st_geometrytype(geometry_lijn), count(*) from kunstwerkdeel_2d where bgt_type = 'hoogspanningsmast' and geometry_lijn is not null group by bgt_type, st_geometrytype(geometry_lijn)
union all
select bgt_type, st_geometrytype(geometry_vlak), count(*) from kunstwerkdeel_2d where bgt_type = 'hoogspanningsmast' and geometry_vlak is not null group by bgt_type, st_geometrytype(geometry_vlak);

-- Mast
create table mast_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from mast_2d_tmp;

alter table mast_2d add primary key (ogc_fid);
create index mast_2d_geometry_punt_geom_idx on mast_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index mast_2d_eindregistratie_idx on mast_2d (eindregistratie);
create index mast_2d_bgt_status_idx on mast_2d (bgt_status);
create index mast_2d_plus_status_idx on mast_2d (plus_status);

create or replace view mast_2dactueel as select * from mast_2d where eindregistratie is null;
create or replace view mast_2dactueelbestaand as select * from mast_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table mast_2d_tmp;

-- Onbegroeid terreindeel
create table onbegroeidterreindeel_2d as select ogc_fid, geometry_vlak, geometry_kruinlijn, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(onbegroeidterreindeeloptalud as boolean) from onbegroeidterreindeel_2d_tmp;

alter table onbegroeidterreindeel_2d add primary key (ogc_fid);
create index onbegroeidterreindeel_2d_geometry_vlak_geom_idx on onbegroeidterreindeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index onbegroeidterreindeel_2d_geometry_kruinlijn_geom_idx on onbegroeidterreindeel_2d using gist((geometry_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index onbegroeidterreindeel_2d_eindregistratie_idx on onbegroeidterreindeel_2d (eindregistratie);
create index onbegroeidterreindeel_2d_bgt_status_idx on onbegroeidterreindeel_2d (bgt_status);
create index onbegroeidterreindeel_2d_plus_status_idx on onbegroeidterreindeel_2d (plus_status);

create or replace view onbegroeidterreindeel_2dactueel as select * from onbegroeidterreindeel_2d where eindregistratie is null;
create or replace view onbegroeidterreindeel_2dactueelbestaand as select * from onbegroeidterreindeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table onbegroeidterreindeel_2d_tmp;

-- Ondersteunend waterdeel
create table ondersteunendwaterdeel_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from ondersteunendwaterdeel_2d_tmp;

alter table ondersteunendwaterdeel_2d add primary key (ogc_fid);
create index ondersteunendwaterdeel_2d_geometry_vlak_geom_idx on ondersteunendwaterdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index ondersteunendwaterdeel_2d_eindregistratie_idx on ondersteunendwaterdeel_2d (eindregistratie);
create index ondersteunendwaterdeel_2d_bgt_status_idx on ondersteunendwaterdeel_2d (bgt_status);
create index ondersteunendwaterdeel_2d_plus_status_idx on ondersteunendwaterdeel_2d (plus_status);

create or replace view ondersteunendwaterdeel_2dactueel as select * from ondersteunendwaterdeel_2d where eindregistratie is null;
create or replace view ondersteunendwaterdeel_2dactueelbestaand as select * from ondersteunendwaterdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwaterdeel_2d_tmp;

-- Ondersteunend wegdeel
create table ondersteunendwegdeel_2d as select ogc_fid, geometry_vlak, geometry_kruinlijn, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(ondersteunendwegdeeloptalud as boolean) from ondersteunendwegdeel_2d_tmp;

alter table ondersteunendwegdeel_2d add primary key (ogc_fid);
create index ondersteunendwegdeel_2d_geometry_vlak_geom_idx on ondersteunendwegdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index ondersteunendwegdeel_2d_geometry_kruinlijn_geom_idx on ondersteunendwegdeel_2d using gist((geometry_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index ondersteunendwegdeel_2d_eindregistratie_idx on ondersteunendwegdeel_2d (eindregistratie);
create index ondersteunendwegdeel_2d_bgt_status_idx on ondersteunendwegdeel_2d (bgt_status);
create index ondersteunendwegdeel_2d_plus_status_idx on ondersteunendwegdeel_2d (plus_status);

create or replace view ondersteunendwegdeel_2dactueel as select * from ondersteunendwegdeel_2d where eindregistratie is null;
create or replace view ondersteunendwegdeel_2dactueelbestaand as select * from ondersteunendwegdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwegdeel_2d_tmp;

-- Ongeclassificeerd object
create table ongeclassificeerdobject_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from ongeclassificeerdobject_2d_tmp;

alter table ongeclassificeerdobject_2d add primary key (ogc_fid);
create index ongeclassificeerdobject_2d_geometry_vlak_geom_idx on ongeclassificeerdobject_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index ongeclassificeerdobject_2d_eindregistratie_idx on ongeclassificeerdobject_2d (eindregistratie);
create index ongeclassificeerdobject_2d_bgt_status_idx on ongeclassificeerdobject_2d (bgt_status);
create index ongeclassificeerdobject_2d_plus_status_idx on ongeclassificeerdobject_2d (plus_status);

create or replace view ongeclassificeerdobject_2dactueel as select * from ongeclassificeerdobject_2d where eindregistratie is null;
create or replace view ongeclassificeerdobject_2dactueelbestaand as select * from ongeclassificeerdobject_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ongeclassificeerdobject_2d_tmp;

-- Openbare ruimte
create table openbareruimte_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from openbareruimte_2d_tmp;

alter table openbareruimte_2d add primary key (ogc_fid);
create index openbareruimte_2d_geometry_vlak_geom_idx on openbareruimte_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index openbareruimte_2d_eindregistratie_idx on openbareruimte_2d (eindregistratie);
create index openbareruimte_2d_bgt_status_idx on openbareruimte_2d (bgt_status);
create index openbareruimte_2d_plus_status_idx on openbareruimte_2d (plus_status);

create or replace view openbareruimte_2dactueel as select * from openbareruimte_2d where eindregistratie is null;
create or replace view openbareruimte_2dactueelbestaand as select * from openbareruimte_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimte_2d_tmp;

-- Openbare-ruimtelabel
create table openbareruimtelabel as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagopr, tekst, hoek, openbareruimtetype from openbareruimtelabel_tmp;

alter table openbareruimtelabel add primary key (ogc_fid);
create index openbareruimtelabel_geometry_punt_geom_idx on openbareruimtelabel using gist((geometry_punt::geometry(POINT, 28992)));
create index openbareruimtelabel_eindregistratie_idx on openbareruimtelabel (eindregistratie);
create index openbareruimtelabel_bgt_status_idx on openbareruimtelabel (bgt_status);
create index openbareruimtelabel_plus_status_idx on openbareruimtelabel (plus_status);

create or replace view openbareruimtelabelactueel as select * from openbareruimtelabel where eindregistratie is null;
create or replace view openbareruimtelabelactueelbestaand as select * from openbareruimtelabel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimtelabel_tmp;

-- Overbruggingsdeel
create table overbruggingsdeel_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, typeoverbruggingsdeel, hoortbijtypeoverbrugging, cast(overbruggingisbeweegbaar as boolean) from overbruggingsdeel_2d_tmp;

alter table overbruggingsdeel_2d add primary key (ogc_fid);
create index overbruggingsdeel_2d_geometry_vlak_geom_idx on overbruggingsdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index overbruggingsdeel_2d_eindregistratie_idx on overbruggingsdeel_2d (eindregistratie);
create index overbruggingsdeel_2d_bgt_status_idx on overbruggingsdeel_2d (bgt_status);
create index overbruggingsdeel_2d_plus_status_idx on overbruggingsdeel_2d (plus_status);

create or replace view overbruggingsdeel_2dactueel as select * from overbruggingsdeel_2d where eindregistratie is null;
create or replace view overbruggingsdeel_2dactueelbestaand as select * from overbruggingsdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overbruggingsdeel_2d_tmp;

-- Overig bouwwerk
create table overigbouwwerk_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from overigbouwwerk_2d_tmp;

alter table overigbouwwerk_2d add primary key (ogc_fid);
create index overigbouwwerk_2d_geometry_vlak_geom_idx on overigbouwwerk_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index overigbouwwerk_2d_eindregistratie_idx on overigbouwwerk_2d (eindregistratie);
create index overigbouwwerk_2d_bgt_status_idx on overigbouwwerk_2d (bgt_status);
create index overigbouwwerk_2d_plus_status_idx on overigbouwwerk_2d (plus_status);

create or replace view overigbouwwerk_2dactueel as select * from overigbouwwerk_2d where eindregistratie is null;
create or replace view overigbouwwerk_2dactueelbestaand as select * from overigbouwwerk_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigbouwwerk_2d_tmp;

-- Overige scheiding
create table overigescheiding_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 2 then st_forcecurve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null end geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, plus_type from overigescheiding_2d_tmp;

alter table overigescheiding_2d add primary key (ogc_fid);
create index overigescheiding_2d_geometry_lijn_geom_idx on overigescheiding_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index overigescheiding_2d_geometry_vlak_geom_idx on overigescheiding_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index overigescheiding_2d_eindregistratie_idx on overigescheiding_2d (eindregistratie);
create index overigescheiding_2d_bgt_status_idx on overigescheiding_2d (bgt_status);
create index overigescheiding_2d_plus_status_idx on overigescheiding_2d (plus_status);

create or replace view overigescheiding_2dactueel as select * from overigescheiding_2d where eindregistratie is null;
create or replace view overigescheiding_2dactueelbestaand as select * from overigescheiding_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigescheiding_2d_tmp;

-- Paal
create table paal_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from paal_2d_tmp;

alter table paal_2d add primary key (ogc_fid);
create index paal_2d_geometry_punt_geom_idx on paal_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index paal_2d_eindregistratie_idx on paal_2d (eindregistratie);
create index paal_2d_bgt_status_idx on paal_2d (bgt_status);
create index paal_2d_plus_status_idx on paal_2d (plus_status);

create or replace view paal_2dactueel as select * from paal_2d where eindregistratie is null;
create or replace view paal_2dactueelbestaand as select * from paal_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table paal_2d_tmp;

-- Pand
create table pand_2d as select ogc_fid, geometry_vlak, geometry_nummeraanduiding, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagpnd, tekst, hoek, identificatiebagvbolaagstehuisnummer, identificatiebagvbohoogstehuisnummer from pand_2d_tmp;

alter table pand_2d add primary key (ogc_fid);
create index pand_2d_geometry_vlak_geom_idx on pand_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index pand_2d_geometry_nummeraanduiding_geom_idx on pand_2d using gist((geometry_nummeraanduiding::geometry(POINT, 28992)));
create index pand_2d_eindregistratie_idx on pand_2d (eindregistratie);
create index pand_2d_bgt_status_idx on pand_2d (bgt_status);
create index pand_2d_plus_status_idx on pand_2d (plus_status);

create or replace view pand_2dactueel as select * from pand_2d where eindregistratie is null;
create or replace view pand_2dactueelbestaand as select * from pand_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table pand_2d_tmp;

-- Plaatsbepalingspunt
create table plaatsbepalingspunt as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, nauwkeurigheid, cast(datuminwinning as date), inwinnendeinstantie, inwinningsmethode from plaatsbepalingspunt_tmp;

alter table plaatsbepalingspunt add primary key (ogc_fid);
create index plaatsbepalingspunt_geometry_punt_geom_idx on plaatsbepalingspunt using gist((geometry_punt::geometry(POINT, 28992)));

drop table plaatsbepalingspunt_tmp;

-- Put
create table put_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from put_2d_tmp;

alter table put_2d add primary key (ogc_fid);
create index put_2d_geometry_punt_geom_idx on put_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index put_2d_eindregistratie_idx on put_2d (eindregistratie);
create index put_2d_bgt_status_idx on put_2d (bgt_status);
create index put_2d_plus_status_idx on put_2d (plus_status);

create or replace view put_2dactueel as select * from put_2d where eindregistratie is null;
create or replace view put_2dactueelbestaand as select * from put_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table put_2d_tmp;

-- Scheiding
create table scheiding_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 2 then st_forcecurve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null end geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from scheiding_2d_tmp;

alter table scheiding_2d add primary key (ogc_fid);
create index scheiding_2d_geometry_lijn_geom_idx on scheiding_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index scheiding_2d_geometry_vlak_geom_idx on scheiding_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index scheiding_2d_eindregistratie_idx on scheiding_2d (eindregistratie);
create index scheiding_2d_bgt_status_idx on scheiding_2d (bgt_status);
create index scheiding_2d_plus_status_idx on scheiding_2d (plus_status);

create or replace view scheiding_2dactueel as select * from scheiding_2d where eindregistratie is null;
create or replace view scheiding_2dactueelbestaand as select * from scheiding_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table scheiding_2d_tmp;

-- Sensor
create table sensor_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null end geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from sensor_2d_tmp;

alter table sensor_2d add primary key (ogc_fid);
create index sensor_2d_geometry_lijn_geom_idx on sensor_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index sensor_2d_geometry_punt_geom_idx on sensor_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index sensor_2d_eindregistratie_idx on sensor_2d (eindregistratie);
create index sensor_2d_bgt_status_idx on sensor_2d (bgt_status);
create index sensor_2d_plus_status_idx on sensor_2d (plus_status);

create or replace view sensor_2dactueel as select * from sensor_2d where eindregistratie is null;
create or replace view sensor_2dactueelbestaand as select * from sensor_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table sensor_2d_tmp;

-- Spoor
create table spoor_2d as select ogc_fid, wkb_geometry geometry_lijn, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie from spoor_2d_tmp;

alter table spoor_2d add primary key (ogc_fid);
create index spoor_2d_geometry_lijn_geom_idx on spoor_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index spoor_2d_eindregistratie_idx on spoor_2d (eindregistratie);
create index spoor_2d_bgt_status_idx on spoor_2d (bgt_status);
create index spoor_2d_plus_status_idx on spoor_2d (plus_status);

create or replace view spoor_2dactueel as select * from spoor_2d where eindregistratie is null;
create or replace view spoor_2dactueelbestaand as select * from spoor_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table spoor_2d_tmp;

-- Stadsdeel
create table stadsdeel_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from stadsdeel_2d_tmp;

alter table stadsdeel_2d add primary key (ogc_fid);
create index stadsdeel_2d_geometry_vlak_geom_idx on stadsdeel_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index stadsdeel_2d_eindregistratie_idx on stadsdeel_2d (eindregistratie);
create index stadsdeel_2d_bgt_status_idx on stadsdeel_2d (bgt_status);
create index stadsdeel_2d_plus_status_idx on stadsdeel_2d (plus_status);

create or replace view stadsdeel_2dactueel as select * from stadsdeel_2d where eindregistratie is null;
create or replace view stadsdeel_2dactueelbestaand as select * from stadsdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table stadsdeel_2d_tmp;

-- Straatmeubilair
create table straatmeubilair_2d as select ogc_fid, wkb_geometry geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from straatmeubilair_2d_tmp;

alter table straatmeubilair_2d add primary key (ogc_fid);
create index straatmeubilair_2d_geometry_punt_geom_idx on straatmeubilair_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index straatmeubilair_2d_eindregistratie_idx on straatmeubilair_2d (eindregistratie);
create index straatmeubilair_2d_bgt_status_idx on straatmeubilair_2d (bgt_status);
create index straatmeubilair_2d_plus_status_idx on straatmeubilair_2d (plus_status);

create or replace view straatmeubilair_2dactueel as select * from straatmeubilair_2d where eindregistratie is null;
create or replace view straatmeubilair_2dactueelbestaand as select * from straatmeubilair_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table straatmeubilair_2d_tmp;

-- Tunneldeel
create table tunneldeel_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from tunneldeel_2d_tmp;

alter table tunneldeel_2d add primary key (ogc_fid);
create index tunneldeel_2d_geometry_vlak_geom_idx on tunneldeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index tunneldeel_2d_eindregistratie_idx on tunneldeel_2d (eindregistratie);
create index tunneldeel_2d_bgt_status_idx on tunneldeel_2d (bgt_status);
create index tunneldeel_2d_plus_status_idx on tunneldeel_2d (plus_status);

create or replace view tunneldeel_2dactueel as select * from tunneldeel_2d where eindregistratie is null;
create or replace view tunneldeel_2dactueelbestaand as select * from tunneldeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table tunneldeel_2d_tmp;

-- Vegetatieobject
create table vegetatieobject_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null end geometry_punt, case when st_dimension(wkb_geometry) = 2 then st_forcecurve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null end geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from vegetatieobject_2d_tmp;

alter table vegetatieobject_2d add primary key (ogc_fid);
create index vegetatieobject_2d_geometry_lijn_geom_idx on vegetatieobject_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index vegetatieobject_2d_geometry_punt_geom_idx on vegetatieobject_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index vegetatieobject_2d_geometry_vlak_geom_idx on vegetatieobject_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index vegetatieobject_2d_eindregistratie_idx on vegetatieobject_2d (eindregistratie);
create index vegetatieobject_2d_bgt_status_idx on vegetatieobject_2d (bgt_status);
create index vegetatieobject_2d_plus_status_idx on vegetatieobject_2d (plus_status);

create or replace view vegetatieobject_2dactueel as select * from vegetatieobject_2d where eindregistratie is null;
create or replace view vegetatieobject_2dactueelbestaand as select * from vegetatieobject_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table vegetatieobject_2d_tmp;

-- Waterdeel
create table waterdeel_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterdeel_2d_tmp;

alter table waterdeel_2d add primary key (ogc_fid);
create index waterdeel_2d_geometry_vlak_geom_idx on waterdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index waterdeel_2d_eindregistratie_idx on waterdeel_2d (eindregistratie);
create index waterdeel_2d_bgt_status_idx on waterdeel_2d (bgt_status);
create index waterdeel_2d_plus_status_idx on waterdeel_2d (plus_status);

create or replace view waterdeel_2dactueel as select * from waterdeel_2d where eindregistratie is null;
create or replace view waterdeel_2dactueelbestaand as select * from waterdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterdeel_2d_tmp;

-- Waterinrichtingselement
create table waterinrichtingselement_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null end geometry_punt, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterinrichtingselement_2d_tmp;

alter table waterinrichtingselement_2d add primary key (ogc_fid);
create index waterinrichtingselement_2d_geometry_lijn_geom_idx on waterinrichtingselement_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index waterinrichtingselement_2d_geometry_punt_geom_idx on waterinrichtingselement_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index waterinrichtingselement_2d_eindregistratie_idx on waterinrichtingselement_2d (eindregistratie);
create index waterinrichtingselement_2d_bgt_status_idx on waterinrichtingselement_2d (bgt_status);
create index waterinrichtingselement_2d_plus_status_idx on waterinrichtingselement_2d (plus_status);

create or replace view waterinrichtingselement_2dactueel as select * from waterinrichtingselement_2d where eindregistratie is null;
create or replace view waterinrichtingselement_2dactueelbestaand as select * from waterinrichtingselement_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterinrichtingselement_2d_tmp;

-- Waterschap
create table waterschap_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from waterschap_2d_tmp;

alter table waterschap_2d add primary key (ogc_fid);
create index waterschap_2d_geometry_vlak_geom_idx on waterschap_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index waterschap_2d_eindregistratie_idx on waterschap_2d (eindregistratie);
create index waterschap_2d_bgt_status_idx on waterschap_2d (bgt_status);
create index waterschap_2d_plus_status_idx on waterschap_2d (plus_status);

create or replace view waterschap_2dactueel as select * from waterschap_2d where eindregistratie is null;
create or replace view waterschap_2dactueelbestaand as select * from waterschap_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterschap_2d_tmp;

-- Wegdeel
create table wegdeel_2d as select ogc_fid, geometry_vlak, geometry_kruinlijn, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(wegdeeloptalud as boolean) from wegdeel_2d_tmp;

alter table wegdeel_2d add primary key (ogc_fid);
create index wegdeel_2d_geometry_vlak_geom_idx on wegdeel_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index wegdeel_2d_geometry_kruinlijn_geom_idx on wegdeel_2d using gist((geometry_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index wegdeel_2d_eindregistratie_idx on wegdeel_2d (eindregistratie);
create index wegdeel_2d_bgt_status_idx on wegdeel_2d (bgt_status);
create index wegdeel_2d_plus_status_idx on wegdeel_2d (plus_status);

create or replace view wegdeel_2dactueel as select * from wegdeel_2d where eindregistratie is null;
create or replace view wegdeel_2dactueelbestaand as select * from wegdeel_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wegdeel_2d_tmp;

-- Weginrichtingselement
create table weginrichtingselement_2d as select ogc_fid, case when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) <> 'ST_CircularString' then st_forcecurve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) when st_dimension(wkb_geometry) = 1 and st_geometrytype(wkb_geometry) = 'ST_CircularString' then st_geomfromtext('COMPOUNDCURVE(' || st_astext(wkb_geometry) || ')', 28992)::geometry(COMPOUNDCURVE, 28992) else null end geometry_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null end geometry_punt, case when st_dimension(wkb_geometry) = 2 then st_forcecurve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null end geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from weginrichtingselement_2d_tmp;

alter table weginrichtingselement_2d add primary key (ogc_fid);
create index weginrichtingselement_2d_geometry_lijn_geom_idx on weginrichtingselement_2d using gist((geometry_lijn::geometry(COMPOUNDCURVE, 28992)));
create index weginrichtingselement_2d_geometry_punt_geom_idx on weginrichtingselement_2d using gist((geometry_punt::geometry(POINT, 28992)));
create index weginrichtingselement_2d_geometry_vlak_geom_idx on weginrichtingselement_2d using gist((geometry_vlak::geometry(CURVEPOLYGON, 28992)));
create index weginrichtingselement_2d_eindregistratie_idx on weginrichtingselement_2d (eindregistratie);
create index weginrichtingselement_2d_bgt_status_idx on weginrichtingselement_2d (bgt_status);
create index weginrichtingselement_2d_plus_status_idx on weginrichtingselement_2d (plus_status);

create or replace view weginrichtingselement_2dactueel as select * from weginrichtingselement_2d where eindregistratie is null;
create or replace view weginrichtingselement_2dactueelbestaand as select * from weginrichtingselement_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table weginrichtingselement_2d_tmp;

-- Wijk
create table wijk_2d as select ogc_fid, wkb_geometry geometry_vlak, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from wijk_2d_tmp;

alter table wijk_2d add primary key (ogc_fid);
create index wijk_2d_geometry_vlak_geom_idx on wijk_2d using gist((geometry_vlak::geometry(MULTISURFACE, 28992)));
create index wijk_2d_eindregistratie_idx on wijk_2d (eindregistratie);
create index wijk_2d_bgt_status_idx on wijk_2d (bgt_status);
create index wijk_2d_plus_status_idx on wijk_2d (plus_status);

create or replace view wijk_2dactueel as select * from wijk_2d where eindregistratie is null;
create or replace view wijk_2dactueelbestaand as select * from wijk_2d where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wijk_2d_tmp;
