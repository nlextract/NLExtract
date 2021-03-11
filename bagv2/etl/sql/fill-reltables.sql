-- Fills the (Legacy) relation tables and nevenadres.
-- This is to remain compatible with BAG v1.
--
-- Just van den Broecke 2021
--

-- N-M relation VBO-PND
INSERT INTO verblijfsobjectpand (
     identificatie, aanduidingRecordInactief, tijdstipinactief,
     begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
     verblijfsobjectStatus,gerelateerdpand)
  SELECT
    vbo.identificatie,
    vbo.aanduidingRecordInactief,
    vbo.tijdstipinactief,
    vbo.begindatumTijdvakGeldigheid,
    vbo.einddatumTijdvakGeldigheid,
    vbo.verblijfsobjectStatus,
    vbo.gerelateerdpand
FROM
    (SELECT
        identificatie,
        aanduidingRecordInactief,
        tijdstipinactief,
        begindatumTijdvakGeldigheid,
        einddatumTijdvakGeldigheid,
        verblijfsobjectStatus,
        UNNEST(gerelateerdepanden) as gerelateerdpand
    FROM verblijfsobject) vbo;

-- Multiple VBO gebruiksdoelen.
INSERT INTO verblijfsobjectgebruiksdoel (
     identificatie, aanduidingRecordInactief, tijdstipinactief,
     begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
     verblijfsobjectStatus, gebruiksdoelverblijfsobject)
  SELECT
    vbo.identificatie,
    vbo.aanduidingRecordInactief,
    vbo.tijdstipinactief,
    vbo.begindatumTijdvakGeldigheid,
    vbo.einddatumTijdvakGeldigheid,
    vbo.verblijfsobjectStatus,
    vbo.gebruiksdoelverblijfsobject
FROM
    (SELECT
        identificatie,
        aanduidingRecordInactief,
        tijdstipinactief,
        begindatumTijdvakGeldigheid,
        einddatumTijdvakGeldigheid,
        verblijfsobjectStatus,
        UNNEST(gebruiksdoelverblijfsobject)::gebruiksdoelverblijfsobject as gebruiksdoelverblijfsobject
    FROM verblijfsobject) vbo;

-- Vul adresseerbaarobjectnevenadres uit VBO
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, aanduidingRecordInactief, nevenadres, hoofdadres, typeadresseerbaarobject, verblijfsobjectStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    vbo.identificatie,
    vbo.aanduidingRecordInactief,
    vbo.nevenadres,
    vbo.hoofdadres as hoofdadres,
    'VBO' as typeadresseerbaarobject,
    vbo.verblijfsobjectStatus,

    vbo.geconstateerd,
    vbo.documentdatum,
    vbo.documentnummer,
    vbo.voorkomenidentificatie,
    vbo.begindatumTijdvakGeldigheid,
    vbo.einddatumTijdvakGeldigheid,
    vbo.tijdstipregistratie,
    vbo.eindregistratie,
    vbo.tijdstipinactief,
    vbo.tijdstipregistratielv,
    vbo.tijdstipeindregistratielv,
    vbo.tijdstipinactieflv,
    vbo.tijdstipnietbaglv,
         
    vbo.geopunt
FROM
    (SELECT
        identificatie,
        aanduidingRecordInactief,
        hoofdadres,
        UNNEST(nevenadressen) as nevenadres,
        verblijfsobjectStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, geopunt
    FROM  verblijfsobject) vbo
WHERE nevenadres IS NOT NULL;

-- Vul adresseerbaarobjectnevenadres uit LIG
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, aanduidingRecordInactief, nevenadres, hoofdadres, typeadresseerbaarobject, ligplaatsStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    lig.identificatie,
    lig.aanduidingRecordInactief,
    lig.nevenadres,
    lig.hoofdadres as hoofdadres,
    'LIG' as typeadresseerbaarobject,
    lig.ligplaatsStatus,

    lig.geconstateerd,
    lig.documentdatum,
    lig.documentnummer,
    lig.voorkomenidentificatie,
    lig.begindatumTijdvakGeldigheid,
    lig.einddatumTijdvakGeldigheid,
    lig.tijdstipregistratie,
    lig.eindregistratie,
    lig.tijdstipinactief,
    lig.tijdstipregistratielv,
    lig.tijdstipeindregistratielv,
    lig.tijdstipinactieflv,
    lig.tijdstipnietbaglv,

    ST_Centroid(lig.geovlak) as geopunt
  FROM
    (SELECT
        identificatie,
        aanduidingRecordInactief,
        hoofdadres,
        UNNEST(nevenadressen) as nevenadres,
        ligplaatsStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, geovlak
    FROM  ligplaats) lig
WHERE nevenadres IS NOT NULL;


-- Vul adresseerbaarobjectnevenadres uit STA
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, aanduidingRecordInactief, nevenadres, hoofdadres, typeadresseerbaarobject, standplaatsStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    sta.identificatie,
    sta.aanduidingRecordInactief,
    sta.nevenadres,
    sta.hoofdadres as hoofdadres,
    'STA' as typeadresseerbaarobject,
    sta.standplaatsStatus,

    sta.geconstateerd,
    sta.documentdatum,
    sta.documentnummer,
    sta.voorkomenidentificatie,
    sta.begindatumTijdvakGeldigheid,
    sta.einddatumTijdvakGeldigheid,
    sta.tijdstipregistratie,
    sta.eindregistratie,
    sta.tijdstipinactief,
    sta.tijdstipregistratielv,
    sta.tijdstipeindregistratielv,
    sta.tijdstipinactieflv,
    sta.tijdstipnietbaglv,

    ST_Centroid(sta.geovlak) as geopunt
  FROM
    (SELECT
        identificatie,
        aanduidingRecordInactief,
        hoofdadres,
        UNNEST(nevenadressen) as nevenadres,
        standplaatsStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, geovlak
    FROM  standplaats) sta
WHERE nevenadres IS NOT NULL;

-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, begindatumTijdvakGeldigheid, einddatumTijdvakGeldigheid from adresseerbaarobjectnevenadres;

