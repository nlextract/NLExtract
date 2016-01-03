<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:gml="http://www.opengis.net/gml"
				xmlns:imgeo="http://www.geostandaarden.nl/imgeo/2.1"
				xmlns:lu="http://www.opengis.net/citygml/landuse/2.0"
				xmlns:tra="http://www.opengis.net/citygml/transportation/2.0"
				xmlns:tun="http://www.opengis.net/citygml/tunnel/2.0"
				xmlns:veg="http://www.opengis.net/citygml/vegetation/2.0"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				xmlns:wat="http://www.opengis.net/citygml/waterbody/2.0"
				xmlns:bri="http://www.opengis.net/citygml/bridge/2.0"
				xmlns:bui="http://www.opengis.net/citygml/building/2.0"
				xmlns:cif="http://www.opengis.net/citygml/cityfurniture/2.0"
				xmlns:c="http://www.opengis.net/citygml/2.0">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullend CityModel -->
    <xsl:template match="/">
        <CityModel xmlns:gml="http://www.opengis.net/gml"
				xmlns:imgeo="http://www.geostandaarden.nl/imgeo/2.1"
				xmlns:lu="http://www.opengis.net/citygml/landuse/2.0"
				xmlns:tra="http://www.opengis.net/citygml/transportation/2.0"
				xmlns:tun="http://www.opengis.net/citygml/tunnel/2.0"
				xmlns:veg="http://www.opengis.net/citygml/vegetation/2.0"
				xmlns:xlink="http://www.w3.org/1999/xlink"
				xmlns:wat="http://www.opengis.net/citygml/waterbody/2.0"
				xmlns:bri="http://www.opengis.net/citygml/bridge/2.0"
				xmlns:bui="http://www.opengis.net/citygml/building/2.0"
				xmlns:cif="http://www.opengis.net/citygml/cityfurniture/2.0"
				xmlns="http://www.opengis.net/citygml/2.0"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
				xsi:schemaLocation="http://www.geostandaarden.nl/imgeo/2.1 http://schemas.geonovum.nl/imgeo/2.1/imgeo-2.1.1.xsd">
            <xsl:apply-templates/>
        </CityModel>
    </xsl:template>
    
    <xsl:template match="c:cityObjectMember">
        <xsl:for-each select="*">
            <xsl:call-template name="SplitsBGTObject"/>
        </xsl:for-each>
        <xsl:for-each select=".//imgeo:Nummeraanduidingreeks">
            <c:cityObjectMember>
                <xsl:copy>
                    <xsl:copy-of select="*|@*"/>
                </xsl:copy>
            </c:cityObjectMember>
        </xsl:for-each>
        <xsl:for-each select=".//imgeo:OpenbareRuimteLabel">
            <c:cityObjectMember>
                <xsl:copy>
                    <xsl:copy-of select="*|@*"/>
                </xsl:copy>
            </c:cityObjectMember>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="SplitsBGTObject">
        <xsl:if test="*[starts-with(local-name(),'geometrie2d')] != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="ns" select="namespace-uri()"/>
                <xsl:with-param name="objectType"><xsl:value-of select="concat(local-name(), '_2D')"/></xsl:with-param>
                <xsl:with-param name="geometrie" select="*[starts-with(local-name(),'geometrie2d')]"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="*[starts-with(local-name(),'lod0')] != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="ns" select="namespace-uri()"/>
                <xsl:with-param name="objectType"><xsl:value-of select="concat(local-name(), '_lod0')"/></xsl:with-param>
                <xsl:with-param name="geometrie" select="*[starts-with(local-name(),'lod0')]"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="*[starts-with(local-name(),'kruinlijn')] != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="ns" select="namespace-uri()"/>
                <xsl:with-param name="objectType"><xsl:value-of select="concat(local-name(), '_kruinlijn')"/></xsl:with-param>
                <xsl:with-param name="geometrie" select="*[starts-with(local-name(),'kruinlijn')]"/>
            </xsl:call-template>
        </xsl:if>
        <xsl:if test="*[local-name()='geometrie'] != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="ns" select="namespace-uri()"/>
                <xsl:with-param name="objectType"><xsl:value-of select="local-name()"/></xsl:with-param>
                <xsl:with-param name="geometrie" select="*[local-name()='geometrie']"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <!--fid>
            <xsl:value-of select='top10nl:identificatie/brt:NEN3610ID/brt:lokaalID'/>
        </fid-->

        <!-- Copieer alle attributen, behalve de geometrieen. -->
        <xsl:copy-of select="*[not(starts-with(local-name(),'lod0')) and not(starts-with(local-name(),'lod1')) and not(starts-with(local-name(),'lod2')) and not(starts-with(local-name(),'lod3')) and not(starts-with(local-name(),'geometrie2d')) and not(starts-with(local-name(),'kruinlijn')) and not(local-name()='plaatsingspunt') and not(local-name()='geometrie') and not(local-name()='nummeraanduidingreeks')]"/>
    </xsl:template>

    <!-- Copieer alle elementen van object, behalve geometrieen, en voeg 1 enkele geometrie aan eind toe. -->
    <xsl:template name="CopyWithSingleGeometry" priority="1">
        <xsl:param name="ns"/>
        <xsl:param name="objectType"/>
        <xsl:param name="geometrie"/>
        
        <!-- Bepaal de namespace prefix -->
        <xsl:variable name="prefix">
            <xsl:choose>
                <xsl:when test="$ns='http://www.geostandaarden.nl/imgeo/2.1'">imgeo</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/landuse/2.0'">lu</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/transportation/2.0'">tra</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/tunnel/2.0'">tun</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/vegetation/2.0'">veg</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/waterbody/2.0'">wat</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/bridge/2.0'">bri</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/building/2.0'">bui</xsl:when>
                <xsl:when test="$ns='http://www.opengis.net/citygml/cityfurniture/2.0'">tra</xsl:when>
                <xsl:otherwise>c</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <c:cityObjectMember>
            <xsl:element name="{$prefix}:{$objectType}">
                <xsl:call-template name="CopyNonGeoProps"/>
                <xsl:copy-of select="$geometrie"/>
            </xsl:element>
        </c:cityObjectMember>
    </xsl:template>

</xsl:stylesheet>
