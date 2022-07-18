--
-- Maakt en vult afgeleide tabel "adres" aan met volledige adressen (BAG v2 versie).
--
-- De BAG bevat geen echte adressen zoals bijv. ACN (Adres Coordinaten Nederland), dwz
-- een tabel met straat, huisnummer, woonplaats, gemeente, provincie etc.
-- De elementen voor een compleet adres zitten wel in de (verrijkte) BAG.
-- Via SQL scripts hieronder wordt een echte "adres" tabel aangemaakt en gevuld
-- uit de BAG basistabellen.
--
-- Auteur: Just van den Broecke
--
-- OBSOLETE: we gebruiken nu adres-plus2adres-tabel.sql

-- Maak  een "echte" adressen tabel
DROP TABLE IF EXISTS adres CASCADE;
CREATE TABLE adres (
    gid serial,
    openbareruimtenaam character varying(80),
    huisnummer numeric(5,0),
    huisletter character varying(1),
    huisnummertoevoeging character varying(4),
    postcode character varying(6),
    woonplaatsnaam character varying(80),
    gemeentenaam character varying(80),
    provincienaam character varying(16),
    typeadresseerbaarobject character varying(3),
    adresseerbaarobject varchar(16),
    nummeraanduiding varchar(16),
    nevenadres BOOLEAN DEFAULT FALSE,
    geopunt geometry(Point, 28992),
    textsearchable_adres tsvector
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam,
        provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT o.naam AS openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
-- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
-- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    (CASE
      WHEN wp2.naam IS NULL THEN w.naam ELSE wp2.naam END) AS woonplaatsnaam,
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
       WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'VBO' as typeadresseerbaarobject,
    v.identificatie as adresseerbaarobject,
    n.identificatie as nummeraanduiding,
    v.wkb_geometry AS geopunt
   FROM verblijfsobjectactueelbestaand v
    JOIN nummeraanduidingactueelbestaand n
    ON (n.identificatie = v.hoofdadresnummeraanduidingref)
    JOIN openbareruimteactueelbestaand o
    ON (n.openbareruimteref = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.woonplaatsref = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand  g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.woonplaatsref = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.naam AS openbareruimenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
   -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    (CASE
      WHEN wp2.naam IS NULL THEN w.naam ELSE wp2.naam END) AS woonplaatsnaam,
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
       WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'LIG' as typeadresseerbaarobject,
	l.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
    -- Vlak geometrie wordt punt
	ST_Centroid(l.geovlak)  as geopunt
  FROM ligplaatsactueelbestaand l
   JOIN nummeraanduidingactueelbestaand n
   ON (n.identificatie = l.hoofdadresnummeraanduidingref)
   JOIN openbareruimteactueelbestaand o
   ON (n.openbareruimteref = o.identificatie)
   JOIN woonplaatsactueelbestaand w
   ON (o.woonplaatsref = w.identificatie)
   JOIN gemeente_woonplaatsactueelbestaand  g
   ON (g.woonplaatscode = w.identificatie)
   JOIN provincie_gemeenteactueelbestaand p
   ON (g.gemeentecode = p.gemeentecode)
   -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
   LEFT OUTER JOIN woonplaatsactueelbestaand wp2
   ON (n.woonplaatsref = wp2.identificatie)
   LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
   ON (g2.woonplaatscode = wp2.identificatie)
   LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
   ON (g2.gemeentecode = p2.gemeentecode);

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeadresseerbaarobject, adresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.naam AS openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
   -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    (CASE
     WHEN wp2.naam IS NULL THEN w.naam ELSE wp2.naam END) AS woonplaatsnaam,
    (CASE
       WHEN p2.gemeentenaam IS NULL THEN  p.gemeentenaam ELSE  p2.gemeentenaam END),
    (CASE
      WHEN p2.provincienaam IS NULL THEN  p.provincienaam ELSE  p2.provincienaam END),
    'STA' as typeadresseerbaarobject,
	s.identificatie as adresseerbaarobject,
	n.identificatie as nummeraanduiding,
    -- Vlak geometrie wordt punt
    ST_Centroid(s.geovlak) as geopunt
  FROM standplaatsactueelbestaand s
   JOIN nummeraanduidingactueelbestaand n
   ON (n.identificatie = s.hoofdadresnummeraanduidingref)
   JOIN openbareruimteactueelbestaand o
   ON (n.openbareruimteref = o.identificatie)
   JOIN woonplaatsactueelbestaand w
   ON (o.woonplaatsref = w.identificatie)
   JOIN gemeente_woonplaatsactueelbestaand  g
   ON (g.woonplaatscode = w.identificatie)
   JOIN provincie_gemeenteactueelbestaand p
   ON (g.gemeentecode = p.gemeentecode)
   -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
   -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
   LEFT OUTER JOIN woonplaatsactueelbestaand wp2
   ON (n.woonplaatsref = wp2.identificatie)
   LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand  g2
   ON (g2.woonplaatscode = wp2.identificatie)
   LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
   ON (g2.gemeentecode = p2.gemeentecode);

--
-- START NEVENADRESSEN
--

INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode,
                   woonplaatsnaam, gemeentenaam, provincienaam,
                   typeadresseerbaarobject, adresseerbaarobject,
                   nummeraanduiding, nevenadres, geopunt)
  SELECT
    o.naam AS openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.naam, w.naam) AS woonplaatsnaam,
    COALESCE(p2.gemeentenaam, p.gemeentenaam),
    COALESCE(p2.provincienaam, p.provincienaam),
    an.typeadresseerbaarobject,
    an.identificatie as adresseerbaarobject,
    n.identificatie as nummeraanduiding,
    TRUE,
    an.geopunt
FROM
    adresseerbaarobjectnevenadresactueel an
JOIN
    nummeraanduidingactueelbestaand n
ON
    (an.nevenadres = n.identificatie)
JOIN
    openbareruimteactueelbestaand o           
ON
    (n.openbareruimteref = o.identificatie)
JOIN
    woonplaatsactueelbestaand w
ON
    (o.woonplaatsref = w.identificatie)
JOIN
    gemeente_woonplaatsactueelbestaand g
ON
    (g.woonplaatscode = w.identificatie)
JOIN
    provincie_gemeenteactueelbestaand p
ON
    (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdeWoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
LEFT OUTER JOIN
    woonplaatsactueelbestaand wp2
ON
    (n.woonplaatsref = wp2.identificatie)
LEFT OUTER JOIN
    gemeente_woonplaatsactueelbestaand g2
ON
    (g2.woonplaatscode = wp2.identificatie)
LEFT OUTER JOIN
    provincie_gemeenteactueelbestaand p2
ON
    (g2.gemeentecode = p2.gemeentecode);

--
-- EINDE NEVENADRESSEN
--


-- Vul de text vector kolom voor full text search
UPDATE adres set textsearchable_adres = to_tsvector(openbareruimtenaam||' '||huisnummer||' '||trim(coalesce(huisletter,'')||' '||coalesce(huisnummertoevoeging,''))||' '||woonplaatsnaam);

-- Maak indexen aan na inserten (betere performance)
CREATE INDEX adres_geom_idx ON adres USING gist (geopunt);
CREATE INDEX adres_adreseerbaarobject ON adres USING btree (adresseerbaarobject);
CREATE INDEX adres_nummeraanduiding ON adres USING btree (nummeraanduiding);
CREATE INDEX adresvol_idx ON adres USING gin (textsearchable_adres);
