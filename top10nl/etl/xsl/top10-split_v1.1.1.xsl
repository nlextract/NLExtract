<?xml version="1.0" encoding="UTF-8"?>

<!--
Voorbewerking Top10NL GML Objecten

Auteur: Just van den Broecke

Aangepast voor Top10NL versie 1.1.1 door Frank Steggink

Dit XSLT script doet een voorbewerking op de ruwe Top10NL GML zoals door Het Kadaster
geleverd. Dit is nodig omdat GDAL ogr2ogr niet alle mogelijkheden van GML goed aankan.

Voornamelijk gaat het om meerdere geometrie-attributen per Top10 Object. Het interne
GDAL model kent maar 1 geometrie per feature. Daarnaast is het bij visualiseren bijv.
met SLDs voor een WMS vaak het handigst om 1 geometrie per laag te hebben. ook als we bijvoorbeeld 
een OGR conversie naar ESRI Shapefile willen doen met ogr2ogr.

Dit script splitst objecten uit Top10NL uit in geometrie-specifieke objecten.
Bijvoorbeeld een weg (object type Wegdeel) kent 5 mogelijke geometrie attributen:
(geometrieVlak geometrieLijn geometriePunt hartLijn hartPunt). Na uitsplitsen ontstaan dan 5
object typen: Wegdeel_Vlak, Wegdeel_Lijn, Wegdeel_hartLijn etc. Objecten met 1 geometrie worden
simpelweg doorgeggeven.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:top10nl="http://www.kadaster.nl/schemas/top10nl/v20120116"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:smil20="http://www.w3.org/2001/SMIL20/"
                xmlns:smil20lang="http://www.w3.org/2001/SMIL20/Language">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullende FeatureCollection -->
    <xsl:template match="/">
        <gml:FeatureCollection
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:top10nl="http://www.kadaster.nl/schemas/top10nl/v20120116"
                xsi:schemaLocation="http://www.kadaster.nl/schemas/top10nl/v20120116 TOP10NL_1_1_1.xsd"
                gml:id="uuidf074ae61-93b9-448a-b1db-289fd15e8752"
                >
            <xsl:apply-templates/>
        </gml:FeatureCollection>
    </xsl:template>

    <!-- Copy extent van hele FeatureCollection -->
    <xsl:template match="gml:boundedBy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
    Top10 Feature Types en hun geometrie-attributen

    Wegdeel:            geometrieVlak geometrieLijn geometriePunt hartLijn hartPunt
    Waterdeel:          geometrieVlak geometrieLijn geometriePunt
    Spoorbaandeel:                    geometrieLijn geometriePunt
    Gebouw:             geometrieVlak
    Terrein:            geometrieVlak
    Inrichtingselement:               geometrieLijn geometriePunt

    FunctioneelGebied:  geometrieVlak labelPunt
    GeografischGebied:  geometrieVlak labelPunt
    RegistratiefGebied: geometrieVlak labelPunt

    IsoHoogte:          geometrieLijn
    KadeOfWal:          geometrieLijn
    Hoogteverschil:                                 hogeZijde (Lijn) lageZijde (Lijn)
    OverigReliëf:       geometrieLijn geometriePunt
    HoogteOfDieptePunt:               geometriePunt
    -->
    <xsl:template match="gml:featureMember">
        <!-- START Multiple geom features: split into separate feature types, one for each geom type -->
        <xsl:for-each select="top10nl:Waterdeel">
            <xsl:call-template name="SplitsWaterdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Wegdeel">
            <xsl:call-template name="SplitsWegdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Spoorbaandeel">
            <xsl:call-template name="SplitsSpoorbaandeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:FunctioneelGebied">
            <xsl:call-template name="SplitsFunctioneelGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:GeografischGebied">
            <xsl:call-template name="SplitsGeografischGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Inrichtingselement">
            <xsl:call-template name="SplitsInrichtingselement"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:RegistratiefGebied">
            <xsl:call-template name="SplitsRegistratiefGebied"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:OverigRelief">
            <xsl:call-template name="SplitsOverigRelief"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Hoogteverschil">
            <xsl:call-template name="SplitsHoogteverschil"/>
        </xsl:for-each>

        <!-- START Single geom features: just copy all -->
        <xsl:for-each select="top10nl:Gebouw">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">Gebouw_Vlak</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Terrein">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">Terrein_Vlak</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:IsoHoogte">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">IsoHoogte_Lijn</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:HoogteOfDieptePunt">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">HoogteOfDiepte_Punt</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:KadeOfWal">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">KadeOfWal_Lijn</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

    </xsl:template>

    <!-- Splits FunctioneelGebied: heeft geometrieVlak en labelPunt -->
    <xsl:template name="SplitsFunctioneelGebied">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:labelPunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">FunctioneelGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits GeografischGebied: heeft geometrieVlak en labelPunt -->
    <xsl:template name="SplitsGeografischGebied">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:labelPunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">GeografischGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Hoogteverschil: heeft hogeZijde    (Lijn) en lageZijde (Lijn) -->
    <xsl:template name="SplitsHoogteverschil">
        <xsl:if test="top10nl:hogeZijde != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">HoogteverschilHZ_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hogeZijde"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:lageZijde != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">HoogteverschilLZ_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:lageZijde"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Inrichtingselement: heeft geometrieLijn en geometriePunt -->
    <xsl:template name="SplitsInrichtingselement">
        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Inrichtingselement_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits OverigRelief: heeft geometrieLijn en geometriePunt -->
    <xsl:template name="SplitsOverigRelief">
        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">OverigRelief_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">OverigRelief_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits GeografischGebied: heeft geometrieVlak en labelPunt -->
    <xsl:template name="SplitsRegistratiefGebied">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:labelPunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">RegistratiefGebied_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Splits Spoorbaandeel: heeft geometrieLijn en geometriePunt -->
    <xsl:template name="SplitsSpoorbaandeel">
        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Splits Waterdeel: heeft geometrieVlak, geometrieLijn en geometriePunt -->
    <xsl:template name="SplitsWaterdeel">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Splits Wegdeel, heeft geometrieVlak, geometrieLijn, geometriePunt, hartLijn en hartPunt -->
    <xsl:template name="SplitsWegdeel">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hartLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_HartLijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartLijn"/>
            </xsl:call-template>

        </xsl:if>

        <xsl:if test="top10nl:hartPunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_HartPunt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartPunt"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <fid>
            <xsl:value-of select='substring(top10nl:identificatie, 12)'/>
        </fid>

        <!-- Copieer alle top10:* attributen, behalve de geometrieen. -->
        <xsl:copy-of
                select="top10nl:*[not(self::top10nl:geometrieVlak)][not(self::top10nl:geometrieLijn)][not(self::top10nl:geometriePunt)][not(self::top10nl:hartLijn)][not(self::top10nl:hartPunt)][not(self::top10nl:labelPunt)][not(self::top10nl:hogeZijde)][not(self::top10nl:lageZijde)]"/>
    </xsl:template>

    <!-- Copieer alle elementen van object behalve geometrieen en voeg 1 enkele geometrie aan eind toe. -->
    <xsl:template name="CopyWithSingleGeometry" priority="1">
        <xsl:param name="objectType"/>
        <xsl:param name="geometrie"/>
        <gml:featureMember>
            <xsl:element name="{$objectType}">
                <xsl:call-template name="CopyNonGeoProps"/>
                <xsl:copy-of select="$geometrie"/>
            </xsl:element>
        </gml:featureMember>
    </xsl:template>

    <!-- Copieer hele object. -->
    <xsl:template name="CopyAll" priority="1">
        <xsl:param name="objectType"/>
        <gml:featureMember>
            <xsl:element name="{$objectType}">
                <!-- Kopieer alle niet-geometrie properties -->
                <xsl:call-template name="CopyNonGeoProps"/>
                
                <!-- Kopieer geometrie property -->
                <xsl:copy-of select="top10nl:geometrieVlak|top10nl:geometrieLijn|top10nl:geometriePunt"/>
            </xsl:element>
        </gml:featureMember>
    </xsl:template>

</xsl:stylesheet>
