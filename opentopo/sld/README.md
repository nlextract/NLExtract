Deze directory bevat SLD (Styled Layer Descriptor) files vnl bedoeld
om een "piramide" op te bouwen voor een kaart (WMS) waarbij afhankelijk
van de schaal/resolutie die wordt opgevraagd een van de kaartlagen wordt
geactiveerd, "aangezet". Een typisch scenario is met een GeoServer GroupLayer.

De gebruikte resoluties van OpenTopo zijn

```
200, 400, 800 en 1600 pix/km.
```

In de meeste GIS-tools worden resoluties in kaarteenheid/pixel van projectie berekend, bijv voor
Nederland RD projectie is dat meters/pixel (m/px).

Voor OpenTopo resoluties wordt dit als volgt:

```
px/km   m/px
200     5
400     2.5
800     1.25
1600    0.625 m/px
```

De PDOK/Geonovum tiling resolutie-reeks is:

```
3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105, 0.0525
```

Helaas is dit een reeks die niet lekker past.

Om de OpenTopo resoluties toch hierin te passen kunnen we de volgende toewijzing doen:

```
5      (200px/km) : 3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720
2.5    (400px/km) : 3.360,
1.25   (800px/km) : 1.680,
0.625  (1600px/km): 0.840, 0.420, 0.210, 0.105, 0.0525
```

"Schaal" is een lastig begrip want deze is afhankelijk vna de pixeldichtheid van het medium (scherm, papier) waarop
de kaart wordt afgebeeld. De omrekeneenheid hiervoor is DPI (dots per inch) om van resoluties naar schalen te
komen. The OGC standard output resolution is 90 DPI. OpenLayers 25.4 / 0.28 = 90.7. 1 inch is 0.0254m.
90 / 0.0254 = 3543.3 px/m. Dus bijv resolutie 6.72 wordt schaal:  6.72 * 3543.3  = 1: 23811 (benadering)



Overzicht zoom/resolutie/aantal tiles/opslag en OpenTopo set. De GeoServer DPI is 90 (OGC standaard), dus omrekening
van resolutie naar schaal (voor RD) is:

```
Zoom Resol   Schaal          Tilecount        GB    OpenTopo
6    13.44   1:48000                                200
7    6.72    1:23811                                200
8    3,36    1:11905          87380             1   400
9    1,68    1:5952          349524            4    800
10   0,84    1:2976          1398100          16    1600
11   0,42    1:1500          5592404          67    1600
12   0,21    1:750           22369620        268    1600
13   0,105   1:375           89478484        1073   1600
14   0,0525  1:149           357913940       4294   1600
15   0,02625 1:74            1431655764     17179   1600
16   0,01313 1:37            5726623060     68719   1600
17   0,0066  1:19            22906492244   274877   1600
18   0,00328 1:9             91625968980  1099511   1600
19   0,00164 1:5             366503875924 4398046   1600
```

Voor Google projectie geldt een andere resolutie-array. Die willen we meenemen zodat
we ook tiles in Google-projectie (EPSG:9009113) kunnen genereren met de juiste OpenTopo resoluties.

Bij benadering zijn dit de volgende resoluties en schalen (bij 90DPI):

```
Zoom Resol   Schaal      OpenTopo
6    19      1:67677       200
7    9.6     1:34016       200
8    4.8     1:17008       400
9    2.4     1:8504        800
10   1.2     1:4252       1600
11   0.6     1:2126       1600
12   0,3     1:1063       1600
```

Hierop baseren we deze indeling naar schalen bij benadering, zodat iedere resolutie "omvat" wordt voor zowel RD als
Google projectie, maar maakt voor tiling niet uit omdat daar vaste resoluties gekozen worden.

```
0-5000           1600px/km
5000-10000       800px/km
10000-20000      400px/km
20000-en hoger   200px/km
```

In GeoServer gaan we een "Layer Group" samenstellen van 4 OpenTopo lagen waarbij afhankelijk van de opgevraagde
resolutie (dms WMS width/height tezamen met bbox in RD) een van de 4 OpenTopo lagen wordt "aangezet" en de anderen
worden uitgezet. Dit kan mbv van SLDs, bijv. tussen schalen 1:9000 en 1:20000 wordt 400px/km aangezet:

```
<?xml version="1.0" encoding="ISO-8859-1"?>
<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld"
                       xmlns:xsi="http://www.w3.org/4001/XMLSchema-instance"
                       xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
    <NamedLayer>
        <Name>opentopo-400px</Name>
        <UserStyle>
            <Name>opentopo-400px</Name>
            <Title>OpenTopo Raster</Title>
            <Abstract>Schaalbegrenzing 400px/km kaarten</Abstract>
            <FeatureTypeStyle>
                <FeatureTypeName>Feature</FeatureTypeName>
                <Rule>
                    <MinScaleDenominator>10000</MinScaleDenominator>
                    <MaxScaleDenominator>20000</MaxScaleDenominator>
                    <RasterSymbolizer>
                        <Opacity>1.0</Opacity>
                    </RasterSymbolizer>
                </Rule>
            </FeatureTypeStyle>
        </UserStyle>
    </NamedLayer>
</StyledLayerDescriptor>


```
