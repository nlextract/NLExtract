<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor version="1.0.0" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd"
                       xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc"
                       xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <NamedLayer>
        <Name>terrein_vlak</Name>
        <UserStyle>
            <Name>normal</Name>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <Name>Akkerland</Name>
                    <Title>Akkerland</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>akkerland</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                     <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#FCF8EE</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Bebouwdgebied</Name>
                    <Title>Bebouwd gebied</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bebouwd gebied</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#fa280b</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
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
                                   <ogc:Literal>0.1</ogc:Literal>
                               </CssParameter>
                               <CssParameter name="stroke-dashoffset">
                                   <ogc:Literal>0</ogc:Literal>
                               </CssParameter>
                           </Stroke>
                       </LineSymbolizer>
                   </Rule>

                <Rule>
                    <Name>Boomgaard</Name>
                    <Title>Boomgaard</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>boomgaard</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#9AE75F</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Boomkwekerij</Name>
                    <Title>Boomkwekerij</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>boomkwekerij</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#9AE75F</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Dodenakker</Name>
                    <Title>Dodenakker</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>dodenakker</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#B7C3BF</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Fruitkwekerij</Name>
                    <Title>Fruitkwekerij</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>fruitkwekerij</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#9AE75F</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>GemengdLoofNaaldbos</Name>
                    <Title>gemengd loof naaldbos</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: gemengd bos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#ABD09B</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                    <LineSymbolizer>
                           <Stroke>
                               <CssParameter name="stroke">
                                   <ogc:Literal>#119c0a</ogc:Literal>
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
                                   <ogc:Literal>0.1</ogc:Literal>
                               </CssParameter>
                               <CssParameter name="stroke-dashoffset">
                                   <ogc:Literal>0</ogc:Literal>
                               </CssParameter>
                           </Stroke>
                       </LineSymbolizer>
                   </Rule>
                <Rule>
                    <Name>Grasland</Name>
                    <Title>Grasland</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>grasland</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#FCF8EE</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Griend</Name>
                    <!-- soort bos, moerasachtig -->
                    <Title>Griend</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: griend</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#B0D6A0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Heide</Name>
                    <Title>Heide</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>heide</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#F5CFEF</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>loofbos</Name>
                    <Title>loofbos</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: loofbos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#B0D6A0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                    <LineSymbolizer>
                            <Stroke>
                                <CssParameter name="stroke">
                                    <ogc:Literal>#119c0a</ogc:Literal>
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
                                    <ogc:Literal>0.1</ogc:Literal>
                                </CssParameter>
                                <CssParameter name="stroke-dashoffset">
                                    <ogc:Literal>0</ogc:Literal>
                                </CssParameter>
                            </Stroke>
                        </LineSymbolizer>
                    </Rule>
                <Rule>
                    <Name>Naaldbos</Name>
                    <Title>Naaldbos</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: naaldbos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#A7CC95</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                    <LineSymbolizer>
                            <Stroke>
                                <CssParameter name="stroke">
                                    <ogc:Literal>#119c0a</ogc:Literal>
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
                                    <ogc:Literal>0.1</ogc:Literal>
                                </CssParameter>
                                <CssParameter name="stroke-dashoffset">
                                    <ogc:Literal>0</ogc:Literal>
                                </CssParameter>
                            </Stroke>
                        </LineSymbolizer>
                    </Rule>
                <Rule>
                    <Name>Steenglooiing</Name>
                    <Title>Steenglooiing</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>basaltblokken, steenglooiing</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#BBBBBB</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>Populierenopstand</Name>
                    <Title>Populierenopstand</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>populieren</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#B0D6A0</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>


                <Rule>
                    <Name>Zand</Name>
                    <Title>Zand</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>zand</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#F1F5AD</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>OverigBodemgebruik</Name>
                    <Title>Overig bodemgebruik</Title>
                    <Abstract>Abstract</Abstract>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>overig</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <!-- change this -->
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">
                                <ogc:Literal>#999999</ogc:Literal>
                            </CssParameter>
                            <CssParameter name="fill-opacity">
                                <ogc:Literal>1.0</ogc:Literal>
                            </CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
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
                                   <ogc:Literal>0.1</ogc:Literal>
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
