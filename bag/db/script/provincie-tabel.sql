-- Maak een provincie tabel als accumulatie (union) van alle gemeenten

drop table if exists provincie;

create table provincie as
  select provinciecode,provincienaam,ST_Multi(ST_Union(gemeente.geovlak)) as geovlak
  from
  	gemeente_provincie,
  	gemeente
  where gemeente_provincie.gemeentecode = gemeente.gemeentecode
  group by provinciecode,provincienaam;

alter table provincie add column gid serial;

ALTER TABLE ONLY provincie ADD CONSTRAINT provincie_pkey PRIMARY KEY (gid);

CREATE INDEX provincie_geom_idx ON provincie USING gist (geovlak);

select probe_geometry_columns();
