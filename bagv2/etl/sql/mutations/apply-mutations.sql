/*
Apply mutation tables to the final BAG tables.

For each table, the INSERT comes before the UPDATE,
because there might be changes to additions.

Peter Saalbrink, 2022
*/

-- ligplaats
WITH mutaties_ligplaats_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_ligplaats
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO ligplaats (
    identificatie,
    ligplaatsstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    hoofdadres,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    nevenadressen,
    geovlak
)
SELECT
    mut.identificatie,
    mut.status,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.hoofdadresnummeraanduidingref,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.nevenadresnummeraanduidingref,
    mut.wkb_geometry
FROM mutaties_ligplaats_tmp mut
ON CONFLICT ON CONSTRAINT ligplaats_unique
DO UPDATE SET
    hoofdadres                  = EXCLUDED.hoofdadres,
    nevenadressen               = EXCLUDED.nevenadressen,
    ligplaatsstatus             = EXCLUDED.ligplaatsstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    geovlak                     = EXCLUDED.geovlak;

-- nummeraanduiding
WITH mutaties_nummeraanduiding_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_nummeraanduiding
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO nummeraanduiding (
    identificatie,
    huisnummer,
    huisletter,
    huisnummertoevoeging,
    postcode,
    typeadresseerbaarobject,
    nummeraanduidingstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    gerelateerdewoonplaats,
    gerelateerdeopenbareruimte
)
SELECT
    mut.identificatie,
    mut.huisnummer,
    mut.huisletter,
    mut.huisnummertoevoeging,
    mut.postcode,
    mut.typeadresseerbaarobject,
    mut.status,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.woonplaatsref,
    mut.openbareruimteref
FROM mutaties_nummeraanduiding_tmp mut
ON CONFLICT ON CONSTRAINT nummeraanduiding_unique
DO UPDATE SET
    huisnummer                  = EXCLUDED.huisnummer,
    huisletter                  = EXCLUDED.huisletter,
    huisnummertoevoeging        = EXCLUDED.huisnummertoevoeging,
    postcode                    = EXCLUDED.postcode,
    typeadresseerbaarobject     = EXCLUDED.typeadresseerbaarobject,
    nummeraanduidingstatus      = EXCLUDED.nummeraanduidingstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    gerelateerdewoonplaats      = EXCLUDED.gerelateerdewoonplaats,
    gerelateerdeopenbareruimte  = EXCLUDED.gerelateerdeopenbareruimte;

-- openbareruimte
WITH mutaties_openbareruimte_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_openbareruimte
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO openbareruimte (
    identificatie,
    openbareruimtenaam,
    openbareruimtetype,
    openbareruimtestatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    gerelateerdewoonplaats,
    verkorteopenbareruimtenaam
)
SELECT
    mut.identificatie,
    mut.naam,
    mut.type,
    mut.status::text::openbareruimtestatus,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.woonplaatsref,
    mut.verkortenaam
FROM mutaties_openbareruimte_tmp mut
ON CONFLICT ON CONSTRAINT openbareruimte_unique
DO UPDATE SET
    openbareruimtenaam          = EXCLUDED.openbareruimtenaam,
    openbareruimtetype          = EXCLUDED.openbareruimtetype,
    openbareruimtestatus        = EXCLUDED.openbareruimtestatus::text::openbareruimtestatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    gerelateerdewoonplaats      = EXCLUDED.gerelateerdewoonplaats,
    verkorteopenbareruimtenaam  = EXCLUDED.verkorteopenbareruimtenaam;

-- pand
WITH mutaties_pand_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_pand
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO pand (
    identificatie,
    bouwjaar,
    pandstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    geovlak
)
SELECT
    mut.identificatie,
    mut.oorspronkelijkbouwjaar,
    mut.status,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.wkb_geometry
FROM mutaties_pand_tmp mut
ON CONFLICT ON CONSTRAINT pand_unique
DO UPDATE SET
    bouwjaar                    = EXCLUDED.bouwjaar,
    pandstatus                  = EXCLUDED.pandstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    geovlak                     = EXCLUDED.geovlak;

-- standplaats
WITH mutaties_standplaats_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_standplaats
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO standplaats (
    identificatie,
    standplaatsstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    hoofdadres,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    nevenadressen,
    geovlak
)
SELECT
    mut.identificatie,
    mut.status::text::standplaatsstatus,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.hoofdadresnummeraanduidingref,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.nevenadresnummeraanduidingref,
    mut.wkb_geometry
FROM mutaties_standplaats_tmp mut
ON CONFLICT ON CONSTRAINT standplaats_unique
DO UPDATE SET
    standplaatsstatus           = EXCLUDED.standplaatsstatus::text::standplaatsstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    hoofdadres                  = EXCLUDED.hoofdadres,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    nevenadressen               = EXCLUDED.nevenadressen,
    geovlak                     = EXCLUDED.geovlak;

-- verblijfsobject
WITH mutaties_verblijfsobject_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_verblijfsobject
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO verblijfsobject (
    identificatie,
    gebruiksdoelverblijfsobject,
    oppervlakteverblijfsobject,
    verblijfsobjectstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    gerelateerdepanden,
    hoofdadres,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    nevenadressen,
    geopunt
)
SELECT
    mut.identificatie,
    mut.gebruiksdoel,
    mut.oppervlakte,
    mut.status,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.pandref,
    mut.hoofdadresnummeraanduidingref,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.nevenadresnummeraanduidingref,
    mut.wkb_geometry
FROM mutaties_verblijfsobject_tmp mut
ON CONFLICT ON CONSTRAINT verblijfsobject_unique
DO UPDATE SET
    gebruiksdoelverblijfsobject = EXCLUDED.gebruiksdoelverblijfsobject,
    oppervlakteverblijfsobject  = EXCLUDED.oppervlakteverblijfsobject,
    verblijfsobjectstatus       = EXCLUDED.verblijfsobjectstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    gerelateerdepanden          = EXCLUDED.gerelateerdepanden,
    hoofdadres                  = EXCLUDED.hoofdadres,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    nevenadressen               = EXCLUDED.nevenadressen,
    geopunt                     = EXCLUDED.geopunt;

-- woonplaats
WITH mutaties_woonplaats_tmp AS (
    SELECT DISTINCT ON (identificatie, voorkomenidentificatie) *
    FROM mutaties_woonplaats
    ORDER BY identificatie,
             voorkomenidentificatie,
             begingeldigheid DESC,
             eindgeldigheid DESC NULLS LAST,
             tijdstipregistratielv DESC NULLS LAST,
             tijdstipnietbaglv DESC NULLS LAST
)
INSERT INTO woonplaats (
    identificatie,
    woonplaatsnaam,
    woonplaatsstatus,
    geconstateerd,
    documentdatum,
    documentnummer,
    voorkomenidentificatie,
    begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid,
    tijdstipregistratie,
    eindregistratie,
    tijdstipinactief,
    tijdstipregistratielv,
    tijdstipeindregistratielv,
    tijdstipinactieflv,
    tijdstipnietbaglv,
    geovlak
)
SELECT
    mut.identificatie,
    mut.naam,
    mut.status,
    mut.geconstateerd,
    mut.documentdatum,
    mut.documentnummer,
    mut.voorkomenidentificatie,
    mut.begingeldigheid,
    mut.eindgeldigheid,
    mut.tijdstipregistratie,
    mut.eindregistratie,
    mut.tijdstipinactief,
    mut.tijdstipregistratielv,
    mut.tijdstipeindregistratielv,
    mut.tijdstipinactieflv,
    mut.tijdstipnietbaglv,
    mut.wkb_geometry
FROM mutaties_woonplaats_tmp mut
ON CONFLICT ON CONSTRAINT woonplaats_unique
DO UPDATE SET
    woonplaatsnaam              = EXCLUDED.woonplaatsnaam,
    woonplaatsstatus            = EXCLUDED.woonplaatsstatus,
    geconstateerd               = EXCLUDED.geconstateerd,
    documentdatum               = EXCLUDED.documentdatum,
    documentnummer              = EXCLUDED.documentnummer,
    begindatumtijdvakgeldigheid = EXCLUDED.begindatumtijdvakgeldigheid,
    einddatumtijdvakgeldigheid  = EXCLUDED.einddatumtijdvakgeldigheid,
    tijdstipregistratie         = EXCLUDED.tijdstipregistratie,
    eindregistratie             = EXCLUDED.eindregistratie,
    tijdstipinactief            = EXCLUDED.tijdstipinactief,
    tijdstipregistratielv       = EXCLUDED.tijdstipregistratielv,
    tijdstipeindregistratielv   = EXCLUDED.tijdstipeindregistratielv,
    tijdstipinactieflv          = EXCLUDED.tijdstipinactieflv,
    tijdstipnietbaglv           = EXCLUDED.tijdstipnietbaglv,
    geovlak                     = EXCLUDED.geovlak;
