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
      ligplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
      AND (ligplaats.einddatumtijdvakgeldigheid is NULL OR ligplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
      AND ligplaats.aanduidingrecordinactief = FALSE;

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
      ligplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (ligplaats.einddatumtijdvakgeldigheid is NULL OR ligplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND ligplaats.aanduidingrecordinactief = FALSE
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
      nummeraanduiding.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
      AND (nummeraanduiding.einddatumtijdvakgeldigheid is NULL OR nummeraanduiding.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
      AND nummeraanduiding.aanduidingrecordinactief = FALSE;

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
    nummeraanduiding.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (nummeraanduiding.einddatumtijdvakgeldigheid is NULL OR nummeraanduiding.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND nummeraanduiding.aanduidingrecordinactief = FALSE
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
    openbareruimte.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (openbareruimte.einddatumtijdvakgeldigheid is NULL OR openbareruimte.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
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
    openbareruimte.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (openbareruimte.einddatumtijdvakgeldigheid is NULL OR openbareruimte.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
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
      pand.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
      AND (pand.einddatumtijdvakgeldigheid is NULL OR pand.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
      AND pand.aanduidingrecordinactief = FALSE;

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
     pand.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
     AND (pand.einddatumtijdvakgeldigheid is NULL OR pand.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
     AND pand.aanduidingrecordinactief = FALSE
     AND (pand.pandstatus <> 'Niet gerealiseerd pand' AND pand.pandstatus  <> 'Pand gesloopt' );

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
    standplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (standplaats.einddatumtijdvakgeldigheid is NULL OR standplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND standplaats.aanduidingrecordinactief = FALSE;

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
    standplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (standplaats.einddatumtijdvakgeldigheid is NULL OR standplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND standplaats.aanduidingrecordinactief = FALSE
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
            verblijfsobject.geopunt
    FROM verblijfsobject
  WHERE
    verblijfsobject.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (verblijfsobject.einddatumtijdvakgeldigheid is NULL OR verblijfsobject.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND verblijfsobject.aanduidingrecordinactief = FALSE;


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
            verblijfsobject.geopunt
    FROM verblijfsobject
    WHERE
      verblijfsobject.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
      AND (verblijfsobject.einddatumtijdvakgeldigheid is NULL OR verblijfsobject.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
      AND verblijfsobject.aanduidingrecordinactief = FALSE
      AND (verblijfsobject.verblijfsobjectstatus <> 'Niet gerealiseerd verblijfsobject'
      AND verblijfsobject.verblijfsobjectstatus  <> 'Verblijfsobject ingetrokken' );

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
    woonplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (woonplaats.einddatumtijdvakgeldigheid is NULL OR woonplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND woonplaats.aanduidingrecordinactief = FALSE;

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
    woonplaats.begindatumtijdvakgeldigheid <= LOCALTIMESTAMP
    AND (woonplaats.einddatumtijdvakgeldigheid is NULL OR woonplaats.einddatumtijdvakgeldigheid >= LOCALTIMESTAMP)
    AND woonplaats.aanduidingrecordinactief = FALSE
    AND woonplaats.woonplaatsstatus  <> 'Woonplaats ingetrokken';


