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
                    <Name>aanlegsteiger</Name>
                    <Title>aanlegsteiger</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>aanlegsteiger</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#6d616c</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#3c383c</CssParameter>
                            <CssParameter name="stroke-width">0.12</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>akkerland</Name>
                    <Title>akkerland</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>akkerland</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#f5f3df</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#6c6c5a</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>basaltblokken, steenglooiing</Name>
                    <Title>basaltblokken, steenglooiing</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>basaltblokken, steenglooiing</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#5d626a</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#333335</CssParameter>
                            <CssParameter name="stroke-width">0.12</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>bebouwd gebied</Name>
                    <Title>bebouwd gebied</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bebouwd gebied</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#6b6365</CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>boomgaard</Name>
                    <Title>boomgaard</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>boomgaard</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#a6d69d</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#617063</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>boomkwekerij</Name>
                    <Title>boomkwekerij</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>boomkwekerij</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#a5cc83</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#616d58</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>bos: gemengd bos</Name>
                    <Title>bos: gemengd bos</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: gemengd bos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#96b68a</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#7a8a5c</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>bos: griend</Name>
                    <Title>bos: griend</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: griend</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#9cba88</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#4f5e46</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>bos: loofbos</Name>
                    <Title>bos: loofbos</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: loofbos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#9cbc86</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#788a65</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>bos: naaldbos</Name>
                    <Title>bos: naaldbos</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>bos: naaldbos</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#91b18d</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#738b6d</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>dodenakker</Name>
                    <Title>dodenakker</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>dodenakker</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#c0c09b</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#73765a</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>fruitkwekerij</Name>
                    <Title>fruitkwekerij</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>fruitkwekerij</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#b9e0a8</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#586852</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>grasland</Name>
                    <Title>grasland</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>grasland</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#deebc9</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#889479</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>heide</Name>
                    <Title>heide</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>heide</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#d4c8da</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#8b7381</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>overig</Name>
                    <Title>overig</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>overig</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#989194</CssParameter>
                        </Fill>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>populieren</Name>
                    <Title>populieren</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>populieren</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#a5c48c</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#4d5944</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>spoorbaanlichaam</Name>
                    <Title>spoorbaanlichaam</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>spoorbaanlichaam</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#737170</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#635a5b</CssParameter>
                            <CssParameter name="stroke-width">0.11</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>
                <Rule>
                    <Name>zand</Name>
                    <Title>zand</Title>
                    <ogc:Filter>
                        <ogc:PropertyIsEqualTo>
                            <ogc:PropertyName>typelandgebruik</ogc:PropertyName>
                            <ogc:Literal>zand</ogc:Literal>
                        </ogc:PropertyIsEqualTo>
                    </ogc:Filter>
                    <MaxScaleDenominator>100000</MaxScaleDenominator>
                    <PolygonSymbolizer>
                        <Fill>
                            <CssParameter name="fill">#f0e792</CssParameter>
                        </Fill>
                        <Stroke>
                            <CssParameter name="stroke">#8e8359</CssParameter>
                            <CssParameter name="stroke-width">0.1</CssParameter>
                        </Stroke>
                    </PolygonSymbolizer>
                </Rule>

            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>
