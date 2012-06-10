<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0"
                       xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld"
                       xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink"
                       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <!-- a Named Layer is the basic building block of an SLD document
    For 2.5D in GeoServer see:
      http://www.maptags.de/?p=148
      http://mapping-malaysia.blogspot.com/2010/07/pseudo-3d-buildings-in-geoserver.html
    -->
    <NamedLayer>
        <Name>Polygon</Name>
        <UserStyle>
            <!-- Styles can have names, titles and abstracts -->
            <Title>2.5d Polygon</Title>
            <Abstract>Customised 2.5d polygon view</Abstract>
            <!-- FeatureTypeStyles describe how to render different features -->
            <!-- A FeatureTypeStyle for rendering polygons -->
            <FeatureTypeStyle>
                <Rule>
                    <MinScaleDenominator>5000</MinScaleDenominator>
                     <MaxScaleDenominator>35000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                         <Fill>
                            <CssParameter name="fill">#FF6600</CssParameter>
                             <CssParameter name="fill-opacity">1</CssParameter>
                        </Fill>
 <!--                       <Stroke>
                            <CssParameter name="stroke">#999999</CssParameter>
                        </Stroke>   -->
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <FeatureTypeStyle>
                <Rule>
                    <MaxScaleDenominator>5000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Geometry>
                            <ogc:Function name="isometric">
                                <ogc:PropertyName>geovlak</ogc:PropertyName>
                                <ogc:Literal>-1</ogc:Literal>
                            </ogc:Function>
                        </Geometry>
                        <Fill>
                            <CssParameter name="fill">#555555</CssParameter>
                        </Fill>
                 <!--       <Stroke>
                            <CssParameter name="stroke">#000000</CssParameter>
                        </Stroke>               -->
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
            <FeatureTypeStyle>
                <Rule>
                    <MaxScaleDenominator>5000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Geometry>
                            <ogc:Function name="offset">
                                <ogc:PropertyName>geovlak</ogc:PropertyName>
                                <ogc:Literal>0</ogc:Literal>
                                <ogc:Literal>-1</ogc:Literal>
                            </ogc:Function>
                        </Geometry>
                        <Fill>
                            <CssParameter name="fill">#FF6600</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#222222</CssParameter>
                            <CssParameter name="stroke-linecap">
                                 <ogc:Literal>round</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-linejoin">
                                 <ogc:Literal>bevel</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-opacity">
                                 <ogc:Literal>1</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-width">
                                 <ogc:Literal>0.7</ogc:Literal>
                             </CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
