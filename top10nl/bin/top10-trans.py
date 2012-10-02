#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Doel: Opknippen en transformeren GML-bestanden

# Imports
import argparse
import os.path
import sys
from copy import deepcopy
from lxml import etree
from time import localtime, strftime


# Constantes
GML_NS = 'http://www.opengis.net/gml'
NS = {'gml': GML_NS}
MAX_FEATURES = 40000   # 50000 features/bestand kan er al voor zorgen dat de XSLT-transformatie mislukt

def transform(gml_file, xslt_file, out_dir, max_features = MAX_FEATURES):
    print 'Begintijd top10-trans:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

    # Bepaal de base name
    gmlBaseName = os.path.splitext(os.path.basename(gml_file))[0]
    print 'GML bestand=%s baseName=%s out_dir=%s' % (gml_file, gmlBaseName,out_dir)

    # Open het XSLT-bestand
    xsltF = open(xslt_file, 'r')
    xsltDoc = etree.parse(xsltF)
    xslt = etree.XSLT(xsltDoc)
    xsltF.close()

    # Open het GML bestand; verwijder hierbij nodes met alleen whitespace
    print 'Inlezen GML bestand %s...' % gml_file
    parser = etree.XMLParser(remove_blank_text=True)
    gmlF=open(gml_file, 'r')
    gmlDoc=etree.parse(gmlF, parser)
    gmlF.close()

    # Bepaal de features in het bestand en verwijder gml:featureMembers / gml:featureMember elementen
    features = []
    for elem in gmlDoc.getroot():
        tag = elem.tag.rsplit('}', 1)[-1]
        if tag=='featureMembers' or tag=='featureMember':
            features.extend(list(elem))
        gmlDoc.getroot().remove(elem)

    print 'Aantal features in bestand %s: %d' % (gml_file, len(features))

    # Maak een tijdelijk element aan om de features in op te slaan. De features worden hierbij verplaatst.
    root = etree.Element('root')
    for feature in features:
        root.append(feature)

    # Vervang het verwijderde featureMembers element of de verwijderde featureMember elementen door een
    # nieuw featureMembers element
    etree.SubElement(gmlDoc.getroot(), etree.QName(GML_NS, 'featureMembers'))

    # Verwerk de features
    idx=0   # teller
    gmlTemplate=gmlDoc
    fileNameTemplate=os.path.join(out_dir, '%s_%%02d.gml' % gmlBaseName)
    features=root.xpath('*')

    while len(features) > 0:
        # Kloon de GML template en verplaats een deel van de features er naar toe
        print 'Iteratie %d: %d te verwerken features' % (idx, len(features[0:max_features]))
        gmlDoc = deepcopy(gmlTemplate)
        featureMembers = gmlDoc.xpath('gml:featureMembers', namespaces=NS)[0]
        for feature in features[0:max_features]:
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

    print 'Eindtijd top10-trans:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

def main():

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

    transform(args.GML, args.XSLT, args.DIR, args.maxFeatures)

if __name__ == "__main__":
    main()
