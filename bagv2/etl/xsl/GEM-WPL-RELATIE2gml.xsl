<?xml version="1.0" encoding="UTF-8"?>
<!--

Transform GEM-WPL-RELATIE XML to valid GML FeatureCollection, zodat deze bijvoorbeeld in ogr2ogr verwerkt kan worden.

Author:  Just van den Broecke, Just Objects B.V.
-->
<xsl:stylesheet version="1.0"
                xmlns:ogr="http://ogr.maptools.org/"
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:bagtypes="www.kadaster.nl/schemas/lvbag/gem-wpl-rel/bag-types/v20200601"
                xmlns:gwr-product="www.kadaster.nl/schemas/lvbag/gem-wpl-rel/gwr-producten-lvc/v20200601"
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
             <!-- Loop through all cities. -->
            <xsl:apply-templates select="//gwr-product:GemeenteWoonplaatsRelatie"/>
        </ogr:FeatureCollection>
    </xsl:template>

    <!-- Make each city an ogr:featureMember. -->
    <xsl:template match="gwr-product:GemeenteWoonplaatsRelatie">
        <gml:featureMember>
            <ogr:GemeenteWoonplaatsRelatie>
                <ogr:begingeldigheid>
                     <xsl:value-of select="gwr-product:tijdvakgeldigheid/bagtypes:begindatumTijdvakGeldigheid/text()"/>
                 </ogr:begingeldigheid>
                <ogr:eindgeldigheid>
                     <xsl:value-of select="gwr-product:tijdvakgeldigheid/bagtypes:einddatumTijdvakGeldigheid/text()"/>
                 </ogr:eindgeldigheid>
                <ogr:woonplaatscode>
                    <xsl:value-of select="gwr-product:gerelateerdeWoonplaats/gwr-product:identificatie/text()"/>
                </ogr:woonplaatscode>
                <ogr:gemeentecode>
                    <xsl:value-of select="gwr-product:gerelateerdeGemeente/gwr-product:identificatie/text()"/>
                </ogr:gemeentecode>
                <ogr:status>
                    <xsl:value-of select="gwr-product:status/text()"/>
                </ogr:status>
                <ogr:geometry>
                    <gml:Point srsName="urn:ogc:def:crs:EPSG:28992">
                        <gml:coordinates>20000,450000</gml:coordinates>
                     </gml:Point>
                </ogr:geometry>
            </ogr:GemeenteWoonplaatsRelatie>
        </gml:featureMember>
    </xsl:template>
</xsl:stylesheet>
