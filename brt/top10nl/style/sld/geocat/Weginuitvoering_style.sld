<!--SLD file created with GeoCat Bridge premium v1.1.0 using ArcGIS Desktop with Geoserver extensions.
 Date: 26 January 2012
 See www.geocat.net for more details-->
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       version="1.0.0">
    <NamedLayer>
        <Name>Weg_in_uitvoering</Name>
        <UserStyle>
            <Name>Weginuitvoering_style</Name>
            <Title>Weginuitvoering style</Title>
            <FeatureTypeStyle>
                <Rule>
                    <Name>in uitvoering</Name>
                    <Title>in uitvoering</Title>
                    <ogc:Filter>
                        <ogc:Or>
                            <ogc:PropertyIsEqualTo>
                                <ogc:PropertyName>SYMBOL_H0</ogc:PropertyName>
                                <ogc:Literal><![CDATA[122]]></ogc:Literal>
                            </ogc:PropertyIsEqualTo>
                            <ogc:PropertyIsEqualTo>
                                <ogc:PropertyName>SYMBOL_H0</ogc:PropertyName>
                                <ogc:Literal><![CDATA[121]]></ogc:Literal>
                            </ogc:PropertyIsEqualTo>
                        </ogc:Or>
                    </ogc:Filter>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#AAAAAA
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">3
                            </CssParameter>
                            <CssParameter
                                    name="stroke-dasharray">5 4
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linecap">butt
                            </CssParameter>
                            <CssParameter
                                    name="stroke-linejoin">round
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>