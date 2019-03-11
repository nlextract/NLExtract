-- Create final tables in BGT schema
set time zone 'Europe/Amsterdam';

-- Function to parse PostGIS version number
CREATE OR REPLACE FUNCTION _nlx_parse_version(VARCHAR)
RETURNS integer AS
$$
    SELECT split_part($1, '.', 1)::integer * 10000 + split_part($1, '.', 2)::integer * 100 + split_part($1, '.', 3)::integer AS result;
$$
LANGUAGE sql;

-- Usage: SELECT _nlx_parse_version(postgis_lib_version());

-- Function to force a geometry to its curved representation. This way, similar functionality to
-- ST_ForceCurve is available in PostGIS 2.0 and 2.1, and also circular strings are converted to
-- compound curves.
DO
$do$
BEGIN
IF (SELECT _nlx_parse_version(postgis_lib_version())) >= 20200 THEN
	CREATE OR REPLACE FUNCTION _nlx_force_curve(geometry)
	RETURNS geometry AS
	$$
		SELECT CASE
			WHEN st_geometrytype($1) = 'ST_CircularString' THEN
				st_geomfromtext('COMPOUNDCURVE(' || st_astext($1) || ')', st_srid($1))
			ELSE
				st_forcecurve($1)
			END AS result;
	$$
	LANGUAGE sql;
ELSE
	CREATE OR REPLACE FUNCTION _nlx_force_curve(geometry)
	RETURNS geometry AS
	$$
		SELECT CASE
			WHEN st_geometrytype($1) = 'ST_CircularString' THEN
				st_geomfromtext('COMPOUNDCURVE(' || st_astext($1) || ')', st_srid($1))
			WHEN st_geometrytype($1) = 'ST_LineString' THEN
				st_geomfromtext('COMPOUNDCURVE(' || substr(st_astext($1), 11) || ')', st_srid($1))
			WHEN st_geometrytype($1) = 'ST_Polygon' THEN
				st_geomfromtext('CURVEPOLYGON' || substr(st_astext($1), 8), st_srid($1))
			WHEN st_geometrytype($1) = 'ST_MultiLineString' THEN
				st_geomfromtext('MULTICURVE(' || substr(st_astext($1), 15) || ')', st_srid($1))
			WHEN st_geometrytype($1) = 'ST_MultiPolygon' THEN
				st_geomfromtext('MULTISURFACE(' || substr(st_astext($1), 12) || ')', st_srid($1))
			ELSE
				$1
			END AS result;
	$$
	LANGUAGE sql;
END IF;
END
$do$;

-- Function to conditionally rename a column
CREATE OR REPLACE FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR)
RETURNS bool AS
$$
BEGIN

    IF EXISTS (SELECT 1
            FROM information_schema.columns
            WHERE table_schema='{schema}' AND table_name=tbl AND column_name=oldname) THEN
        EXECUTE FORMAT('ALTER TABLE %s RENAME COLUMN %s TO %s', tbl, oldname, newname);
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;

END;
$$
LANGUAGE plpgsql;

-- Bak
select _nlx_renamecolumn('bak_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists bak cascade;
create table bak as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bak_tmp;

alter table bak add primary key (ogc_fid);
alter table bak alter column gml_id set not null;
create index bak_geometrie_punt_geom_idx on bak using gist((geometrie_punt::geometry(POINT, 28992)));
create index bak_eindregistratie_idx on bak (eindregistratie);
create index bak_bgt_status_idx on bak (bgt_status);
create index bak_plus_status_idx on bak (plus_status);

create or replace view bakactueel as select * from bak where eindregistratie is null;
create or replace view bakactueelbestaand as select * from bak where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bak_tmp;

-- Begroeid terreindeel
drop table if exists begroeidterreindeel cascade;
create table begroeidterreindeel as select ogc_fid, geometrie_vlak, geometrie_kruinlijn, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(begroeidterreindeeloptalud as boolean) from begroeidterreindeel_tmp;

alter table begroeidterreindeel add primary key (ogc_fid);
alter table begroeidterreindeel alter column gml_id set not null;
create index begroeidterreindeel_geometrie_vlak_geom_idx on begroeidterreindeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index begroeidterreindeel_geometrie_kruinlijn_geom_idx on begroeidterreindeel using gist((geometrie_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index begroeidterreindeel_eindregistratie_idx on begroeidterreindeel (eindregistratie);
create index begroeidterreindeel_bgt_status_idx on begroeidterreindeel (bgt_status);
create index begroeidterreindeel_plus_status_idx on begroeidterreindeel (plus_status);

create or replace view begroeidterreindeelactueel as select * from begroeidterreindeel where eindregistratie is null;
create or replace view begroeidterreindeelactueelbestaand as select * from begroeidterreindeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table begroeidterreindeel_tmp;

-- Bord
select _nlx_renamecolumn('bord_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists bord cascade;
create table bord as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from bord_tmp;

alter table bord add primary key (ogc_fid);
alter table bord alter column gml_id set not null;
create index bord_geometrie_punt_geom_idx on bord using gist((geometrie_punt::geometry(POINT, 28992)));
create index bord_eindregistratie_idx on bord (eindregistratie);
create index bord_bgt_status_idx on bord (bgt_status);
create index bord_plus_status_idx on bord (plus_status);

create or replace view bordactueel as select * from bord where eindregistratie is null;
create or replace view bordactueelbestaand as select * from bord where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table bord_tmp;

-- Buurt
select _nlx_renamecolumn('buurt_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists buurt cascade;
create table buurt as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from buurt_tmp;

alter table buurt add primary key (ogc_fid);
alter table buurt alter column gml_id set not null;
create index buurt_geometrie_vlak_geom_idx on buurt using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index buurt_eindregistratie_idx on buurt (eindregistratie);
create index buurt_bgt_status_idx on buurt (bgt_status);
create index buurt_plus_status_idx on buurt (plus_status);

create or replace view buurtactueel as select * from buurt where eindregistratie is null;
create or replace view buurtactueelbestaand as select * from buurt where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table buurt_tmp;

-- Functioneel gebied
select _nlx_renamecolumn('functioneelgebied_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists functioneelgebied cascade;
create table functioneelgebied as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type, naam from functioneelgebied_tmp;

alter table functioneelgebied add primary key (ogc_fid);
alter table functioneelgebied alter column gml_id set not null;
create index functioneelgebied_geometrie_vlak_geom_idx on functioneelgebied using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index functioneelgebied_eindregistratie_idx on functioneelgebied (eindregistratie);
create index functioneelgebied_bgt_status_idx on functioneelgebied (bgt_status);
create index functioneelgebied_plus_status_idx on functioneelgebied (plus_status);

create or replace view functioneelgebiedactueel as select * from functioneelgebied where eindregistratie is null;
create or replace view functioneelgebiedactueelbestaand as select * from functioneelgebied where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table functioneelgebied_tmp;

-- Gebouwinstallatie
select _nlx_renamecolumn('gebouwinstallatie_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists gebouwinstallatie cascade;
create table gebouwinstallatie as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from gebouwinstallatie_tmp;

alter table gebouwinstallatie add primary key (ogc_fid);
alter table gebouwinstallatie alter column gml_id set not null;
create index gebouwinstallatie_geometrie_vlak_geom_idx on gebouwinstallatie using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index gebouwinstallatie_eindregistratie_idx on gebouwinstallatie (eindregistratie);
create index gebouwinstallatie_bgt_status_idx on gebouwinstallatie (bgt_status);
create index gebouwinstallatie_plus_status_idx on gebouwinstallatie (plus_status);

create or replace view gebouwinstallatieactueel as select * from gebouwinstallatie where eindregistratie is null;
create or replace view gebouwinstallatieactueelbestaand as select * from gebouwinstallatie where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table gebouwinstallatie_tmp;

-- Installatie
select _nlx_renamecolumn('installatie_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists installatie cascade;
create table installatie as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from installatie_tmp;

alter table installatie add primary key (ogc_fid);
alter table installatie alter column gml_id set not null;
create index installatie_geometrie_punt_geom_idx on installatie using gist((geometrie_punt::geometry(POINT, 28992)));
create index installatie_eindregistratie_idx on installatie (eindregistratie);
create index installatie_bgt_status_idx on installatie (bgt_status);
create index installatie_plus_status_idx on installatie (plus_status);

create or replace view installatieactueel as select * from installatie where eindregistratie is null;
create or replace view installatieactueelbestaand as select * from installatie where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table installatie_tmp;

-- Kast
select _nlx_renamecolumn('kast_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists kast cascade;
create table kast as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kast_tmp;

alter table kast add primary key (ogc_fid);
alter table kast alter column gml_id set not null;
create index kast_geometrie_punt_geom_idx on kast using gist((geometrie_punt::geometry(POINT, 28992)));
create index kast_eindregistratie_idx on kast (eindregistratie);
create index kast_bgt_status_idx on kast (bgt_status);
create index kast_plus_status_idx on kast (plus_status);

create or replace view kastactueel as select * from kast where eindregistratie is null;
create or replace view kastactueelbestaand as select * from kast where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kast_tmp;

-- Kunstwerkdeel
-- Note that some hoogspanningsmast features are curve polygons, and some other features are multi
-- surfaces. This is invalid, but these geometries are converted nonetheless. This should be
-- reported though.
drop table if exists kunstwerkdeel cascade;
create table kunstwerkdeel as select ogc_fid, case when st_geometrytype(wkb_geometry) = 'ST_MultiPoint' then wkb_geometry::geometry(MULTIPOINT, 28992) else null::geometry(MULTIPOINT, 28992) end geometrie_multipunt, case when st_geometrytype(wkb_geometry) = 'ST_MultiPolygon' or st_geometrytype(wkb_geometry) = 'ST_MultiSurface' then _nlx_force_curve(wkb_geometry)::geometry(MULTISURFACE, 28992) else null::geometry(MULTISURFACE, 28992) end geometrie_multivlak, case when st_geometrytype(wkb_geometry) = 'ST_CircularString' or st_geometrytype(wkb_geometry) = 'ST_CompoundCurve' or st_geometrytype(wkb_geometry) = 'ST_LineString' then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_geometrytype(wkb_geometry) = 'ST_CurvePolygon' or st_geometrytype(wkb_geometry) = 'ST_Polygon' then _nlx_force_curve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null::geometry(CURVEPOLYGON, 28992) end geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from kunstwerkdeel_tmp;

alter table kunstwerkdeel add primary key (ogc_fid);
alter table kunstwerkdeel alter column gml_id set not null;
create index kunstwerkdeel_geometrie_multipunt_geom_idx on kunstwerkdeel using gist((geometrie_multipunt::geometry(MULTIPOINT, 28992)));
create index kunstwerkdeel_geometrie_multivlak_geom_idx on kunstwerkdeel using gist((geometrie_multivlak::geometry(MULTISURFACE, 28992)));
create index kunstwerkdeel_geometrie_lijn_geom_idx on kunstwerkdeel using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index kunstwerkdeel_geometrie_vlak_geom_idx on kunstwerkdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index kunstwerkdeel_eindregistratie_idx on kunstwerkdeel (eindregistratie);
create index kunstwerkdeel_bgt_status_idx on kunstwerkdeel (bgt_status);
create index kunstwerkdeel_plus_status_idx on kunstwerkdeel (plus_status);

create or replace view kunstwerkdeelactueel as select * from kunstwerkdeel where eindregistratie is null;
create or replace view kunstwerkdeelactueelbestaand as select * from kunstwerkdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table kunstwerkdeel_tmp;

-- Report invalid geometry types for kunstwerkdeel
-- TODO: separate step / pipeline
select bgt_type, st_geometrytype(geometrie_multipunt), count(*) from kunstwerkdeel where bgt_type <> 'hoogspanningsmast' and geometrie_multipunt is not null group by bgt_type, st_geometrytype(geometrie_multipunt)
union all
select bgt_type, st_geometrytype(geometrie_multivlak), count(*) from kunstwerkdeel where bgt_type <> 'hoogspanningsmast' and geometrie_multivlak is not null group by bgt_type, st_geometrytype(geometrie_multivlak)
union all
select bgt_type, st_geometrytype(geometrie_lijn), count(*) from kunstwerkdeel where bgt_type = 'hoogspanningsmast' and geometrie_lijn is not null group by bgt_type, st_geometrytype(geometrie_lijn)
union all
select bgt_type, st_geometrytype(geometrie_vlak), count(*) from kunstwerkdeel where bgt_type = 'hoogspanningsmast' and geometrie_vlak is not null group by bgt_type, st_geometrytype(geometrie_vlak);

-- Mast
select _nlx_renamecolumn('mast_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists mast cascade;
create table mast as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from mast_tmp;

alter table mast add primary key (ogc_fid);
alter table mast alter column gml_id set not null;
create index mast_geometrie_punt_geom_idx on mast using gist((geometrie_punt::geometry(POINT, 28992)));
create index mast_eindregistratie_idx on mast (eindregistratie);
create index mast_bgt_status_idx on mast (bgt_status);
create index mast_plus_status_idx on mast (plus_status);

create or replace view mastactueel as select * from mast where eindregistratie is null;
create or replace view mastactueelbestaand as select * from mast where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table mast_tmp;

-- Onbegroeid terreindeel
drop table if exists onbegroeidterreindeel cascade;
create table onbegroeidterreindeel as select ogc_fid, geometrie_vlak, geometrie_kruinlijn, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(onbegroeidterreindeeloptalud as boolean) from onbegroeidterreindeel_tmp;

alter table onbegroeidterreindeel add primary key (ogc_fid);
alter table onbegroeidterreindeel alter column gml_id set not null;
create index onbegroeidterreindeel_geometrie_vlak_geom_idx on onbegroeidterreindeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index onbegroeidterreindeel_geometrie_kruinlijn_geom_idx on onbegroeidterreindeel using gist((geometrie_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index onbegroeidterreindeel_eindregistratie_idx on onbegroeidterreindeel (eindregistratie);
create index onbegroeidterreindeel_bgt_status_idx on onbegroeidterreindeel (bgt_status);
create index onbegroeidterreindeel_plus_status_idx on onbegroeidterreindeel (plus_status);

create or replace view onbegroeidterreindeelactueel as select * from onbegroeidterreindeel where eindregistratie is null;
create or replace view onbegroeidterreindeelactueelbestaand as select * from onbegroeidterreindeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table onbegroeidterreindeel_tmp;

-- Ondersteunend waterdeel
select _nlx_renamecolumn('ondersteunendwaterdeel_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists ondersteunendwaterdeel cascade;
create table ondersteunendwaterdeel as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from ondersteunendwaterdeel_tmp;

alter table ondersteunendwaterdeel add primary key (ogc_fid);
alter table ondersteunendwaterdeel alter column gml_id set not null;
create index ondersteunendwaterdeel_geometrie_vlak_geom_idx on ondersteunendwaterdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index ondersteunendwaterdeel_eindregistratie_idx on ondersteunendwaterdeel (eindregistratie);
create index ondersteunendwaterdeel_bgt_status_idx on ondersteunendwaterdeel (bgt_status);
create index ondersteunendwaterdeel_plus_status_idx on ondersteunendwaterdeel (plus_status);

create or replace view ondersteunendwaterdeelactueel as select * from ondersteunendwaterdeel where eindregistratie is null;
create or replace view ondersteunendwaterdeelactueelbestaand as select * from ondersteunendwaterdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwaterdeel_tmp;

-- Ondersteunend wegdeel
drop table if exists ondersteunendwegdeel cascade;
create table ondersteunendwegdeel as select ogc_fid, geometrie_vlak, geometrie_kruinlijn, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(ondersteunendwegdeeloptalud as boolean) from ondersteunendwegdeel_tmp;

alter table ondersteunendwegdeel add primary key (ogc_fid);
alter table ondersteunendwegdeel alter column gml_id set not null;
create index ondersteunendwegdeel_geometrie_vlak_geom_idx on ondersteunendwegdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index ondersteunendwegdeel_geometrie_kruinlijn_geom_idx on ondersteunendwegdeel using gist((geometrie_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index ondersteunendwegdeel_eindregistratie_idx on ondersteunendwegdeel (eindregistratie);
create index ondersteunendwegdeel_bgt_status_idx on ondersteunendwegdeel (bgt_status);
create index ondersteunendwegdeel_plus_status_idx on ondersteunendwegdeel (plus_status);

create or replace view ondersteunendwegdeelactueel as select * from ondersteunendwegdeel where eindregistratie is null;
create or replace view ondersteunendwegdeelactueelbestaand as select * from ondersteunendwegdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ondersteunendwegdeel_tmp;

-- Ongeclassificeerd object
select _nlx_renamecolumn('ongeclassificeerdobject_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists ongeclassificeerdobject cascade;
create table ongeclassificeerdobject as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from ongeclassificeerdobject_tmp;

alter table ongeclassificeerdobject add primary key (ogc_fid);
alter table ongeclassificeerdobject alter column gml_id set not null;
create index ongeclassificeerdobject_geometrie_vlak_geom_idx on ongeclassificeerdobject using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index ongeclassificeerdobject_eindregistratie_idx on ongeclassificeerdobject (eindregistratie);
create index ongeclassificeerdobject_bgt_status_idx on ongeclassificeerdobject (bgt_status);
create index ongeclassificeerdobject_plus_status_idx on ongeclassificeerdobject (plus_status);

create or replace view ongeclassificeerdobjectactueel as select * from ongeclassificeerdobject where eindregistratie is null;
create or replace view ongeclassificeerdobjectactueelbestaand as select * from ongeclassificeerdobject where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table ongeclassificeerdobject_tmp;

-- Openbare ruimte
select _nlx_renamecolumn('openbareruimte_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists openbareruimte cascade;
create table openbareruimte as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from openbareruimte_tmp;

alter table openbareruimte add primary key (ogc_fid);
alter table openbareruimte alter column gml_id set not null;
create index openbareruimte_geometrie_vlak_geom_idx on openbareruimte using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index openbareruimte_eindregistratie_idx on openbareruimte (eindregistratie);
create index openbareruimte_bgt_status_idx on openbareruimte (bgt_status);
create index openbareruimte_plus_status_idx on openbareruimte (plus_status);

create or replace view openbareruimteactueel as select * from openbareruimte where eindregistratie is null;
create or replace view openbareruimteactueelbestaand as select * from openbareruimte where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimte_tmp;

-- Openbare-ruimtelabel
select _nlx_renamecolumn('openbareruimtelabel_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists openbareruimtelabel cascade;
create table openbareruimtelabel as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagopr, tekst, hoek, openbareruimtetype from openbareruimtelabel_tmp;

alter table openbareruimtelabel add primary key (ogc_fid);
alter table openbareruimtelabel alter column gml_id set not null;
create index openbareruimtelabel_geometrie_punt_geom_idx on openbareruimtelabel using gist((geometrie_punt::geometry(POINT, 28992)));
create index openbareruimtelabel_eindregistratie_idx on openbareruimtelabel (eindregistratie);
create index openbareruimtelabel_bgt_status_idx on openbareruimtelabel (bgt_status);
create index openbareruimtelabel_plus_status_idx on openbareruimtelabel (plus_status);

create or replace view openbareruimtelabelactueel as select * from openbareruimtelabel where eindregistratie is null;
create or replace view openbareruimtelabelactueelbestaand as select * from openbareruimtelabel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table openbareruimtelabel_tmp;

-- Overbruggingsdeel
select _nlx_renamecolumn('overbruggingsdeel_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists overbruggingsdeel cascade;
create table overbruggingsdeel as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, typeoverbruggingsdeel, hoortbijtypeoverbrugging, cast(overbruggingisbeweegbaar as boolean) from overbruggingsdeel_tmp;

alter table overbruggingsdeel add primary key (ogc_fid);
alter table overbruggingsdeel alter column gml_id set not null;
create index overbruggingsdeel_geometrie_vlak_geom_idx on overbruggingsdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index overbruggingsdeel_eindregistratie_idx on overbruggingsdeel (eindregistratie);
create index overbruggingsdeel_bgt_status_idx on overbruggingsdeel (bgt_status);
create index overbruggingsdeel_plus_status_idx on overbruggingsdeel (plus_status);

create or replace view overbruggingsdeelactueel as select * from overbruggingsdeel where eindregistratie is null;
create or replace view overbruggingsdeelactueelbestaand as select * from overbruggingsdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overbruggingsdeel_tmp;

-- Overig bouwwerk
select _nlx_renamecolumn('overigbouwwerk_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists overigbouwwerk cascade;
create table overigbouwwerk as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from overigbouwwerk_tmp;

alter table overigbouwwerk add primary key (ogc_fid);
alter table overigbouwwerk alter column gml_id set not null;
create index overigbouwwerk_geometrie_vlak_geom_idx on overigbouwwerk using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index overigbouwwerk_eindregistratie_idx on overigbouwwerk (eindregistratie);
create index overigbouwwerk_bgt_status_idx on overigbouwwerk (bgt_status);
create index overigbouwwerk_plus_status_idx on overigbouwwerk (plus_status);

create or replace view overigbouwwerkactueel as select * from overigbouwwerk where eindregistratie is null;
create or replace view overigbouwwerkactueelbestaand as select * from overigbouwwerk where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigbouwwerk_tmp;

-- Overige scheiding
drop table if exists overigescheiding cascade;
create table overigescheiding as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 2 then _nlx_force_curve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null::geometry(CURVEPOLYGON, 28992) end geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, plus_type from overigescheiding_tmp;

alter table overigescheiding add primary key (ogc_fid);
alter table overigescheiding alter column gml_id set not null;
create index overigescheiding_geometrie_lijn_geom_idx on overigescheiding using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index overigescheiding_geometrie_vlak_geom_idx on overigescheiding using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index overigescheiding_eindregistratie_idx on overigescheiding (eindregistratie);
create index overigescheiding_bgt_status_idx on overigescheiding (bgt_status);
create index overigescheiding_plus_status_idx on overigescheiding (plus_status);

create or replace view overigescheidingactueel as select * from overigescheiding where eindregistratie is null;
create or replace view overigescheidingactueelbestaand as select * from overigescheiding where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table overigescheiding_tmp;

-- Paal
select _nlx_renamecolumn('paal_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists paal cascade;
create table paal as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type, hectometeraanduiding from paal_tmp;

alter table paal add primary key (ogc_fid);
alter table paal alter column gml_id set not null;
create index paal_geometrie_punt_geom_idx on paal using gist((geometrie_punt::geometry(POINT, 28992)));
create index paal_eindregistratie_idx on paal (eindregistratie);
create index paal_bgt_status_idx on paal (bgt_status);
create index paal_plus_status_idx on paal (plus_status);

create or replace view paalactueel as select * from paal where eindregistratie is null;
create or replace view paalactueelbestaand as select * from paal where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table paal_tmp;

-- Pand
drop table if exists pand cascade;
create table pand as select ogc_fid, geometrie_vlak, geometrie_nummeraanduiding, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, identificatiebagpnd, nummeraanduidingtekst, nummeraanduidinghoek, identificatiebagvbolaagstehuisnummer, identificatiebagvbohoogstehuisnummer from pand_tmp;

alter table pand add primary key (ogc_fid);
alter table pand alter column gml_id set not null;
create index pand_geometrie_vlak_geom_idx on pand using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index pand_geometrie_nummeraanduiding_geom_idx on pand using gist((geometrie_nummeraanduiding::geometry(POINT, 28992)));
create index pand_eindregistratie_idx on pand (eindregistratie);
create index pand_bgt_status_idx on pand (bgt_status);
create index pand_plus_status_idx on pand (plus_status);

create or replace view pandactueel as select * from pand where eindregistratie is null;
create or replace view pandactueelbestaand as select * from pand where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table pand_tmp;

-- Plaatsbepalingspunt
select _nlx_renamecolumn('plaatsbepalingspunt_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists plaatsbepalingspunt cascade;
create table plaatsbepalingspunt as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, nauwkeurigheid, cast(datuminwinning as date), inwinnendeinstantie, inwinningsmethode from plaatsbepalingspunt_tmp;

alter table plaatsbepalingspunt add primary key (ogc_fid);
alter table plaatsbepalingspunt alter column gml_id set not null;
create index plaatsbepalingspunt_geometrie_punt_geom_idx on plaatsbepalingspunt using gist((geometrie_punt::geometry(POINT, 28992)));

drop table plaatsbepalingspunt_tmp;

-- Put
select _nlx_renamecolumn('put_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists put cascade;
create table put as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from put_tmp;

alter table put add primary key (ogc_fid);
alter table put alter column gml_id set not null;
create index put_geometrie_punt_geom_idx on put using gist((geometrie_punt::geometry(POINT, 28992)));
create index put_eindregistratie_idx on put (eindregistratie);
create index put_bgt_status_idx on put (bgt_status);
create index put_plus_status_idx on put (plus_status);

create or replace view putactueel as select * from put where eindregistratie is null;
create or replace view putactueelbestaand as select * from put where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table put_tmp;

-- Scheiding
drop table if exists scheiding cascade;
create table scheiding as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 2 then _nlx_force_curve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null::geometry(CURVEPOLYGON, 28992) end geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from scheiding_tmp;

alter table scheiding add primary key (ogc_fid);
alter table scheiding alter column gml_id set not null;
create index scheiding_geometrie_lijn_geom_idx on scheiding using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index scheiding_geometrie_vlak_geom_idx on scheiding using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index scheiding_eindregistratie_idx on scheiding (eindregistratie);
create index scheiding_bgt_status_idx on scheiding (bgt_status);
create index scheiding_plus_status_idx on scheiding (plus_status);

create or replace view scheidingactueel as select * from scheiding where eindregistratie is null;
create or replace view scheidingactueelbestaand as select * from scheiding where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table scheiding_tmp;

-- Sensor
drop table if exists sensor cascade;
create table sensor as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null::geometry(POINT, 28992) end geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from sensor_tmp;

alter table sensor add primary key (ogc_fid);
alter table sensor alter column gml_id set not null;
create index sensor_geometrie_lijn_geom_idx on sensor using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index sensor_geometrie_punt_geom_idx on sensor using gist((geometrie_punt::geometry(POINT, 28992)));
create index sensor_eindregistratie_idx on sensor (eindregistratie);
create index sensor_bgt_status_idx on sensor (bgt_status);
create index sensor_plus_status_idx on sensor (plus_status);

create or replace view sensoractueel as select * from sensor where eindregistratie is null;
create or replace view sensoractueelbestaand as select * from sensor where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table sensor_tmp;

-- Spoor
select _nlx_renamecolumn('spoor_tmp', 'wkb_geometry', 'geometrie_lijn');

drop table if exists spoor cascade;
create table spoor as select ogc_fid, geometrie_lijn, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie from spoor_tmp;

alter table spoor add primary key (ogc_fid);
alter table spoor alter column gml_id set not null;
create index spoor_geometrie_lijn_geom_idx on spoor using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index spoor_eindregistratie_idx on spoor (eindregistratie);
create index spoor_bgt_status_idx on spoor (bgt_status);
create index spoor_plus_status_idx on spoor (plus_status);

create or replace view spooractueel as select * from spoor where eindregistratie is null;
create or replace view spooractueelbestaand as select * from spoor where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table spoor_tmp;

-- Stadsdeel
select _nlx_renamecolumn('stadsdeel_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists stadsdeel cascade;
create table stadsdeel as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from stadsdeel_tmp;

alter table stadsdeel add primary key (ogc_fid);
alter table stadsdeel alter column gml_id set not null;
create index stadsdeel_geometrie_vlak_geom_idx on stadsdeel using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index stadsdeel_eindregistratie_idx on stadsdeel (eindregistratie);
create index stadsdeel_bgt_status_idx on stadsdeel (bgt_status);
create index stadsdeel_plus_status_idx on stadsdeel (plus_status);

create or replace view stadsdeelactueel as select * from stadsdeel where eindregistratie is null;
create or replace view stadsdeelactueelbestaand as select * from stadsdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table stadsdeel_tmp;

-- Straatmeubilair
select _nlx_renamecolumn('straatmeubilair_tmp', 'wkb_geometry', 'geometrie_punt');

drop table if exists straatmeubilair cascade;
create table straatmeubilair as select ogc_fid, geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from straatmeubilair_tmp;

alter table straatmeubilair add primary key (ogc_fid);
alter table straatmeubilair alter column gml_id set not null;
create index straatmeubilair_geometrie_punt_geom_idx on straatmeubilair using gist((geometrie_punt::geometry(POINT, 28992)));
create index straatmeubilair_eindregistratie_idx on straatmeubilair (eindregistratie);
create index straatmeubilair_bgt_status_idx on straatmeubilair (bgt_status);
create index straatmeubilair_plus_status_idx on straatmeubilair (plus_status);

create or replace view straatmeubilairactueel as select * from straatmeubilair where eindregistratie is null;
create or replace view straatmeubilairactueelbestaand as select * from straatmeubilair where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table straatmeubilair_tmp;

-- Tunneldeel
select _nlx_renamecolumn('tunneldeel_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists tunneldeel cascade;
create table tunneldeel as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status from tunneldeel_tmp;

alter table tunneldeel add primary key (ogc_fid);
alter table tunneldeel alter column gml_id set not null;
create index tunneldeel_geometrie_vlak_geom_idx on tunneldeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index tunneldeel_eindregistratie_idx on tunneldeel (eindregistratie);
create index tunneldeel_bgt_status_idx on tunneldeel (bgt_status);
create index tunneldeel_plus_status_idx on tunneldeel (plus_status);

create or replace view tunneldeelactueel as select * from tunneldeel where eindregistratie is null;
create or replace view tunneldeelactueelbestaand as select * from tunneldeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table tunneldeel_tmp;

-- Vegetatieobject
drop table if exists vegetatieobject cascade;
create table vegetatieobject as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null::geometry(POINT, 28992) end geometrie_punt, case when st_dimension(wkb_geometry) = 2 then _nlx_force_curve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null::geometry(CURVEPOLYGON, 28992) end geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from vegetatieobject_tmp;

alter table vegetatieobject add primary key (ogc_fid);
alter table vegetatieobject alter column gml_id set not null;
create index vegetatieobject_geometrie_lijn_geom_idx on vegetatieobject using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index vegetatieobject_geometrie_punt_geom_idx on vegetatieobject using gist((geometrie_punt::geometry(POINT, 28992)));
create index vegetatieobject_geometrie_vlak_geom_idx on vegetatieobject using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index vegetatieobject_eindregistratie_idx on vegetatieobject (eindregistratie);
create index vegetatieobject_bgt_status_idx on vegetatieobject (bgt_status);
create index vegetatieobject_plus_status_idx on vegetatieobject (plus_status);

create or replace view vegetatieobjectactueel as select * from vegetatieobject where eindregistratie is null;
create or replace view vegetatieobjectactueelbestaand as select * from vegetatieobject where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table vegetatieobject_tmp;

-- Waterdeel
select _nlx_renamecolumn('waterdeel_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists waterdeel cascade;
create table waterdeel as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterdeel_tmp;

alter table waterdeel add primary key (ogc_fid);
alter table waterdeel alter column gml_id set not null;
create index waterdeel_geometrie_vlak_geom_idx on waterdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index waterdeel_eindregistratie_idx on waterdeel (eindregistratie);
create index waterdeel_bgt_status_idx on waterdeel (bgt_status);
create index waterdeel_plus_status_idx on waterdeel (plus_status);

create or replace view waterdeelactueel as select * from waterdeel where eindregistratie is null;
create or replace view waterdeelactueelbestaand as select * from waterdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterdeel_tmp;

-- Waterinrichtingselement
drop table if exists waterinrichtingselement cascade;
create table waterinrichtingselement as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null::geometry(POINT, 28992) end geometrie_punt, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from waterinrichtingselement_tmp;

alter table waterinrichtingselement add primary key (ogc_fid);
alter table waterinrichtingselement alter column gml_id set not null;
create index waterinrichtingselement_geometrie_lijn_geom_idx on waterinrichtingselement using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index waterinrichtingselement_geometrie_punt_geom_idx on waterinrichtingselement using gist((geometrie_punt::geometry(POINT, 28992)));
create index waterinrichtingselement_eindregistratie_idx on waterinrichtingselement (eindregistratie);
create index waterinrichtingselement_bgt_status_idx on waterinrichtingselement (bgt_status);
create index waterinrichtingselement_plus_status_idx on waterinrichtingselement (plus_status);

create or replace view waterinrichtingselementactueel as select * from waterinrichtingselement where eindregistratie is null;
create or replace view waterinrichtingselementactueelbestaand as select * from waterinrichtingselement where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterinrichtingselement_tmp;

-- Waterschap
select _nlx_renamecolumn('waterschap_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists waterschap cascade;
create table waterschap as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from waterschap_tmp;

alter table waterschap add primary key (ogc_fid);
alter table waterschap alter column gml_id set not null;
create index waterschap_geometrie_vlak_geom_idx on waterschap using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index waterschap_eindregistratie_idx on waterschap (eindregistratie);
create index waterschap_bgt_status_idx on waterschap (bgt_status);
create index waterschap_plus_status_idx on waterschap (plus_status);

create or replace view waterschapactueel as select * from waterschap where eindregistratie is null;
create or replace view waterschapactueelbestaand as select * from waterschap where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table waterschap_tmp;

-- Wegdeel
drop table if exists wegdeel cascade;
create table wegdeel as select ogc_fid, geometrie_vlak, geometrie_kruinlijn, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_functie, plus_functie, bgt_fysiekvoorkomen, plus_fysiekvoorkomen, cast(wegdeeloptalud as boolean) from wegdeel_tmp;

alter table wegdeel add primary key (ogc_fid);
alter table wegdeel alter column gml_id set not null;
create index wegdeel_geometrie_vlak_geom_idx on wegdeel using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index wegdeel_geometrie_kruinlijn_geom_idx on wegdeel using gist((geometrie_kruinlijn::geometry(COMPOUNDCURVE, 28992)));
create index wegdeel_eindregistratie_idx on wegdeel (eindregistratie);
create index wegdeel_bgt_status_idx on wegdeel (bgt_status);
create index wegdeel_plus_status_idx on wegdeel (plus_status);

create or replace view wegdeelactueel as select * from wegdeel where eindregistratie is null;
create or replace view wegdeelactueelbestaand as select * from wegdeel where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wegdeel_tmp;

-- Weginrichtingselement
drop table if exists weginrichtingselement cascade;
create table weginrichtingselement as select ogc_fid, case when st_dimension(wkb_geometry) = 1 then _nlx_force_curve(wkb_geometry)::geometry(COMPOUNDCURVE, 28992) else null::geometry(COMPOUNDCURVE, 28992) end geometrie_lijn, case when st_dimension(wkb_geometry) = 0 then wkb_geometry::geometry(POINT, 28992) else null::geometry(POINT, 28992) end geometrie_punt, case when st_dimension(wkb_geometry) = 2 then _nlx_force_curve(wkb_geometry)::geometry(CURVEPOLYGON, 28992) else null::geometry(CURVEPOLYGON, 28992) end geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, bgt_type, plus_type from weginrichtingselement_tmp;

alter table weginrichtingselement add primary key (ogc_fid);
alter table weginrichtingselement alter column gml_id set not null;
create index weginrichtingselement_geometrie_lijn_geom_idx on weginrichtingselement using gist((geometrie_lijn::geometry(COMPOUNDCURVE, 28992)));
create index weginrichtingselement_geometrie_punt_geom_idx on weginrichtingselement using gist((geometrie_punt::geometry(POINT, 28992)));
create index weginrichtingselement_geometrie_vlak_geom_idx on weginrichtingselement using gist((geometrie_vlak::geometry(CURVEPOLYGON, 28992)));
create index weginrichtingselement_eindregistratie_idx on weginrichtingselement (eindregistratie);
create index weginrichtingselement_bgt_status_idx on weginrichtingselement (bgt_status);
create index weginrichtingselement_plus_status_idx on weginrichtingselement (plus_status);

create or replace view weginrichtingselementactueel as select * from weginrichtingselement where eindregistratie is null;
create or replace view weginrichtingselementactueelbestaand as select * from weginrichtingselement where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table weginrichtingselement_tmp;

-- Wijk
select _nlx_renamecolumn('wijk_tmp', 'wkb_geometry', 'geometrie_vlak');

drop table if exists wijk cascade;
create table wijk as select ogc_fid, geometrie_vlak, gml_id, namespace, lokaalid, cast(objectbegintijd as date), cast(objecteindtijd as date), cast(tijdstipregistratie as timestamptz), cast(eindregistratie as timestamptz), cast(lv_publicatiedatum as timestamptz), bronhouder, cast(inonderzoek as boolean), relatievehoogteligging, bgt_status, plus_status, naam from wijk_tmp;

alter table wijk add primary key (ogc_fid);
alter table wijk alter column gml_id set not null;
create index wijk_geometrie_vlak_geom_idx on wijk using gist((geometrie_vlak::geometry(MULTISURFACE, 28992)));
create index wijk_eindregistratie_idx on wijk (eindregistratie);
create index wijk_bgt_status_idx on wijk (bgt_status);
create index wijk_plus_status_idx on wijk (plus_status);

create or replace view wijkactueel as select * from wijk where eindregistratie is null;
create or replace view wijkactueelbestaand as select * from wijk where eindregistratie is null and bgt_status = 'bestaand' and plus_status <> 'plan' and plus_status <> 'historie';

drop table wijk_tmp;

-- Cleanup functions
DROP FUNCTION _nlx_parse_version(version VARCHAR);
DROP FUNCTION _nlx_force_curve(geometry geometry);
DROP FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR);
