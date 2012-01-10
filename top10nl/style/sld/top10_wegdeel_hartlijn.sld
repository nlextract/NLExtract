<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <NamedLayer>
        <Name>wegdeel_hartlijn</Name>
        <UserStyle>
            <Name>normal</Name>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <Name>hoofdweg</Name>
                    <!-- use lines from these scales -->
                    <Title>hoofdweg</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typeweg</ogc:PropertyName>
                            <ogc:Literal>hoofdweg</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>500000</MaxScaleDenominator>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#000000</ogc:Literal>
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
                                <ogc:Literal>4.0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
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
                                <ogc:Literal>3.0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>nwegnummer</ogc:PropertyName>
                        </Label>
                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Helvetica</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-size">
                                <ogc:Literal>8.0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-style">
                                <ogc:Literal>normal</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>bold</ogc:Literal>
                            </CssParameter>
                        </Font>
                        <LabelPlacement>
                            <LinePlacement>
                                <PerpendicularOffset>
                                    <ogc:Literal>0.0</ogc:Literal>
                                </PerpendicularOffset>
                            </LinePlacement>
                        </LabelPlacement>
                        <Halo>
                            <Radius>
                                <ogc:Literal>1</ogc:Literal>
                            </Radius>
                            <Fill>
                                <CssParameter name="fill">
                                    <ogc:Literal>#ffffff</ogc:Literal>
                                </CssParameter>
                                <CssParameter name="fill-opacity">
                                    <ogc:Literal>0.7</ogc:Literal>
                                </CssParameter>
                            </Fill>
                        </Halo>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#000000</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                     <VendorOption name="group">yes</VendorOption>
                        <VendorOption name="spaceAround">5</VendorOption>
                    </TextSymbolizer>
                </Rule>
                <Rule>
                    <Name>straat</Name>
                    <!-- use lines from these scales -->
                    <Title>straat</Title>
                    <Abstract>straat</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typeweg</ogc:PropertyName>
                            <ogc:Literal>straat</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>25000</MaxScaleDenominator>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#111111</ogc:Literal>
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
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                     <LineSymbolizer>
                         <Stroke>
                             <CssParameter name="stroke">
                                 <ogc:Literal>#ffffff</ogc:Literal>
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
                                 <ogc:Literal>0.8</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-dashoffset">
                                 <ogc:Literal>0</ogc:Literal>
                             </CssParameter>
                         </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <Name>lokaal</Name>
                    <!-- use lines from these scales -->
                    <Title>overig</Title>
                    <Abstract>lokaal</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typeweg</ogc:PropertyName>
                            <ogc:Literal>lokale weg</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>50000</MaxScaleDenominator>
                    <LineSymbolizer>
                         <Stroke>
                             <CssParameter name="stroke">
                                 <ogc:Literal>#000000</ogc:Literal>
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
                                 <ogc:Literal>2.0</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-dashoffset">
                                 <ogc:Literal>0</ogc:Literal>
                             </CssParameter>
                         </Stroke>
                     </LineSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#f8f02d</ogc:Literal>
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
                                <ogc:Literal>1.6</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                </Rule>
                <Rule>
                    <Name>overig</Name>
                    <!-- use lines from these scales -->
                    <Title>overig</Title>
                    <Abstract>overig</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typeweg</ogc:PropertyName>
                            <ogc:Literal>overig</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>25000</MaxScaleDenominator>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#000000</ogc:Literal>
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
                                <ogc:Literal>1.8</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                    <LineSymbolizer>
                          <Stroke>
                              <CssParameter name="stroke">
                                  <ogc:Literal>#999999</ogc:Literal>
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
                                  <ogc:Literal>1.6</ogc:Literal>
                              </CssParameter>
                              <CssParameter name="stroke-dashoffset">
                                  <ogc:Literal>0</ogc:Literal>
                              </CssParameter>
                          </Stroke>
                      </LineSymbolizer>
                  </Rule>
                <Rule>
                    <Name>regionale weg</Name>
                    <!-- use lines from these scales -->
                    <Title>nweg</Title>
                    <Abstract>nweg</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>typeweg</ogc:PropertyName>
                             <ogc:Literal>regionale weg</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                   </ogc:Filter>
                    <MaxScaleDenominator>500000</MaxScaleDenominator>
                    <LineSymbolizer>
                         <Stroke>
                             <CssParameter name="stroke">
                                 <ogc:Literal>#000000</ogc:Literal>
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
                                 <ogc:Literal>3.0</ogc:Literal>
                             </CssParameter>
                             <CssParameter name="stroke-dashoffset">
                                 <ogc:Literal>0</ogc:Literal>
                             </CssParameter>
                         </Stroke>
                     </LineSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#fe8820</ogc:Literal>
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
                                <ogc:Literal>2.4</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>


                </Rule>
                <Rule>

                    <Name>Straatnamen</Name>
                    <Title>Straatnamen</Title>
                    <Abstract>Straatnamen</Abstract>
                    <MinScaleDenominator>500</MinScaleDenominator>
                    <MaxScaleDenominator>10000</MaxScaleDenominator>
                    <TextSymbolizer>
                        <Label>
                            <ogc:PropertyName>straatnaam</ogc:PropertyName>
                        </Label>
                        <Font>
                            <CssParameter name="font-family">
                                <ogc:Literal>Helvetica</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-size">
                                <ogc:Literal>10.0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-style">
                                <ogc:Literal>normal</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="font-weight">
                                <ogc:Literal>normal</ogc:Literal>
                            </CssParameter>
                        </Font>
                        <LabelPlacement>
                            <LinePlacement>
                                <PerpendicularOffset>
                                    <ogc:Literal>0.0</ogc:Literal>
                                </PerpendicularOffset>
                            </LinePlacement>
                        </LabelPlacement>
                        <Halo>
                            <Radius>
                                <ogc:Literal>1</ogc:Literal>
                            </Radius>
                            <Fill>
                                <CssParameter name="fill">
                                    <ogc:Literal>#ffffff</ogc:Literal>
                                </CssParameter>
                                <CssParameter name="fill-opacity">
                                    <ogc:Literal>0.7</ogc:Literal>
                                </CssParameter>
                            </Fill>
                        </Halo>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#000000</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                        <VendorOption name="spaceAround">5</VendorOption>
                        <!-- priority, grouping etc -->
                    </TextSymbolizer>
                </Rule>
                <Rule>
                    <Name>snelweg</Name>
                    <!-- use lines from these scales -->
                    <Title>snelweg</Title>
                    <Abstract>snelweg</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                             <ogc:PropertyName>typeweg</ogc:PropertyName>
                             <ogc:Literal>autosnelweg</ogc:Literal>
                         </ogc:PropertyIsEqualTo>
                   </ogc:Filter>
                    <MaxScaleDenominator>500000</MaxScaleDenominator>
                    <LineSymbolizer>
                          <Stroke>
                              <CssParameter name="stroke">
                                  <ogc:Literal>#222222</ogc:Literal>
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
                                  <ogc:Literal>6</ogc:Literal>
                              </CssParameter>
                              <CssParameter name="stroke-dashoffset">
                                  <ogc:Literal>0</ogc:Literal>
                              </CssParameter>
                          </Stroke>
                      </LineSymbolizer>
                    <LineSymbolizer>
                        <Stroke>
                            <CssParameter name="stroke">
                                <ogc:Literal>#8f3994</ogc:Literal>
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
                                <ogc:Literal>4</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="stroke-dashoffset">
                                <ogc:Literal>0</ogc:Literal>
                            </CssParameter>
                        </Stroke>
                    </LineSymbolizer>
                 </Rule>
                
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>

