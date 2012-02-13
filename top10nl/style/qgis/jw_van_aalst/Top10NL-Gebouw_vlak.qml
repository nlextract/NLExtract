<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis version="1.7.3-Wroclaw" minimumScale="0" maximumScale="1e+08" hasScaleBasedVisibilityFlag="0">
  <transparencyLevelInt>255</transparencyLevelInt>
  <renderer-v2 attr="hoogteklasse" symbollevels="0" type="categorizedSymbol">
    <categories>
      <category symbol="0" value="hoogbouw" label="hoogbouw"/>
      <category symbol="1" value="laagbouw" label="laagbouw"/>
      <category symbol="2" value="onbekend" label="onbekend"/>
    </categories>
    <symbols>
      <symbol outputUnit="MM" alpha="1" type="fill" name="0">
        <layer pass="0" class="SimpleFill" locked="0">
          <prop k="color" v="73,62,64,255"/>
          <prop k="color_border" v="57,45,48,255"/>
          <prop k="offset" v="0,0"/>
          <prop k="style" v="solid"/>
          <prop k="style_border" v="solid"/>
          <prop k="width_border" v="0.12"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="fill" name="1">
        <layer pass="0" class="SimpleFill" locked="0">
          <prop k="color" v="108,99,101,255"/>
          <prop k="color_border" v="62,53,57,255"/>
          <prop k="offset" v="0,0"/>
          <prop k="style" v="solid"/>
          <prop k="style_border" v="solid"/>
          <prop k="width_border" v="0.1"/>
        </layer>
      </symbol>
      <symbol outputUnit="MM" alpha="1" type="fill" name="2">
        <layer pass="0" class="SimpleFill" locked="0">
          <prop k="color" v="108,99,101,255"/>
          <prop k="color_border" v="62,53,57,255"/>
          <prop k="offset" v="0,0"/>
          <prop k="style" v="solid"/>
          <prop k="style_border" v="solid"/>
          <prop k="width_border" v="0.08"/>
        </layer>
      </symbol>
    </symbols>
    <source-symbol>
      <symbol outputUnit="MM" alpha="1" type="fill" name="0">
        <layer pass="0" class="SimpleFill" locked="0">
          <prop k="color" v="113,30,138,255"/>
          <prop k="color_border" v="0,0,0,255"/>
          <prop k="offset" v="0,0"/>
          <prop k="style" v="solid"/>
          <prop k="style_border" v="solid"/>
          <prop k="width_border" v="0.26"/>
        </layer>
      </symbol>
    </source-symbol>
    <colorramp type="colorbrewer" name="[source]">
      <prop k="colors" v="3"/>
      <prop k="schemeName" v="RdYlGn"/>
    </colorramp>
    <rotation field=""/>
    <sizescale field=""/>
  </renderer-v2>
  <customproperties/>
  <displayfield>gml_id</displayfield>
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
    <edittype type="0" name="bronactual"/>
    <edittype type="0" name="bronactualiteit"/>
    <edittype type="0" name="bronbeschr"/>
    <edittype type="0" name="bronbeschrijving"/>
    <edittype type="0" name="bronnauwke"/>
    <edittype type="0" name="bronnauwkeurigheid"/>
    <edittype type="0" name="brontype"/>
    <edittype type="0" name="dimensie"/>
    <edittype type="0" name="fid"/>
    <edittype type="0" name="gml_id"/>
    <edittype type="0" name="hoogteklas"/>
    <edittype type="0" name="hoogteklasse"/>
    <edittype type="0" name="hoogtenive"/>
    <edittype type="0" name="hoogteniveau"/>
    <edittype type="0" name="identifica"/>
    <edittype type="0" name="identificatie"/>
    <edittype type="0" name="naam"/>
    <edittype type="0" name="objectBegi"/>
    <edittype type="0" name="objectBeginTijd"/>
    <edittype type="0" name="objectbegintijd"/>
    <edittype type="0" name="ogc_fid"/>
    <edittype type="0" name="status"/>
    <edittype type="0" name="typeGebouw"/>
    <edittype type="0" name="typegebouw"/>
    <edittype type="0" name="versieBegi"/>
    <edittype type="0" name="versieBeginTijd"/>
    <edittype type="0" name="versiebegintijd"/>
  </edittypes>
  <editform>.</editform>
  <editforminit></editforminit>
  <annotationform>../../../../../..</annotationform>
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
