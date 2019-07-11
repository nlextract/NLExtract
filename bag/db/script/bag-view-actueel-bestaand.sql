-- Views voor BAG tabellen
-- BAG Objecten kunnen niet-actueel of zelfs niet bestaand (beeindigd) zijn
-- Via Views kunnen actuele en bestaande objecten uitgefilterd worden.

DROP VIEW IF EXISTS ligplaatsactueel;
CREATE VIEW ligplaatsactueel AS
    SELECT ligplaats.gid,
            ligplaats.identificatie,
            ligplaats.aanduidingrecordinactief,
            ligplaats.aanduidingrecordcorrectie,
            ligplaats.officieel,
            ligplaats.inonderzoek,
            ligplaats.documentnummer,
            ligplaats.documentdatum,
            ligplaats.hoofdadres,
            ligplaats.ligplaatsstatus,
            ligplaats.begindatumtijdvakgeldigheid,
            ligplaats.einddatumtijdvakgeldigheid,
            ligplaats.geovlak
    FROM ligplaats
    WHERE
      ligplaats.begindatumtijdvakgeldigheid <= now()
      AND (ligplaats.einddatumtijdvakgeldigheid is NULL OR ligplaats.einddatumtijdvakgeldigheid >= now())
      AND ligplaats.aanduidingrecordinactief = FALSE
      AND ligplaats.geom_valid = TRUE;

DROP VIEW IF EXISTS ligplaatsactueelbestaand;
CREATE VIEW ligplaatsactueelbestaand AS
    SELECT ligplaats.gid,
            ligplaats.identificatie,
            ligplaats.aanduidingrecordinactief,
            ligplaats.aanduidingrecordcorrectie,
            ligplaats.officieel,
            ligplaats.inonderzoek,
            ligplaats.documentnummer,
            ligplaats.documentdatum,
            ligplaats.hoofdadres,
            ligplaats.ligplaatsstatus,
            ligplaats.begindatumtijdvakgeldigheid,
            ligplaats.einddatumtijdvakgeldigheid,
            ligplaats.geovlak
    FROM ligplaats
    WHERE
      ligplaats.begindatumtijdvakgeldigheid <= now()
    AND (ligplaats.einddatumtijdvakgeldigheid is NULL OR ligplaats.einddatumtijdvakgeldigheid >= now())
    AND ligplaats.aanduidingrecordinactief = FALSE
    AND ligplaats.geom_valid = TRUE
    AND ligplaats.ligplaatsstatus <> 'Plaats ingetrokken';

DROP VIEW IF EXISTS nummeraanduidingactueel;
CREATE VIEW nummeraanduidingactueel AS
    SELECT nummeraanduiding.gid,
            nummeraanduiding.identificatie,
            nummeraanduiding.aanduidingrecordinactief,
            nummeraanduiding.aanduidingrecordcorrectie,
            nummeraanduiding.officieel,
            nummeraanduiding.inonderzoek,
            nummeraanduiding.documentnummer,
            nummeraanduiding.documentdatum,
            nummeraanduiding.huisnummer,
            nummeraanduiding.huisletter,
            nummeraanduiding.huisnummertoevoeging,
            nummeraanduiding.postcode,
            nummeraanduiding.nummeraanduidingstatus,
            nummeraanduiding.typeadresseerbaarobject,
            nummeraanduiding.gerelateerdeopenbareruimte,
            nummeraanduiding.gerelateerdewoonplaats,
            nummeraanduiding.begindatumtijdvakgeldigheid,
            nummeraanduiding.einddatumtijdvakgeldigheid
    FROM nummeraanduiding
    WHERE
      nummeraanduiding.begindatumtijdvakgeldigheid <= now()
      AND (nummeraanduiding.einddatumtijdvakgeldigheid is NULL OR nummeraanduiding.einddatumtijdvakgeldigheid >= now())
      AND nummeraanduiding.aanduidingrecordinactief = FALSE
      AND nummeraanduiding.postcode is NOT NULL;

DROP VIEW IF EXISTS nummeraanduidingactueelbestaand;
CREATE VIEW nummeraanduidingactueelbestaand AS
    SELECT nummeraanduiding.gid,
            nummeraanduiding.identificatie,
            nummeraanduiding.aanduidingrecordinactief,
            nummeraanduiding.aanduidingrecordcorrectie,
            nummeraanduiding.officieel,
            nummeraanduiding.inonderzoek,
            nummeraanduiding.documentnummer,
            nummeraanduiding.documentdatum,
            nummeraanduiding.huisnummer,
            nummeraanduiding.huisletter,
            nummeraanduiding.huisnummertoevoeging,
            nummeraanduiding.postcode,
            nummeraanduiding.nummeraanduidingstatus,
            nummeraanduiding.typeadresseerbaarobject,
            nummeraanduiding.gerelateerdeopenbareruimte,
            nummeraanduiding.gerelateerdewoonplaats,
            nummeraanduiding.begindatumtijdvakgeldigheid,
            nummeraanduiding.einddatumtijdvakgeldigheid
  FROM nummeraanduiding
  WHERE
    nummeraanduiding.begindatumtijdvakgeldigheid <= now()
    AND (nummeraanduiding.einddatumtijdvakgeldigheid is NULL OR nummeraanduiding.einddatumtijdvakgeldigheid >= now())
    AND nummeraanduiding.aanduidingrecordinactief = FALSE
    AND nummeraanduiding.postcode is NOT NULL
    AND nummeraanduiding.nummeraanduidingstatus <> 'Naamgeving ingetrokken';

DROP VIEW IF EXISTS openbareruimteactueel;

CREATE VIEW openbareruimteactueel AS
    SELECT openbareruimte.gid,
            openbareruimte.identificatie,
            openbareruimte.aanduidingrecordinactief,
            openbareruimte.aanduidingrecordcorrectie,
            openbareruimte.officieel,
            openbareruimte.inonderzoek,
            openbareruimte.documentnummer,
            openbareruimte.documentdatum,
            openbareruimte.openbareruimtenaam,
            openbareruimte.openbareruimtestatus,
            openbareruimte.openbareruimtetype,
            openbareruimte.gerelateerdewoonplaats,
            openbareruimte.verkorteopenbareruimtenaam,
            openbareruimte.begindatumtijdvakgeldigheid,
            openbareruimte.einddatumtijdvakgeldigheid
  FROM openbareruimte
  WHERE
    openbareruimte.begindatumtijdvakgeldigheid <= now()
    AND (openbareruimte.einddatumtijdvakgeldigheid is NULL OR openbareruimte.einddatumtijdvakgeldigheid >= now())
    AND openbareruimte.aanduidingrecordinactief = FALSE;

DROP VIEW IF EXISTS openbareruimteactueelbestaand;
CREATE VIEW openbareruimteactueelbestaand AS
    SELECT openbareruimte.gid,
            openbareruimte.identificatie,
            openbareruimte.aanduidingrecordinactief,
            openbareruimte.aanduidingrecordcorrectie,
            openbareruimte.officieel,
            openbareruimte.inonderzoek,
            openbareruimte.documentnummer,
            openbareruimte.documentdatum,
            openbareruimte.openbareruimtenaam,
            openbareruimte.openbareruimtestatus,
            openbareruimte.openbareruimtetype,
            openbareruimte.gerelateerdewoonplaats,
            openbareruimte.verkorteopenbareruimtenaam,
            openbareruimte.begindatumtijdvakgeldigheid,
            openbareruimte.einddatumtijdvakgeldigheid
  FROM openbareruimte
  WHERE
    openbareruimte.begindatumtijdvakgeldigheid <= now()
    AND (openbareruimte.einddatumtijdvakgeldigheid is NULL OR openbareruimte.einddatumtijdvakgeldigheid >= now())
    AND openbareruimte.aanduidingrecordinactief = FALSE
    AND openbareruimte.openbareruimtestatus <> 'Naamgeving ingetrokken';

DROP VIEW IF EXISTS pandactueel;
CREATE VIEW pandactueel AS
    SELECT  pand.gid,
            pand.identificatie,
            pand.aanduidingrecordinactief,
            pand.aanduidingrecordcorrectie,
            pand.officieel,
            pand.inonderzoek,
            pand.documentnummer,
            pand.documentdatum,
            pand.pandstatus,
            pand.bouwjaar,
            pand.begindatumtijdvakgeldigheid,
            pand.einddatumtijdvakgeldigheid,
            pand.geovlak
    FROM pand
    WHERE
      pand.begindatumtijdvakgeldigheid <= now()
      AND (pand.einddatumtijdvakgeldigheid is NULL OR pand.einddatumtijdvakgeldigheid >= now())
      AND pand.aanduidingrecordinactief = FALSE
      AND pand.geom_valid = TRUE;

DROP VIEW IF EXISTS pandactueelbestaand;
CREATE VIEW pandactueelbestaand AS
    SELECT  pand.gid,
            pand.identificatie,
            pand.aanduidingrecordinactief,
            pand.aanduidingrecordcorrectie,
            pand.officieel,
            pand.inonderzoek,
            pand.documentnummer,
            pand.documentdatum,
            pand.pandstatus,
            pand.bouwjaar,
            pand.begindatumtijdvakgeldigheid,
            pand.einddatumtijdvakgeldigheid,
            pand.geovlak
  FROM pand
   WHERE
     pand.begindatumtijdvakgeldigheid <= now()
     AND (pand.einddatumtijdvakgeldigheid is NULL OR pand.einddatumtijdvakgeldigheid >= now())
     AND pand.aanduidingrecordinactief = FALSE
     AND pand.geom_valid = TRUE
     AND (pand.pandstatus <> 'Niet gerealiseerd pand' 
       AND pand.pandstatus <> 'Pand gesloopt'
       AND pand.pandstatus <> 'Bouwvergunning verleend');

DROP VIEW IF EXISTS standplaatsactueel;
CREATE VIEW standplaatsactueel AS
    SELECT standplaats.gid,
            standplaats.identificatie,
            standplaats.aanduidingrecordinactief,
            standplaats.aanduidingrecordcorrectie,
            standplaats.officieel,
            standplaats.inonderzoek,
            standplaats.documentnummer,
            standplaats.documentdatum,
            standplaats.hoofdadres,
            standplaats.standplaatsstatus,
            standplaats.begindatumtijdvakgeldigheid,
            standplaats.einddatumtijdvakgeldigheid,
            standplaats.geovlak
  FROM standplaats
  WHERE
    standplaats.begindatumtijdvakgeldigheid <= now()
    AND (standplaats.einddatumtijdvakgeldigheid is NULL OR standplaats.einddatumtijdvakgeldigheid >= now())
    AND standplaats.aanduidingrecordinactief = FALSE
    AND standplaats.geom_valid = TRUE
;

DROP VIEW IF EXISTS standplaatsactueelbestaand;
CREATE VIEW standplaatsactueelbestaand AS
    SELECT standplaats.gid,
            standplaats.identificatie,
            standplaats.aanduidingrecordinactief,
            standplaats.aanduidingrecordcorrectie,
            standplaats.officieel,
            standplaats.inonderzoek,
            standplaats.documentnummer,
            standplaats.documentdatum,
            standplaats.hoofdadres,
            standplaats.standplaatsstatus,
            standplaats.begindatumtijdvakgeldigheid,
            standplaats.einddatumtijdvakgeldigheid,
            standplaats.geovlak
  FROM standplaats
  WHERE
    standplaats.begindatumtijdvakgeldigheid <= now()
    AND (standplaats.einddatumtijdvakgeldigheid is NULL OR standplaats.einddatumtijdvakgeldigheid >= now())
    AND standplaats.aanduidingrecordinactief = FALSE
    AND standplaats.geom_valid = TRUE
    AND standplaats.standplaatsstatus <> 'Plaats ingetrokken';


DROP VIEW IF EXISTS verblijfsobjectactueel;
CREATE VIEW verblijfsobjectactueel AS
    SELECT verblijfsobject.gid,
            verblijfsobject.identificatie,
            verblijfsobject.aanduidingrecordinactief,
            verblijfsobject.aanduidingrecordcorrectie,
            verblijfsobject.officieel,
            verblijfsobject.inonderzoek,
            verblijfsobject.documentnummer,
            verblijfsobject.documentdatum,
            verblijfsobject.hoofdadres,
            verblijfsobject.verblijfsobjectstatus,
            verblijfsobject.oppervlakteverblijfsobject,
            verblijfsobject.begindatumtijdvakgeldigheid,
            verblijfsobject.einddatumtijdvakgeldigheid,
            verblijfsobject.geopunt,
            verblijfsobject.geovlak
    FROM verblijfsobject
  WHERE
    verblijfsobject.begindatumtijdvakgeldigheid <= now()
    AND (verblijfsobject.einddatumtijdvakgeldigheid is NULL OR verblijfsobject.einddatumtijdvakgeldigheid >= now())
    AND verblijfsobject.aanduidingrecordinactief = FALSE
    AND (verblijfsobject.geom_valid is NULL OR verblijfsobject.geom_valid = TRUE);


DROP VIEW IF EXISTS verblijfsobjectactueelbestaand;
CREATE VIEW verblijfsobjectactueelbestaand AS
    SELECT verblijfsobject.gid,
            verblijfsobject.identificatie,
            verblijfsobject.aanduidingrecordinactief,
            verblijfsobject.aanduidingrecordcorrectie,
            verblijfsobject.officieel,
            verblijfsobject.inonderzoek,
            verblijfsobject.documentnummer,
            verblijfsobject.documentdatum,
            verblijfsobject.hoofdadres,
            verblijfsobject.verblijfsobjectstatus,
            verblijfsobject.oppervlakteverblijfsobject,
            verblijfsobject.begindatumtijdvakgeldigheid,
            verblijfsobject.einddatumtijdvakgeldigheid,
            verblijfsobject.geopunt,
            verblijfsobject.geovlak
    FROM verblijfsobject
    WHERE
      verblijfsobject.begindatumtijdvakgeldigheid <= now()
      AND (verblijfsobject.einddatumtijdvakgeldigheid is NULL OR verblijfsobject.einddatumtijdvakgeldigheid >= now())
      AND verblijfsobject.aanduidingrecordinactief = FALSE
      AND (verblijfsobject.geom_valid is NULL OR verblijfsobject.geom_valid = TRUE)
      AND (verblijfsobject.verblijfsobjectstatus <> 'Niet gerealiseerd verblijfsobject'
        AND verblijfsobject.verblijfsobjectstatus  <> 'Verblijfsobject ingetrokken');

-- JvdB removed AND verblijfsobject.verblijfsobjectstatus  <> 'Verblijfsobject gevormd', see issue #173
-- https://github.com/nlextract/NLExtract/issues/173  23.3.16
--

DROP VIEW IF EXISTS woonplaatsactueel;
CREATE VIEW woonplaatsactueel AS
    SELECT woonplaats.gid,
            woonplaats.identificatie,
            woonplaats.aanduidingrecordinactief,
            woonplaats.aanduidingrecordcorrectie,
            woonplaats.officieel,
            woonplaats.inonderzoek,
            woonplaats.documentnummer,
            woonplaats.documentdatum,
            woonplaats.woonplaatsnaam,
            woonplaats.woonplaatsstatus,
            woonplaats.begindatumtijdvakgeldigheid,
            woonplaats.einddatumtijdvakgeldigheid,
            woonplaats.geovlak
    FROM woonplaats
  WHERE
    woonplaats.begindatumtijdvakgeldigheid <= now()
    AND (woonplaats.einddatumtijdvakgeldigheid is NULL OR woonplaats.einddatumtijdvakgeldigheid >= now())
    AND woonplaats.aanduidingrecordinactief = FALSE
    AND woonplaats.geom_valid = TRUE;

DROP VIEW IF EXISTS woonplaatsactueelbestaand;
CREATE VIEW woonplaatsactueelbestaand AS
    SELECT woonplaats.gid,
            woonplaats.identificatie,
            woonplaats.aanduidingrecordinactief,
            woonplaats.aanduidingrecordcorrectie,
            woonplaats.officieel,
            woonplaats.inonderzoek,
            woonplaats.documentnummer,
            woonplaats.documentdatum,
            woonplaats.woonplaatsnaam,
            woonplaats.woonplaatsstatus,
            woonplaats.begindatumtijdvakgeldigheid,
            woonplaats.einddatumtijdvakgeldigheid,
            woonplaats.geovlak
    FROM woonplaats
  WHERE
    woonplaats.begindatumtijdvakgeldigheid <= now()
    AND (woonplaats.einddatumtijdvakgeldigheid is NULL OR woonplaats.einddatumtijdvakgeldigheid >= now())
    AND woonplaats.aanduidingrecordinactief = FALSE
    AND woonplaats.geom_valid = TRUE
    AND woonplaats.woonplaatsstatus  <> 'Woonplaats ingetrokken';

DROP VIEW IF EXISTS verblijfsobjectpandactueel;
CREATE VIEW verblijfsobjectpandactueel AS
    SELECT vbop.gid,
            vbop.identificatie,
            vbop.aanduidingrecordinactief,
            vbop.aanduidingrecordcorrectie,
            vbop.begindatumtijdvakgeldigheid,
            vbop.einddatumtijdvakgeldigheid,
            vbop.gerelateerdpand,
            vbop.verblijfsobjectstatus,
            vbop.geom_valid
    FROM verblijfsobjectpand as vbop
  WHERE
    vbop.begindatumtijdvakgeldigheid <= now()
    AND (vbop.einddatumtijdvakgeldigheid is NULL OR vbop.einddatumtijdvakgeldigheid >= now())
    AND vbop.aanduidingrecordinactief = FALSE
    AND (vbop.geom_valid is NULL OR vbop.geom_valid = TRUE);

DROP VIEW IF EXISTS verblijfsobjectpandactueelbestaand;
CREATE VIEW verblijfsobjectpandactueelbestaand AS
    SELECT vbop.gid,
            vbop.identificatie,
            vbop.aanduidingrecordinactief,
            vbop.aanduidingrecordcorrectie,
            vbop.begindatumtijdvakgeldigheid,
            vbop.einddatumtijdvakgeldigheid,
            vbop.gerelateerdpand,
            vbop.verblijfsobjectstatus,
            vbop.geom_valid
    FROM verblijfsobjectpand as vbop
  WHERE
    vbop.begindatumtijdvakgeldigheid <= now()
    AND (vbop.einddatumtijdvakgeldigheid is NULL OR vbop.einddatumtijdvakgeldigheid >= now())
    AND vbop.aanduidingrecordinactief = FALSE
    AND (vbop.geom_valid is NULL OR vbop.geom_valid = TRUE)
    AND ((vbop.verblijfsobjectstatus <> 'Niet gerealiseerd verblijfsobject' AND
          vbop.verblijfsobjectstatus <> 'Verblijfsobject ingetrokken') OR
         vbop.verblijfsobjectstatus is NULL);

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueel;
CREATE VIEW adresseerbaarobjectnevenadresactueel AS
    SELECT aon.gid,
            aon.identificatie,
            aon.aanduidingrecordinactief,
            aon.aanduidingrecordcorrectie,
            aon.begindatumtijdvakgeldigheid,
            aon.einddatumtijdvakgeldigheid,
            aon.nevenadres,
            aon.ligplaatsstatus,
            aon.standplaatsstatus,
            aon.verblijfsobjectstatus,
            aon.geom_valid
    FROM adresseerbaarobjectnevenadres as aon
  WHERE
    aon.begindatumtijdvakgeldigheid <= now()
    AND (aon.einddatumtijdvakgeldigheid is NULL OR aon.einddatumtijdvakgeldigheid >= now())
    AND aon.aanduidingrecordinactief = FALSE
    AND (aon.geom_valid is NULL OR aon.geom_valid = TRUE);

DROP VIEW IF EXISTS adresseerbaarobjectnevenadresactueelbestaand;
CREATE VIEW adresseerbaarobjectnevenadresactueelbestaand AS
    SELECT aon.gid,
            aon.identificatie,
            aon.aanduidingrecordinactief,
            aon.aanduidingrecordcorrectie,
            aon.begindatumtijdvakgeldigheid,
            aon.einddatumtijdvakgeldigheid,
            aon.nevenadres,
            aon.ligplaatsstatus,
            aon.standplaatsstatus,
            aon.verblijfsobjectstatus,
            aon.geom_valid
    FROM adresseerbaarobjectnevenadres as aon
  WHERE
    aon.begindatumtijdvakgeldigheid <= now()
    AND (aon.einddatumtijdvakgeldigheid is NULL OR aon.einddatumtijdvakgeldigheid >= now())
    AND aon.aanduidingrecordinactief = FALSE
    AND (aon.geom_valid is NULL OR aon.geom_valid = TRUE)
    AND ((aon.ligplaatsstatus <> 'Plaats ingetrokken' OR aon.ligplaatsstatus is NULL) AND
         (aon.standplaatsstatus <> 'Plaats ingetrokken' OR aon.standplaatsstatus is NULL) AND
         ((aon.verblijfsobjectstatus <> 'Niet gerealiseerd verblijfsobject' AND
           aon.verblijfsobjectstatus <> 'Verblijfsobject ingetrokken') OR
          aon.verblijfsobjectstatus is NULL));

DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueel;
CREATE VIEW verblijfsobjectgebruiksdoelactueel AS
    SELECT vog.gid,
            vog.identificatie,
            vog.aanduidingrecordinactief,
            vog.aanduidingrecordcorrectie,
            vog.begindatumtijdvakgeldigheid,
            vog.einddatumtijdvakgeldigheid,
            vog.gebruiksdoelverblijfsobject,
            vog.verblijfsobjectstatus,
            vog.geom_valid
    FROM verblijfsobjectgebruiksdoel as vog
  WHERE
    vog.begindatumtijdvakgeldigheid <= now()
    AND (vog.einddatumtijdvakgeldigheid is NULL OR vog.einddatumtijdvakgeldigheid >= now())
    AND vog.aanduidingrecordinactief = FALSE
    AND (vog.geom_valid is NULL OR vog.geom_valid = TRUE);

DROP VIEW IF EXISTS verblijfsobjectgebruiksdoelactueelbestaand;
CREATE VIEW verblijfsobjectgebruiksdoelactueelbestaand AS
    SELECT vog.gid,
            vog.identificatie,
            vog.aanduidingrecordinactief,
            vog.aanduidingrecordcorrectie,
            vog.begindatumtijdvakgeldigheid,
            vog.einddatumtijdvakgeldigheid,
            vog.gebruiksdoelverblijfsobject,
            vog.verblijfsobjectstatus,
            vog.geom_valid
    FROM verblijfsobjectgebruiksdoel as vog
  WHERE
    vog.begindatumtijdvakgeldigheid <= now()
    AND (vog.einddatumtijdvakgeldigheid is NULL OR vog.einddatumtijdvakgeldigheid >= now())
    AND vog.aanduidingrecordinactief = FALSE
    AND (vog.geom_valid is NULL OR vog.geom_valid = TRUE)
    AND ((vog.verblijfsobjectstatus <> 'Niet gerealiseerd verblijfsobject' AND
          vog.verblijfsobjectstatus <> 'Verblijfsobject ingetrokken') OR
         vog.verblijfsobjectstatus is NULL);

DROP VIEW IF EXISTS gemeente_woonplaatsactueelbestaand;
CREATE VIEW gemeente_woonplaatsactueelbestaand AS
    SELECT  gw.gid,
            gw.begindatumtijdvakgeldigheid,
            gw.einddatumtijdvakgeldigheid,
            gw.woonplaatscode,
            gw.gemeentecode,
            gw.status
    FROM gemeente_woonplaats as gw
  WHERE
    gw.begindatumtijdvakgeldigheid <= now()
    AND (gw.einddatumtijdvakgeldigheid is NULL OR gw.einddatumtijdvakgeldigheid >= now())
    AND gw.status = 'definitief';

DROP VIEW IF EXISTS provincie_gemeenteactueelbestaand;
CREATE VIEW provincie_gemeenteactueelbestaand AS
    SELECT  pg.gid,
            pg.provinciecode,
            pg.provincienaam,
            pg.gemeentecode,
            pg.gemeentenaam,
            pg.begindatum,
            pg.einddatum
    FROM provincie_gemeente AS pg
  WHERE
    pg.begindatum <= now()
    AND (pg.einddatum IS NULL OR pg.einddatum >= now());

----------------------------------------------------------------------------------
-- Extra definitie voor GeoServer om om te gaan met VIEWs
----------------------------------------------------------------------------------
-- http://getsatisfaction.com/opengeo/topics/postgis_index_in_opengeo

-- Table: gt_pk_metadata

DROP TABLE IF EXISTS gt_pk_metadata;

CREATE TABLE gt_pk_metadata
(
  table_schema character varying(32) NOT NULL,
  table_name character varying(32) NOT NULL,
  pk_column character varying(32) NOT NULL,
  pk_column_idx integer,
  pk_policy character varying(32),
  pk_sequence character varying(64),
  CONSTRAINT gt_pk_metadata_table_schema_key UNIQUE (table_schema, table_name, pk_column),
  CONSTRAINT gt_pk_metadata_pk_policy_check CHECK (pk_policy::text = ANY (ARRAY['sequence'::character varying::text, 'assigned'::character varying::text, 'autoincrement'::character varying::text]))
);

--NOTICE:  CREATE TABLE / UNIQUE will create implicit index "gt_pk_metadata_table_schema_key" for table "gt_pk_metadata"
--Vraag succesvol terug met leeg resultaat in 31 ms.

-- Insert record in view hulp tabel (example)
-- Naam schema waar view aanwezig is
-- Naam view
-- Naam primary key in the tabel
INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'ligplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'ligplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'standplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'standplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'verblijfplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'verblijfplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'woonplaatsactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'woonplaatsactueelbestaand', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'pandactueel', 'gid', null, null, null);

INSERT INTO gt_pk_metadata(table_schema, table_name, pk_column, pk_column_idx, pk_policy, pk_sequence)
VALUES (current_schema(), 'pandactueelbestaand', 'gid', null, null, null);
