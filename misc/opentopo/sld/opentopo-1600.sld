<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld"
                       xmlns:xsi="http://www.w3.org/16001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>opentopo-1600px</Name>
        <UserStyle>
            <Name>opentopo-1600px</Name>
            <Title>OpenTopo Raster</Title>
            <Abstract>Schaalbegrenzing 1600px/km kaarten</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <MaxScaleDenominator>5000</MaxScaleDenominator>
                    <RasterSymbolizer>
                        <Opacity>1.0</Opacity>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
