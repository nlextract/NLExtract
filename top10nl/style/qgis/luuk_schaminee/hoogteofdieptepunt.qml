<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="1.9.90-Alpha" minimumScale="0" maximumScale="1e+08" hasScaleBasedVisibilityFlag="0">
  <transparencyLevelInt>255</transparencyLevelInt>
  <renderer-v2 attr="TYPERELIEF" symbollevels="0" type="categorizedSymbol">
    <categories>
      <category symbol="0" value="2" label="dieptepunt"/>
      <category symbol="1" value="4" label="hoogtepunt"/>
      <category symbol="2" value="8" label="peil"/>
    </categories>
    <symbols>
      <symbol outputUnit="MM" alpha="1" type="marker" name="0">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="0,0,255,255"/>
          <prop k="color_border" v="0,0,255,255"/>
          <prop k="name" v="cross"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="1">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="158,56,0,255"/>
          <prop k="color_border" v="158,56,0,255"/>
          <prop k="name" v="cross"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="2">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="115,0,76,255"/>
          <prop k="color_border" v="115,0,76,255"/>
          <prop k="name" v="cross"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
    </symbols>
    <rotation field=""/>
    <sizescale field=""/>
  </renderer-v2>
  <customproperties/>
  <displayfield>OBJECTID</displayfield>
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
    <edittype type="0" name="HOOGTE"/>
    <edittype type="0" name="HOOGTEKLAS"/>
    <edittype type="0" name="HOOGTEKL_1"/>
    <edittype type="0" name="HOOGTENIVE"/>
    <edittype type="0" name="IDENTIFICA"/>
    <edittype type="0" name="ID_NR"/>
    <edittype type="0" name="NAAM"/>
    <edittype type="0" name="OBJECTBEGI"/>
    <edittype type="0" name="OBJECTEIND"/>
    <edittype type="0" name="OBJECTID"/>
    <edittype type="0" name="STATUS"/>
    <edittype type="0" name="STATUS_COD"/>
    <edittype type="0" name="SYMBOL"/>
    <edittype type="0" name="TDN_CODE"/>
    <edittype type="0" name="TYPERELIEF"/>
    <edittype type="0" name="TYPERELI_1"/>
    <edittype type="0" name="VERSIEBEGI"/>
    <edittype type="0" name="VERSIEEIND"/>
  </edittypes>
  <editform></editform>
  <editforminit></editforminit>
  <annotationform></annotationform>
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
