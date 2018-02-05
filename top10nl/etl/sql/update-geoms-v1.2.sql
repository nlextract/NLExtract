-- Convert polygons to multipolygons in feature types which have both
update functioneelgebied set geometrie_multivlak = st_multi(geometrie_vlak), geometrie_vlak = null where geometrie_vlak is not null;
alter table functioneelgebied drop column geometrie_vlak;

update geografischgebied set geometrie_multivlak = st_multi(geometrie_vlak), geometrie_vlak = null where geometrie_vlak is not null;
alter table geografischgebied drop column geometrie_vlak;

update plaats set geometrie_multivlak = st_multi(geometrie_vlak), geometrie_vlak = null where geometrie_vlak is not null;
alter table plaats drop column geometrie_vlak;

update registratiefgebied set geometrie_multivlak = st_multi(geometrie_vlak), geometrie_vlak = null where geometrie_vlak is not null;
alter table registratiefgebied drop column geometrie_vlak;

-- Rename default column name wkb_geometry to desired name, despite the fact that this has been specified in the GFS file
alter table terrein rename wkb_geometry to geometrie_vlak;
