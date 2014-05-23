#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Doel: Transformeer een enkel GML-bestand

# Imports
import argparse
import os.path
import sys

from lxml import etree

def main():
    # Argumenten
    argparser = argparse.ArgumentParser(
        description='Transform een GML-bestand',
        epilog='Vanwege de transformatie is uiteindelijk het aantal features per bestand hoger')
    argparser.add_argument('GML', type=str, help='het op te splitsen GML-bestand')
    argparser.add_argument('XSLT', type=str, help='het XSLT-bestand')
    args = argparser.parse_args()

    # Controleer paden
    if not os.path.exists(args.GML):
        print 'Het opgegeven GML-bestand is niet aangetroffen!'
        sys.exit(1)

    if not os.path.exists(args.XSLT):
        print 'Het opgegeven XSLT-bestand is niet aangetroffen!'
        sys.exit(1)

    # Open het XSLT-bestand
    xsltF = open(args.XSLT, 'r')
    xsltDoc = etree.parse(xsltF)
    xslt = etree.XSLT(xsltDoc)
    xsltF.close()

    # Open het GML bestand; verwijder hierbij nodes met alleen whitespace
    parser = etree.XMLParser(remove_blank_text=True, ns_clean=True)
    gmlF = open(args.GML, 'r')
    gmlDoc = etree.parse(gmlF, parser)
    gmlF.close()

    # Voer de transformatie uit
    resultDoc = xslt(gmlDoc)

    # Sla het nieuwe GML bestand op
    o = open(args.GML, 'w')
    o.write(etree.tostring(resultDoc, pretty_print=True, xml_declaration=True, encoding='UTF-8'))
    o.flush()
    o.close()

if __name__ == "__main__":
    main()
