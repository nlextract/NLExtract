<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <NamedLayer>
        <Name>gebouw</Name>
        <UserStyle>
            <Name>normal</Name>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <!-- <Rule>
                    <Name>gebouw</Name>
                    <Title>gebouw</Title>
                    <Abstract>gebouw</Abstract>
                    <MaxScaleDenominator>25000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#ff715d</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#cc0000</ogc:Literal>
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
                </Rule>      -->

             <Rule>
                     <Name>kas</Name>
                     <Title>kas</Title>
                      <ogc:Filter>
                         <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>typegebouw</ogc:PropertyName>
                             <ogc:Literal>(1:kas, warenhuis)</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                     </ogc:Filter>
                 <MaxScaleDenominator>25000</MaxScaleDenominator>
                     <PolygonSymbolizer>
                         <Fill>
                             <CssParameter name="fill">#d1e1db</CssParameter>
                         </Fill>
                         <Stroke>
                             <CssParameter name="stroke">#41494b</CssParameter>
                              <CssParameter name="stroke-width">0.19</CssParameter>
                         </Stroke>
                     </PolygonSymbolizer>
                 </Rule>

                <Rule>
                    <Name>hoogbouw</Name>
                    <Title>hoogbouw</Title>
                     <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>hoogteklasse</ogc:PropertyName>
                            <ogc:Literal>hoogbouw</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>25000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#524548</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#403437</CssParameter>
                            <CssParameter name="stroke-width">0.12</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>laagbouw</Name>
                    <Title>laagbouw</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>hoogteklasse</ogc:PropertyName>
                            <ogc:Literal>laagbouw</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>25000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#6c6365</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#3e3539</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>

            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
