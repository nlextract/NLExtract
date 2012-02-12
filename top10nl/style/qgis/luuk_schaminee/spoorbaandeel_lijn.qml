<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="1.9.90-Alpha" minimumScale="0" maximumScale="1e+08" hasScaleBasedVisibilityFlag="0">
  <transparencyLevelInt>255</transparencyLevelInt>
  <renderer-v2 symbollevels="0" type="RuleRenderer" firstrule="1">
    <rules>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 = 400 or SYMBOL_H0 = 401" symbol="0" scalemindenom="0" label="trein"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 = 402" symbol="1" scalemindenom="0" label="metro"/>
      <rule scalemaxdenom="0" description="" filter="SYMBOL_H0 = 403" symbol="2" scalemindenom="0" label="tram"/>
    </rules>
    <symbols>
      <symbol outputUnit="MM" alpha="1" type="line" name="0">
        <layer pass="0" class="SimpleLine" locked="1">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="0,0,0,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="3"/>
        </layer>
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="flat"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="customdash" v="4;2"/>
          <prop k="joinstyle" v="round"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="dot"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="1">
        <layer pass="0" class="SimpleLine" locked="1">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="156,156,156,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="2.5"/>
        </layer>
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="230,152,0,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="1.875"/>
        </layer>
        <layer pass="0" class="SimpleLine" locked="1">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="dot"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="2">
        <layer pass="0" class="SimpleLine" locked="1">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="178,178,178,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="2.5"/>
        </layer>
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="255,211,127,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="1.875"/>
        </layer>
        <layer pass="0" class="SimpleLine" locked="1">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="255,255,255,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="dot"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="2"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="line" name="default">
        <layer pass="0" class="SimpleLine" locked="0">
          <prop k="capstyle" v="square"/>
          <prop k="color" v="129,16,227,255"/>
          <prop k="customdash" v="5;2"/>
          <prop k="joinstyle" v="bevel"/>
          <prop k="offset" v="0"/>
          <prop k="penstyle" v="solid"/>
          <prop k="use_custom_dash" v="0"/>
          <prop k="width" v="0.26"/>
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
    <edittype type="0" name="AANTALSPOR"/>
    <edittype type="0" name="BAANVAKNAA"/>
    <edittype type="0" name="BRONACTUAL"/>
    <edittype type="0" name="BRONBESCHR"/>
    <edittype type="0" name="BRONNAUWKE"/>
    <edittype type="0" name="BRONTYPE"/>
    <edittype type="0" name="BRONTYPE_C"/>
    <edittype type="0" name="BRUGNAAM"/>
    <edittype type="0" name="DIMENSIE"/>
    <edittype type="0" name="ELECTRIFIC"/>
    <edittype type="0" name="ELEKTRIFIC"/>
    <edittype type="0" name="FYSIEKVOOR"/>
    <edittype type="0" name="FYSIEKVO_1"/>
    <edittype type="0" name="HOOGTENIVE"/>
    <edittype type="0" name="IDENTIFICA"/>
    <edittype type="0" name="ID_NR"/>
    <edittype type="0" name="OBJECTBEGI"/>
    <edittype type="0" name="OBJECTEIND"/>
    <edittype type="0" name="SHAPE_Leng"/>
    <edittype type="0" name="SPOORBREED"/>
    <edittype type="0" name="SPOORBRE_1"/>
    <edittype type="0" name="STATUS"/>
    <edittype type="0" name="STATUS_COD"/>
    <edittype type="0" name="SYMBOL"/>
    <edittype type="0" name="SYMBOL_H0"/>
    <edittype type="0" name="TDN_CODE"/>
    <edittype type="0" name="TUNNELNAAM"/>
    <edittype type="0" name="TYPEINFRAS"/>
    <edittype type="0" name="TYPEINFR_1"/>
    <edittype type="0" name="TYPESPOORB"/>
    <edittype type="0" name="TYPESPOO_1"/>
    <edittype type="0" name="VERSIEBEGI"/>
    <edittype type="0" name="VERSIEEIND"/>
    <edittype type="0" name="VERVOERFUN"/>
    <edittype type="0" name="VERVOERF_1"/>
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
