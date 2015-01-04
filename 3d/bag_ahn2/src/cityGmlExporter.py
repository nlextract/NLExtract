#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Klassedefinitie voor de CityGmlExporter

import functools

from datetime import datetime
from lxml import etree
from threeDExporter import ThreeDExporter


# GML / CityGML namespaces
GML_NS = "http://www.opengis.net/gml"
GML = "{%s}" % GML_NS
CGML_NS = "http://www.opengis.net/citygml/1.0"
CGML = "{%s}" % CGML_NS
BLDG_NS = "http://www.opengis.net/citygml/building/1.0"
BLDG = "{%s}" % BLDG_NS
APP_NS = "http://www.opengis.net/citygml/appearance/1.0"
APP = "{%s}" % APP_NS
NSMAP = {None: CGML_NS, "gml": GML_NS, "bldg": BLDG_NS, "app": APP_NS} 
NSMAP2 = {"gml": GML_NS, "bldg": BLDG_NS, "app": APP_NS} 


class CityGmlExporter(ThreeDExporter):

    def __init__(self):
        self.root = etree.Element(CGML + "CityModel", nsmap=NSMAP)

        self.root.append(etree.Comment("CityGML file gegenereerd d.m.v. NLExtract - bag_ahn2/exportBuildings op " + str(datetime.now()).split(".")[0]))
        self.root.append(etree.Comment("Gebouwen: o.b.v. BAG"))
        self.root.append(etree.Comment("Gebouwhoogtes: o.b.v. AHN2"))

        etree.SubElement(self.root, GML + "name").text = "BAG 3D"
        self.bnd = etree.SubElement(self.root, GML + "boundedBy")
        
        self.min_height = float("inf")
        self.max_height = float("-inf")


    # Voegt een gebouw toe aan de exporter
    def addBuilding(self, id, poly, min_height, avg_height):
        # Create a building
        com = etree.SubElement(self.root, CGML + "cityObjectMember")
        building = etree.SubElement(com, BLDG + "Building")
        building.set(GML + "id", "g" + str(id))
        
        # Add walls: two subsequent coordinates are used to construct a wall face.
        # A WallSurface is generated for each ring in the geometry.
        reduce(lambda building, ring: self.boundedBy(building, "WallSurface", map(functools.partial(self.createWallPoly, avg_height, min_height), zip(ring, ring[1:]))), poly, building)
                
        # Add roof; after replacing the height
        roofRings = map(lambda ring: map(lambda c: [c[0], c[1], avg_height], ring), poly)
        self.boundedBy(building, "RoofSurface", [roofRings])
        
        if min_height < self.min_height:
            self.min_height = min_height
        if avg_height > self.max_height:
            self.max_height = avg_height
        

    # Exporteert de data die de exporter bevat
    def exportData(self, bbox, crs, centerOnOrigin):
        self.root.insert(3, etree.Comment("Aantal gebouwen: %d" % self.root.xpath('count(//bldg:Building)', namespaces=NSMAP2)))
        if centerOnOrigin:
            self.root.insert(4, etree.Comment("Gebouwen zijn gecentreerd op de oorsprong"))
            centerX = (bbox[0] + bbox[2]) / 2.0
            centerY = (bbox[1] + bbox[3]) / 2.0
            bbox[0] -= centerX
            bbox[1] -= centerY
            bbox[2] -= centerX
            bbox[3] -= centerY
            
        env = etree.SubElement(self.bnd, GML + "Envelope", srsName="EPSG:%d" % crs)
        etree.SubElement(env, GML + "pos", srsDimension="3").text = "%.3f %.3f %.3f" % (bbox[0], bbox[1], self.min_height)
        etree.SubElement(env, GML + "pos", srsDimension="3").text = "%.3f %.3f %.3f" % (bbox[2], bbox[3], self.max_height)
        
        print(etree.tostring(self.root, pretty_print=True))


    # Creates a posList string based on the given coordinates            
    def posList(self, coords):
        return reduce(lambda txt, c: txt + " %.3f %.3f %.3f" % (c[0], c[1], c[2] if len(c)>=3 else 0 ), coords, "").strip()

        
    # Creates a LinearRing geometry, and adds it to the parent
    def linearRing(self, parent, ring):
        lrng = etree.SubElement(parent, GML + "LinearRing")
        plst = etree.SubElement(lrng, GML + "posList", srsDimension="3")  
        plst.text = self.posList(ring)

        
    # Creates a Polygon geometry, and adds it to the parent    
    def polygon(self, parent, rings):
        pol = etree.SubElement(parent, GML + "Polygon")
        ext = etree.SubElement(pol, GML + "exterior")
        self.linearRing(ext, rings[0])
        
        for ring in rings[1:]:
            int = etree.SubElement(pol, GML + "interior")
            self.linearRing(int, ring)
        

    # Creates a LoD 2 multisurface geometry, and adds it to the parent   
    def multiSurface(self, parent, surfaces):
        msf = etree.SubElement(parent, GML + "MultiSurface")
        
        for surface in surfaces:
            sfm = etree.SubElement(msf, GML + "surfaceMember")
            #osf = etree.SubElement(sfm, GML + "OrientableSurface", orientation="+")
            #bsf = etree.SubElement(osf, GML + "baseSurface")
            self.polygon(sfm, surface)


    # Adds a bounding surface to a building    
    def boundedBy(self, building, surfaceType, surfaces):
        bnd = etree.SubElement(building, BLDG + "boundedBy")
        srf = etree.SubElement(bnd, BLDG + surfaceType)
        lod2msf = etree.SubElement(srf, BLDG + "lod2MultiSurface")
        self.multiSurface(lod2msf, surfaces)
        return building

        
    # Creates a wall polygon constructed from two floor coordinates, the floor height, and the roof height
    def createWallPoly(self, height_r, height_i, c2):
        c0 = c2[0]
        c1 = c2[1]
        return [[(c0[0],c0[1],height_i),(c1[0],c1[1],height_i),(c1[0],c1[1],height_r),(c0[0],c0[1],height_r),(c0[0],c0[1],height_i)]]
