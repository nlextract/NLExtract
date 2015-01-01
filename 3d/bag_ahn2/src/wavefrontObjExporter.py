#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Klassedefinitie voor de WavefrontObjExporter

from datetime import datetime
from triangulatingExporter import TriangulatingExporter


class WavefrontObjExporter(TriangulatingExporter):
    
    def __init__(self):
        self.buildings = []
        self.allVerts = []


    # Voegt een gebouw toe aan de exporter
    def addBuilding(self, id, poly, min_height, avg_height):
        result = self.triangulatePolygon(poly)
        
        verts = result['vertices']
        tris = result['triangles']
        segs = result['segments']

        v0 = len(self.allVerts) + 1
        vl = len(verts)
        
        self.allVerts.extend(map(lambda x: [x[0], x[1], min_height], verts))
        self.allVerts.extend(map(lambda x: [x[0], x[1], avg_height], verts))
        
        self.buildings.append({
            'id': id,
            'floor': map(lambda tri: [tri[0]+v0, tri[1]+v0, tri[2]+v0], tris),
            'roof': map(lambda tri: [tri[2]+v0+vl, tri[1]+v0+vl, tri[0]+v0+vl], tris),
            'walls': map(lambda seg: [seg[0]+v0, seg[1]+v0, seg[1]+v0+vl, seg[0]+v0+vl], segs)
        })


    # Exporteert de data die de exporter bevat
    def exportData(self, bbox, crs):
        print "################################################################################"
        print "# OBJ file gegenereerd d.m.v. NLExtract - bag_ahn2/exportBuildings op " + str(datetime.now()).split(".")[0]
        print "# Gebouwen: o.b.v. BAG"
        print "# Gebouwhoogtes: o.b.v. AHN2"
        print "# Aantal gebouwen: %d" % len(self.buildings)
        print "# Gebied: (%.3f, %.3f) - (%.3f, %.3f)" % (bbox[0], bbox[1], bbox[2], bbox[3])
        print "################################################################################"

        print ""
        for v in self.allVerts:
            print "v %.3f %.3f %.3f" % (v[0], v[1], v[2])
            
        for b in self.buildings:
            print ""
            print "# new building"
            print "g building-%d" % b['id']
            print "# floor"
            #print "s 1"
            for t in b['floor']:
                print "f %d %d %d" % (t[0], t[1], t[2])
            print "# roof"
            #print "s 2"
            for t in b['roof']:
                print "f %d %d %d" % (t[0], t[1], t[2])
            #print "s off"
            print "# walls"
            for w in b['walls']:
                print "f %d %d %d %d" % (w[0], w[1], w[2], w[3])
