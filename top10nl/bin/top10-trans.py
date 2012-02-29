#!/usr/bin/env python
#
# Auteur: F. Steggink
# Doel: Opknippen en transformeren GML-bestanden

# Imports
import argparse
import os.path
import sys
from copy import deepcopy
from lxml import etree
from time import localtime, strftime

# Constantes
NS={'gml':'http://www.opengis.net/gml'}
MAX_FEATURES=40000   # 50000 features/bestand kan er al voor zorgen dat de XSLT-transformatie mislukt

# Argumenten
argparser = argparse.ArgumentParser(
	description='Splits en transform een GML-bestand',
	epilog='Vanwege de transformatie is uiteindelijk het aantal features per bestand hoger')
argparser.add_argument('GML', type=str, help='het op te splitsen GML-bestand')
argparser.add_argument('XSLT', type=str, help='het XSLT-bestand')
argparser.add_argument('DIR', type=str, help='locatie opgesplitste bestanden')
argparser.add_argument('--max_features', dest='maxFeatures', default=MAX_FEATURES, type=int, help='features per bestand, default: %d' % MAX_FEATURES)
args = argparser.parse_args()

# Controleer paden
if not os.path.exists(args.GML):
	print 'Het opgegeven GML-bestand is niet aangetroffen!'
	sys.exit(1)

if not os.path.exists(args.XSLT):
	print 'Het opgegeven XSLT-bestand is niet aangetroffen!'
	sys.exit(1)

if not os.path.exists(args.DIR):
	print 'De opgegeven directory is niet aangetroffen!'
	sys.exit(1)

print 'Begintijd:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

# Bepaal de base name
gmlBaseName = os.path.splitext(os.path.basename(args.GML))[0]
print 'Inlezen bestand %s...' % gmlBaseName

# Open het XSLT-bestand
xsltF=open(args.XSLT, 'r')
xsltDoc=etree.parse(xsltF)
xslt=etree.XSLT(xsltDoc)
xsltF.close()

# Open het GML bestand; verwijder hierbij nodes met alleen whitespace
parser = etree.XMLParser(remove_blank_text=True)
gmlF=open(args.GML, 'r')
gmlDoc=etree.parse(gmlF, parser)
gmlF.close()

featureMembers = gmlDoc.xpath('gml:featureMembers', namespaces=NS)[0]
features=featureMembers.xpath('*', namespaces=NS)
print 'Aantal features in bestand %s: %d' % (gmlBaseName, len(features))

# Maak een tijdelijk element aan om de features in op te slaan. De features worden hierbij verplaatst.
root = etree.Element('root')
for feature in features:
	root.append(feature)

# Verwerk de features
idx=0   # teller
gmlTemplate=gmlDoc
fileNameTemplate=os.path.join(args.DIR, '%s_%%02d.gml' % gmlBaseName)
features=root.xpath('*')

while len(features) > 0:
	# Kloon de GML template en verplaats een deel van de features er naar toe
	print 'Iteratie %d: %d te verwerken features' % (idx, len(features[0:args.maxFeatures]))
	gmlDoc = deepcopy(gmlTemplate)
	featureMembers = gmlDoc.xpath('gml:featureMembers', namespaces=NS)[0]
	for feature in features[0:args.maxFeatures]:
		featureMembers.append(feature)
		
	# Voer gelijk de transformatie uit
	resultDoc=xslt(gmlDoc)
	
	# Sla het nieuwe GML bestand op
	fileName = fileNameTemplate % idx
	o = open(fileName, 'w')
	o.write(etree.tostring(resultDoc, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
	o.flush()
	o.close()
	
	# Voor volgende iteratie
	features=root.xpath('*')
	idx+=1

print 'Eindtijd:', strftime('%a, %d %b %Y %H:%M:%S', localtime())
