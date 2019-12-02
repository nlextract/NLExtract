--
-- Maakt en vult afgeleide tabel "adres_full" aan met volledige adressen
--
-- De BAG bevat geen echte adressen zoals bijv. ACN (Adres Coordinaten Nederland), dwz
-- een tabel met straat, huisnummer, woonplaats, gemeente, provincie etc.
-- De elementen voor een compleet adres zitten wel in de (verrijkte) BAG.
-- Via SQL scripts hieronder wordt een echte "adres_full" tabel aangemaakt en gevuld
-- uit de BAG basistabellen.
--
-- Auteur: Just van den Broecke
-- Aanvullingen: Michel de Groot
--

-- Maak  een "echte" adressen tabel
DROP TABLE IF EXISTS adres_full CASCADE;
CREATE TABLE adres_full (
  openbareruimtenaam character varying(80),
  huisnummer numeric(5,0),
  huisletter character varying(1),
  huisnummertoevoeging character varying(4),
  postcode character varying(6),
  woonplaatsnaam character varying(80),
  gemeentenaam character varying(80),
  provincienaam character varying(16),
  -- 7311SZ 264 len = 178
  verblijfsobjectgebruiksdoel character varying,
  oppervlakteverblijfsobject numeric(6,0) DEFAULT 0,
  verblijfsobjectstatus character varying,
  typeadresseerbaarobject character varying(3),
  adresseerbaarobject varchar(16),
  pandid varchar(16),
  pandstatus character varying,
  pandbouwjaar numeric(4,0),
  nummeraanduiding varchar(16),
  nevenadres BOOLEAN DEFAULT FALSE,
  geopunt geometry(PointZ, 28992),
  textsearchable_adres tsvector,
  verkorteopenbareruimtenaam character varying(24) DEFAULT NULL
);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, verblijfsobjectgebruiksdoel,
                        oppervlakteverblijfsobject, verblijfsobjectstatus, typeadresseerbaarobject, adresseerbaarobject, pandid, pandstatus, pandbouwjaar, nummeraanduiding, geopunt, verkorteopenbareruimtenaam)
  SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    ARRAY_TO_STRING(ARRAY_AGG(d.gebruiksdoelverblijfsobject ORDER BY gebruiksdoelverblijfsobject), ', ') AS verblijfsobjectgebruiksdoel,
    v.oppervlakteverblijfsobject,
    v.verblijfsobjectstatus,
    'VBO' as typeadresseerbaarobject,
    v.identificatie as adresseerbaarobject,
    pv.identificatie as pandid,
    pv.pandstatus,
    pv.bouwjaar as pandbouwjaar,
    n.identificatie as nummeraanduiding,
    v.geopunt,
    o.verkorteopenbareruimtenaam
  FROM verblijfsobjectactueelbestaand v
    JOIN nummeraanduidingactueelbestaand n
    ON (n.identificatie = v.hoofdadres)
    JOIN verblijfsobjectgebruiksdoelactueelbestaand d
    ON (d.identificatie = v.identificatie)
    LEFT OUTER JOIN verblijfsobjectpandactueel vp
    ON (v.identificatie = vp.identificatie)
    LEFT OUTER JOIN pandactueel pv
    ON (vp.gerelateerdpand = pv.identificatie)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode)
  GROUP BY
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    v.oppervlakteverblijfsobject,
    v.verblijfsobjectstatus,
    typeadresseerbaarobject,
    adresseerbaarobject,
    pandid,
    pv.pandstatus,
    pandbouwjaar,
    nummeraanduiding,
    geopunt,
    o.verkorteopenbareruimtenaam
           ;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject,
                        adresseerbaarobject, pandid, pandstatus, pandbouwjaar, nummeraanduiding, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, geopunt, verkorteopenbareruimtenaam)
  SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    'LIG' as typeadresseerbaarobject,
    l.identificatie as adresseerbaarobject,
    NULL, -- pandid
    '', -- pandstatus
    NULL, -- pandbouwjaar
    n.identificatie as nummeraanduiding,
    'Ligplaats',
    l.ligplaatsstatus,
    -- Vlak geometrie wordt punt
    ST_Force3D(ST_Centroid(l.geovlak))  as geopunt,
    o.verkorteopenbareruimtenaam
  FROM ligplaatsactueelbestaand l
    JOIN nummeraanduidingactueelbestaand n
    ON (n.identificatie = l.hoofdadres)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode);

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject,
                        adresseerbaarobject, pandid, pandstatus, pandbouwjaar, nummeraanduiding, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, geopunt, verkorteopenbareruimtenaam)
  SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    'STA' as typeadresseerbaarobject,
    s.identificatie as adresseerbaarobject,
    NULL, -- pandid
    '', -- pandstatus
    NULL, -- pandbouwjaar
    n.identificatie as nummeraanduiding,
    'Standplaats',
    s.standplaatsstatus,
      -- Vlak geometrie wordt punt
    ST_Force3D(ST_Centroid(s.geovlak)) as geopunt,
    o.verkorteopenbareruimtenaam
  FROM standplaatsactueelbestaand s
    JOIN nummeraanduidingactueelbestaand n
    ON (n.identificatie = s.hoofdadres)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Verblijfplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject, adresseerbaarobject,
                        pandid, pandstatus, pandbouwjaar, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, oppervlakteverblijfsobject, verblijfsobjectstatus, geopunt, verkorteopenbareruimtenaam)
  SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    'VBO' as typeadresseerbaarobject,
    an.identificatie as adresseerbaarobject,
    pv.identificatie as pandid,
    pv.pandstatus,
    pv.bouwjaar as pandbouwjaar,
    n.identificatie as nummeraanduiding,
    TRUE,
    ARRAY_TO_STRING(ARRAY_AGG(d.gebruiksdoelverblijfsobject ORDER BY gebruiksdoelverblijfsobject), ', ') AS verblijfsobjectgebruiksdoel,
    v.oppervlakteverblijfsobject,
    v.verblijfsobjectstatus,
    v.geopunt,
    o.verkorteopenbareruimtenaam
  FROM adresseerbaarobjectnevenadresactueel an
    JOIN nummeraanduidingactueelbestaand n
    ON (an.nevenadres = n.identificatie)
    JOIN verblijfsobjectactueelbestaand v
    ON (an.identificatie = v.identificatie)
    LEFT OUTER JOIN verblijfsobjectgebruiksdoelactueel d
    ON (v.identificatie = d.identificatie)
    LEFT OUTER JOIN verblijfsobjectpandactueel vp
    ON (v.identificatie = vp.identificatie)
    LEFT OUTER JOIN pandactueel pv
    ON (vp.gerelateerdpand = pv.identificatie)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode)
  GROUP BY
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    typeadresseerbaarobject,
    adresseerbaarobject,
    pandid,
    pv.pandstatus,
    pandbouwjaar,
    nummeraanduiding,
    nevenadres,
    v.oppervlakteverblijfsobject,
    v.verblijfsobjectstatus,
    v.geopunt,
    o.verkorteopenbareruimtenaam
           ;

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Ligplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject,
                        adresseerbaarobject, pandid, pandstatus, pandbouwjaar, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, geopunt, verkorteopenbareruimtenaam)
  SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    'LIG' as typeadresseerbaarobject,
    an.identificatie as adresseerbaarobject,
    NULL, -- pandid
    '', -- pandstatus
    NULL, -- pandbouwjaar
    n.identificatie as nummeraanduiding,
    TRUE,
    'Ligplaats',
    l.ligplaatsstatus,
    ST_Force3D(ST_Centroid(l.geovlak))  as geopunt,
    o.verkorteopenbareruimtenaam
  FROM adresseerbaarobjectnevenadresactueel an
    JOIN nummeraanduidingactueelbestaand n
    ON (an.nevenadres = n.identificatie AND n.typeadresseerbaarobject = 'Ligplaats')
    JOIN ligplaatsactueelbestaand l
    ON (an.identificatie = l.identificatie)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode);

-- Insert (actuele+bestaande) data uit combinatie van BAG tabellen: Nevenadressen voor Standplaats
INSERT INTO adres_full (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, typeadresseerbaarobject,
                        adresseerbaarobject, pandid, pandstatus, pandbouwjaar, nummeraanduiding, nevenadres, verblijfsobjectgebruiksdoel, verblijfsobjectstatus, geopunt, verkorteopenbareruimtenaam)
 SELECT
    o.openbareruimtenaam,
    n.huisnummer,
    n.huisletter,
    n.huisnummertoevoeging,
    n.postcode,
    COALESCE(wp2.woonplaatsnaam,w.woonplaatsnaam),
    COALESCE(p2.gemeentenaam,p.gemeentenaam),
    COALESCE(p2.provincienaam,p.provincienaam),
    'STA' as typeadresseerbaarobject,
    an.identificatie as adresseerbaarobject,
    NULL, -- pandid
    '', -- pandstatus
    NULL, -- pandbouwjaar
    n.identificatie as nummeraanduiding,
    TRUE,
    'Standplaats',
    s.standplaatsstatus,
    ST_Force3D(ST_Centroid(s.geovlak)) as geopunt,
    o.verkorteopenbareruimtenaam
  FROM adresseerbaarobjectnevenadresactueel an
    JOIN nummeraanduidingactueelbestaand n
    ON (an.nevenadres = n.identificatie AND n.typeadresseerbaarobject = 'Standplaats')
    JOIN standplaatsactueelbestaand s
    ON (an.identificatie = s.identificatie)
    JOIN openbareruimteactueelbestaand o
    ON (n.gerelateerdeopenbareruimte = o.identificatie)
    JOIN woonplaatsactueelbestaand w
    ON (o.gerelateerdewoonplaats = w.identificatie)
    JOIN gemeente_woonplaatsactueelbestaand g
    ON (g.woonplaatscode = w.identificatie)
    JOIN provincie_gemeenteactueelbestaand p
    ON (g.gemeentecode = p.gemeentecode)
    -- Wanneer nummeraanduiding een gerelateerdewoonplaats heeft moet die gebruikt worden ipv via openbareruimte!
    -- Zie issue: https://github.com/nlextract/NLExtract/issues/54
    LEFT OUTER JOIN woonplaatsactueelbestaand wp2
    ON (n.gerelateerdewoonplaats = wp2.identificatie)
    LEFT OUTER JOIN gemeente_woonplaatsactueelbestaand g2
    ON (g2.woonplaatscode = wp2.identificatie)
    LEFT OUTER JOIN provincie_gemeenteactueelbestaand p2
    ON (g2.gemeentecode = p2.gemeentecode);
-- EINDE NEVENADRESSEN

-- Vul de text vector kolom voor full text search
UPDATE adres_full set textsearchable_adres = to_tsvector(openbareruimtenaam||' '||huisnummer||' '||trim(coalesce(huisletter,'')||' '||coalesce(huisnummertoevoeging,''))||' '||woonplaatsnaam);

-- Maak indexen aan na inserten (betere performance)
CREATE INDEX adres_full_geom_idx ON adres_full USING gist (geopunt);
CREATE INDEX adres_full_adreseerbaarobject ON adres_full USING btree (adresseerbaarobject);
CREATE INDEX adres_full_nummeraanduiding ON adres_full USING btree (nummeraanduiding);
CREATE INDEX adres_full_pandid ON adres_full USING btree (pandid);
CREATE INDEX adres_full_idx ON adres_full USING gin (textsearchable_adres);

-- Populeert public.geometry_columns
-- Dummy voor PostGIS 2+
SELECT public.probe_geometry_columns();

DROP SEQUENCE IF EXISTS adres_full_gid_seq;
CREATE SEQUENCE adres_full_gid_seq;
ALTER TABLE adres_full ADD gid integer UNIQUE;
ALTER TABLE adres_full ALTER COLUMN gid SET DEFAULT NEXTVAL('adres_full_gid_seq');
UPDATE adres_full SET gid = NEXTVAL('adres_full_gid_seq');
ALTER TABLE adres_full ADD PRIMARY KEY (gid);
