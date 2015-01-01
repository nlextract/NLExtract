#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Klassedefinitie voor de TriangulatingExporter

import itertools
import triangle

from abc import ABCMeta, abstractmethod
from threeDExporter import ThreeDExporter


class TriangulatingExporter(ThreeDExporter):
    __metaclass__ = ABCMeta

    # Verwijdert de laatste coordinaat van elke ring in de polygoon, aangezien dit dezelfde is als de eerste
    def stripLastCoordinate(self, poly):
        for n in range(len(poly)):
            del poly[n][-1]
        return poly
        

    # Geeft een coordinaat terug die in de opgegeven ring valt. Dit is een coordinaat binnen de eerste driehoek na
    # triangulatie van de ring. De ring bevat geen gaten (anders was het wel een polygoon).
    def getHolePoint(self, ring):
        segments = []
        vertmarks = []
        segmarks = []
        
        for i in range(len(ring) - 1):
            segments.append([int(i), int(i+1)])
            vertmarks.append([0])
            segmarks.append([0])
        segments.append([int(i+1),int(0)])
        vertmarks.append([0])
        segmarks.append([0])

        pol = {'vertices': ring, 'segments': segments, 'vertex_markers': vertmarks, 'segment_markers': segmarks}
        tris = triangle.triangulate(pol, opts="p")
        tri = tris['triangles'][0]
        v = tris['vertices']

        # De gemiddelde waarde van de coordinaten van een driehoek ligt altijd binnen de driehoek
        a = v[tri[0]]
        b = v[tri[1]]
        c = v[tri[2]]
        
        return [(a[0]+b[0]+c[0])/3,(a[1]+b[1]+c[1])/3]
        
        
    # Trianguleert de opgegeven polygon
    def triangulatePolygon(self, poly):
        poly = self.stripLastCoordinate(poly)

        segments = []
        vertmarks = []
        segmarks = []
        holes = []
        c = 0
        for p in range(len(poly)):
            for i in range(len(poly[p]) - 1):
                segments.append([int(c+i), int(c+i+1)])
            segments.append([int(c+i+1),int(c)])
            c = len(segments)
            
            # Vertex en segment markers
            # Nummer bij vertexes en segments moet overeen komen
            for i in range(len(poly[p])):
                vertmarks.append([p])
                segmarks.append([p])
            
            if p > 0:
                # Gat
                holes.append(self.getHolePoint(poly[p]))

        allverts = list(itertools.chain.from_iterable(poly))       
                
        if len(holes) > 0:
            pol = {'vertices': allverts, 'segments': segments, 'vertex_markers': vertmarks, 'segment_markers': segmarks, 'holes': holes}
        else:
            pol = {'vertices': allverts, 'segments': segments, 'vertex_markers': vertmarks, 'segment_markers': segmarks}
        result = triangle.triangulate(pol, opts="p")

        result['triangles'] = self.correctTriangles(result['triangles'], result['vertices'])
        result['segments'] = self.correctSegments(result['segments'])
        
        return result


    # Corrigeert driehoeken: zorg ervoor dat ze CW lopen. Dit zorgt ervoor dat de surface normal van de vloervlakken
    # naar beneden wijzen en van de dakvlakken (die andersom georienteerd zijn) naar boven.
    def correctTriangles(self, tris, verts):
        for t in range(len(tris)):
            tri = tris[t]
            a = verts[tri[0]]
            b = verts[tri[1]]
            c = verts[tri[2]]
            sum = (b[0] - a[0]) * (b[1] + a[1]) + (c[0] - b[0]) * (c[1] + b[1]) + (a[0] - c[0]) * (a[1] + c[1])
            if sum < 0:
                # Keer de volgorde van de vertices om
                tris[t] = [tri[0], tri[2], tri[1]]
        
        return tris
        

    # Corrigeert segmenten: zorg ervoor dat de normalen van de muurvlakken die hieruit worden gegenereerd naar
    # buiten wijzen.
    def correctSegments(self, segs):
        for s in range(len(segs)):
            seg = segs[s]
            if seg[1] == seg[0] + 1:
                pass
            elif seg[0] == seg[1] + 1:
                segs[s] = [seg[1], seg[0]]
            elif seg[1] > seg[0]:
                segs[s] = [seg[1], seg[0]]
            else:
                pass

        return segs
