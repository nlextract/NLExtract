#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Conversie van BAG-panden met hoogte-attributen naar 3D-formaten.

# Aannames:
# Data (panden) zit in een PostGIS tabel, met tenminste de volgende attributen:
# * identificatie numeric(16,0)
# * geovlak       geometry(PolygonZ, 28992)
# * min_height    real
# * avg_height    real (of double precision)

# TODO:
# Input data via VRT
# Clipping shape: via VRT?
# Te joinen attributen (bijv. adres)

import argparse
import psycopg2
import sys


# Constanten
CRS = 28992

    
# Maakt een nieuwe exporter aan (factory method)
def createExporter(exporterType, crs):
    if exporterType == 'Wavefront OBJ':
        from wavefrontObjExporter import WavefrontObjExporter
        return WavefrontObjExporter()
    elif exporterType == "CityGML":
        from cityGmlExporter import CityGmlExporter
        return CityGmlExporter()
    else:
        from ogrExporter import OgrExporter
        return OgrExporter(exporterType, crs)
        
    raise NameError('Exporter type %s is niet geimplementeerd' % exporterType)

    
# Maakt een object aan voor het gegeven record, waarbij de beschrijving van de cursor wordt gebruikt
class reg(object):
    def __init__(self, cursor, record):
        for (attr, val) in zip((d[0] for d in cursor.description), record) :
            setattr(self, attr, val)

    
# Converteert een WKT-polygoon naar een polygoon-object. Dit is een lijst van ringen. Een ring is een lijst van
# coordinaten, welke op hun beurt bestaan uit een lijst van ordinaten [x, y, [z]], wat floats zijn.
def wktToPoly(wkt):
    if wkt[0:7] != 'POLYGON':
        raise Exception("WKT not a valid polygon! %s" % wkt)

    pos1 = wkt.find("((") + 2
    pos2 = wkt.find("))")
    rings = wkt[pos1:pos2].split("),(")
    
    return map(lambda ring: map(lambda o: map(lambda n: float(n), o.split(" ")), ring.split(",")), rings)


# Controleert of er geldige argumenten opgegeven zijn
def checkArgs(args):

    if not args.format in ['Wavefront OBJ', 'CityGML']:
        from osgeo import ogr
        if ogr.GetDriverByName(args.format) == None:
            sys.stderr.write('Het opgegeven outputformaat is niet herkend\n')
            return False

    # Controleer of de bounding box geldig is
    if args.bbox[0] >= args.bbox[2] or args.bbox[1] >= args.bbox[3]:
        sys.stderr.write('De opgegeven bounding box is ongeldig\n')
        return False
        
    # Controleer of er verbinding met de database gemaakt kan worden
    connStr = "host=%s port=%d dbname=%s user=%s password=%s" % (args.pg_host, args.pg_port, args.pg_db, args.pg_user, args.pg_pass)
    conn = psycopg2.connect(connStr)
    
    # Controleer of de opgegeven tabel gevonden kan worden en de juiste kolommen bevat
    query = "select identificatie, geovlak, min_height, avg_height from %s.%s limit 0" % (args.pg_schema, args.pg_table)
    cur = conn.cursor()
    cur.execute(query)

    cur.close()
    conn.close()
    
    return True

    
def moveToOrigin(poly, centerX, centerY):
    for r in range(len(poly)):
        ring = poly[r]
        for v in range(len(ring)):
            ring[v][0] -= centerX
            ring[v][1] -= centerY
        
        poly[r] = ring
        
    return poly
    
    
# Verwerkt de gebouwen binnen de opgegeven bounding box
def processBuildings(args):
    exporter = createExporter(args.format, args.ogr_tsrs)

    lineString = "LINESTRING(%d %d,%d %d)" % (args.bbox[0], args.bbox[1], args.bbox[2], args.bbox[3])
    
    if args.ogr_tsrs == 28992:
        geom = "st_astext(ST_Force_2D(geovlak))"
    else:
        geom = "st_astext(st_transform(ST_Force_2D(geovlak), %d))" % args.ogr_tsrs
    query = "select identificatie, %s geom, min_height, avg_height from %s.%s p where st_intersects(geovlak, st_envelope(st_linefromtext('%s', %d)))" % (geom, args.pg_schema, args.pg_table, lineString, CRS)

    connStr = "host=%s port=%d dbname=%s user=%s password=%s" % (args.pg_host, args.pg_port, args.pg_db, args.pg_user, args.pg_pass)
    conn = psycopg2.connect(connStr)
    cur = conn.cursor()
    cur.execute(query)
    
    centerX = (args.bbox[0] + args.bbox[2]) / 2.0
    centerY = (args.bbox[1] + args.bbox[3]) / 2.0

    for record in cur:
        r = reg(cur, record)
        poly = wktToPoly(r.geom)
        
        if args.centerOnOrigin:
            poly = moveToOrigin(poly, centerX, centerY)
        
        if r.min_height > -15 and r.avg_height > -15:        
            exporter.addBuilding(r.identificatie, poly, r.min_height, r.avg_height)

    cur.close()
    conn.close()
    
    exporter.exportData(args.bbox, CRS, args.centerOnOrigin)
    

def main():    
    # Samenstellen command line parameters
    argparser = argparse.ArgumentParser(description='Exporteer gebouwen naar 3D')
    argparser.add_argument('--format', type=str, dest='format', help='Outputformaat', required=True)
    argparser.add_argument('--bbox', type=float, dest='bbox', help='Bounding box', nargs=4, required=True, metavar=('MINX', 'MINY', 'MAXX', 'MAXY'))
    argparser.add_argument('--centerOnOrigin', dest='centerOnOrigin', help='Centreer op oorsprong', action='store_true')

    # Database verbindingsparameters
    # TODO: settings file?
    argparser.add_argument('--pg_host',     type=str, dest='pg_host',   default='localhost', help='PostgreSQL server host (default: localhost)')
    argparser.add_argument('--pg_port',     type=int, dest='pg_port',   default='5432',      help='PostgreSQL server poort (default: 5432)')
    argparser.add_argument('--pg_db',       type=str, dest='pg_db',     default='bag',       help='PostgreSQL database (default: bag)')
    argparser.add_argument('--pg_schema',   type=str, dest='pg_schema', default='public',    help='PostgreSQL schema (default: public)')
    argparser.add_argument('--pg_user',     type=str, dest='pg_user',   required=True,       help='PostgreSQL gebruikersnaam')
    argparser.add_argument('--pg_password', type=str, dest='pg_pass',   required=True,       help='PostgreSQL wachtwoord')
    argparser.add_argument('--pg_table',    type=str, dest='pg_table',  required=True,       help='PostgreSQL tabel')
    
    # OGR parameters
    argparser.add_argument('--ogr_tsrs',    type=int, dest='ogr_tsrs',  default=28992,       help='EPSG-identifer data (default: 28992)')

    argparser.set_defaults(centerOnOrigin=False)
    
    args = argparser.parse_args()
    if not checkArgs(args):
        sys.exit(1)
        
    processBuildings(args)

    return
    

if __name__ == "__main__":
    main()
