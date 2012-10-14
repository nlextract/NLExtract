#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
# XML validation.
#
# NB: you need to have installed libxml2 2.8.0 or newer!
# Older libxml2 versions like 2.7.8 have a bug which causes failure in GML Schema
# parsing. See https://bugzilla.gnome.org/show_bug.cgi?id=630130
#
# Author:Just van den Broecke
#
from lxml import etree
import sys, os

def validate(xsd_file_path, gml_file_path):
    print("Parsen van schema eenmalig met (GML XSD) dependencies voor schema=%s (even geduld aub...)" % xsd_file_path)
    schema = etree.XMLSchema(etree.parse(xsd_file_path))

    print("Parsen van GML bestand %s" % gml_file_path)
    parser = etree.XMLParser(remove_blank_text=True, ns_clean=True)
    gml_file = open(gml_file_path, 'r')
    gml_doc = etree.parse(gml_file, parser)
    gml_file.close()

    print ("GML doc valideren tegen schema=%s ..." % xsd_file_path)
    result = schema.validate(gml_doc)
    print("Validatie resultaat: %s" % str(result))

def main():
    xsd_file_path = os.path.join(os.path.dirname(os.path.realpath(sys.argv[0])), '../doc/schema/TOP10NL_1_1_1.xsd')

    # Controleer args
    if len(sys.argv) < 2:
        print('geen GML file opgegeven: gebruik top10validatie.py <GML Bestand>')
        sys.exit(1)

    gml_file_path = sys.argv[1]

    # Controleer paden
    if not os.path.exists(gml_file_path):
        print('Het opgegeven GML-bestand %s is niet aangetroffen!' % gml_file_path)
        sys.exit(1)

    validate(xsd_file_path, gml_file_path)

if __name__ == "__main__":
    main()
