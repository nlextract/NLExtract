<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>BAG Adres</Name>
        <UserStyle>
            <Title>BAG Adres</Title>
            <Abstract>Simpele stijl voor BAG Adres</Abstract>
            <FeatureTypeStyle>
                <Rule>
                    <Title>BAG Adres</Title>
                    <MaxScaleDenominator>2000</MaxScaleDenominator>
                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>huisnummer</ogc:PropertyName>
                            <ogc:PropertyName>huisletter</ogc:PropertyName>
                            <ogc:PropertyName>huisnummertoevoeging</ogc:PropertyName>
                        </Label>
                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Verdana</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-size">
                                <ogc:Literal>8</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-style">
                                <ogc:Literal>italic</ogc:Literal>
                            </CssParameter>
                        </Font>

                        <LabelPlacement>
                            <PointPlacement>
                                <AnchorPoint>
                                    <AnchorPointX>0.5</AnchorPointX>
                                    <AnchorPointY>0.5</AnchorPointY>
                                </AnchorPoint>
                            </PointPlacement>
                        </LabelPlacement>

                        <Fill>
                            <CssParameter name="fill">#000000</CssParameter>
                        </Fill>
                    </TextSymbolizer>

                </Rule>

            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>

