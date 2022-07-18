-- Fills the (Legacy) relation tables and nevenadres.
-- This is to remain compatible with BAG v1.
--
-- Just van den Broecke 2021
--

-- N-M relation VBO-PND
INSERT INTO verblijfsobjectpand (
     identificatie, tijdstipinactief,
     voorkomenidentificatie, begingeldigheid, eindgeldigheid,
     verblijfsobjectStatus,gerelateerdpand)
  SELECT
    vbo.identificatie,
    vbo.tijdstipinactief,
    vbo.voorkomenidentificatie,
    vbo.begingeldigheid,
    vbo.eindgeldigheid,
    vbo.verblijfsobjectStatus,
    vbo.gerelateerdpand
FROM
    (SELECT
        identificatie,
        tijdstipinactief,
        voorkomenidentificatie,
        begingeldigheid,
        eindgeldigheid,
        status::verblijfsobjectStatus AS verblijfsobjectStatus,
        UNNEST(pandref) as gerelateerdpand
    FROM verblijfsobject) vbo;

-- Multiple VBO gebruiksdoelen.
INSERT INTO verblijfsobjectgebruiksdoel (
     identificatie, tijdstipinactief,
     voorkomenidentificatie, begingeldigheid, eindgeldigheid,
     verblijfsobjectStatus, gebruiksdoelverblijfsobject)
  SELECT
    vbo.identificatie,
    vbo.tijdstipinactief,
    vbo.voorkomenidentificatie,
    vbo.begingeldigheid,
    vbo.eindgeldigheid,
    vbo.verblijfsobjectStatus,
    vbo.gebruiksdoelverblijfsobject
FROM
    (SELECT
        identificatie,
        tijdstipinactief,
        voorkomenidentificatie,
        begingeldigheid,
        eindgeldigheid,
        status::verblijfsobjectStatus AS verblijfsobjectStatus,
        UNNEST(gebruiksdoel)::gebruiksdoelverblijfsobject as gebruiksdoelverblijfsobject
    FROM verblijfsobject) vbo;

-- Vul adresseerbaarobjectnevenadres uit VBO
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, nevenadres, hoofdadres, typeadresseerbaarobject, verblijfsobjectStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    vbo.identificatie,
    vbo.nevenadres,
    vbo.hoofdadres as hoofdadres,
    'VBO' as typeadresseerbaarobject,
    vbo.verblijfsobjectStatus,

    vbo.geconstateerd,
    vbo.documentdatum,
    vbo.documentnummer,
    vbo.voorkomenidentificatie,
    vbo.begingeldigheid,
    vbo.eindgeldigheid,
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
        hoofdadresnummeraanduidingref AS hoofdadres,
        UNNEST(nevenadresnummeraanduidingref) as nevenadres,
        status::verblijfsobjectStatus AS verblijfsobjectStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, wkb_geometry AS geopunt
    FROM  verblijfsobject) vbo
WHERE nevenadres IS NOT NULL;

-- Vul adresseerbaarobjectnevenadres uit LIG
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, nevenadres, hoofdadres, typeadresseerbaarobject, ligplaatsStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    lig.identificatie,
    lig.nevenadres,
    lig.hoofdadres as hoofdadres,
    'LIG' as typeadresseerbaarobject,
    lig.ligplaatsStatus,

    lig.geconstateerd,
    lig.documentdatum,
    lig.documentnummer,
    lig.voorkomenidentificatie,
    lig.begingeldigheid,
    lig.eindgeldigheid,
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
        hoofdadresnummeraanduidingref AS hoofdadres,
        UNNEST(nevenadresnummeraanduidingref) as nevenadres,
        status::ligplaatsStatus AS ligplaatsStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, geovlak
    FROM  ligplaats) lig
WHERE nevenadres IS NOT NULL;


-- Vul adresseerbaarobjectnevenadres uit STA
-- Let op de ARRAY UNNEST om nevenadressen uit te splitsen naar rows.
INSERT INTO adresseerbaarobjectnevenadres (
     identificatie, nevenadres, hoofdadres, typeadresseerbaarobject, standplaatsStatus,
     geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
     tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
     tijdstipinactieflv, tijdstipnietbaglv, geopunt)
  SELECT
    sta.identificatie,
    sta.nevenadres,
    sta.hoofdadres as hoofdadres,
    'STA' as typeadresseerbaarobject,
    sta.standplaatsStatus,

    sta.geconstateerd,
    sta.documentdatum,
    sta.documentnummer,
    sta.voorkomenidentificatie,
    sta.begingeldigheid,
    sta.eindgeldigheid,
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
        hoofdadresnummeraanduidingref AS hoofdadres,
        UNNEST(nevenadresnummeraanduidingref) as nevenadres,
        status::standplaatsStatus AS standplaatsStatus,
        geconstateerd, documentdatum, documentnummer, voorkomenidentificatie, begingeldigheid, eindgeldigheid,
        tijdstipregistratie, eindregistratie, tijdstipinactief, tijdstipregistratielv, tijdstipeindregistratielv,
        tijdstipinactieflv, tijdstipnietbaglv, geovlak
    FROM  standplaats) sta
WHERE nevenadres IS NOT NULL;

-- select identificatie, nevenadres, hoofdadres,typeadresseerbaarobject, begingeldigheid, eindgeldigheid from adresseerbaarobjectnevenadres;

