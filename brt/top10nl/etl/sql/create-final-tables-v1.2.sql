-- Create final tables in TOP10NL schema

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
create table functioneelgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typefunctioneelgebied, soortnaam, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from functioneelgebied_tmp;

alter table functioneelgebied add primary key (ogc_fid);
alter table functioneelgebied alter column gml_id set not null;
create index functioneelgebied_geometrie_multivlak_geom_idx on functioneelgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index functioneelgebied_geometrie_punt_geom_idx on functioneelgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table functioneelgebied_tmp;

-- Gebouw
create table gebouw as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typegebouw, fysiekvoorkomen, hoogteklasse, hoogteniveau, hoogte, status, soortnaam, naam, gebruiksdoel, geometrie_vlak, geometrie_punt from gebouw_tmp;

alter table gebouw add primary key (ogc_fid);
alter table gebouw alter column gml_id set not null;
create index gebouw_geometrie_vlak_geom_idx on gebouw using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index gebouw_geometrie_punt_geom_idx on gebouw using gist((geometrie_punt::geometry(POINT, 28992)));

drop table gebouw_tmp;

-- Geografisch gebied
create table geografischgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typegeografischgebied, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from geografischgebied_tmp;

alter table geografischgebied add primary key (ogc_fid);
alter table geografischgebied alter column gml_id set not null;
create index geografischgebied_geometrie_multivlak_geom_idx on geografischgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index geografischgebied_geometrie_punt_geom_idx on geografischgebied using gist((geometrie_punt::geometry(POINT, 28992)));

drop table geografischgebied_tmp;

-- Hoogte
create table hoogte as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typehoogte, hoogte, referentievlak, geometrie_lijn, geometrie_punt from hoogte_tmp;

alter table hoogte add primary key (ogc_fid);
alter table hoogte alter column gml_id set not null;
create index hoogte_geometrie_lijn_geom_idx on hoogte using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index hoogte_geometrie_punt_geom_idx on hoogte using gist((geometrie_punt::geometry(POINT, 28992)));

drop table hoogte_tmp;

-- Inrichtingselement
create table inrichtingselement as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typeinrichtingselement, hoogte, breedte, hoogteniveau, soortnaam, naam, nummer, geometrie_lijn, geometrie_punt from inrichtingselement_tmp;

alter table inrichtingselement add primary key (ogc_fid);
alter table inrichtingselement alter column gml_id set not null;
create index inrichtingselement_geometrie_lijn_geom_idx on inrichtingselement using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index inrichtingselement_geometrie_punt_geom_idx on inrichtingselement using gist((geometrie_punt::geometry(POINT, 28992)));

drop table inrichtingselement_tmp;

-- Plaats
create table plaats as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typegebied, bebouwdekom, isbagwoonplaats, aantalinwoners, naamofficieel, naamnl, naamfries, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak, geometrie_punt from plaats_tmp;

alter table plaats add primary key (ogc_fid);
alter table plaats alter column gml_id set not null;
create index plaats_geometrie_multivlak_geom_idx on plaats using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));
create index plaats_geometrie_punt_geom_idx on plaats using gist((geometrie_punt::geometry(POINT, 28992)));

drop table plaats_tmp;

-- Plantopografie
create table plantopografie as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typeobject, naam, geometrie_vlak, geometrie_lijn, geometrie_punt from plantopografie_tmp;

alter table plantopografie add primary key (ogc_fid);
alter table plantopografie alter column gml_id set not null;
create index plantopografie_geometrie_vlak_geom_idx on plantopografie using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index plantopografie_geometrie_lijn_geom_idx on plantopografie using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index plantopografie_geometrie_punt_geom_idx on plantopografie using gist((geometrie_punt::geometry(POINT, 28992)));

drop table plantopografie_tmp;

-- Registratief gebied
create table registratiefgebied as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typeregistratiefgebied, naamofficieel, naamnl, naamfries, nummer, case when geometrie_vlak is not null then st_multi(geometrie_vlak)::geometry(MULTIPOLYGON, 28992) else geometrie_multivlak end geometrie_multivlak from registratiefgebied_tmp;

alter table registratiefgebied add primary key (ogc_fid);
alter table registratiefgebied alter column gml_id set not null;
create index registratiefgebied_geometrie_multivlak_geom_idx on registratiefgebied using gist((geometrie_multivlak::geometry(MULTIPOLYGON, 28992)));

drop table registratiefgebied_tmp;

-- Relief
create table relief as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typerelief, hoogteklasse, hoogteniveau, functie, geometrie_lijn, geometrie_hogezijde, geometrie_lagezijde from relief_tmp;

alter table relief add primary key (ogc_fid);
alter table relief alter column gml_id set not null;
create index relief_geometrie_lijn_geom_idx on relief using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index relief_geometrie_hogezijde_geom_idx on relief using gist((geometrie_hogezijde::geometry(LINESTRING, 28992)));
create index relief_geometrie_lagezijde_geom_idx on relief using gist((geometrie_lagezijde::geometry(LINESTRING, 28992)));

drop table relief_tmp;

-- Spoorbaandeel
create table spoorbaandeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typeinfrastructuur, typespoorbaan, fysiekvoorkomen, spoorbreedte, aantalsporen, vervoerfunctie, elektrificatie, hoogteniveau, status, brugnaam, tunnelnaam, baanvaknaam, geometrie_lijn, geometrie_punt from spoorbaandeel_tmp;

alter table spoorbaandeel add primary key (ogc_fid);
alter table spoorbaandeel alter column gml_id set not null;
create index spoorbaandeel_geometrie_lijn_geom_idx on spoorbaandeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index spoorbaandeel_geometrie_punt_geom_idx on spoorbaandeel using gist((geometrie_punt::geometry(POINT, 28992)));

drop table spoorbaandeel_tmp;

-- Terrein
select _nlx_renamecolumn('terrein_tmp', 'wkb_geometry', 'geometrie_vlak');

create table terrein as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typelandgebruik, fysiekvoorkomen, voorkomen, hoogteniveau, naam, geometrie_vlak from terrein_tmp;

alter table terrein add primary key (ogc_fid);
alter table terrein alter column gml_id set not null;
create index terrein_geometrie_vlak_geom_idx on terrein using gist((geometrie_vlak::geometry(POLYGON, 28992)));

drop table terrein_tmp;

-- Waterdeel
create table waterdeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typewater, breedteklasse, hoofdafwatering, fysiekvoorkomen, voorkomen, hoogteniveau, functie, getijdeinvloed, vaarwegklasse, naamofficieel, naamnl, naamfries, isbagnaam, sluisnaam, brugnaam, geometrie_vlak, geometrie_lijn, geometrie_punt from waterdeel_tmp;

alter table waterdeel add primary key (ogc_fid);
alter table waterdeel alter column gml_id set not null;
create index waterdeel_geometrie_vlak_geom_idx on waterdeel using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index waterdeel_geometrie_lijn_geom_idx on waterdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index waterdeel_geometrie_punt_geom_idx on waterdeel using gist((geometrie_punt::geometry(POINT, 28992)));

drop table waterdeel_tmp;

-- Wegdeel
create table wegdeel as select ogc_fid, gml_id, namespace, lokaalid, brontype, bronactualiteit::date, bronbeschrijving, bronnauwkeurigheid, objectbegintijd::date, objecteindtijd::date, tijdstipregistratie::date, eindregistratie::date, tdncode, visualisatiecode, mutatietype, typeinfrastructuur, typeweg, hoofdverkeersgebruik, fysiekvoorkomen, verhardingsbreedteklasse, gescheidenrijbaan, verhardingstype, aantalrijstroken, hoogteniveau, status, naam, isbagnaam, awegnummer, nwegnummer, ewegnummer, swegnummer, afritnummer, afritnaam, knooppuntnaam, brugnaam, tunnelnaam, geometrie_vlak, geometrie_lijn, geometrie_punt, geometrie_hartpunt, geometrie_hartlijn from wegdeel_tmp;

alter table wegdeel add primary key (ogc_fid);
alter table wegdeel alter column gml_id set not null;
create index wegdeel_geometrie_vlak_geom_idx on wegdeel using gist((geometrie_vlak::geometry(POLYGON, 28992)));
create index wegdeel_geometrie_lijn_geom_idx on wegdeel using gist((geometrie_lijn::geometry(LINESTRING, 28992)));
create index wegdeel_geometrie_punt_geom_idx on wegdeel using gist((geometrie_punt::geometry(POINT, 28992)));
create index wegdeel_geometrie_hartlijn_geom_idx on wegdeel using gist((geometrie_hartlijn::geometry(LINESTRING, 28992)));
create index wegdeel_geometrie_hartpunt_geom_idx on wegdeel using gist((geometrie_hartpunt::geometry(POINT, 28992)));

drop table wegdeel_tmp;

-- Cleanup functions
DROP FUNCTION _nlx_renamecolumn(tbl VARCHAR, oldname VARCHAR, newname VARCHAR);
