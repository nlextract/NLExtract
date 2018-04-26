<!--SLD file created with GeoCat Bridge premium v1.1.0 using ArcGIS Desktop with Geoserver extensions.
 Date: 26 January 2012
 See www.geocat.net for more details-->
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       version="1.0.0">
    <NamedLayer>
        <Name>Isohoogtelijn</Name>
        <UserStyle>
            <Name>Isohoogtelijn_style</Name>
            <Title>Isohoogtelijn style</Title>
            <FeatureTypeStyle>
                <Rule>
                    <Name>laagwaterlijn</Name>
                    <Title>laagwaterlijn</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[6]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#004DA8
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">1
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <Name>hoogtelijn</Name>
                    <Title>hoogtelijn</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[3]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#A83800
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">1
                            </CssParameter>
                            <CssParameter
                                    name="stroke-dasharray">3 2
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linecap">butt
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linejoin">mitre
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <Name>dieptelijn</Name>
                    <Title>dieptelijn</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[1]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#004DA8
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">1
                            </CssParameter>
                            <CssParameter
                                    name="stroke-dasharray">3 2
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linecap">butt
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linejoin">mitre
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>