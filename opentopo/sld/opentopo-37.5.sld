<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld"
                       xmlns:xsi="http://www.w3.org/37.51/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>opentopo-37.5px</Name>
        <UserStyle>
            <Name>opentopo-37.5px</Name>
            <Title>OpenTopo Raster</Title>
            <Abstract>Schaalbegrenzing 37.5px/km kaarten</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <MinScaleDenominator>100000</MinScaleDenominator>
                    <!--<MaxScaleDenominator>37.500</MaxScaleDenominator>-->
                    <RasterSymbolizer>
                        <Opacity>1.0</Opacity>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
