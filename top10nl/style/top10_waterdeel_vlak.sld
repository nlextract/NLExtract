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
                <Rule>
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
                </Rule>
<!--                <Rule>
                    <Name>Watersmallscale</Name>
                    <Title>Watervlak</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:Filter>
                            <ogc:PropertyIsLike wildCard="*" singleChar="#" escape="!">
                                <ogc:PropertyName>hoofdafwatering</ogc:PropertyName>
                                <ogc:Literal>ja*</ogc:Literal>
                            </ogc:PropertyIsLike>
                        </ogc:Filter>
                    </ogc:Filter>
                    <MinScaleDenominator>250000</MinScaleDenominator>
                    <MaxScaleDenominator>1.7976931348623157E308</MaxScaleDenominator>
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
                </Rule>  -->
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
