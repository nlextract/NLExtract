<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
 <NamedLayer>
  <Name>pg_waterdeel_vlak</Name>
  <UserStyle>
   <Title>pg_waterdeel_vlak</Title>
   <FeatureTypeStyle>
    <Rule>
     <Name>droogvallend</Name>
     <Title>droogvallend</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>TYPEWATER</ogc:PropertyName>
       <ogc:Literal>droogvallend</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cddbe7</CssParameter>
      </Fill>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>meer, plas, ven, vijver</Name>
     <Title>meer, plas, ven, vijver</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>TYPEWATER</ogc:PropertyName>
       <ogc:Literal>meer, plas, ven, vijver</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#94cceb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#94cceb</CssParameter>
       <CssParameter name="stroke-width">0.12</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>waterloop</Name>
     <Title>waterloop</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>TYPEWATER</ogc:PropertyName>
       <ogc:Literal>waterloop</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#94cceb</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#94cceb</CssParameter>
       <CssParameter name="stroke-width">0.12</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>zee</Name>
     <Title>zee</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>TYPEWATER</ogc:PropertyName>
       <ogc:Literal>zee</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#93cae1</CssParameter>
      </Fill>
     </PolygonSymbolizer>
    </Rule>
   </FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
