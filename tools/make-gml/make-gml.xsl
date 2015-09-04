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
     
    <xsl:template match="ParentTypes/*">
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
    
    <xsl:template match="*" mode="parent">
        <xsl:param name="id"/>
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="text()='{ID}'">
                    <xsl:value-of select="$id"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="parent">
                        <xsl:with-param name="id" select="$id"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template name="AddFeature">
        <xsl:param name="el"/>
        <xsl:param name="elPos"/>
        <xsl:param name="at"/>
        <xsl:param name="atPos"/>
        <xsl:param name="val"/>  <!-- Leeg wanneer AddFeature wordt aangeroepen waarbij dit attribuut wordt weggelaten vanwege minOccurs='0' -->
        <xsl:param name="val2"/> <!-- Alleen wanneer maxOccurs een andere waarde heeft dan '1' -->
        <xsl:param name="valPos"/>
        <xsl:param name="featureName"/>
        
        <xsl:for-each select="$el/GeometryTypes/*">
            <xsl:variable name="id" select="$elPos * 100000 + $atPos * 1000 + $valPos * 10 + position() - 1"/>
            <xsl:variable name="llx" select="100000 + $valPos * 10 + $elPos * 1000"/>
            <xsl:variable name="lly" select="400000 + (position() - 1) * 10 + $atPos * 100"/>
            <top10nl:FeatureMember>
                <xsl:element name="top10nl:{name($el)}" namespace="{$ttnlNS}">
                    <xsl:attribute name="gml:id" namespace="http://www.opengis.net/gml/3.2">
                        <xsl:value-of select="concat('nl.top10nl.',$id)"/>
                    </xsl:attribute>
                    <xsl:if test="$el[@parentType]">
                        <xsl:variable name="parentType" select="$el/../../ParentTypes/*[name()=$el/@parentType]"/>
                        <xsl:apply-templates select="$parentType/*" mode="parent">
                            <xsl:with-param name="id" select="$id"/>
                        </xsl:apply-templates>
                    </xsl:if>
                    
                    <xsl:for-each select="$el/Attributes/*">
                        <xsl:if test="name(.)=name($at) and $val">
                            <!-- De (eerste) waarde van het actieve attribuut -->
                            <xsl:element name="top10nl:{name(.)}" namespace="{$ttnlNS}">
                                <xsl:value-of select="$val/text()"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="name(.)=name($at) and $val2">
                            <!-- De tweede waarde van het actieve attribuut -->
                            <xsl:comment>Extra waarde voor het actieve attribuut <xsl:value-of select="name(.)"/></xsl:comment>
                            <xsl:element name="top10nl:{name(.)}" namespace="{$ttnlNS}">
                                <xsl:value-of select="$val2/text()"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="name(.)=name($at) and not($val)">
                            <!-- Melding dat het actieve attribuut wordt weggelaten -->
                            <xsl:comment>Het actieve attribuut <xsl:value-of select="name(.)"/> wordt overgeslagen</xsl:comment>
                        </xsl:if>
                        <xsl:if test="name(.)!=name($at) and (not(@minOccurs) or @minOccurs!='0')">
                            <!-- Overige attributen; hierbij worden optionele attributen standaard weggelaten -->
                            <xsl:element name="top10nl:{name(.)}" namespace="{$ttnlNS}">
                                <xsl:value-of select="./Value[1]/text()"/>
                            </xsl:element>
                        </xsl:if>
                        <xsl:if test="name(.)!=name($at) and @minOccurs='0'">
                            <!-- Melding dat een optioneel attribuut wordt weggelaten -->
                            <xsl:comment>Het optionele attribuut <xsl:value-of select="name(.)"/> wordt overgeslagen</xsl:comment>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="$el/NameAttributes/*">
                        <xsl:element name="top10nl:{text()}" namespace="{$ttnlNS}">
                            <xsl:value-of select="$featureName"/>
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
            <xsl:if test="@minOccurs='0'">
                <!-- Maak een feature aan waarbij het actieve attribuut wordt weggelaten -->
                <xsl:call-template name="AddFeature">
                    <xsl:with-param name="el" select="$el"/>
                    <xsl:with-param name="elPos" select="$elPos"/>
                    <xsl:with-param name="at" select="$at"/>
                    <xsl:with-param name="atPos" select="$atPos"/>
                    <xsl:with-param name="valPos" select="0"/>
                    <xsl:with-param name="featureName" select="concat('Test weggelaten attribuut ', name($at))"/>                    
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="Value">
                <!-- Maak features aan voor alle waarden van het actieve attribuut -->
                <xsl:call-template name="AddFeature">
                    <xsl:with-param name="el" select="$el"/>
                    <xsl:with-param name="elPos" select="$elPos"/>
                    <xsl:with-param name="at" select="$at"/>
                    <xsl:with-param name="atPos" select="$atPos"/>
                    <xsl:with-param name="val" select="."/>
                    <xsl:with-param name="valPos" select="position()"/>
                    <xsl:with-param name="featureName" select="concat('Test ', name($at), ' ', .)"/>                    
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="@maxOccurs and @maxOccurs!='1' and @maxOccurs!='0'">
                <!-- Maak een feature aan met meerdere waarden voor het actieve attribuut -->
                <xsl:call-template name="AddFeature">
                    <xsl:with-param name="el" select="$el"/>
                    <xsl:with-param name="elPos" select="$elPos"/>
                    <xsl:with-param name="at" select="$at"/>
                    <xsl:with-param name="atPos" select="$atPos"/>
                    <xsl:with-param name="val" select="Value[1]"/>
                    <xsl:with-param name="val2" select="Value[2]"/>
                    <xsl:with-param name="valPos" select="count(Value) + 1"/>
                    <xsl:with-param name="featureName" select="concat('Test multiattribuut ', name($at))"/>                    
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>