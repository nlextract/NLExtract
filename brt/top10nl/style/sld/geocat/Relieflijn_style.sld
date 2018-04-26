<!--SLD file created with GeoCat Bridge premium v1.1.0 using ArcGIS Desktop with Geoserver extensions.
 Date: 26 January 2012
 See www.geocat.net for more details-->
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       version="1.0.0">
    <NamedLayer>
        <Name>Relief_lijn</Name>
        <UserStyle>
            <Name>Relieflijn_style</Name>
            <Title>Relieflijn style</Title>
            <FeatureTypeStyle>
                <Rule>
                    <Name>talud, hoogteverschil</Name>
                    <Title>talud, hoogteverschil</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>SYMBOL</ogc:PropertyName>
                            <ogc:Literal><![CDATA[801;802]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#4C7300
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">40
                            </CssParameter>
                            <CssParameter
                                    name="stroke-dasharray">1 2
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <Name>kade of wal</Name>
                    <Title>kade of wal</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>SYMBOL</ogc:PropertyName>
                            <ogc:Literal><![CDATA[800]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#000000
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">4
                            </CssParameter>
                            <CssParameter
                                    name="stroke-dasharray">1 4
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>