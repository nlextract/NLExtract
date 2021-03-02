<?xml version="1.0" encoding="UTF-8"?>
<!--

Transform LEVERINGSDOCUMENT-BAG-EXTRACT XML to valid GML FeatureCollection, zodat deze bijvoorbeeld in ogr2ogr verwerkt kan worden.

Author:  Just van den Broecke, Just Objects B.V.
-->
<xsl:stylesheet version="1.0"
                xmlns:ogr="http://ogr.maptools.org/"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xb="http://www.kadaster.nl/schemas/lvbag/extract-levering/v20200601"
                xmlns:selecties-extract="http://www.kadaster.nl/schemas/lvbag/extract-selecties/v20200601"
                 >
    <xsl:output method="xml" omit-xml-declaration="no" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/">
        <ogr:FeatureCollection
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:ogr="http://ogr.maptools.org/"
                xmlns:gml="http://www.opengis.net/gml"
                xsi:schemaLocation="http://ogr.maptools.org/ http://www.opengis.net/gml http://schemas.opengis.net/gml/2.1.2/feature.xsd"
                >
            <gml:boundedBy>
              <gml:Box>
                <gml:coord><gml:X>-180.0</gml:X><gml:Y>-90.0</gml:Y></gml:coord>
                <gml:coord><gml:X>180.0</gml:X><gml:Y>90.0</gml:Y></gml:coord>
              </gml:Box>
            </gml:boundedBy>

            <xsl:apply-templates select="//xb:SelectieGegevens"/>
        </ogr:FeatureCollection>
    </xsl:template>

    <!-- Make each entry an ogr:featureMember. -->
    <xsl:template match="xb:SelectieGegevens/selecties-extract:LVC-Extract">
        <gml:featureMember>
            <ogr:nlx_bag_info>
                <ogr:sleutel>extract_datum</ogr:sleutel>
                <ogr:waarde>
                     <xsl:value-of select="selecties-extract:StandTechnischeDatum/text()"/>
                 </ogr:waarde>
                <ogr:geometry>
                    <gml:Point srsName="urn:ogc:def:crs:EPSG:28992">
                        <gml:coordinates>20000,450000</gml:coordinates>
                     </gml:Point>
                </ogr:geometry>
            </ogr:nlx_bag_info>
        </gml:featureMember>
    </xsl:template>
</xsl:stylesheet>
