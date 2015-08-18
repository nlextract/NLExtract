<?xml version="1.0" encoding="UTF-8"?>
<!--
    Auteur: Frank Steggink
    
    Met deze XSL-stylesheet kan een GML-bestand worden gemaakt o.b.v. een template. ...
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:top10nl="http://www.kadaster.nl/schemas/imbrt/top10nl/1.2"
        xmlns:brt="http://www.kadaster.nl/schemas/imbrt/brt-alg/1.0"
        xmlns:gml="http://www.opengis.net/gml/3.2">
    <xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:variable name="ttnlNS" select="'http://www.kadaster.nl/schemas/imbrt/top10nl/1.2'"/>

    <xsl:template match="/">
        <top10nl:FeatureCollectionT10NL xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:top10nl="http://www.kadaster.nl/schemas/imbrt/top10nl/1.2"
                xmlns:brt="http://www.kadaster.nl/schemas/imbrt/brt-alg/1.0"
                xmlns:gml="http://www.opengis.net/gml/3.2"
                xsi:schemaLocation="http://www.kadaster.nl/schemas/imbrt/top10nl/1.2 top10nl-concept.xsd"
                gml:id="NL.TOP10NL_FC1">
            <xsl:comment>Dit GML-bestand is gegenereerd met make-gml.xsl</xsl:comment>
            <xsl:apply-templates/>
        </top10nl:FeatureCollectionT10NL>
    </xsl:template>

    <xsl:template match="BaseGeometries">
        <!-- Negeer -->
    </xsl:template>
    
    <xsl:template match="PuntGeometrie|LijnGeometrie|VlakGeometrie|VlakGeometrieMetGat|MultivlakGeometrie|HartpuntGeometrie|HartlijnGeometrie|HogeZijdeGeometrie|LageZijdeGeometrie" mode="geom">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:variable name="curName" select="name()"/>
        <xsl:variable name="baseGeom" select="//BaseGeometries/*[name()=$curName]/*"/>
        <xsl:apply-templates select="$baseGeom" mode="pos">
            <xsl:with-param name="llx" select="$llx"/>
            <xsl:with-param name="lly" select="$lly"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="geom">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:copy>
            <xsl:apply-templates mode="geom">
                <xsl:with-param name="llx" select="$llx"/>
                <xsl:with-param name="lly" select="$lly"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="text()" mode="pos">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:call-template name="x-pos">
            <xsl:with-param name="llx" select="$llx"/>
            <xsl:with-param name="lly" select="$lly"/>
            <xsl:with-param name="posList" select="normalize-space(.)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="x-pos">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:param name="posList"/>
        <xsl:value-of select="$llx + substring-before($posList, ' ')"/>
        <xsl:value-of select="' '"/>
        <xsl:call-template name="y-pos">
            <xsl:with-param name="llx" select="$llx"/>
            <xsl:with-param name="lly" select="$lly"/>
            <xsl:with-param name="posList" select="substring-after($posList, ' ')"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="y-pos">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:param name="posList"/>
        <xsl:choose>
            <xsl:when test="contains($posList, ' ')">
                <xsl:value-of select="$lly + substring-before($posList, ' ')"/>
                <xsl:value-of select="' '"/>
                <xsl:call-template name="x-pos">
                    <xsl:with-param name="llx" select="$llx"/>
                    <xsl:with-param name="lly" select="$lly"/>
                    <xsl:with-param name="posList" select="substring-after($posList, ' ')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$lly + $posList"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="pos">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates mode="pos">
                <xsl:comment><xsl:value-of select="name(*)"/></xsl:comment>
                <xsl:with-param name="llx" select="$llx"/>
                <xsl:with-param name="lly" select="$lly"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="FeatureTypes/*">
        <xsl:variable name="el" select="."/>
        <xsl:variable name="elPos" select="position()"/>
        <xsl:for-each select="Attributes/*">
            <xsl:variable name="at" select="."/>
            <xsl:variable name="atPos" select="position()"/>
            <xsl:for-each select="Value">
                <xsl:variable name="v" select="."/>
                <xsl:variable name="valPos" select="position()"/>
                <xsl:variable name="n" select="concat('Test ', name($at), ' ', $v)"/>
                <xsl:for-each select="$el/GeometryTypes/*">
                    <xsl:variable name="id" select="$elPos * 100000 + $atPos * 1000 + $valPos * 10 + position() - 1"/>
                    <xsl:variable name="llx" select="100000 + $valPos * 10 + $elPos * 1000"/>
                    <xsl:variable name="lly" select="400000 + (position() - 1) * 10 + $atPos * 100"/>
                    <top10nl:FeatureMember>
                        <xsl:element name="top10nl:{name($el)}" namespace="{$ttnlNS}">
                            <xsl:attribute name="gml:id" namespace="http://www.opengis.net/gml/3.2">
                                <xsl:value-of select="concat('nl.top10nl.',$id)"/>
                            </xsl:attribute>
                            <top10nl:identificatie>
                                <brt:NEN3610ID>
                                    <brt:namespace>NL.TOP10NL</brt:namespace>
                                    <brt:lokaalID><xsl:value-of select="$id"/></brt:lokaalID>
                                </brt:NEN3610ID>
                            </top10nl:identificatie>
                            <top10nl:brontype>Luchtfoto</top10nl:brontype>
                            <top10nl:bronactualiteit>2015-01-01</top10nl:bronactualiteit>
                            <top10nl:bronbeschrijving>Een orthogerectificeerde fotografische opname van een deel van het aardoppervlak. Gemaakt vanuit een vliegtuig.</top10nl:bronbeschrijving>
                            <top10nl:bronnauwkeurigheid>0.4</top10nl:bronnauwkeurigheid>
                            <top10nl:objectBeginTijd>2015-08-15</top10nl:objectBeginTijd>
                            <top10nl:tijdstipRegistratie>2015-08-15</top10nl:tijdstipRegistratie>
                            <top10nl:tdnCode>999</top10nl:tdnCode>
                            <top10nl:visualisatieCode>19160</top10nl:visualisatieCode>
                            <top10nl:mutatieType>TEST</top10nl:mutatieType>
                            <xsl:for-each select="$el/Attributes/*">
                                <xsl:element name="top10nl:{name(.)}" namespace="{$ttnlNS}">
                                    <xsl:if test=".=$at">
                                        <xsl:value-of select="$v/text()"/>
                                    </xsl:if>
                                    <xsl:if test="not(.=$at)">
                                        <xsl:value-of select="./Value[1]/text()"/>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="$el/NameAttributes/*">
                                <xsl:element name="top10nl:{text()}" namespace="{$ttnlNS}">
                                    <xsl:value-of select="$n"/>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:copy>
                                <xsl:apply-templates mode="geom">
                                    <xsl:with-param name="llx" select="$llx"/>
                                    <xsl:with-param name="lly" select="$lly"/>
                                </xsl:apply-templates>
                            </xsl:copy>
                        </xsl:element>
                    </top10nl:FeatureMember>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>