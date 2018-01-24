-- Convert polygons to multipolygons in feature types which have both
update functioneelgebied set geometry_multivlak = st_multi(geometry_vlak), geometry_vlak = null where geometry_vlak is not null;
alter table functioneelgebied drop column geometry_vlak;

update geografischgebied set geometry_multivlak = st_multi(geometry_vlak), geometry_vlak = null where geometry_vlak is not null;
alter table geografischgebied drop column geometry_vlak;

update plaats set geometry_multivlak = st_multi(geometry_vlak), geometry_vlak = null where geometry_vlak is not null;
alter table plaats drop column geometry_vlak;

update registratiefgebied set geometry_multivlak = st_multi(geometry_vlak), geometry_vlak = null where geometry_vlak is not null;
alter table registratiefgebied drop column geometry_vlak;

-- Rename default column name wkb_geometry to desired name, despite the fact that this has been specified in the GFS file
alter table terrein rename wkb_geometry to geometry_vlak;
