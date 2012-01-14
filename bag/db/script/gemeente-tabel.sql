-- Maak een gemeente tabel als accumulatie (union) van alle woonplaatsen
-- Let op
-- 1. in gemeente_woonplaats staan gemeenten die beeindigd zijn; deze uitfilteren
-- 2. dubbele woonplaatsen in woonplaats tabel ! Zie bijv
-- select id,identificatie, aanduidingrecordinactief, aanduidingrecordcorrectie, officieel, inonderzoek, documentnummer,
--    documentdatum, woonplaatsnaam,   woonplaatsstatus  ,begindatumtijdvakgeldigheid, einddatumtijdvakgeldigheid from woonplaats where identificatie = '1183'
--    Dus ook inaktieve woonplaatsen uitfilteren !!
-- SELECT identificatie, COUNT(identificatie) AS NumOccurrences FROM woonplaats GROUP BY identificatie HAVING ( COUNT(identificatie) > 1 );

drop table if exists gemeente;

create table gemeente as
  select gw.gemeentecode,gw.gemeentenaam,ST_Multi(ST_Union(w.geovlak)) as geovlak
  from gemeente_woonplaats as gw, woonplaats as w
  where gw.woonplaatscode = w.identificatie AND w.aanduidingrecordinactief = 'N' AND gw.einddatum_woonplaats IS NULL AND gw.einddatum_gemeente IS NULL
  group by gw.gemeentecode,gw.gemeentenaam;

alter table gemeente add column gid serial;

ALTER TABLE ONLY gemeente ADD CONSTRAINT gemeente_pkey PRIMARY KEY (gid);

CREATE INDEX gemeente_geom_idx ON gemeente USING gist (geovlak);

select probe_geometry_columns();
