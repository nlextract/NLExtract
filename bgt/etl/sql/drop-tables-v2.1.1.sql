-- Auteur: Frank Steggink
-- Doel: script om BGT / IMGeo tabellen te verwijderen. De definitieve tabellen worden niet nu al verwijderd, maar pas
-- bij het uitvoeren van create-final-tables, zodat de oude data nog aanwezig blijft i.g.v. een calamiteit. Eventueel
-- kunnen ze vooraf apart worden verwijderd door het uitvoeren van het script drop-final-tables.

SET search_path={schema},public;

DROP TABLE IF EXISTS    bak_2d CASCADE;
DROP TABLE IF EXISTS    bak_2d_tmp CASCADE;
DROP TABLE IF EXISTS    bak_lod0 CASCADE;
DROP TABLE IF EXISTS    bak_tmp CASCADE;

DROP TABLE IF EXISTS    begroeidterreindeel_2d CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_lod0 CASCADE;
DROP TABLE IF EXISTS    begroeidterreindeel_tmp CASCADE;

DROP TABLE IF EXISTS    bord_2d CASCADE;
DROP TABLE IF EXISTS    bord_2d_tmp CASCADE;
DROP TABLE IF EXISTS    bord_lod0 CASCADE;
DROP TABLE IF EXISTS    bord_tmp CASCADE;

DROP TABLE IF EXISTS    buurt_2d CASCADE;
DROP TABLE IF EXISTS    buurt_2d_tmp CASCADE;
DROP TABLE IF EXISTS    buurt_lod0 CASCADE;
DROP TABLE IF EXISTS    buurt_tmp CASCADE;

DROP TABLE IF EXISTS    functioneelgebied_2d CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_2d_tmp CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_lod0 CASCADE;
DROP TABLE IF EXISTS    functioneelgebied_tmp CASCADE;

DROP TABLE IF EXISTS    gebouwinstallatie_2d CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_2d_tmp CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_lod0 CASCADE;
DROP TABLE IF EXISTS    gebouwinstallatie_tmp CASCADE;

DROP TABLE IF EXISTS    installatie_2d CASCADE;
DROP TABLE IF EXISTS    installatie_2d_tmp CASCADE;
DROP TABLE IF EXISTS    installatie_lod0 CASCADE;
DROP TABLE IF EXISTS    installatie_tmp CASCADE;

DROP TABLE IF EXISTS    kast_2d CASCADE;
DROP TABLE IF EXISTS    kast_2d_tmp CASCADE;
DROP TABLE IF EXISTS    kast_lod0 CASCADE;
DROP TABLE IF EXISTS    kast_tmp CASCADE;

DROP TABLE IF EXISTS    kunstwerkdeel_2d CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    kunstwerkdeel_tmp CASCADE;

DROP TABLE IF EXISTS    mast_2d CASCADE;
DROP TABLE IF EXISTS    mast_2d_tmp CASCADE;
DROP TABLE IF EXISTS    mast_lod0 CASCADE;
DROP TABLE IF EXISTS    mast_tmp CASCADE;

DROP TABLE IF EXISTS    nummeraanduidingreeks CASCADE;

DROP TABLE IF EXISTS    onbegroeidterreindeel_2d CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_lod0 CASCADE;
DROP TABLE IF EXISTS    onbegroeidterreindeel_tmp CASCADE;

DROP TABLE IF EXISTS    ondersteunendwaterdeel_2d CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    ondersteunendwaterdeel_tmp CASCADE;

DROP TABLE IF EXISTS    ondersteunendwegdeel_2d CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    ondersteunendwegdeel_tmp CASCADE;

DROP TABLE IF EXISTS    ongeclassificeerdobject_2d CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_2d_tmp CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_lod0 CASCADE;
DROP TABLE IF EXISTS    ongeclassificeerdobject_tmp CASCADE;

DROP TABLE IF EXISTS    openbareruimte_2d CASCADE;
DROP TABLE IF EXISTS    openbareruimte_2d_tmp CASCADE;
DROP TABLE IF EXISTS    openbareruimte_lod0 CASCADE;
DROP TABLE IF EXISTS    openbareruimte_tmp CASCADE;

DROP TABLE IF EXISTS    openbareruimtelabel_tmp CASCADE;

DROP TABLE IF EXISTS    overbruggingsdeel_2d CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    overbruggingsdeel_tmp CASCADE;

DROP TABLE IF EXISTS    overigbouwwerk_2d CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_lod0 CASCADE;
DROP TABLE IF EXISTS    overigbouwwerk_tmp CASCADE;

DROP TABLE IF EXISTS    overigescheiding_2d CASCADE;
DROP TABLE IF EXISTS    overigescheiding_2d_tmp CASCADE;
DROP TABLE IF EXISTS    overigescheiding_lod0 CASCADE;
DROP TABLE IF EXISTS    overigescheiding_tmp CASCADE;

DROP TABLE IF EXISTS    paal_2d CASCADE;
DROP TABLE IF EXISTS    paal_2d_tmp CASCADE;
DROP TABLE IF EXISTS    paal_lod0 CASCADE;
DROP TABLE IF EXISTS    paal_tmp CASCADE;

DROP TABLE IF EXISTS    pand_2d CASCADE;
DROP TABLE IF EXISTS    pand_2d_tmp CASCADE;
DROP TABLE IF EXISTS    pand_lod0 CASCADE;
DROP TABLE IF EXISTS    pand_tmp CASCADE;

DROP TABLE IF EXISTS    plaatsbepalingspunt_tmp CASCADE;

DROP TABLE IF EXISTS    put_2d CASCADE;
DROP TABLE IF EXISTS    put_2d_tmp CASCADE;
DROP TABLE IF EXISTS    put_lod0 CASCADE;
DROP TABLE IF EXISTS    put_tmp CASCADE;

DROP TABLE IF EXISTS    scheiding_2d CASCADE;
DROP TABLE IF EXISTS    scheiding_2d_tmp CASCADE;
DROP TABLE IF EXISTS    scheiding_lod0 CASCADE;
DROP TABLE IF EXISTS    scheiding_tmp CASCADE;

DROP TABLE IF EXISTS    sensor_2d CASCADE;
DROP TABLE IF EXISTS    sensor_2d_tmp CASCADE;
DROP TABLE IF EXISTS    sensor_lod0 CASCADE;
DROP TABLE IF EXISTS    sensor_tmp CASCADE;

DROP TABLE IF EXISTS    spoor_2d CASCADE;
DROP TABLE IF EXISTS    spoor_2d_tmp CASCADE;
DROP TABLE IF EXISTS    spoor_lod0 CASCADE;
DROP TABLE IF EXISTS    spoor_tmp CASCADE;

DROP TABLE IF EXISTS    stadsdeel_2d CASCADE;
DROP TABLE IF EXISTS    stadsdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    stadsdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    stadsdeel_tmp CASCADE;

DROP TABLE IF EXISTS    straatmeubilair_2d CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_2d_tmp CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_lod0 CASCADE;
DROP TABLE IF EXISTS    straatmeubilair_tmp CASCADE;

DROP TABLE IF EXISTS    tunneldeel_2d CASCADE;
DROP TABLE IF EXISTS    tunneldeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    tunneldeel_lod0 CASCADE;
DROP TABLE IF EXISTS    tunneldeel_tmp CASCADE;

DROP TABLE IF EXISTS    vegetatieobject_2d CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_2d_tmp CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_lod0 CASCADE;
DROP TABLE IF EXISTS    vegetatieobject_tmp CASCADE;

DROP TABLE IF EXISTS    waterdeel_2d CASCADE;
DROP TABLE IF EXISTS    waterdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    waterdeel_tmp CASCADE;

DROP TABLE IF EXISTS    waterinrichtingselement_2d CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_lod0 CASCADE;
DROP TABLE IF EXISTS    waterinrichtingselement_tmp CASCADE;

DROP TABLE IF EXISTS    waterschap_2d CASCADE;
DROP TABLE IF EXISTS    waterschap_2d_tmp CASCADE;
DROP TABLE IF EXISTS    waterschap_lod0 CASCADE;
DROP TABLE IF EXISTS    waterschap_tmp CASCADE;

DROP TABLE IF EXISTS    wegdeel_2d CASCADE;
DROP TABLE IF EXISTS    wegdeel_2d_tmp CASCADE;
DROP TABLE IF EXISTS    wegdeel_kruinlijn CASCADE;
DROP TABLE IF EXISTS    wegdeel_kruinlijn_tmp CASCADE;
DROP TABLE IF EXISTS    wegdeel_lod0 CASCADE;
DROP TABLE IF EXISTS    wegdeel_tmp CASCADE;

DROP TABLE IF EXISTS    weginrichtingselement_2d CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_2d_tmp CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_lod0 CASCADE;
DROP TABLE IF EXISTS    weginrichtingselement_tmp CASCADE;

DROP TABLE IF EXISTS    wijk_2d CASCADE;
DROP TABLE IF EXISTS    wijk_2d_tmp CASCADE;
DROP TABLE IF EXISTS    wijk_lod0 CASCADE;
DROP TABLE IF EXISTS    wijk_tmp CASCADE;

SET search_path="$user",public;
