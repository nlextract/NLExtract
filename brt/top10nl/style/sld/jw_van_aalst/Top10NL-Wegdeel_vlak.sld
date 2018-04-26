<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
 <NamedLayer>
  <Name>pg_wegdl_vl_auto</Name>
  <UserStyle>
   <Title>pg_wegdl_vl_auto</Title>
   <FeatureTypeStyle>
    <Rule>
     <Name>(1:autosnelweg)</Name>
     <Title>(1:autosnelweg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:autosnelweg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:hoofdweg)</Name>
     <Title>(1:hoofdweg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:hoofdweg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:lokale weg)</Name>
     <Title>(1:lokale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:lokale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#fafafa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:overig)</Name>
     <Title>(1:overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f9f8f9</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:regionale weg)</Name>
     <Title>(1:regionale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:regionale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:straat)</Name>
     <Title>(1:straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#fbfafb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:autosnelweg,hoofdweg)</Name>
     <Title>(2:autosnelweg,hoofdweg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:autosnelweg,hoofdweg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:autosnelweg,lokale weg)</Name>
     <Title>(2:autosnelweg,lokale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:autosnelweg,lokale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:autosnelweg,overig)</Name>
     <Title>(2:autosnelweg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:autosnelweg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:autosnelweg,regionale weg)</Name>
     <Title>(2:autosnelweg,regionale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:autosnelweg,regionale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:hoofdweg,lokale weg)</Name>
     <Title>(2:hoofdweg,lokale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:hoofdweg,lokale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:hoofdweg,overig)</Name>
     <Title>(2:hoofdweg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:hoofdweg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:hoofdweg,regionale weg)</Name>
     <Title>(2:hoofdweg,regionale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:hoofdweg,regionale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:hoofdweg,straat)</Name>
     <Title>(2:hoofdweg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:hoofdweg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:lokale weg,overig)</Name>
     <Title>(2:lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#ffffff</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:lokale weg,straat)</Name>
     <Title>(2:lokale weg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:lokale weg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#fbfafb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:regionale weg,lokale weg)</Name>
     <Title>(2:regionale weg,lokale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:regionale weg,lokale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:regionale weg,overig)</Name>
     <Title>(2:regionale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:regionale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:regionale weg,straat)</Name>
     <Title>(2:regionale weg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:regionale weg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:straat,overig)</Name>
     <Title>(2:straat,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:straat,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#fbfafb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,lokale weg,overig)</Name>
     <Title>(3:hoofdweg,lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,regionale weg,lokale weg)</Name>
     <Title>(3:hoofdweg,regionale weg,lokale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,regionale weg,lokale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,regionale weg,overig)</Name>
     <Title>(3:hoofdweg,regionale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,regionale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,straat,overig)</Name>
     <Title>(3:hoofdweg,straat,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,straat,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:lokale weg,straat,overig)</Name>
     <Title>(3:lokale weg,straat,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:lokale weg,straat,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#fbfafb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#fbfafb</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:regionale weg,lokale weg,overig)</Name>
     <Title>(3:regionale weg,lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:regionale weg,lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:regionale weg,lokale weg,straat)</Name>
     <Title>(3:regionale weg,lokale weg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:regionale weg,lokale weg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:regionale weg,straat,overig)</Name>
     <Title>(3:regionale weg,straat,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:regionale weg,straat,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:autosnelweg,straat)</Name>
     <Title>(2:autosnelweg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:autosnelweg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:startbaan, landingsbaan,rolbaan, platform)</Name>
     <Title>(2:startbaan, landingsbaan,rolbaan, platform)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:startbaan, landingsbaan,rolbaan, platform)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f2f6fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f2f6fa</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,hoofdweg,overig)</Name>
     <Title>(3:autosnelweg,hoofdweg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,hoofdweg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,hoofdweg,regionale weg)</Name>
     <Title>(3:autosnelweg,hoofdweg,regionale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,hoofdweg,regionale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,hoofdweg,straat)</Name>
     <Title>(3:autosnelweg,hoofdweg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,hoofdweg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,lokale weg,overig)</Name>
     <Title>(3:autosnelweg,lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,lokale weg,regionale weg)</Name>
     <Title>(3:autosnelweg,lokale weg,regionale weg)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,lokale weg,regionale weg)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:autosnelweg,regionale weg,overig)</Name>
     <Title>(3:autosnelweg,regionale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:autosnelweg,regionale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,regionale weg,straat)</Name>
     <Title>(3:hoofdweg,regionale weg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,regionale weg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:autosnelweg,regionale weg,lokale weg,overig)</Name>
     <Title>(4:autosnelweg,regionale weg,lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(4:autosnelweg,regionale weg,lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#7644d2</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#7644d2</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:startbaan, landingsbaan,rolbaan, platform,overig)</Name>
     <Title>(3:startbaan, landingsbaan,rolbaan, platform,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:startbaan, landingsbaan,rolbaan, platform,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f2f6fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f2f6fa</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:hoofdweg,regionale weg,lokale weg,overig)</Name>
     <Title>(4:hoofdweg,regionale weg,lokale weg,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(4:hoofdweg,regionale weg,lokale weg,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:regionale weg,lokale weg,straat,overig)</Name>
     <Title>(4:regionale weg,lokale weg,straat,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(4:regionale weg,lokale weg,straat,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f4bc37</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f4bc37</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:startbaan, landingsbaan)</Name>
     <Title>(1:startbaan, landingsbaan)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:startbaan, landingsbaan)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f0f6fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f2f6fa</CssParameter>
       <CssParameter name="stroke-width">0.19</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:rolbaan, platform)</Name>
     <Title>(1:rolbaan, platform)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(1:rolbaan, platform)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#eef2f8</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f0f4f8</CssParameter>
       <CssParameter name="stroke-width">0.19</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:startbaan, landingsbaan,overig)</Name>
     <Title>(2:startbaan, landingsbaan,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:startbaan, landingsbaan,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f0f5fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f0f5fa</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:rolbaan, platform,overig)</Name>
     <Title>(2:rolbaan, platform,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(2:rolbaan, platform,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f0f5fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f0f5fa</CssParameter>
       <CssParameter name="stroke-width">0.19</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>nog een</Name>
     <Title>nog een</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:rolbaan, platform,overig,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#f0f5fa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#f0f5fa</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:hoofdweg,lokale weg,straat)</Name>
     <Title>(3:hoofdweg,lokale weg,straat)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>typeweg</ogc:PropertyName>
       <ogc:Literal>(3:hoofdweg,lokale weg,straat)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c74143</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c74143</CssParameter>
       <CssParameter name="stroke-width">0.17</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
   </FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
