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
  select gw.gemeentecode,gp.gemeentenaam,ST_Multi(ST_Union(w.geovlak)) as geovlak
  from gemeente_woonplaatsactueelbestaand as gw, woonplaatsactueelbestaand as w, gemeente_provincie as gp
  where gw.woonplaatscode = w.identificatie and gw.gemeentecode = gp.gemeentecode
  group by gw.gemeentecode,gp.gemeentenaam;

alter table gemeente add column gid serial;

ALTER TABLE ONLY gemeente ADD CONSTRAINT gemeente_pkey PRIMARY KEY (gid);

CREATE INDEX gemeente_geom_idx ON gemeente USING gist (geovlak);
CREATE INDEX gemeente_naam ON gemeente USING btree (gemeentenaam);

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
CREATE INDEX provincie_naam ON provincie USING btree (provincienaam);
