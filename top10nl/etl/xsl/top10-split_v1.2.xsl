<?xml version="1.0" encoding="UTF-8"?>

<!--
Voorbewerking Top10NL GML Objecten

Auteur: Just van den Broecke

Aangepast voor Top10NL versie 1.1.1 en 1.2 door Frank Steggink

Dit XSLT script doet een voorbewerking op de ruwe Top10NL GML zoals door Het Kadaster
geleverd. Dit is nodig omdat GDAL ogr2ogr niet alle mogelijkheden van GML goed aankan
en omdat met ingang van versie 1.2 de plaats van de geometrie in een feature is gewijzigd.

Voornamelijk gaat het om meerdere geometrie-attributen per Top10 Object. Het interne
GDAL model kent maar 1 geometrie per feature. Daarnaast is het bij visualiseren bijv.
met SLDs voor een WMS vaak het handigst om 1 geometrie per laag te hebben. Dit geldt ook
als we bijvoorbeeld een OGR conversie naar ESRI Shapefile willen doen met ogr2ogr.

Dit script splitst objecten uit Top10NL uit in geometrie-specifieke objecten.
Bijvoorbeeld een weg (objecttype Wegdeel) heeft twee geometrie-attributen. Het attribuut
hoofdGeometrie kan weer een vlak, lijn of punt bevatten en het attribuut hartGeometrie kan
een lijn of punt bevatten. Na uitsplitsen ontstaan max. 5 verschillende objecttypen, namelijk
Wegdeel_Vlak, Wegdeel_Lijn, Wegdeel_hartLijn etc. Ieder van deze objecten bevat slechts een
geometrie.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:top10nl="http://register.geostandaarden.nl/gmlapplicatieschema/top10nl/1.2.0"
                xmlns:brt="http://register.geostandaarden.nl/gmlapplicatieschema/brt-algemeen/1.2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:smil20="http://www.w3.org/2001/SMIL20/"
                xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullende FeatureCollection -->
    <xsl:template match="/">
        <top10nl:FeatureCollectionT10NL
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:top10nl="http://register.geostandaarden.nl/gmlapplicatieschema/top10nl/1.2.0"
                xmlns:brt="http://register.geostandaarden.nl/gmlapplicatieschema/brt-algemeen/1.2.0"
                xsi:schemaLocation="http://register.geostandaarden.nl/gmlapplicatieschema/top10nl/1.2.0 top10nl.xsd"
                gml:id="uuidf074ae61-93b9-448a-b1db-289fd15e8752"
                >
            <xsl:apply-templates/>
        </top10nl:FeatureCollectionT10NL>
    </xsl:template>

    <!-- Copy extent van hele FeatureCollection -->
    <xsl:template match="gml:boundedBy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
    Top10 Feature Types en hun geometrie-attributen
    
    Wegdeel.hoofdGeometrie:          vlak, lijn, punt
       "   .hartGeometrie:                 lijn, punt
    Waterdeel.geometrie:             vlak, lijn, punt
    Spoorbaandeel.geometrie:               lijn, punt
    Gebouw.geometrie:                vlak,       punt
    Terrein.geometrieVlak:           vlak
    Inrichtingselement.geometrie:          lijn, punt
    
    FunctioneelGebied.geometrie:     (multi)vlak, punt
    GeografischGebied.geometrie:     (multi)vlak, punt
    Plaats.geometrie:                (multi)vlak, punt
    RegistratiefGebied.geometrie:    (multi)vlak
    
    Hoogte.geometrie:                lijn, punt
    Relief.lijnGeometrie:            lijn
      "   .taludGeometrie.hogeZijde: lijn
      "   .      "       .lageZijde: lijn
    
    PlanTopografie.geometrie:        vlak, lijn, punt
    -->
    <xsl:template match="top10nl:FeatureMember">
        <xsl:for-each select="top10nl:Wegdeel">
            <xsl:call-template name="SplitsWegdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Waterdeel">
            <xsl:call-template name="SplitsWaterdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Spoorbaandeel">
            <xsl:call-template name="SplitsSpoorbaandeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Gebouw">
            <xsl:call-template name="SplitsGebouw"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Terrein">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Terrein_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Inrichtingselement">
            <xsl:call-template name="SplitsInrichtingselement"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:FunctioneelGebied">
            <xsl:call-template name="SplitsFunctioneelGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:GeografischGebied">
            <xsl:call-template name="SplitsGeografischGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Plaats">
            <xsl:call-template name="SplitsPlaats"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:RegistratiefGebied">
            <xsl:call-template name="SplitsRegistratiefGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Hoogte">
            <xsl:call-template name="SplitsHoogte"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Relief">
            <xsl:call-template name="SplitsRelief"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:PlanTopografie">
            <xsl:call-template name="SplitsPlanTopografie"/>
        </xsl:for-each>

    </xsl:template>

    <!-- Splits FunctioneelGebied: heeft geometrie.vlak, geometrie.multiVlak of geometrie.punt -->
    <xsl:template name="SplitsFunctioneelGebied">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Gebouw: heeft geometrie.vlak of geometrie.punt -->
    <xsl:template name="SplitsGebouw">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Gebouw_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Gebouw_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits GeografischGebied: heeft geometrie.vlak, geometrie.multiVlak of geometrie.punt -->
    <xsl:template name="SplitsGeografischGebied">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Hoogte: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsHoogte">
        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Inrichtingselement: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsInrichtingselement">
        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Plaats: heeft geometrie.vlak, geometrie.multiVlak of geometrie.punt -->
    <xsl:template name="SplitsPlaats">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits PlanTopografie: heeft geometrie.vlak, geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsPlanTopografie">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits RegistratiefGebied: heeft geometrie.vlak of geometrie.multiVlak -->
    <xsl:template name="SplitsRegistratiefGebied">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakOfMultivlak/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakOfMultivlak/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top10nl:geometrie/brt:BRTVlakOfMultivlak/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakOfMultivlak/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Relief: heeft lijngeometrie of taludGeometrie.hogeZijde en taludGeometrie.lageZijde -->
    <xsl:template name="SplitsRelief">
        <xsl:if test="top10nl:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Relief_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:taludGeometrie/brt:BRTHogeEnLageZijde != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Relief_HogeZijde</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:taludGeometrie/brt:BRTHogeEnLageZijde/brt:hogeZijde"/>
            </xsl:call-template>
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Relief_LageZijde</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:taludGeometrie/brt:BRTHogeEnLageZijde/brt:lageZijde"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Spoorbaandeel: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsSpoorbaandeel">
        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Waterdeel: heeft geometrie.vlak, geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsWaterdeel">
        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Wegdeel, heeft hoofdGeometrie.vlak, hoofdGeometrie.lijn, hoofdGeometrie.punt, hartGeometrie.lijn en/of hartGeometrie.punt -->
    <xsl:template name="SplitsWegdeel">
        <xsl:if test="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hoofdGeometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hartGeometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_HartLijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartGeometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hartGeometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_HartPunt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartGeometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <!-- Copieer alle top10:* attributen, behalve de geometrieen. -->
        <xsl:copy-of
                select="top10nl:*[not(self::top10nl:hoofdGeometrie)][not(self::top10nl:hartGeometrie)][not(self::top10nl:geometrie)][not(self::top10nl:geometrieVlak)][not(self::top10nl:lijnGeometrie)][not(self::top10nl:taludGeometrie)]"/>
    </xsl:template>

    <!-- Copieer alle elementen van object behalve geometrieen en voeg 1 enkele geometrie aan eind toe. -->
    <xsl:template name="CopyWithSingleGeometry" priority="1">
        <xsl:param name="objectType"/>
        <xsl:param name="geometrie"/>
        <gml:featureMember>
            <xsl:element name="{$objectType}">
                <xsl:attribute name="gml:id"><xsl:value-of select="@gml:id"/></xsl:attribute>
                <xsl:call-template name="CopyNonGeoProps"/>
                <xsl:copy-of select="$geometrie"/>
            </xsl:element>
        </gml:featureMember>
    </xsl:template>

</xsl:stylesheet>
