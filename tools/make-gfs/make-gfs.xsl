<?xml version="1.0" encoding="UTF-8"?>
<!--
    Auteur: Frank Steggink
    
    Met deze XSL-stylesheet kan een GFS-bestand worden gemaakt o.b.v. een template. Een GFS-bestand kan zeer omvangrijk
    worden. Het heeft geen overerving-concept, dus alle properties moeten over alle features worden gekopieerd. Dit
    zorgt ervoor dat een GFS-bestand slecht onderhoudbaar is. Door in een template-bestand wel rekening te houden met
    overerving, wordt het onderhoud een stuk vergemakkelijkt.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <GMLFeatureClassList>
            <xsl:comment>Dit GFS-bestand is gegenereerd met make-gfs.xsl</xsl:comment>
            <xsl:apply-templates/>
        </GMLFeatureClassList>
    </xsl:template>
    
    <xsl:template match="SpatialInfo">
        <!-- Negeer dit -->
    </xsl:template>
    
    <xsl:template match="GMLFeatureClass">
        <xsl:if test="GeometryType">
            <GMLFeatureClass>
                <xsl:copy-of select="Name"/>
                <xsl:copy-of select="ElementPath"/>
                <xsl:copy-of select="GeometryType"/>
                <xsl:copy-of select="//SpatialInfo/*"/>
                <xsl:call-template name="CopyProperties">
                    <xsl:with-param name="featureClass" select="."/>
                </xsl:call-template>                
            </GMLFeatureClass>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="CopyProperties">
        <xsl:param name="featureClass"/>
        
        <xsl:if test="$featureClass/ParentClass">
            <!-- Properties van parent klasse -->
            <xsl:variable name="parentClassName" select="$featureClass/ParentClass/text()"/>            
            <xsl:call-template name="CopyProperties">
                <xsl:with-param name="featureClass" select="//GMLFeatureClass[Name=$parentClassName]"/>
            </xsl:call-template>
        </xsl:if>
        
        <!-- Eigen properties -->
        <xsl:if test="$featureClass/PropertyDefn">
            <xsl:comment>Begin properties van <xsl:value-of select="$featureClass/Name"/></xsl:comment>
            <xsl:copy-of select="$featureClass/PropertyDefn"/>
            <xsl:comment>Einde properties van <xsl:value-of select="$featureClass/Name"/></xsl:comment>
        </xsl:if>
    </xsl:template>
        
</xsl:stylesheet>
