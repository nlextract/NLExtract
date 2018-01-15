<?xml version="1.0" encoding="UTF-8"?>

<!--
Voorbewerking TOP50NL GML Objecten

Auteur: Just van den Broecke en Frank Steggink

Dit XSLT script doet een voorbewerking op de ruwe TOP50NL GML zoals door Het Kadaster
geleverd. Dit is nodig omdat GDAL ogr2ogr niet alle mogelijkheden van GML goed aankan.

Voornamelijk gaat het om meerdere geometrie-attributen per TOP50 Object. Het interne
GDAL model kent maar 1 geometrie per feature. Daarnaast is het bij visualiseren bijv.
met SLDs voor een WMS vaak het handigst om 1 geometrie per laag te hebben. Dit geldt ook
als we bijvoorbeeld een OGR conversie naar ESRI Shapefile willen doen met ogr2ogr.

Dit script splitst objecten uit TOP50NL uit in geometrie-specifieke objecten.
Bijvoorbeeld een weg (objecttype Wegdeel) kan een vlak of lijn  bevatten. Na uitsplitsen
ontstaan max. 2 verschillende objecttypen, namelijk Wegdeel_Vlak en Wegdeel_Lijn. Ieder
van deze objecten bevat slechts een geometrie.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:top50nl="http://www.kadaster.nl/top50nl/1.1"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:smil20="http://www.w3.org/2001/SMIL20/"
                xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullende FeatureCollection -->
    <xsl:template match="/">
		<top50nl:FeatureCollectionTop50
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
				xmlns:top50nl="http://www.kadaster.nl/top50nl/1.1"
				xmlns:gml="http://www.opengis.net/gml/3.2"
				xsi:schemaLocation="http://www.kadaster.nl/top50nl/1.1 top50nl_1_1.xsd"
				gml:id="Top50NL_FC">
            <xsl:apply-templates/>
		</top50nl:FeatureCollectionTop50 >
    </xsl:template>

    <!-- Copy extent van hele FeatureCollection -->
    <xsl:template match="gml:boundedBy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
    TOP50NL Feature Types en hun geometrie-attributen
    
    Wegdeel.geometrie:               vlak, lijn
    Waterdeel.geometrie:             vlak, lijn
    Spoorbaandeel.geometrie:               lijn
    Gebouw.geometrie:                vlak,       punt
    Terrein.geometrie:               vlak
    Inrichtingselement.geometrie:          lijn, punt
    
    FunctioneelGebied.geometrie:     (multi)vlak, punt
    GeografischGebied.geometrie:     (multi)vlak, punt
    RegistratiefGebied.geometrie:    (multi)vlak
	
    Hoogte.geometrie:                lijn, punt
    Relief.geometrie:                lijn
    -->
    <xsl:template match="top50nl:FeatureMember">
        <xsl:for-each select="top50nl:Wegdeel">
            <xsl:call-template name="SplitsWegdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Waterdeel">
            <xsl:call-template name="SplitsWaterdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Spoorbaandeel">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Gebouw">
            <xsl:call-template name="SplitsGebouw"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Terrein">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Terrein_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie"/>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Inrichtingselement">
            <xsl:call-template name="SplitsInrichtingselement"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:FunctioneelGebied">
            <xsl:call-template name="SplitsFunctioneelGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:GeografischGebied">
            <xsl:call-template name="SplitsGeografischGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:RegistratiefGebied">
            <xsl:call-template name="SplitsRegistratiefGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Hoogte">
            <xsl:call-template name="SplitsHoogte"/>
        </xsl:for-each>

        <xsl:for-each select="top50nl:Relief">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Relief_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- Splits FunctioneelGebied: heeft geometrie.vlak, geometrie.multivlak of geometrie.punt -->
    <xsl:template name="SplitsFunctioneelGebied">
        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Gebouw: heeft geometrie.vlak of geometrie.punt -->
    <xsl:template name="SplitsGebouw">
        <xsl:if test="top50nl:geometrie/top50nl:VlakOfPunt/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Gebouw_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfPunt/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:VlakOfPunt/top50nl:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Gebouw_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfPunt/top50nl:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits GeografischGebied: heeft geometrie.vlak, geometrie.multivlak of geometrie.punt -->
    <xsl:template name="SplitsGeografischGebied">
        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakMultivlakOfPunt/top50nl:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Hoogte: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsHoogte">
        <xsl:if test="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Hoogte_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Inrichtingselement: heeft geometrie.lijn of geometrie.punt -->
    <xsl:template name="SplitsInrichtingselement">
        <xsl:if test="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:puntGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:LijnOfPunt/top50nl:puntGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits RegistratiefGebied: heeft geometrie.vlak of geometrie.multivlak -->
    <xsl:template name="SplitsRegistratiefGebied">
        <xsl:if test="top50nl:geometrie/top50nl:VlakOfMultivlak/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfMultivlak/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:if test="top50nl:geometrie/top50nl:VlakOfMultivlak/top50nl:multivlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfMultivlak/top50nl:multivlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Waterdeel: heeft geometrie.vlak of geometrie.lijn -->
    <xsl:template name="SplitsWaterdeel">
        <xsl:if test="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Wegdeel, heeft geometrie.vlak of geometrie.lijn -->
    <xsl:template name="SplitsWegdeel">
        <xsl:if test="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:vlakGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:vlakGeometrie"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:lijnGeometrie != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top50nl:geometrie/top50nl:VlakOfLijn/top50nl:lijnGeometrie"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <!-- Copieer alle top10:* attributen, behalve de geometrieen. -->
        <xsl:copy-of
                select="top50nl:*[not(self::top50nl:geometrie)]"/>
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
