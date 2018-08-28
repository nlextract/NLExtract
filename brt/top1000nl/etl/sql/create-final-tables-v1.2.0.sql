-- Create final tables in TOP1000NL schema

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
create table functioneelgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typefunctioneelgebied, soortnaam, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from functioneelgebied_tmp;

alter table functioneelgebied add primary key (ogc_fid);
alter table functioneelgebied alter column gml_id set not null;
create index functioneelgebied_geometrie_multivlak_geom_idx on functioneelgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index functioneelgebied_geometrie_punt_geom_idx on functioneelgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table functioneelgebied_tmp;

-- Gebouw
select _nlx_renamecolumn('gebouw_tmp', 'wkb_geometry', 'geometrie_punt');

create table gebouw as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typegebouw, status, soortnaam, naam, geometrie_punt from gebouw_tmp;

alter table gebouw add primary key (ogc_fid);
alter table gebouw alter column gml_id set not null;
create index gebouw_geometrie_punt_geom_idx on gebouw using gist((geometrie_punt::geometry(POINT, 28992)));

drop table gebouw_tmp;

-- Geografisch gebied
create table geografischgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typegeografischgebied, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from geografischgebied_tmp;

alter table geografischgebied add primary key (ogc_fid);
alter table geografischgebied alter column gml_id set not null;
create index geografischgebied_geometrie_multivlak_geom_idx on geografischgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index geografischgebied_geometrie_punt_geom_idx on geografischgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table geografischgebied_tmp;

-- Hoogte
create table hoogte as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typehoogte, hoogte, referentievlak, geometrie_lijn, geometrie_punt from hoogte_tmp;

alter table hoogte add primary key (ogc_fid);
alter table hoogte alter column gml_id set not null;
create index hoogte_geometrie_lijn_geom_idx on hoogte using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index hoogte_geometrie_punt_geom_idx on hoogte using gist((geometrie_punt::geometry(POINT, 28992)));

drop table hoogte_tmp;

-- Inrichtingselement
create table inrichtingselement as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typeinrichtingselement, soortnaam, naam, geometrie_lijn, geometrie_punt from inrichtingselement_tmp;

alter table inrichtingselement add primary key (ogc_fid);
alter table inrichtingselement alter column gml_id set not null;
create index inrichtingselement_geometrie_lijn_geom_idx on inrichtingselement using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index inrichtingselement_geometrie_punt_geom_idx on inrichtingselement using gist((geometrie_punt::geometry(POINT, 28992)));

drop table inrichtingselement_tmp;

-- Plaats
create table plaats as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typegebied, aantalinwoners, naamofficieel, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from plaats_tmp;

alter table plaats add primary key (ogc_fid);
alter table plaats alter column gml_id set not null;
create index plaats_geometrie_multivlak_geom_idx on plaats using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index plaats_geometrie_punt_geom_idx on plaats using gist((geometrie_punt::geometry(POINT, 28992)));

drop table plaats_tmp;

-- Plantopografie
create table plantopografie as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typeobject, naam, geometrie_vlak, geometrie_lijn, geometrie_punt from plantopografie_tmp;

alter table plantopografie add primary key (ogc_fid);
alter table plantopografie alter column gml_id set not null;
create index plantopografie_geometrie_vlak_geom_idx on plantopografie using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index plantopografie_geometrie_lijn_geom_idx on plantopografie using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index plantopografie_geometrie_punt_geom_idx on plantopografie using gist((geometrie_punt::geometry(POINT, 28992)));

drop table plantopografie_tmp;

-- Registratief gebied
create table registratiefgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typeregistratiefgebied, naamofficieel, naamnl, naamfries, nummer, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak from registratiefgebied_tmp;

alter table registratiefgebied add primary key (ogc_fid);
alter table registratiefgebied alter column gml_id set not null;
create index registratiefgebied_geometrie_multivlak_geom_idx on registratiefgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));

drop table registratiefgebied_tmp;

-- Spoorbaandeel
select _nlx_renamecolumn('spoorbaandeel_tmp', 'wkb_geometry', 'geometrie_lijn');

create table spoorbaandeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typeinfrastructuur, typespoorbaan, fysiekvoorkomen, spoorbreedte, aantalsporen, vervoerfunctie, elektrificatie, status, brugnaam, tunnelnaam, baanvaknaam, geometrie_lijn from spoorbaandeel_tmp;

alter table spoorbaandeel add primary key (ogc_fid);
alter table spoorbaandeel alter column gml_id set not null;
create index spoorbaandeel_geometrie_lijn_geom_idx on spoorbaandeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table spoorbaandeel_tmp;

-- Terrein
select _nlx_renamecolumn('terrein_tmp', 'wkb_geometry', 'geometrie_vlak');

create table terrein as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typelandgebruik, naam, voorkomen, geometrie_vlak from terrein_tmp;

alter table terrein add primary key (ogc_fid);
alter table terrein alter column gml_id set not null;
create index terrein_geometrie_vlak_geom_idx on terrein using gist((geometrie_vlak::geometry(POLYGON, 28992)));

drop table terrein_tmp;

-- Waterdeel
create table waterdeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typewater, breedteklasse, fysiekvoorkomen, voorkomen, getijdeinvloed, vaarwegklasse, naamofficieel, naamnl, naamfries, isbagnaam, sluisnaam, brugnaam, geometrie_vlak, geometrie_lijn from waterdeel_tmp;

alter table waterdeel add primary key (ogc_fid);
alter table waterdeel alter column gml_id set not null;
create index waterdeel_geometrie_vlak_geom_idx on waterdeel using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index waterdeel_geometrie_lijn_geom_idx on waterdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));

drop table waterdeel_tmp;

-- Wegdeel
create table wegdeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, visualisatiecode, typeinfrastructuur, typeweg, hoofdverkeersgebruik, fysiekvoorkomen, verhardingsbreedteklasse, gescheidenrijbaan, verhardingstype, aantalrijstroken, status, naam, isbagnaam, awegnummer, nwegnummer, ewegnummer, swegnummer, afritnummer, afritnaam, knooppuntnaam, brugnaam, tunnelnaam, geometrie_lijn, geometrie_punt from wegdeel_tmp;

alter table wegdeel add primary key (ogc_fid);
alter table wegdeel alter column gml_id set not null;
create index wegdeel_geometrie_lijn_geom_idx on wegdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index wegdeel_geometrie_punt_geom_idx on wegdeel using gist((geometrie_punt::geometry(POINT, 28992)));

drop table wegdeel_tmp;

-- Cleanup functions
DROP FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR);
