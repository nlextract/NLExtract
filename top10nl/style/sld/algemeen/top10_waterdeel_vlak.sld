<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <NamedLayer>
        <Name>water</Name>
        <UserStyle>
            <Name>normal</Name>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <!-- <Rule>
                    <Name>Waterlargescale</Name>
                    <Title>Watervlak</Title>
                    <Abstract>Watervlak</Abstract>
                    <MaxScaleDenominator>250000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#99b3cc</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#4851ff</ogc:Literal>
                            </CssParameter>
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
                                <ogc:Literal>0.2</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>       -->
                <Rule>
                    <Name>droogvallend</Name>
                    <Title>droogvallend</Title>
                      <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typewater</ogc:PropertyName>
                            <ogc:Literal>droogvallend</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                   <MaxScaleDenominator>250000</MaxScaleDenominator>
                   <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#cddbe7</CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>meer, plas, ven, vijver</Name>
                    <Title>meer, plas, ven, vijver</Title>
                     <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typewater</ogc:PropertyName>
                            <ogc:Literal>meer, plas, ven, vijver</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                   <MaxScaleDenominator>250000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#94cceb</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#94cceb</CssParameter>
                            <CssParameter name="stroke-width">0.12</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>waterloop</Name>
                    <Title>waterloop</Title>
                     <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typewater</ogc:PropertyName>
                            <ogc:Literal>waterloop</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                   <MaxScaleDenominator>250000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#94cceb</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#94cceb</CssParameter>
                            <CssParameter name="stroke-width">0.12</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>zee</Name>
                    <Title>zee</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typewater</ogc:PropertyName>
                            <ogc:Literal>zee</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#93cae1</CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
