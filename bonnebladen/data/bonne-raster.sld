<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>Bonne</Name>
        <UserStyle>
            <Name>Bonne</Name>
            <Title>Bonne</Title>
            <Abstract>Bonne transparantie settings</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <RasterSymbolizer>

                        <ChannelSelection>
                            <GrayChannel>
                                <SourceChannelName>1</SourceChannelName>
                            </GrayChannel>
                        </ChannelSelection>

                        <ColorMap type="values" extended="false">
                            <ColorMapEntry color="#000000" quantity="0" label="0" opacity="1"/>
                            <!--<ColorMapEntry color="#ffffff" quantity="1" label="1" opacity="0"/>-->
                        </ColorMap>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
