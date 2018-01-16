<?xml version="1.0" encoding="UTF-8"?>

<!--
Voorbewerking TOP1000NL GML Objecten

Auteur: Just van den Broecke en Frank Steggink

Dit XSLT script doet een voorbewerking op de ruwe TOP1000NL GML zoals door Het Kadaster
geleverd. Dit is nodig, omdat GDAL ogr2ogr niet alle mogelijkheden van GML goed aankan.

Voornamelijk gaat het om meerdere geometrie-attributen per TOP1000NL Object. Het interne
GDAL model kent maar 1 geometrie per feature. Daarnaast is het bij visualiseren bijv.
met SLDs voor een WMS vaak het handigst om 1 geometrie per laag te hebben. Dit geldt ook
als we bijvoorbeeld een OGR conversie naar ESRI Shapefile willen doen met ogr2ogr.

Dit script splitst objecten uit TOP1000NL uit in geometrie-specifieke objecten.
Bijvoorbeeld een weg (objecttype Wegdeel) kan een lijn of punt bevatten. Na uitsplitsen
ontstaan max. 2 verschillende objecttypen, namelijk Wegdeel_Lijn en Wegdeel_Punt. Ieder
van deze objecten bevat slechts één geometrie.

TODO: vanaf versie 2.0 ondersteunt GDAL meerdere geometrieën per feature. Deze stylesheet
houdt hier nog geen rekening mee.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:top1000nl="http://register.geostandaarden.nl/gmlapplicatieschema/top1000nl/1.2.0"
                xmlns:brt="http://register.geostandaarden.nl/gmlapplicatieschema/brt-algemeen/1.2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:smil20="http://www.w3.org/2001/SMIL20/"
                xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullende FeatureCollection -->
    <xsl:template match="/">
        <top1000nl:FeatureCollectionT1000NL
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:top1000nl="http://register.geostandaarden.nl/gmlapplicatieschema/top1000nl/1.2.0"
                xmlns:brt="http://register.geostandaarden.nl/gmlapplicatieschema/brt-algemeen/1.2.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xsi:schemaLocation="http://register.geostandaarden.nl/gmlapplicatieschema/top1000nl/1.2.0 top1000nl.xsd"
                gml:id="Top1000NL_FC">
            <xsl:apply-templates/>
        </top1000nl:FeatureCollectionT1000NL>
    </xsl:template>

    <!-- Copy extent van hele FeatureCollection -->
    <xsl:template match="gml:boundedBy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
    TOP1000NL Feature Types en hun geometrie-attributen
    
    Wegdeel.geometrie:                     lijn, punt
    Waterdeel.geometrie:             vlak, lijn
    Spoorbaandeel.geometrie:               lijn
    Gebouw.geometrie:                            punt
    Terrein.geometrie:               vlak
    Inrichtingselement.geometrie:          lijn, punt
    
    FunctioneelGebied.geometrie:     (multi)vlak, punt
    GeografischGebied.geometrie:     (multi)vlak, punt
    RegistratiefGebied.geometrie:    (multi)vlak
    Plaats.geometrie:                (multi)vlak, punt
    
    Hoogte.geometrie:                lijn, punt
    
    PlanTopografie.geometrie:        vlak, lijn, punt    -->
    <xsl:template match="top1000nl:FeatureMember">
        <xsl:for-each select="top1000nl:Wegdeel">
            <xsl:call-template name="SplitsWegdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Waterdeel">
            <xsl:call-template name="SplitsWaterdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Spoorbaandeel">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Gebouw">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Gebouw_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Terrein">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Terrein_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Inrichtingselement">
            <xsl:call-template name="SplitsInrichtingselement"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:FunctioneelGebied">
            <xsl:call-template name="SplitsFunctioneelGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:GeografischGebied">
            <xsl:call-template name="SplitsGeografischGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Plaats">
            <xsl:call-template name="SplitsPlaats"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:RegistratiefGebied">
            <xsl:call-template name="SplitsRegistratiefGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:Hoogte">
            <xsl:call-template name="SplitsHoogte"/>
        </xsl:for-each>

        <xsl:for-each select="top1000nl:PlanTopografie">
            <xsl:call-template name="SplitsPlanTopografie"/>
        </xsl:for-each>
    </xsl:template>

    <!-- Splits FunctioneelGebied: heeft geometrie.vlak, geometrie.multivlak of geometrie.punt -->
    <xsl:template name="SplitsFunctioneelGebied">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits GeografischGebied: heeft geometrie.vlak, geometrie.multivlak of geometrie.punt -->
    <xsl:template name="SplitsGeografischGebied">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Hoogte: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsHoogte">
        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Inrichtingselement: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsInrichtingselement">
        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Plaats: heeft geometrie.vlak, geometrie.multivlak of geometrie.punt -->
    <xsl:template name="SplitsPlaats">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Plaats_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakMultivlakOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits PlanTopografie: heeft geometrie.vlak, geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsPlanTopografie">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">PlanTopografie_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits RegistratiefGebied: heeft geometrie.vlak of geometrie.multivlak -->
    <xsl:template name="SplitsRegistratiefGebied">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakOfMultivlak/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakOfMultivlak/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakOfMultivlak/brt:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakOfMultivlak/brt:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Waterdeel: heeft geometrie.vlak of geometrie.lijn -->
    <xsl:template name="SplitsWaterdeel">
        <xsl:if test="top1000nl:geometrie/brt:BRTVlakOfLijn/brt:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakOfLijn/brt:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTVlakOfLijn/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTVlakOfLijn/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Wegdeel, heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsWegdeel">
        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top1000nl:geometrie/brt:BRTLijnOfPunt/brt:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <!-- Copieer alle top1000nl:* attributen, behalve de geometrieen. -->
        <xsl:copy-of
                select="top1000nl:*[not(self::top1000nl:geometrie)][not(self::top1000nl:lijnGeometrie)][not(self::top1000nl:geometrieVlak)]"/>
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
