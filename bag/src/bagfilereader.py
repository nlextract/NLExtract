__author__ = "Milo van der Linden"
__date__ = "$Jun 11, 2011 3:46:27 PM$"

"""
 Naam:         BAGFileReader.py
 Omschrijving: Inlezen van BAG-gerelateerde files of directories

 Auteur:       Milo van der Linden Just van den Broecke

 Versie:       1.0
               - basis versie
 Datum:        22 december 2011


 OpenGeoGroep.nl
"""

import zipfile
from processor import Processor
import os
from etree import etree
import csv
from log import Log
from postgresdb import Database

try:
  from cStringIO import StringIO
except:
  from StringIO import StringIO

class BAGFileReader:
    def __init__(self, file):
        self.file = file
        self.init = True
        self.processor = Processor()
        self.fileCount = 0
        self.recordCount = 0
        self.database = Database()

    def process(self):
        Log.log.info("process file=" + self.file)
        if not os.path.exists(self.file):
            Log.log.fatal("ik kan BAG-bestand of -directory: '" + self.file + "' ech niet vinden")
            return

        # TODO: Verwerk een directory
        if os.path.isdir(self.file) == True:
            self.readDir()
        elif zipfile.is_zipfile(self.file):
            self.zip = zipfile.ZipFile(self.file, "r")
            self.readzipfile()
        else:
            zipfilename = os.path.basename(self.file).split('.')
            ext = zipfilename[1]
            if ext == 'xml':
                xml = self.parseXML(self.file, zipfilename)
                self.processXML(zipfilename[0],xml)
            if ext == 'csv':
                fileobject = open(self.file, "rb")
                self.processCSV(zipfilename[0], fileobject)

    def readDir(self):
        for each in os.listdir(self.file):
            _file = os.path.join(self.file, each)
            if zipfile.is_zipfile(_file):
                self.zip = zipfile.ZipFile(_file, "r")
                self.readzipfile()
            else:
                if os.path.isdir(_file) <> True:
                    zipfilename = each.split('.')
                    if len(zipfilename) == 2:
                        ext = zipfilename[1]
                        if ext == 'xml':
                            Log.log.info("==> XML File: " + each)
                            xml = self.parseXML(_file, zipfilename[0] + "." + zipfilename[1])
                            self.processXML(zipfilename[0] + "." + zipfilename[1], xml)
                        if ext == 'csv':
                            Log.log.info("==> CSV File: " + each)
                            fileobject = open(_file, "rb")
                            self.processCSV(zipfilename[0],fileobject)

    def readzipfile(self):

        tzip = self.zip
        Log.log.info("readzipfile content=" + str(tzip.namelist()))
        for naam in tzip.namelist():
            ext = naam.split('.')
            Log.log.info("readzipfile: " + naam)
            if len(ext) == 2:
                if ext[1] == 'xml':
                    xml = self.parseXML(StringIO(tzip.read(naam)), naam)
                    self.processXML(naam, xml)
                elif ext[1] == 'zip':
                    self.readzipstring(StringIO(tzip.read(naam)))
                elif ext[1] == 'csv':
                    Log.log.info(naam)
                    fileobject = StringIO(tzip.read(naam))
                    self.processCSV(naam, fileobject)
                else:
                    Log.log.info("Negeer: " + naam)

    def readzipstring(self,naam):
        # Log.log.info("readzipstring naam=" + naam)
        tzip = zipfile.ZipFile(naam, "r")
        # Log.log.info("readzipstring naam=" + tzip.getinfo().filename)

        for nested in tzip.namelist():
            Log.log.info("readzipstring: " + nested)
            ext = nested.split('.')
            if len(ext) == 2:
                if ext[1] == 'xml':
                    xml = self.parseXML(StringIO(tzip.read(nested)), str(nested))
                    self.processXML(nested, xml)
                elif ext[1] == 'csv':
                    Log.log.info(nested)
                    fileobject = StringIO(tzip.read(nested))
                    self.processCSV(nested, fileobject)
                elif ext[1] == 'zip':
                    Log.log.info(nested)
                    self.readzipstring(StringIO(tzip.read(nested)))
                else:
                    Log.log.info("Negeer: " + nested)

    def parseXML(self, file, naam):

        Log.log.startTimer("parseXML")
        xml = None
        try:
            xml = etree.parse(file)
            bericht = Log.log.endTimer("parseXML")
            Database().log_actie('xml_parse', naam, bericht)
        except (Exception), e:
            bericht = Log.log.error("fout %s in XML parsen, bestand=%s" % (str(e), str(naam) ))
            Database().log_actie('xml_parse', naam, bericht, True)
        return xml
    
    def processXML(self, naam, xml):
        if not xml:
            Database().log_actie('xml_processing', naam, 'geen xml document', True)
            return

        try:
            Log.log.info("processXML: " + naam)
            xmldoc = xml.getroot()
            # de processor bepaalt of het een extract of een mutatie is
            self.processor.processDOM(xmldoc, naam)
            #Log.log.info(document)
        except (Exception), e:
            bericht = Log.log.error("fout %s in DOM processing, bestand=%s" % (str(e), str(naam) ))
            Database().log_actie('xml_processing', naam, bericht, True)

    def processCSV(self,naam, fileobject):
        Log.log.info(naam)
        # TODO: zorg voor de verwerking van het geparste csv bestand
        # Maak er gemeente_woonplaats objecten van overeenkomstig de nieuwe
        # tabel woonplaats_gemeente
        myReader = csv.reader(fileobject, delimiter=';', quoting=csv.QUOTE_NONE)
        self.processor.processCSV(myReader, naam)
        
