<?xml version="1.0" encoding="UTF-8"?>
<!--
    Auteur: Frank Steggink
    
    Met deze XSL-stylesheet kan een GML-bestand worden gemaakt o.b.v. een template. Op deze wijze kan er een GML-bestand
    worden aangemaakt met allerlei verschillende combinaties van features, geometrieën en attributen. Er wordt ook
    rekening gehouden met de mogelijke verschillende waarden van attributen die d.m.v. codelijsten zijn vastgelegd en
    zelfs met de multipliciteit van attributen (minOccurs=0/1, maxOccurs=1/unbounded).
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:gml="http://www.opengis.net/gml/3.2">
    <xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Begin met het uitvoeren van de templates -->
    <xsl:template match="/">
        <xsl:apply-templates select="GenerateGML/FeatureCollection"></xsl:apply-templates>
    </xsl:template>
   
    <!-- Schrijf de feature collection weg -->
    <xsl:template match="FeatureCollection/*">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:comment>Dit GML-bestand is gegenereerd met make-gml.xsl</xsl:comment>
            <xsl:apply-templates select="//FeatureTypes"/>
        </xsl:copy>
    </xsl:template>

    <!-- Schrijf alle features weg met alle mogelijke attribuutcombinaties -->
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
                    <xsl:with-param name="featureName" select="concat('Test weggelaten attribuut ', local-name($at))"/>                    
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
                    <xsl:with-param name="featureName" select="concat('Test ', local-name($at), ' ', .)"/>                    
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
                    <xsl:with-param name="featureName" select="concat('Test multiattribuut ', local-name($at))"/>                    
                </xsl:call-template>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- Schrijf het feature weg met alle mogelijke geometriecombinates -->
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
            <!-- Bepaal het numerieke deel van de GML ID -->
            <xsl:variable name="id" select="$elPos * 100000 + $atPos * 1000 + $valPos * 10 + position() - 1"/>
            
            <!-- Bepaal de offset van de geometrie -->
            <xsl:variable name="llx" select="100000 + $valPos * 10 + $elPos * 1000"/>
            <xsl:variable name="lly" select="400000 + (position() - 1) * 10 + $atPos * 100"/>
            
            <!-- Schrijf een nieuw featuremember weg -->
            <xsl:element name="{name(//FeatureMember/*)}" namespace="{namespace-uri(//FeatureMember/*)}">
            
                <!-- Schrijf een nieuwe feature weg -->
                <xsl:element name="{name($el)}" namespace="{namespace-uri($el)}">
                    <!-- Bepaal het uiteindelijke GML ID -->
                    <xsl:attribute name="gml:id" namespace="http://www.opengis.net/gml/3.2">
                        <xsl:value-of select="concat(//IDPrefix,$id)"/>
                    </xsl:attribute>
                    
                    <!-- Schrijf alle attributen van het parenttype weg -->
                    <xsl:if test="$el[@parentType]">
                        <xsl:variable name="parentType" select="$el/../../ParentTypes/*[name()=$el/@parentType]"/>
                        <xsl:apply-templates select="$parentType/*" mode="parent">
                            <xsl:with-param name="id" select="$id"/>
                        </xsl:apply-templates>
                    </xsl:if>
                    
                    <!-- Schrijf alle attributen weg -->
                    <xsl:for-each select="$el/Attributes/*">
                        <xsl:choose>
                            <xsl:when test="name(.)=name($at)">
                                <!-- Actief attribuut -->
                                <xsl:choose>
                                    <xsl:when test="$val">
                                        <!-- De (eerste) waarde van het actieve attribuut -->
                                        <xsl:element name="{name()}" namespace="{namespace-uri()}">
                                            <xsl:value-of select="$val/text()"/>
                                        </xsl:element>
                                        <xsl:if test="$val2">
                                            <!-- De tweede waarde van het actieve attribuut -->
                                            <xsl:comment>Extra waarde voor het actieve attribuut <xsl:value-of select="local-name()"/></xsl:comment>
                                            <xsl:element name="{name()}" namespace="{namespace-uri()}">
                                                <xsl:value-of select="$val2/text()"/>
                                            </xsl:element>
                                        </xsl:if>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Melding dat het actieve attribuut wordt weggelaten -->
                                        <xsl:comment>Het actieve attribuut <xsl:value-of select="local-name()"/> wordt overgeslagen</xsl:comment>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- Niet-actief attribuut -->
                                <xsl:choose>
                                    <xsl:when test="@minOccurs='0'">
                                        <!-- Melding dat een optioneel attribuut wordt weggelaten -->
                                        <xsl:comment>Het optionele attribuut <xsl:value-of select="local-name()"/> wordt overgeslagen</xsl:comment>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <!-- Overige attributen; hierbij worden optionele attributen standaard weggelaten -->
                                        <xsl:element name="{name()}" namespace="{namespace-uri()}">
                                            <xsl:value-of select="./Value[1]/text()"/>
                                        </xsl:element>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    
                    <!-- Schrijf alle namen weg -->
                    <xsl:for-each select="$el/NameAttributes/*">
                        <xsl:element name="{name()}" namespace="{namespace-uri()}">
                            <xsl:value-of select="$featureName"/>
                        </xsl:element>
                    </xsl:for-each>
                    
                    <!-- Schrijf de actieve geometrie weg (mode = geom) -->
                    <xsl:copy>
                        <xsl:apply-templates mode="geom">
                            <xsl:with-param name="llx" select="$llx"/>
                            <xsl:with-param name="lly" select="$lly"/>
                        </xsl:apply-templates>
                    </xsl:copy>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    
    <!-- *********************************************************************************************************** -->
    <!-- Template om attributen van het parenttype te kopiëren, waarbij het meegegeven ID op de juiste plek toegevoegd
         kan worden. -->
    <!-- *********************************************************************************************************** -->
    
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
    
    <!-- *********************************************************************************************************** -->
    <!-- Templates om geometrieën mee op te bouwen, rekening houdend met de meegegeven offset (llx, lly). -->
    <!-- *********************************************************************************************************** -->

    <!-- Kopieer de structuur van het geometrie-element, totdat de basisgeometrie wordt gevonden -->
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

    <!-- Basisgeometriegevonden, start met het wegschrijven hiervan (mode = pos) -->
    <xsl:template match="PuntGeometrie|LijnGeometrie|VlakGeometrie|VlakGeometrieMetGat|MultivlakGeometrie|HartpuntGeometrie|HartlijnGeometrie|HogeZijdeGeometrie|LageZijdeGeometrie" mode="geom">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:variable name="curName" select="name()"/>
        <xsl:variable name="baseGeom" select="//BaseGeometries/Geometry[@name=$curName]/*"/>
        <xsl:apply-templates select="$baseGeom" mode="pos">
            <xsl:with-param name="llx" select="$llx"/>
            <xsl:with-param name="lly" select="$lly"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- Kopieer de structuur van de basisgeometrie, tot aan de tekstinhoud (pos of posList) -->
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
    
    <!-- Tekstinhoud van de basisgeometrie gevonden, start met het wegschrijven van de coördinaten -->
    <xsl:template match="text()" mode="pos">
        <xsl:param name="llx"/>
        <xsl:param name="lly"/>
        <xsl:call-template name="x-pos">
            <xsl:with-param name="llx" select="$llx"/>
            <xsl:with-param name="lly" select="$lly"/>
            <xsl:with-param name="posList" select="normalize-space(.)"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- Voeg de X-positie toe van het coördinaat -->
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
    
    <!-- Voeg de Y-positie toe van het coördinaat -->
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
    
</xsl:stylesheet>
