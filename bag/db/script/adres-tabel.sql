-- maak eerst een "echte" adressen tabel
-- want later indexeren kost teveel tijd
DROP TABLE IF EXISTS adres;
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
    typeaddresseerbaarobject character varying(3),
    addresseerbaarobject numeric(16,0),
    nummeraanduiding numeric(16,0),
    geopunt geometry,
    CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992)),

    PRIMARY KEY (gid)
);

CREATE INDEX adres_geom_idx ON adres USING gist (geopunt);

-- Insert data uit combinatie van BAG tabellen: Verblijfplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam,
        provincienaam, typeaddresseerbaarobject, addresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
    'VBO' as typeaddresseerbaarobject,
	v.identificatie as addresseerbaarobject,
	n.identificatie as nummeraanduiding,
	v.geopunt
FROM
	(SELECT identificatie,  geopunt, hoofdadres from verblijfsobjectactueelbestaand) v,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	v.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert data uit combinatie van BAG tabellen : Ligplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeaddresseerbaarobject, addresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
    'LIG' as typeaddresseerbaarobject,
	l.identificatie as addresseerbaarobject,
	n.identificatie as nummeraanduiding,
	ST_Force_3D(ST_Centroid(l.geovlak))  as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from ligplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;

-- Insert data uit combinatie van BAG tabellen : Standplaats
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam,
        gemeentenaam, provincienaam, typeaddresseerbaarobject, addresseerbaarobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
    'STA' as typeaddresseerbaarobject,
	l.identificatie as addresseerbaarobject,
	n.identificatie as nummeraanduiding,
	ST_Force_3D(ST_Centroid(l.geovlak)) as geopunt
FROM
	(SELECT identificatie,  geovlak, hoofdadres from standplaatsactueelbestaand) l,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduidingactueelbestaand) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimteactueelbestaand) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaatsactueel) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	l.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;




