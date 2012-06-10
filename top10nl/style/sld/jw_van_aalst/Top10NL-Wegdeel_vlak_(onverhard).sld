<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
 <NamedLayer>
  <Name>pg_wegdl_vl_onverhard</Name>
  <UserStyle>
   <Title>pg_wegdl_vl_onverhard</Title>
   <FeatureTypeStyle>
    <Rule>
     <Name>half verhard</Name>
     <Title>half verhard</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>verhardingstype</ogc:PropertyName>
       <ogc:Literal>half verhard</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c8c7c8</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c8c7c8</CssParameter>
       <CssParameter name="stroke-width">0.19</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>onbekend</Name>
     <Title>onbekend</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>verhardingstype</ogc:PropertyName>
       <ogc:Literal>onbekend</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>onverhard</Name>
     <Title>onverhard</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>verhardingstype</ogc:PropertyName>
       <ogc:Literal>onverhard</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#c2c1c1</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#c2c1c1</CssParameter>
       <CssParameter name="stroke-width">0.19</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>verhard</Name>
     <Title>verhard</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>verhardingstype</ogc:PropertyName>
       <ogc:Literal>verhard</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
   </FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
