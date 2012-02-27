<?xml version="1.0" encoding="UTF-8"?>
<StyledLayerDescriptor xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.0.0" xmlns:xlink="http://www.w3.org/1999/xlink" xsi:schemaLocation="http://www.opengis.net/sld StyledLayerDescriptor.xsd">
 <NamedLayer>
  <Name>pg_wegdl_vl_fiets_voet</Name>
  <UserStyle>
   <Title>pg_wegdl_vl_fiets_voet</Title>
   <FeatureTypeStyle>
    <Rule>
     <Name>(1:busverkeer)</Name>
     <Title>(1:busverkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:busverkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#e8fd5e</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#e8fd5e</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:fietsers, bromfietsers)</Name>
     <Title>(1:fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#d7b7b7</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#d7b7b7</CssParameter>
       <CssParameter name="stroke-width">0.12</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:gemengd verkeer)</Name>
     <Title>(1:gemengd verkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:gemengd verkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:overig)</Name>
     <Title>(1:overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:parkeren)</Name>
     <Title>(1:parkeren)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:parkeren)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:parkeren: carpoolplaats)</Name>
     <Title>(1:parkeren: carpoolplaats)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:parkeren: carpoolplaats)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:parkeren: P+R parkeerplaats)</Name>
     <Title>(1:parkeren: P+R parkeerplaats)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:parkeren: P+R parkeerplaats)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:ruiters)</Name>
     <Title>(1:ruiters)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:ruiters)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#917f71</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#5e4537</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(1:snelverkeer)</Name>
     <Title>(1:snelverkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:snelverkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:vliegverkeer)</Name>
     <Title>(1:vliegverkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:vliegverkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(1:voetgangers)</Name>
     <Title>(1:voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(1:voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cdabaa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#cdabaa</CssParameter>
       <CssParameter name="stroke-width">0.18</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:busverkeer,fietsers, bromfietsers)</Name>
     <Title>(2:busverkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:busverkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#e8fd5e</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#e8fd5e</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:busverkeer,gemengd verkeer)</Name>
     <Title>(2:busverkeer,gemengd verkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:busverkeer,gemengd verkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#eafd7e</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#eafd7e</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:busverkeer,overig)</Name>
     <Title>(2:busverkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:busverkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#edfc85</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#ffff7f</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:busverkeer,voetgangers)</Name>
     <Title>(2:busverkeer,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:busverkeer,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#edfc85</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#edfc85</CssParameter>
       <CssParameter name="stroke-width">0.1</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:fietsers, bromfietsers,overig)</Name>
     <Title>(2:fietsers, bromfietsers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:fietsers, bromfietsers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:fietsers, bromfietsers,ruiters)</Name>
     <Title>(2:fietsers, bromfietsers,ruiters)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:fietsers, bromfietsers,ruiters)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:fietsers, bromfietsers,voetgangers)</Name>
     <Title>(2:fietsers, bromfietsers,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:fietsers, bromfietsers,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cdabaa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#cdabaa</CssParameter>
       <CssParameter name="stroke-width">0.14</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:gemengd verkeer,fietsers, bromfietsers)</Name>
     <Title>(2:gemengd verkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:gemengd verkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cdabaa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#cdabaa</CssParameter>
       <CssParameter name="stroke-width">0.18</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:gemengd verkeer,overig)</Name>
     <Title>(2:gemengd verkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:gemengd verkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:gemengd verkeer,ruiters)</Name>
     <Title>(2:gemengd verkeer,ruiters)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:gemengd verkeer,ruiters)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:gemengd verkeer,voetgangers)</Name>
     <Title>(2:gemengd verkeer,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:gemengd verkeer,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cdabaa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#cdabaa</CssParameter>
       <CssParameter name="stroke-width">0.18</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(2:snelverkeer,busverkeer)</Name>
     <Title>(2:snelverkeer,busverkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:snelverkeer,busverkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:snelverkeer,fietsers, bromfietsers)</Name>
     <Title>(2:snelverkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:snelverkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:snelverkeer,gemengd verkeer)</Name>
     <Title>(2:snelverkeer,gemengd verkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:snelverkeer,gemengd verkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:snelverkeer,overig)</Name>
     <Title>(2:snelverkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:snelverkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:snelverkeer,voetgangers)</Name>
     <Title>(2:snelverkeer,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:snelverkeer,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:vliegverkeer,gemengd verkeer)</Name>
     <Title>(2:vliegverkeer,gemengd verkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:vliegverkeer,gemengd verkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:vliegverkeer,overig)</Name>
     <Title>(2:vliegverkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:vliegverkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(2:voetgangers,overig)</Name>
     <Title>(2:voetgangers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(2:voetgangers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#cdabaa</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#cdabaa</CssParameter>
       <CssParameter name="stroke-width">0.18</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:busverkeer,fietsers, bromfietsers,overig)</Name>
     <Title>(3:busverkeer,fietsers, bromfietsers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:busverkeer,fietsers, bromfietsers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:busverkeer,fietsers, bromfietsers,voetgangers)</Name>
     <Title>(3:busverkeer,fietsers, bromfietsers,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:busverkeer,fietsers, bromfietsers,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:busverkeer,gemengd verkeer,fietsers, bromfietsers)</Name>
     <Title>(3:busverkeer,gemengd verkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:busverkeer,gemengd verkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:busverkeer,gemengd verkeer,overig)</Name>
     <Title>(3:busverkeer,gemengd verkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:busverkeer,gemengd verkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:busverkeer,gemengd verkeer,voetgangers)</Name>
     <Title>(3:busverkeer,gemengd verkeer,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:busverkeer,gemengd verkeer,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:fietsers, bromfietsers,voetgangers,overig)</Name>
     <Title>(3:fietsers, bromfietsers,voetgangers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:fietsers, bromfietsers,voetgangers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:gemengd verkeer,fietsers, bromfietsers,overig)</Name>
     <Title>(3:gemengd verkeer,fietsers, bromfietsers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:gemengd verkeer,fietsers, bromfietsers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:gemengd verkeer,fietsers, bromfietsers,parkeren: P+R parkeerplaats)</Name>
     <Title>(3:gemengd verkeer,fietsers, bromfietsers,parkeren: P+R parkeerplaats)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:gemengd verkeer,fietsers, bromfietsers,parkeren: P+R parkeerplaats)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:gemengd verkeer,fietsers, bromfietsers,voetgangers)</Name>
     <Title>(3:gemengd verkeer,fietsers, bromfietsers,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:gemengd verkeer,fietsers, bromfietsers,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:gemengd verkeer,voetgangers,overig)</Name>
     <Title>(3:gemengd verkeer,voetgangers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:gemengd verkeer,voetgangers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer/>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,busverkeer,fietsers, bromfietsers)</Name>
     <Title>(3:snelverkeer,busverkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,busverkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,busverkeer,gemengd verkeer)</Name>
     <Title>(3:snelverkeer,busverkeer,gemengd verkeer)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,busverkeer,gemengd verkeer)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,busverkeer,overig)</Name>
     <Title>(3:snelverkeer,busverkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,busverkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,fietsers, bromfietsers,overig)</Name>
     <Title>(3:snelverkeer,fietsers, bromfietsers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,fietsers, bromfietsers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,fietsers, bromfietsers,voetgangers)</Name>
     <Title>(3:snelverkeer,fietsers, bromfietsers,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,fietsers, bromfietsers,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,gemengd verkeer,fietsers, bromfietsers)</Name>
     <Title>(3:snelverkeer,gemengd verkeer,fietsers, bromfietsers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,gemengd verkeer,fietsers, bromfietsers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,gemengd verkeer,overig)</Name>
     <Title>(3:snelverkeer,gemengd verkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,gemengd verkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:snelverkeer,gemengd verkeer,voetgangers)</Name>
     <Title>(3:snelverkeer,gemengd verkeer,voetgangers)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:snelverkeer,gemengd verkeer,voetgangers)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(3:vliegverkeer,gemengd verkeer,overig)</Name>
     <Title>(3:vliegverkeer,gemengd verkeer,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(3:vliegverkeer,gemengd verkeer,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:gemengd verkeer,fietsers, bromfietsers,voetgangers,overig)</Name>
     <Title>(4:gemengd verkeer,fietsers, bromfietsers,voetgangers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(4:gemengd verkeer,fietsers, bromfietsers,voetgangers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:snelverkeer,fietsers, bromfietsers,voetgangers,overig)</Name>
     <Title>(4:snelverkeer,fietsers, bromfietsers,voetgangers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(4:snelverkeer,fietsers, bromfietsers,voetgangers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
    <Rule>
     <Name>(4:snelverkeer,gemengd verkeer,fietsers, bromfietsers,overig)</Name>
     <Title>(4:snelverkeer,gemengd verkeer,fietsers, bromfietsers,overig)</Title>
     <ogc:Filter>
      <ogc:PropertyIsEqualTo>
       <ogc:PropertyName>hoofdverkeersgebruik</ogc:PropertyName>
       <ogc:Literal>(4:snelverkeer,gemengd verkeer,fietsers, bromfietsers,overig)</ogc:Literal>
      </ogc:PropertyIsEqualTo>
     </ogc:Filter>
     <PolygonSymbolizer>
      <Fill>
       <CssParameter name="fill">#91cf60</CssParameter>
      </Fill>
      <Stroke>
       <CssParameter name="stroke">#000000</CssParameter>
       <CssParameter name="stroke-width">0.26</CssParameter>
      </Stroke>
     </PolygonSymbolizer>
    </Rule>
   </FeatureTypeStyle>
  </UserStyle>
 </NamedLayer>
</StyledLayerDescriptor>
