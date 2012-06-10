<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
 <NamedLayer>
  <Name>pg_gebouw_vlak</Name>
  <UserStyle>
   <Title>pg_gebouw_vlak</Title>
   <FeatureTypeStyle>
    <Rule>
     <Name>hoogbouw</Name>
     <Title>hoogbouw</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoogteklasse</ogc:PropertyName>
       <ogc:Literal>hoogbouw</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
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
