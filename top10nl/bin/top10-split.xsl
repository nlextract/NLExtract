<?xml version="1.0" encoding="UTF-8"?>

<!--
Voorbewerking Top10NL GML Objecten

Auteur: Just van den Broecke

Dit XSLT script doet een voorbewerking op de ruwe Top10NL GML zoals door Het Kadaster
geleverd. Dit is nodig omdat GDAL ogr2ogr niet alle mogelijkheden van GML goed aankan.

Voornamelijk gaat het om meerdere geometrie-attributen per Top10 Object. Het interne
GDAL model kent maar 1 geometrie per feature. Daarnaast is het bij visualiseren bijv.
met SLDs voor een WMS vaak het handigst om 1 geometrie per laag te hebben. ook als we bijvoorbeeld 
een OGR conversie naar ESRI Shapefile willen doen met ogr2ogr.

Dit script splitst objecten uit Top10NL uit in geometrie-specifieke objecten.
Bijvoorbeeld een weg (object type Wegdeel) kent 5 mogelijke geometrie attributen:
(geometrieVlak geometrieLijn geometriePunt hartLijn hartPunt). Na uitsplitsen ontstaan dan 5
object typen: Wegdeel_Vlak, Wegdeel_Lijn, Wegdeel_hartLijn etc. Objecten met 1 geometrie worden
simpelweg doorgeggeven.

-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan"
                xmlns:nen3610="http://www.ravi.nl/nen3610"
                xmlns:top10nl="http://www.kadaster.nl/top10nl"
                xmlns:gml="http://www.opengis.net/gml">
    <xsl:output method="xml" version="1.0" encoding="utf-8" indent="yes"/>
    <xsl:strip-space elements="*"/>

    <!-- Start: output omhullende FeatureCollection -->
    <xsl:template match="/">
        <gml:FeatureCollection
                xmlns:gml="http://www.opengis.net/gml"
                xmlns:tdn="http://www.tdn.nl/tdn"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:nen3610="http://www.ravi.nl/nen3610"
                xmlns:top10nl="http://www.kadaster.nl/top10nl"
                xsi:schemaLocation="http://www.kadaster.nl/top10nl top10nl.xsd"
                gml:id="uuidf074ae61-93b9-448a-b1db-289fd15e8752"
                >
            <xsl:apply-templates/>
        </gml:FeatureCollection>
    </xsl:template>

    <!-- Copy extent van hele FeatureCollection -->
     <xsl:template match="gml:boundedBy">
        <xsl:copy-of select="."/>
    </xsl:template>

    <!--
    Top10 Feature Types en hun geometrie-attributen

    Wegdeel  geometrieVlak geometrieLijn geometriePunt hartLijn hartPunt
    Waterdeel geometrieVlak geometrieLijn  geometriePunt
    Spoorbaandeel  geometrieLijn  geometriePunt
    Gebouw  geometrieVlak     (OK)
    Terrein  geometrieVlak    (OK)

    FunctioneelGebied  geometrieVlak  labelPunt
    GeografischGebied   geometrieVlak labelPunt
    InrichtingsElement geometrieLijn  geometriePunt
    RegistratiefGebied geometrieVlak  labelPunt

    IsoHoogte  geometrieLijn    (OK)
    KadeOfWal  geometrieLijn    (OK)
    Hoogteverschil   hogeZijde	(Lijn) Lijn lageZijde  (Lijn)
    OverigRelief    geometrieLijn	 geometriePunt
    HoogteOfDieptePunt  geometriePunt (OK)
    -->
    <xsl:template match="gml:featureMembers">
        <!-- START Multiple geom features: split into separate feature types, one for each geom type -->
         <xsl:for-each select="top10nl:Waterdeel">
            <xsl:call-template name="SplitsWaterdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Wegdeel">
            <xsl:call-template name="SplitsWegdeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:Spoorbaandeel">
            <xsl:call-template name="SplitsSpoorbaandeel"/>
        </xsl:for-each>

        <xsl:for-each select="top10nl:FunctioneelGebied">
             <xsl:call-template name="SplitsFunctioneelGebied"/>
         </xsl:for-each>

        <xsl:for-each select="top10nl:GeografischGebied">
             <xsl:call-template name="SplitsGeografischGebied"/>
         </xsl:for-each>

        <xsl:for-each select="top10nl:InrichtingsElement">
              <xsl:call-template name="SplitsInrichtingsElement"/>
          </xsl:for-each>


        <xsl:for-each select="top10nl:RegistratiefGebied">
             <xsl:call-template name="SplitsRegistratiefGebied"/>
         </xsl:for-each>

        <xsl:for-each select="top10nl:OverigReliëf">
                <xsl:call-template name="SplitsOverigRelief"/>
            </xsl:for-each>

        <xsl:for-each select="top10nl:Hoogteverschil">
               <xsl:call-template name="SplitsHoogteverschil"/>
           </xsl:for-each>

        <!-- START Single geom features: just copy all -->
        <xsl:for-each select="top10nl:Gebouw">
             <xsl:call-template name="CopyAll">
                 <xsl:with-param name="objectType">Gebouw_Vlak</xsl:with-param>
             </xsl:call-template>
         </xsl:for-each>

         <xsl:for-each select="top10nl:Terrein">
             <xsl:call-template name="CopyAll">
                 <xsl:with-param name="objectType">Terrein_Vlak</xsl:with-param>
             </xsl:call-template>
         </xsl:for-each>

        <xsl:for-each select="top10nl:IsoHoogte">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">IsoHoogte_Lijn</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:HoogteOfDieptePunt">
            <xsl:call-template name="CopyAll">
                <xsl:with-param name="objectType">HoogteOfDiepte_Punt</xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>

        <xsl:for-each select="top10nl:KadeOfWal">
             <xsl:call-template name="CopyAll">
                 <xsl:with-param name="objectType">KadeOfWal_Lijn</xsl:with-param>
             </xsl:call-template>
         </xsl:for-each>

    </xsl:template>

    <!--  Splits FunctioneelGebied heeft geometrieVlak en  abelPunt -->
    <xsl:template name="SplitsFunctioneelGebied">
         <xsl:if test="top10nl:geometrieVlak != ''">
             <xsl:call-template name="CopyWithSingleGeometry">
                 <xsl:with-param name="objectType">FunctioneelGebied_Vlak</xsl:with-param>
                 <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
             </xsl:call-template>
         </xsl:if>

         <xsl:if test="top10nl:labelPunt != ''">
             <xsl:call-template name="CopyWithSingleGeometry">
                 <xsl:with-param name="objectType">FunctioneelGebied_Punt</xsl:with-param>
                 <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
             </xsl:call-template>
         </xsl:if>
     </xsl:template>

    <!--  Splits GeografischGebied heeft geometrieVlak en labelPunt -->
     <xsl:template name="SplitsGeografischGebied">
          <xsl:if test="top10nl:geometrieVlak != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">GeografischGebied_Vlak</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
              </xsl:call-template>
          </xsl:if>

          <xsl:if test="top10nl:labelPunt != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">GeografischGebied_Punt</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
              </xsl:call-template>
          </xsl:if>
      </xsl:template>

    <!--  Splits Hoogteverschil heeft hogeZijde	(Lijn) en lageZijde (Lijn) -->
      <xsl:template name="SplitsHoogteverschil">
           <xsl:if test="top10nl:hogeZijde != ''">
               <xsl:call-template name="CopyWithSingleGeometry">
                   <xsl:with-param name="objectType">HoogteverschilHZ_Lijn</xsl:with-param>
                   <xsl:with-param name="geometrie" select="top10nl:hogeZijde"/>
               </xsl:call-template>
           </xsl:if>

           <xsl:if test="top10nl:lageZijde != ''">
               <xsl:call-template name="CopyWithSingleGeometry">
                   <xsl:with-param name="objectType">HoogteverschilLZ_Lijn</xsl:with-param>
                   <xsl:with-param name="geometrie" select="top10nl:lageZijde"/>
               </xsl:call-template>
           </xsl:if>
       </xsl:template>

    <!--  Splits InrichtingsElement heeft geometrieLijn en geometriePunt -->
     <xsl:template name="SplitsInrichtingsElement">
          <xsl:if test="top10nl:geometrieLijn != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">InrichtingsElement_Lijn</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
              </xsl:call-template>
          </xsl:if>

          <xsl:if test="top10nl:geometriePunt != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">InrichtingsElement_Punt</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
              </xsl:call-template>
          </xsl:if>
      </xsl:template>

    <!--  Splits OverigRelief heeft geometrieLijn en geometriePunt -->
     <xsl:template name="SplitsOverigRelief">
          <xsl:if test="top10nl:geometrieLijn != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">OverigReliëf_Lijn</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
              </xsl:call-template>
          </xsl:if>

          <xsl:if test="top10nl:geometriePunt != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">OverigReliëf_Punt</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
              </xsl:call-template>
          </xsl:if>
      </xsl:template>

    <!--  Splits GeografischGebied heeft geometrieVlak en labelPunt -->
     <xsl:template name="SplitsRegistratiefGebied">
          <xsl:if test="top10nl:geometrieVlak != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">RegistratiefGebied_Vlak</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
              </xsl:call-template>
          </xsl:if>

          <xsl:if test="top10nl:labelPunt != ''">
              <xsl:call-template name="CopyWithSingleGeometry">
                  <xsl:with-param name="objectType">RegistratiefGebied_Punt</xsl:with-param>
                  <xsl:with-param name="geometrie" select="top10nl:labelPunt"/>
              </xsl:call-template>
          </xsl:if>
      </xsl:template>
    
    <!-- Spoorbaandeel geometrieLijn geometriePunt -->
    <xsl:template name="SplitsSpoorbaandeel">
        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Spoorbaandeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Waterdeel geometrieVlak geometrieLijn  geometriePunt -->
    <xsl:template name="SplitsWaterdeel">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Waterdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Wegdeel geometrieVlak geometrieLijn geometriePunt hartLijn hartPunt -->
    <xsl:template name="SplitsWegdeel">
        <xsl:if test="top10nl:geometrieVlak != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Vlak</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieVlak"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometrieLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Lijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometrieLijn"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:geometriePunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_Punt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:geometriePunt"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="top10nl:hartLijn != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType">Wegdeel_HartLijn</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartLijn"/>
            </xsl:call-template>

        </xsl:if>

        <xsl:if test="top10nl:hartPunt != ''">
            <xsl:call-template name="CopyWithSingleGeometry">
                <xsl:with-param name="objectType" >Wegdeel_HartPunt</xsl:with-param>
                <xsl:with-param name="geometrie" select="top10nl:hartPunt"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- Copieer alle niet-geo attributen -->
    <xsl:template name="CopyNonGeoProps" priority="1">
        <fid>
            <xsl:value-of select='substring(nen3610:identificatie, 12,19)'/>
        </fid>
        <!-- Copieer alle nen3610:* attributen. -->
         <xsl:copy-of select="nen3610:*"/>

        <!-- Copieer alle top10:* attributen  behalve de geometrieen. -->
        <xsl:copy-of
                select="top10nl:*[not(self::top10nl:geometrieVlak)][not(self::top10nl:geometrieLijn)][not(self::top10nl:geometriePunt)][not(self::top10nl:hartLijn)][not(self::top10nl:hartPunt)][not(self::top10nl:hogeZijde)][not(self::top10nl:lageZijde)]"/>
    </xsl:template>

    <!-- Copieer alle elementen van object behalve geometrieen en voeg 1 enkele geometrie aan eind toe. -->
    <xsl:template name="CopyWithSingleGeometry" priority="1">
        <xsl:param name="objectType"/>
        <xsl:param name="geometrie"/>
        <gml:featureMember>
            <xsl:element name="{$objectType}">
                <xsl:call-template name="CopyNonGeoProps"/>
                <xsl:copy-of select="$geometrie"/>
            </xsl:element>
        </gml:featureMember>
    </xsl:template>

    <!-- Copieer hele object. -->
    <xsl:template name="CopyAll" priority="1">
        <xsl:param name="objectType"/>
        <gml:featureMember>
            <xsl:element name="{$objectType}">
                <fid>
                    <xsl:value-of select='substring(nen3610:identificatie, 12,19)'/>
                </fid>
                <xsl:copy-of select="*"/>
            </xsl:element>
        </gml:featureMember>
    </xsl:template>

</xsl:stylesheet>
