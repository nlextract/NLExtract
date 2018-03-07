-- Create final tables in BRK schema
set time zone 'Europe/Amsterdam';

-- Annotatie
alter table annotatie rename column wkb_geometry to geometrie;
alter index annotatie_wkb_geometry_geom_idx rename to annotatie_geometrie_geom_idx;
drop sequence annotatie_ogc_fid_seq cascade;

-- Bebouwing
create table bebouwing as select ogc_fid, gml_id, namespace, lokaalid, classificatiecode, bron, kwaliteit, objectdatum::date, zichtbaarheidscode, wkb_geometry as geometrie from bebouwing_tmp;

alter table bebouwing add primary key (ogc_fid);
alter table bebouwing alter column gml_id set not null;
create index bebouwing_geometrie_geom_idx on bebouwing using gist(geometrie);

drop table bebouwing_tmp;

-- KadastraleGrens
create table kadastralegrens as select ogc_fid, gml_id, namespace, lokaalid::bigint, type, logischtijdstipontstaan::timestamptz, logischtijdstipvervallen::timestamptz, wkb_geometry as geometrie from kadastralegrens_tmp;

alter table kadastralegrens add primary key (ogc_fid);
alter table kadastralegrens alter column gml_id set not null;
create index kadastralegrens_geometrie_geom_idx on kadastralegrens using gist(geometrie);

drop table kadastralegrens_tmp;

-- Perceel
create table perceel as select ogc_fid, gml_id, namespace, lokaalid, logischtijdstipontstaan::timestamptz, gemeente, sectie, perceelnummer, waarde, perceelnummerrotatie, deltax, deltay, begrenzing, plaatscoordinaten from perceel_tmp;

alter table perceel add primary key (ogc_fid);
alter table perceel alter column gml_id set not null;
create index perceel_begrenzing_geom_idx on perceel using gist(begrenzing);
create index perceel_plaatscoordinaten_geom_idx on perceel using gist(plaatscoordinaten);

drop table perceel_tmp;
