<!--SLD file created with GeoCat Bridge premium v1.1.0 using ArcGIS Desktop with Geoserver extensions.
 Date: 26 January 2012
 See www.geocat.net for more details-->
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd"
                       version="1.0.0">
    <NamedLayer>
        <Name>Straten</Name>
        <UserStyle>
            <Name>Straten_style</Name>
            <Title>Straten style</Title>
            <FeatureTypeStyle>
                <Rule>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter
                                    name="stroke">#F0F0F0
                            </CssParameter>
                            <CssParameter
                                    name="stroke-width">1
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <MaxScaleDenominator>26000</MaxScaleDenominator>
                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>STRAATNAAM</ogc:PropertyName>
                        </Label>
                        <Font>
                            <CssParameter
                                    name="font-family">Arial
                            </CssParameter>
                            <CssParameter
                                    name="font-size">21
                            </CssParameter>
                        </Font>
                        <LabelPlacement>
                            <LinePlacement>
                                <PerpendicularOffset>35.2778483334744</PerpendicularOffset>
                            </LinePlacement>
                        </LabelPlacement>
                        <Fill>
                            <CssParameter
                                    name="fill">#000000
                            </CssParameter>
                        </Fill>
                        <VendorOption
                                name="followLine">true
                        </VendorOption>
                        <VendorOption
                                name="maxAngleDelta">30
                        </VendorOption>
                        <VendorOption
                                name="repeat">100
                        </VendorOption>
                    </TextSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>