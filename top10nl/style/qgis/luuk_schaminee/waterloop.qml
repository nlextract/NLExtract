<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="1.9.90-Alpha" minimumScale="0" maximumScale="50000" hasScaleBasedVisibilityFlag="1">
  <transparencyLevelInt>255</transparencyLevelInt>
  <renderer-v2 symbollevels="0" type="RuleRenderer" firstrule="0">
    <rules>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 =207" symbol="0" scalemindenom="0" label="0,5 - 3 meter"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 =203" symbol="1" scalemindenom="0" label="3 - 6 meter"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 >=204 AND SYMBOL_H0 &lt;=206" symbol="2" scalemindenom="0" label="overig"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 >=208 AND SYMBOL_H0 &lt;=211" symbol="3" scalemindenom="0" label="duiker"/>
    </rules>
    <symbols>
      <symbol outputUnit="MM" alpha="1" type="line" name="0">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="115,223,255,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.26"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="1">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="0,197,255,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.52"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="2">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="115,223,255,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="dot"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.26"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="3">
        <layer pass="0" class="MarkerLine" locked="0">
          <prop k="interval" v="3"/>
          <prop k="offset" v="0"/>
          <prop k="placement" v="firstvertex"/>
          <prop k="rotate" v="1"/>
        </layer>
        <layer pass="0" class="MarkerLine" locked="0">
          <prop k="interval" v="3"/>
          <prop k="offset" v="0"/>
          <prop k="placement" v="lastvertex"/>
          <prop k="rotate" v="1"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="default">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="142,31,94,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.26"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="@3@0">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="180"/>
          <prop k="color" v="255,0,0,255"/>
          <prop k="color_border" v="0,0,0,255"/>
          <prop k="name" v="arrowhead"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="marker" name="@3@1">
        <layer pass="0" class="SimpleMarker" locked="0">
          <prop k="angle" v="0"/>
          <prop k="color" v="255,0,0,255"/>
          <prop k="color_border" v="0,0,0,255"/>
          <prop k="name" v="arrowhead"/>
          <prop k="offset" v="0,0"/>
          <prop k="size" v="2"/>
        </layer>
      </symbol>
    </symbols>
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
    <edittype type="0" name="BREEDTE"/>
    <edittype type="0" name="BREEDTEKLA"/>
    <edittype type="0" name="BREEDTEK_1"/>
    <edittype type="0" name="BRONACTUAL"/>
    <edittype type="0" name="BRONBESCHR"/>
    <edittype type="0" name="BRONNAUWKE"/>
    <edittype type="0" name="BRONTYPE"/>
    <edittype type="0" name="BRONTYPE_C"/>
    <edittype type="0" name="BRUGNAAM"/>
    <edittype type="0" name="DIMENSIE"/>
    <edittype type="0" name="FUNCTIE"/>
    <edittype type="0" name="FUNCTIE_CO"/>
    <edittype type="0" name="FYSIEKVOOR"/>
    <edittype type="0" name="FYSIEKVO_1"/>
    <edittype type="0" name="HOOFDAFWAT"/>
    <edittype type="0" name="HOOGTENIVE"/>
    <edittype type="0" name="IDENTIFICA"/>
    <edittype type="0" name="ID_NR"/>
    <edittype type="0" name="NAAM"/>
    <edittype type="0" name="OBJECTBEGI"/>
    <edittype type="0" name="OBJECTEIND"/>
    <edittype type="0" name="OBJECTID"/>
    <edittype type="0" name="SCHEEPSLAA"/>
    <edittype type="0" name="SHAPE_Leng"/>
    <edittype type="0" name="SLUISNAAM"/>
    <edittype type="0" name="STATUS"/>
    <edittype type="0" name="STATUS_COD"/>
    <edittype type="0" name="STROOMRICH"/>
    <edittype type="0" name="STROOMRI_1"/>
    <edittype type="0" name="SYMBOL"/>
    <edittype type="0" name="SYMBOL_H0"/>
    <edittype type="0" name="TDN_CODE"/>
    <edittype type="0" name="TYPEINFRAS"/>
    <edittype type="0" name="TYPEINFR_1"/>
    <edittype type="0" name="TYPEWATER"/>
    <edittype type="0" name="TYPEWATER_"/>
    <edittype type="0" name="VERSIEBEGI"/>
    <edittype type="0" name="VERSIEEIND"/>
    <edittype type="0" name="VOORKOMENW"/>
    <edittype type="0" name="VOORKOME_1"/>
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
