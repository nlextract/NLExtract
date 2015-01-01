#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Klassedefinitie voor de OgrExporter

from threeDExporter import ThreeDExporter
from osgeo import ogr, osr


class OgrExporter(ThreeDExporter):

    def __init__(self, driver, crs):
        # Schrijf de output weg naar stdout
        outFile = "/vsistdout/"
        outDriver = ogr.GetDriverByName(driver)

        # Maak de spatial reference aan
        outSpatialRef = osr.SpatialReference()
        outSpatialRef.ImportFromEPSG(crs)        

        # Maak de output datasource aan
        self.outDataSource = outDriver.CreateDataSource(outFile)
        self.outLayer = self.outDataSource.CreateLayer("Building", geom_type=ogr.wkbMultiPolygon, srs=outSpatialRef)

        # Voeg een ID-veld toe
        idField = ogr.FieldDefn("id", ogr.OFTString)
        self.outLayer.CreateField(idField)
        
    
    def __del__(self):
        self.outDataSource.Destroy()   


    # Voegt een gebouw toe aan de exporter
    def addBuilding(self, id, poly, min_height, avg_height):
    
        # Rond de decimalen van de hoogten af
        min_height = round(min_height, 3)
        avg_height = round(avg_height, 3)
    
        # Stel de multipolygon samen
        # Deze bestaat uit een dak-polygon, vloer-polygon en meerdere muur-polygonen
        mPoly = ogr.Geometry(ogr.wkbMultiPolygon)
        
        rPoly = ogr.Geometry(ogr.wkbPolygon)
        fPoly = ogr.Geometry(ogr.wkbPolygon)
        for r in range(len(poly)):
            ring = poly[r]
            rRing = ogr.Geometry(ogr.wkbLinearRing)
            fRing = ogr.Geometry(ogr.wkbLinearRing)
            
            for p in range(len(ring)):
                point = ring[p]
                rRing.AddPoint(point[0], point[1], avg_height)
                fRing.AddPoint(point[0], point[1], min_height)
                
                if p > 0:
                    # Muur toevoegen
                    wPoly = ogr.Geometry(ogr.wkbPolygon)
                    wRing = ogr.Geometry(ogr.wkbLinearRing)
                    wRing.AddPoint(ring[p-1][0], ring[p-1][1], min_height)
                    wRing.AddPoint(ring[p][0], ring[p][1], min_height)
                    wRing.AddPoint(ring[p][0], ring[p][1], avg_height)
                    wRing.AddPoint(ring[p-1][0], ring[p-1][1], avg_height)
                    wRing.AddPoint(ring[p-1][0], ring[p-1][1], min_height)
                    wPoly.AddGeometry(wRing)
                    mPoly.AddGeometry(wPoly)
            
            rPoly.AddGeometry(rRing)
            fPoly.AddGeometry(fRing)
            
        mPoly.AddGeometry(rPoly)
        mPoly.AddGeometry(fPoly)

        # Maak een nieuw feature aan
        featureDefn = self.outLayer.GetLayerDefn()
        feature = ogr.Feature(featureDefn)
        feature.SetGeometry(mPoly)
        feature.SetField("id", str(id))
        self.outLayer.CreateFeature(feature)
        

    # Exporteert de data die de exporter bevat
    def exportData(self, bbox, crs):
        pass
       