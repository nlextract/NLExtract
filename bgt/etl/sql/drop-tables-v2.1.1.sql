-- Auteur: Frank Steggink
-- Doel: script om BGT / IMGeo tabellen te verwijderen.
-- Zowel de originele als de opgesplitste tabellen worden hiermee verwijderd.

SET search_path={schema},public;

DROP TABLE IF EXISTS    bak CASCADE;
DROP TABLE IF EXISTS    bak_2d CASCADE;
DROP TABLE IF EXISTS    bak_2d_tmp CASCADE;
DROP TABLE IF EXISTS    bak_lod0 CASCADE;

DROP TABLE IF EXISTS    begroeidterreindeel CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_2d CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_lod0 CASCADE;

DROP TABLE IF EXISTS    bord CASCADE;
DROP TABLE IF EXISTS    bord_2d CASCADE;
DROP TABLE IF EXISTS    bord_2d_tmp CASCADE;
DROP TABLE IF EXISTS    bord_lod0 CASCADE;

DROP TABLE IF EXISTS    buurt CASCADE;
DROP TABLE IF EXISTS    buurt_2d CASCADE;
DROP TABLE IF EXISTS    buurt_2d_tmp CASCADE;
DROP TABLE IF EXISTS    buurt_lod0 CASCADE;

DROP TABLE IF EXISTS    functioneelgebied CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_2d CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_2d_tmp CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_lod0 CASCADE;

DROP TABLE IF EXISTS    gebouwinstallatie CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_2d CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_2d_tmp CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_lod0 CASCADE;

DROP TABLE IF EXISTS    installatie CASCADE;
DROP TABLE IF EXISTS    installatie_2d CASCADE;
DROP TABLE IF EXISTS    installatie_2d_tmp CASCADE;
DROP TABLE IF EXISTS    installatie_lod0 CASCADE;

DROP TABLE IF EXISTS    kast CASCADE;
DROP TABLE IF EXISTS    kast_2d CASCADE;
DROP TABLE IF EXISTS    kast_2d_tmp CASCADE;
DROP TABLE IF EXISTS    kast_lod0 CASCADE;

DROP TABLE IF EXISTS    kunstwerkdeel CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_2d CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    mast CASCADE;
DROP TABLE IF EXISTS    mast_2d CASCADE;
DROP TABLE IF EXISTS    mast_2d_tmp CASCADE;
DROP TABLE IF EXISTS    mast_lod0 CASCADE;

DROP TABLE IF EXISTS    nummeraanduidingreeks CASCADE;

DROP TABLE IF EXISTS    onbegroeidterreindeel CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_2d CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_lod0 CASCADE;

DROP TABLE IF EXISTS    ondersteunendwaterdeel CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_2d CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    ondersteunendwegdeel CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_2d CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    ongeclassificeerdobject CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_2d CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_lod0 CASCADE;

DROP TABLE IF EXISTS    openbareruimte CASCADE;
DROP TABLE IF EXISTS    openbareruimte_2d CASCADE;
DROP TABLE IF EXISTS    openbareruimte_2d_tmp CASCADE;
DROP TABLE IF EXISTS    openbareruimte_lod0 CASCADE;

DROP TABLE IF EXISTS    openbareruimtelabel CASCADE;
DROP TABLE IF EXISTS    openbareruimtelabel_tmp CASCADE;

DROP TABLE IF EXISTS    overbruggingsdeel CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_2d CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    overigbouwwerk CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_2d CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_lod0 CASCADE;

DROP TABLE IF EXISTS    overigeconstructie CASCADE;
DROP TABLE IF EXISTS    overigeconstructie_2d CASCADE;
DROP TABLE IF EXISTS    overigeconstructie_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overigeconstructie_lod0 CASCADE;

DROP TABLE IF EXISTS    overigescheiding CASCADE;
DROP TABLE IF EXISTS    overigescheiding_2d CASCADE;
DROP TABLE IF EXISTS    overigescheiding_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overigescheiding_lod0 CASCADE;

DROP TABLE IF EXISTS    paal CASCADE;
DROP TABLE IF EXISTS    paal_2d CASCADE;
DROP TABLE IF EXISTS    paal_2d_tmp CASCADE;
DROP TABLE IF EXISTS    paal_lod0 CASCADE;

DROP TABLE IF EXISTS    pand CASCADE;
DROP TABLE IF EXISTS    pand_2d CASCADE;
DROP TABLE IF EXISTS    pand_2d_tmp CASCADE;
DROP TABLE IF EXISTS    pand_lod0 CASCADE;

DROP TABLE IF EXISTS    plaatsbepalingspunt CASCADE;
DROP TABLE IF EXISTS    plaatsbepalingspunt_tmp CASCADE;

DROP TABLE IF EXISTS    put CASCADE;
DROP TABLE IF EXISTS    put_2d CASCADE;
DROP TABLE IF EXISTS    put_2d_tmp CASCADE;
DROP TABLE IF EXISTS    put_lod0 CASCADE;

DROP TABLE IF EXISTS    scheiding CASCADE;
DROP TABLE IF EXISTS    scheiding_2d CASCADE;
DROP TABLE IF EXISTS    scheiding_2d_tmp CASCADE;
DROP TABLE IF EXISTS    scheiding_lod0 CASCADE;

DROP TABLE IF EXISTS    sensor CASCADE;
DROP TABLE IF EXISTS    sensor_2d CASCADE;
DROP TABLE IF EXISTS    sensor_2d_tmp CASCADE;
DROP TABLE IF EXISTS    sensor_lod0 CASCADE;

DROP TABLE IF EXISTS    spoor CASCADE;
DROP TABLE IF EXISTS    spoor_2d CASCADE;
DROP TABLE IF EXISTS    spoor_2d_tmp CASCADE;
DROP TABLE IF EXISTS    spoor_lod0 CASCADE;

DROP TABLE IF EXISTS    stadsdeel CASCADE;
DROP TABLE IF EXISTS    stadsdeel_2d CASCADE;
DROP TABLE IF EXISTS    stadsdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    stadsdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    straatmeubilair CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_2d CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_2d_tmp CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_lod0 CASCADE;

DROP TABLE IF EXISTS    tunneldeel CASCADE;
DROP TABLE IF EXISTS    tunneldeel_2d CASCADE;
DROP TABLE IF EXISTS    tunneldeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    tunneldeel_lod0 CASCADE;

DROP TABLE IF EXISTS    vegetatieobject CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_2d CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_2d_tmp CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_lod0 CASCADE;

DROP TABLE IF EXISTS    waterdeel CASCADE;
DROP TABLE IF EXISTS    waterdeel_2d CASCADE;
DROP TABLE IF EXISTS    waterdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    waterinrichtingselement CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_2d CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_lod0 CASCADE;

DROP TABLE IF EXISTS    waterschap CASCADE;
DROP TABLE IF EXISTS    waterschap_2d CASCADE;
DROP TABLE IF EXISTS    waterschap_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterschap_lod0 CASCADE;

DROP TABLE IF EXISTS    wegdeel CASCADE;
DROP TABLE IF EXISTS    wegdeel_2d CASCADE;
DROP TABLE IF EXISTS    wegdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    wegdeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    wegdeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    wegdeel_lod0 CASCADE;

DROP TABLE IF EXISTS    weginrichtingselement CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_2d CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_2d_tmp CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_lod0 CASCADE;

DROP TABLE IF EXISTS    wijk CASCADE;
DROP TABLE IF EXISTS    wijk_2d CASCADE;
DROP TABLE IF EXISTS    wijk_2d_tmp CASCADE;
DROP TABLE IF EXISTS    wijk_lod0 CASCADE;

SET search_path="$user",public;
