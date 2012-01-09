-- maak eerst een "echte" adressen tabel
-- want later indexeren kost teveel tijd
DROP TABLE IF EXISTS adres;
CREATE TABLE adres (
    id serial,
    openbareruimtenaam character varying(80),
    huisnummer character varying(5),
    huisletter character varying(5),
    huisnummertoevoeging character varying(4),
    postcode character varying(6),
    woonplaatsnaam character varying(80),
    gemeentenaam character varying(80),
    provincienaam character varying(80),

    verblijfsobject character varying(16),
    nummeraanduiding character varying(16),
    geopunt geometry,
    CONSTRAINT enforce_dims_punt CHECK ((st_ndims(geopunt) = 3)),
    CONSTRAINT enforce_geotype_punt CHECK (((geometrytype(geopunt) = 'POINT'::text) OR (geopunt IS NULL))),
    CONSTRAINT enforce_srid_punt CHECK ((st_srid(geopunt) = 28992)),

    PRIMARY KEY (id)
);


CREATE INDEX adres_geom_idx ON adres USING gist (geopunt);

-- Insert data uit combinatie van BAG tabellen
INSERT INTO adres (openbareruimtenaam, huisnummer, huisletter, huisnummertoevoeging, postcode, woonplaatsnaam, gemeentenaam, provincienaam, verblijfsobject, nummeraanduiding, geopunt)
  SELECT
	o.openbareruimtenaam,
	n.huisnummer,
	n.huisletter,
	n.huisnummertoevoeging,
	n.postcode,
	w.woonplaatsnaam,
	g.gemeentenaam,
	p.provincienaam,
	v.identificatie as verblijfsobject,
	n.identificatie as nummeraanduiding,
	v.geopunt
FROM
	(SELECT identificatie,  geopunt, hoofdadres from verblijfsobject where aanduidingrecordinactief = 'N' and einddatum is null) v,
	(SELECT identificatie,  huisnummer, huisletter, huisnummertoevoeging, postcode, gerelateerdeopenbareruimte from nummeraanduiding where aanduidingrecordinactief = 'N' and einddatum is null) n,
	(SELECT identificatie,  openbareruimtenaam, gerelateerdewoonplaats from openbareruimte where aanduidingrecordinactief = 'N' and einddatum is null) o,
	(SELECT identificatie,  woonplaatsnaam from woonplaats where aanduidingrecordinactief = 'N' and einddatum is null) w,
	(SELECT woonplaatscode, gemeentenaam, gemeentecode from gemeente_woonplaats where einddatum_gemeente is null AND einddatum_woonplaats is null) g,
	(SELECT gemeentecode,   provincienaam from gemeente_provincie) p
WHERE
	v.hoofdadres = n.identificatie
	and n.gerelateerdeopenbareruimte = o.identificatie
	and o.gerelateerdewoonplaats = w.identificatie
	and w.identificatie = g.woonplaatscode
	and g.gemeentecode = p.gemeentecode;




