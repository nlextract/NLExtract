-- Create final tables in TOP50NL schema

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

-- Functioneel gebied
create table functioneelgebied as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typefunctioneelgebied, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from functioneelgebied_tmp;

alter table functioneelgebied add primary key (ogc_fid);
alter table functioneelgebied alter column gml_id set not null;
create index functioneelgebied_geometrie_multivlak_geom_idx on functioneelgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index functioneelgebied_geometrie_punt_geom_idx on functioneelgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table functioneelgebied_tmp;

-- Gebouw
create table gebouw as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typegebouw, fysiekvoorkomen, hoogteklasse, hoogte, naamnl, naamfries, geometrie_vlak, geometrie_punt from gebouw_tmp;

alter table gebouw add primary key (ogc_fid);
alter table gebouw alter column gml_id set not null;
create index gebouw_geometrie_vlak_geom_idx on gebouw using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index gebouw_geometrie_punt_geom_idx on gebouw using gist((geometrie_punt::geometry(POINT, 28992)));

drop table gebouw_tmp;

-- Geografisch gebied
create table geografischgebied as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typegeografischgebied, naamnl, naamfries, naamofficieel, aantalinwoners, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from geografischgebied_tmp;

alter table geografischgebied add primary key (ogc_fid);
alter table geografischgebied alter column gml_id set not null;
create index geografischgebied_geometrie_multivlak_geom_idx on geografischgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index geografischgebied_geometrie_punt_geom_idx on geografischgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table geografischgebied_tmp;

-- Hoogte
create table hoogte as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typehoogte, hoogte, geometrie_lijn, geometrie_punt from hoogte_tmp;

alter table hoogte add primary key (ogc_fid);
alter table hoogte alter column gml_id set not null;
create index hoogte_geometrie_lijn_geom_idx on hoogte using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index hoogte_geometrie_punt_geom_idx on hoogte using gist((geometrie_punt::geometry(POINT, 28992)));

drop table hoogte_tmp;

-- Inrichtingselement
create table inrichtingselement as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typeinrichtingselement, hoogteniveau, naamnl, naamfries, nummer, status, geometrie_lijn, geometrie_punt from inrichtingselement_tmp;

alter table inrichtingselement add primary key (ogc_fid);
alter table inrichtingselement alter column gml_id set not null;
create index inrichtingselement_geometrie_lijn_geom_idx on inrichtingselement using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index inrichtingselement_geometrie_punt_geom_idx on inrichtingselement using gist((geometrie_punt::geometry(POINT, 28992)));

drop table inrichtingselement_tmp;

-- Registratief gebied
create table registratiefgebied as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typeregistratiefgebied, naamnl, naamfries, nummer, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak from registratiefgebied_tmp;

alter table registratiefgebied add primary key (ogc_fid);
alter table registratiefgebied alter column gml_id set not null;
create index registratiefgebied_geometrie_multivlak_geom_idx on registratiefgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));

drop table registratiefgebied_tmp;

-- Relief
select _nlx_renamecolumn('relief_tmp', 'wkb_geometry', 'geometrie_lijn');

create table relief as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typerelief, hoogteklasse, hoogteniveau, functie, naamnl, naamfries, geometrie_lijn from relief_tmp;

alter table relief add primary key (ogc_fid);
alter table relief alter column gml_id set not null;
create index relief_geometrie_lijn_geom_idx on relief using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table relief_tmp;

-- Spoorbaandeel
select _nlx_renamecolumn('spoorbaandeel_tmp', 'wkb_geometry', 'geometrie_lijn');

create table spoorbaandeel as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typespoorbaan, fysiekvoorkomen, aantalsporen, hoogteniveau, status, geometrie_lijn from spoorbaandeel_tmp;

alter table spoorbaandeel add primary key (ogc_fid);
alter table spoorbaandeel alter column gml_id set not null;
create index spoorbaandeel_geometrie_lijn_geom_idx on spoorbaandeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table spoorbaandeel_tmp;

-- Terrein
select _nlx_renamecolumn('terrein_tmp', 'wkb_geometry', 'geometrie_vlak');

create table terrein as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typelandgebruik, geometrie_vlak from terrein_tmp;

alter table terrein add primary key (ogc_fid);
alter table terrein alter column gml_id set not null;
create index terrein_geometrie_vlak_geom_idx on terrein using gist((geometrie_vlak::geometry(POLYGON, 28992)));

drop table terrein_tmp;

-- Waterdeel
create table waterdeel as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typewater, breedteklasse, fysiekvoorkomen, hoogteniveau, geometrie_vlak, geometrie_lijn from waterdeel_tmp;

alter table waterdeel add primary key (ogc_fid);
alter table waterdeel alter column gml_id set not null;
create index waterdeel_geometrie_vlak_geom_idx on waterdeel using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index waterdeel_geometrie_lijn_geom_idx on waterdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table waterdeel_tmp;

-- Wegdeel
create table wegdeel as select ogc_fid, gml_id, namespace, lokaalid, versie, objectbegintijd::date, objecteindtijd::date, brontype, bronbeschrijving, bronactualiteit::date, tdncode, visualisatiecode, typeinfrastructuur, typeweg, hoofdverkeersgebruik, fysiekvoorkomen, verhardingsbreedteklasse, gescheidenrijbaan, typeverharding, straatnaamnl, straatnaamfries, hoogteniveau, awegnummer, nwegnummer, ewegnummer, swegnummer, afritnummer, afritnaam, knooppuntnaam, brugnaam, tunnelnaam, geometrie_vlak, geometrie_lijn from wegdeel_tmp;

alter table wegdeel add primary key (ogc_fid);
alter table wegdeel alter column gml_id set not null;
create index wegdeel_geometrie_vlak_geom_idx on wegdeel using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index wegdeel_geometrie_lijn_geom_idx on wegdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table wegdeel_tmp;

-- Cleanup functions
DROP FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR);
