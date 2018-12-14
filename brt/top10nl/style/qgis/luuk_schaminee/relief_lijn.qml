<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="1.9.90-Alpha" minimumScale="0" maximumScale="100000" hasScaleBasedVisibilityFlag="1">
  <transparencyLevelInt>255</transparencyLevelInt>
  <renderer-v2 symbollevels="0" type="RuleRenderer" firstrule="0">
    <rules>
      <rule scalemaxdenom="0" description="" filter="SYMBOL =800" symbol="0" scalemindenom="0" label="kade of wal"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H =801 or SYMBOL =802" symbol="1" scalemindenom="0" label="talud, hoogteverschil"/>
    </rules>
    <symbols>
      <symbol outputUnit="MM" alpha="1" type="line" name="0">
        <layer pass="0" class="MarkerLine" locked="0">
          <prop k="interval" v="2"/>
          <prop k="offset" v="0"/>
          <prop k="placement" v="interval"/>
          <prop k="rotate" v="1"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="1">
        <layer pass="0" class="MarkerLine" locked="0">
          <prop k="interval" v="3"/>
          <prop k="offset" v="0"/>
          <prop k="placement" v="interval"/>
          <prop k="rotate" v="1"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="default">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="212,164,154,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.26"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="@0@0">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="315"/>
          <prop k="color" v="255,0,0,255"/>
          <prop k="color_border" v="0,0,0,255"/>
          <prop k="name" v="line"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="@1@0">
        <layer pass="0" class="FontMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="chr" v="u"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="font" v="ESRI ArcGIS TDN"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="20"/>
        </layer>
      </symbol>
    </symbols>
  </renderer-v2>
  <customproperties/>
  <displayfield>IDENTIFICA</displayfield>
  <label>0</label>
  <labelattributes>
    <label fieldname="" text="Label"/>
    <family fieldname="" name="MS Shell Dlg 2"/>
    <size fieldname="" units="pt" value="12"/>
    <bold fieldname="" on="0"/>
    <italic fieldname="" on="0"/>
    <underline fieldname="" on="0"/>
    <strikeout fieldname="" on="0"/>
    <color fieldname="" red="0" blue="0" green="0"/>
    <x fieldname=""/>
    <y fieldname=""/>
    <offset x="0" y="0" units="pt" yfieldname="" xfieldname=""/>
    <angle fieldname="" value="0" auto="0"/>
    <alignment fieldname="" value="center"/>
    <buffercolor fieldname="" red="255" blue="255" green="255"/>
    <buffersize fieldname="" units="pt" value="1"/>
    <bufferenabled fieldname="" on=""/>
    <multilineenabled fieldname="" on=""/>
    <selectedonly on=""/>
  </labelattributes>
  <edittypes>
    <edittype type="0" name="BRONACTUAL"/>
    <edittype type="0" name="BRONBESCHR"/>
    <edittype type="0" name="BRONNAUWKE"/>
    <edittype type="0" name="BRONTYPE"/>
    <edittype type="0" name="BRONTYPE_C"/>
    <edittype type="0" name="DIMENSIE"/>
    <edittype type="0" name="FUNCTIE"/>
    <edittype type="0" name="FUNCTIE_CO"/>
    <edittype type="0" name="GEOMETRIES"/>
    <edittype type="0" name="GEOMETRI_1"/>
    <edittype type="0" name="HOOGTE"/>
    <edittype type="0" name="HOOGTEKLAS"/>
    <edittype type="0" name="HOOGTEKL_1"/>
    <edittype type="0" name="HOOGTENIVE"/>
    <edittype type="0" name="IDENTIFICA"/>
    <edittype type="0" name="ID_NR"/>
    <edittype type="0" name="NAAM"/>
    <edittype type="0" name="OBJECTBEGI"/>
    <edittype type="0" name="OBJECTEIND"/>
    <edittype type="0" name="SHAPE_Leng"/>
    <edittype type="0" name="STATUS"/>
    <edittype type="0" name="STATUS_COD"/>
    <edittype type="0" name="SYMBOL"/>
    <edittype type="0" name="SYMBOL_H0"/>
    <edittype type="0" name="TDN_CODE"/>
    <edittype type="0" name="TYPERELIEF"/>
    <edittype type="0" name="TYPERELI_1"/>
    <edittype type="0" name="VERSIEBEGI"/>
    <edittype type="0" name="VERSIEEIND"/>
  </edittypes>
  <editform>.</editform>
  <editforminit></editforminit>
  <annotationform>.</annotationform>
  <attributeactions/>
  <overlay display="false" type="diagram">
    <renderer item_interpretation="linear">
      <diagramitem size="0" value="0"/>
      <diagramitem size="0" value="0"/>
    </renderer>
    <factory sizeUnits="MM" type="Pie">
      <wellknownname>Pie</wellknownname>
      <classificationfield>0</classificationfield>
    </factory>
    <scalingAttribute>0</scalingAttribute>
  </overlay>
</qgis>
