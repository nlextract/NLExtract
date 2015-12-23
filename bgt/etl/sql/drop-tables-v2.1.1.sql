-- Auteur: Frank Steggink
-- Doel: script om BGT / IMGeo tabellen te verwijderen.
-- Zowel de originele als de opgesplitste tabellen worden hiermee verwijderd.

SET search_path={schema},public;

DROP TABLE IF EXISTS    bak;
DROP TABLE IF EXISTS    bak_2d;
DROP TABLE IF EXISTS    bak_lod0;

DROP TABLE IF EXISTS    begroeidterreindeel;
DROP TABLE IF EXISTS    begroeidterreindeel_2d;
DROP TABLE IF EXISTS    begroeidterreindeel_kruinlijn;
DROP TABLE IF EXISTS    begroeidterreindeel_lod0;

DROP TABLE IF EXISTS    bord;
DROP TABLE IF EXISTS    bord_2d;
DROP TABLE IF EXISTS    bord_lod0;

DROP TABLE IF EXISTS    buurt;
DROP TABLE IF EXISTS    buurt_2d;
DROP TABLE IF EXISTS    buurt_lod0;

DROP TABLE IF EXISTS    functioneelgebied;
DROP TABLE IF EXISTS    functioneelgebied_2d;
DROP TABLE IF EXISTS    functioneelgebied_lod0;

DROP TABLE IF EXISTS    gebouwinstallatie;
DROP TABLE IF EXISTS    gebouwinstallatie_2d;
DROP TABLE IF EXISTS    gebouwinstallatie_lod0;

DROP TABLE IF EXISTS    installatie;
DROP TABLE IF EXISTS    installatie_2d;
DROP TABLE IF EXISTS    installatie_lod0;

DROP TABLE IF EXISTS    kast;
DROP TABLE IF EXISTS    kast_2d;
DROP TABLE IF EXISTS    kast_lod0;

DROP TABLE IF EXISTS    kunstwerkdeel;
DROP TABLE IF EXISTS    kunstwerkdeel_2d;
DROP TABLE IF EXISTS    kunstwerkdeel_lod0;

DROP TABLE IF EXISTS    mast;
DROP TABLE IF EXISTS    mast_2d;
DROP TABLE IF EXISTS    mast_lod0;

DROP TABLE IF EXISTS    nummeraanduidingreeks;

DROP TABLE IF EXISTS    onbegroeidterreindeel;
DROP TABLE IF EXISTS    onbegroeidterreindeel_2d;
DROP TABLE IF EXISTS    onbegroeidterreindeel_kruinlijn;
DROP TABLE IF EXISTS    onbegroeidterreindeel_lod0;

DROP TABLE IF EXISTS    ondersteunendwaterdeel;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_2d;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_lod0;

DROP TABLE IF EXISTS    ondersteunendwegdeel;
DROP TABLE IF EXISTS    ondersteunendwegdeel_2d;
DROP TABLE IF EXISTS    ondersteunendwegdeel_kruinlijn;
DROP TABLE IF EXISTS    ondersteunendwegdeel_lod0;

DROP TABLE IF EXISTS    ongeclassificeerdobject;
DROP TABLE IF EXISTS    ongeclassificeerdobject_2d;
DROP TABLE IF EXISTS    ongeclassificeerdobject_lod0;

DROP TABLE IF EXISTS    openbareruimte;
DROP TABLE IF EXISTS    openbareruimte_2d;
DROP TABLE IF EXISTS    openbareruimte_lod0;

DROP TABLE IF EXISTS    openbareruimtelabel;

DROP TABLE IF EXISTS    overbruggingsdeel;
DROP TABLE IF EXISTS    overbruggingsdeel_2d;
DROP TABLE IF EXISTS    overbruggingsdeel_lod0;

DROP TABLE IF EXISTS    overigbouwwerk;
DROP TABLE IF EXISTS    overigbouwwerk_2d;
DROP TABLE IF EXISTS    overigbouwwerk_lod0;

DROP TABLE IF EXISTS    overigeconstructie;
DROP TABLE IF EXISTS    overigeconstructie_2d;
DROP TABLE IF EXISTS    overigeconstructie_lod0;

DROP TABLE IF EXISTS    overigescheiding;
DROP TABLE IF EXISTS    overigescheiding_2d;
DROP TABLE IF EXISTS    overigescheiding_lod0;

DROP TABLE IF EXISTS    paal;
DROP TABLE IF EXISTS    paal_2d;
DROP TABLE IF EXISTS    paal_lod0;

DROP TABLE IF EXISTS    pand;
DROP TABLE IF EXISTS    pand_2d;
DROP TABLE IF EXISTS    pand_lod0;

DROP TABLE IF EXISTS    plaatsbepalingspunt;

DROP TABLE IF EXISTS    put;
DROP TABLE IF EXISTS    put_2d;
DROP TABLE IF EXISTS    put_lod0;

DROP TABLE IF EXISTS    scheiding;
DROP TABLE IF EXISTS    scheiding_2d;
DROP TABLE IF EXISTS    scheiding_lod0;

DROP TABLE IF EXISTS    sensor;
DROP TABLE IF EXISTS    sensor_2d;
DROP TABLE IF EXISTS    sensor_lod0;

DROP TABLE IF EXISTS    spoor;
DROP TABLE IF EXISTS    spoor_2d;
DROP TABLE IF EXISTS    spoor_lod0;

DROP TABLE IF EXISTS    stadsdeel;
DROP TABLE IF EXISTS    stadsdeel_2d;
DROP TABLE IF EXISTS    stadsdeel_lod0;

DROP TABLE IF EXISTS    straatmeubilair;
DROP TABLE IF EXISTS    straatmeubilair_2d;
DROP TABLE IF EXISTS    straatmeubilair_lod0;

DROP TABLE IF EXISTS    tunneldeel;
DROP TABLE IF EXISTS    tunneldeel_2d;
DROP TABLE IF EXISTS    tunneldeel_lod0;

DROP TABLE IF EXISTS    vegetatieobject;
DROP TABLE IF EXISTS    vegetatieobject_2d;
DROP TABLE IF EXISTS    vegetatieobject_lod0;

DROP TABLE IF EXISTS    waterdeel;
DROP TABLE IF EXISTS    waterdeel_2d;
DROP TABLE IF EXISTS    waterdeel_lod0;

DROP TABLE IF EXISTS    waterinrichtingselement;
DROP TABLE IF EXISTS    waterinrichtingselement_2d;
DROP TABLE IF EXISTS    waterinrichtingselement_lod0;

DROP TABLE IF EXISTS    waterschap;
DROP TABLE IF EXISTS    waterschap_2d;
DROP TABLE IF EXISTS    waterschap_lod0;

DROP TABLE IF EXISTS    wegdeel;
DROP TABLE IF EXISTS    wegdeel_2d;
DROP TABLE IF EXISTS    wegdeel_kruinlijn;
DROP TABLE IF EXISTS    wegdeel_lod0;

DROP TABLE IF EXISTS    weginrichtingselement;
DROP TABLE IF EXISTS    weginrichtingselement_2d;
DROP TABLE IF EXISTS    weginrichtingselement_lod0;

DROP TABLE IF EXISTS    wijk;
DROP TABLE IF EXISTS    wijk_2d;
DROP TABLE IF EXISTS    wijk_lod0;

SET search_path="$user",public;
