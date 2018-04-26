<!--SLD file created with GeoCat Bridge premium v1.1.0 using ArcGIS Desktop with Geoserver extensions.
 Date: 26 January 2012
 See www.geocat.net for more details-->
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       version="1.0.0">
    <NamedLayer>
        <Name>Hoogte_of_dieptepunt</Name>
        <UserStyle>
            <Name>Hoogteofdieptepunt_style</Name>
            <Title>Hoogteofdieptepunt style</Title>
            <FeatureTypeStyle>
                <Rule>
                    <Name>peil</Name>
                    <Title>peil</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[8]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>ttf://ESRI Default Marker#69</WellKnownName>
                                <Fill>
                                    <CssParameter
                                            name="fill">#73004C
                                    </CssParameter>
                                </Fill>
                            </Mark>
                            <Opacity>1</Opacity>
                            <Size>10</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>hoogtepunt</Name>
                    <Title>hoogtepunt</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[4]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>ttf://ESRI Default Marker#69</WellKnownName>
                                <Fill>
                                    <CssParameter
                                            name="fill">#A83800
                                    </CssParameter>
                                </Fill>
                            </Mark>
                            <Opacity>1</Opacity>
                            <Size>10</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
                <Rule>
                    <Name>dieptepunt</Name>
                    <Title>dieptepunt</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>TYPERELIEF_CODE</ogc:PropertyName>
                            <ogc:Literal><![CDATA[2]]></ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <PointSymbolizer>
                        <Graphic>
                            <Mark>
                                <WellKnownName>ttf://ESRI Default Marker#69</WellKnownName>
                                <Fill>
                                    <CssParameter
                                            name="fill">#0000FF
                                    </CssParameter>
                                </Fill>
                            </Mark>
                            <Opacity>1</Opacity>
                            <Size>10</Size>
                        </Graphic>
                    </PointSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>