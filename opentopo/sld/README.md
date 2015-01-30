Deze directory bevat SLD (Styled Layer Descriptor) files vnl bedoeld
om een "pyramid" op te bouwen voor een kaart (WMS) waarbij afhankelijk
van de schaal/resolutie die wordt opgevraagd een van de kaartlagen wordt
geactiveerd, "aangezet". Een typisch scenario is met een GeoServer GroupLayer.

De gebruikte resoluties van OpenTopo zijn

200, 400, 800 en 1600 pix/km.

Dit vertaalt naar resoluties in m/px (bijv 1000m/200px) resp:

5, 2.5, 1.25 en 0.625 m/px

De PDOK/Geonovum tiling resolutie-reeks is:

3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440, 6.720, 3.360, 1.680, 0.840, 0.420, 0.210, 0.105, 0.0525

Om hierin te passen laten we er resolutie een aantal PDOK-resoluties gelden:

5      (200px/km) : 3440.640, 1720.320, 860.160, 430.080, 215.040, 107.520, 53.760, 26.880, 13.440
2.5    (400px/km) : 6.720, 3.360,
1.25   (800px/km) : 1.680,
0.625  (1600px/km): 0.840, 0.420, 0.210, 0.105, 0.0525

3000 en hoger:


0-3000 1600px/km
3000-9000 800px/km
9000-20000 400px/km
20000-en hoger 200px/km

Zoom Res Scale Tiles GB
6    13.44 1:38096
7    6.72 1:19048
8    3,36 1:9524 87380 1
9    1,68 1:4762 349524 4
10   0,84 1:2381 1398100 16
11   0,42 1:1191 5592404 67
12   0,21 1:595 22369620 268
13   0,105 1:298 89478484 1073
14   0,0525 1:149 357913940 4294
15   0,02625 1:74 1431655764 17179
16   0,01313 1:37 5726623060 68719
17   0,0066 1:19 22906492244 274877
18   0,00328 1:9 91625968980 1099511
19   0,00164 1:5 366503875924 4398046
