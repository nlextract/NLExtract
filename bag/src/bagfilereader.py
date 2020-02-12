"""
 Omschrijving: Inlezen van BAG-gerelateerde files of directories

 Auteurs: Milo van der Linden, Just van den Broecke, Stefan de Konink, rutgerw

 6.jan.2014: redundantie verwijderd, bijhouden evt overslaan verwerkte bestanden in DB en meer Pythonic gemaakt (Just)
"""

import os
import zipfile
import csv
from etree import etree
from io import BytesIO
from log import Log
from processor import Processor
from postgresdb import Database


def fname_key(filenaam):
    # tbv sorteren: mutatie bestand: .zip of .xml op datum, voor andere bestanden maakt het niet uit
    if not filenaam.startswith('9999MUT'):
        return filenaam

    # Draai datum velden om naar YYYYMMDD, bijv:
    # 9999MUT14122014-15122014.zip wordt 9999MUT20141214-20141215.zip
    # 9999MUT02012015-03012015-000002.xml wordt 9999MUT20150102-20150103-000002.xml
    start_datum = filenaam[11:15] + filenaam[9:11] + filenaam[7:9]
    eind_datum = filenaam[20:24] + filenaam[18:20] + filenaam[16:18]
    return filenaam[0:7] + start_datum + '-' + eind_datum + filenaam[24:]


class BAGFileReader:

    def __init__(self, file_path):
        self.file_path = file_path
        self.processor = Processor()
        self.database = Database()

    def process(self):
        Log.log.info("process: verwerk %s" % self.file_path)

        if not os.path.exists(self.file_path):
            Log.log.fatal("kan BAG-bestand of -directory: '%s' niet vinden" % self.file_path)
            return

        if os.path.isdir(self.file_path):
            # Verwerk een directory
            self.process_dir(self.file_path)
        else:
            # Verwerk een "gewone" file: alleen ZIP, CSV of XML
            self.process_file(self.file_path)

    def process_dir(self, file_path):
        Log.log.info("process_dir: verwerk %s" % file_path)

        # Loop door op naam (datum) gesorteerde bestanden (m.n. i.v.m. mutatie-volgorde)
        for each in sorted(os.listdir(file_path), key=fname_key):
            # Volledig pad naar ieder bestand in dir
            nest_file_path = os.path.join(file_path, each)

            # Verwerk alleen file-bestanden (ZIP, CSV, XML)
            # Subdirectories worden dus niet verwerkt!
            if not os.path.isdir(nest_file_path):
                self.process_file(nest_file_path)

    def process_file(self, file_path, file_buf=None):
        filenaam = os.path.basename(file_path)

        # Overslaan als bestand al (succesvol) verwerkt is: bijv bij herstart of reeds verwerkte mutaties
        if self.database.has_log_actie('verwerkt', filenaam, False):
            Log.log.info("bestand %s is reeds verwerkt ==> overslaan" % filenaam)
            self.database.log_actie('overgeslagen', filenaam, 'reeds verwerkt', True)
            return

        # Mutatie-bestand overslaan indien datum eerder dan stand-datum BAG
        if filenaam.startswith('9999MUT'):

            # Draai eerste datum veld om naar YYYYMMDD, bijv:
            # 9999MUT14122014-15122014.zip wordt 20141214
            # 9999MUT02012015-03012015-000002.xml wordt 20150102
            mutatie_start_datum = filenaam[11:15] + filenaam[9:11] + filenaam[7:9]
            mutatie_eind_datum = filenaam[20:24] + filenaam[18:20] + filenaam[16:18]

            # stand datum BAG moet voor of op start-datum mutatie bestand liggen EN
            # voor mutatie einddatum
            sql = "SELECT * FROM nlx_bag_info WHERE sleutel = 'extract_datum' AND waarde <= '%s' AND waarde < '%s'" % (mutatie_start_datum, mutatie_eind_datum)
            if self.database.tx_uitvoeren(sql) != 1:
                Log.log.info("mutatiebestand %s is van eerdere datum-range dan BAG ==> overslaan" % filenaam)
                self.database.log_actie('overgeslagen', filenaam, 'mutatie datum-range voor BAG datum', True)
                return

        # Verkrijg file-extensie (niet alle files, e.g. README bestand hebben die)
        ext = None
        filenaam_arr = filenaam.split('.')
        if len(filenaam_arr) > 1:
            ext = filenaam_arr[-1].lower()

        # file_buf kan BytesIO (stream/buffer) zijn uit zipfile
        file_resource = file_path
        if file_buf:
            file_resource = file_buf

        # Verwerk naar file-extensie/type
        if ext == 'xml':
            self.process_xml(file_resource, filenaam)
        elif ext == 'csv':
            self.process_csv(file_resource, filenaam)
        elif ext == 'zip':
            self.process_zip(file_resource, filenaam)
        else:
            Log.log.info("Negeer bestand: %s" % file_path)

    def process_xml(self, file_resource, filenaam):
        Log.log.info("process_xml: verwerk %s " % filenaam)

        try:
            # XML doc parsen naar etree object
            Log.log.startTimer("parseXML")
            parsed_xml = etree.parse(file_resource)
            bericht = Log.log.endTimer("parseXML")
            self.database.log_actie('xml_parse', filenaam, bericht)
        except (Exception) as e:
            bericht = Log.log.error("fout %s in XML parsen, bestand=%s" % (str(e), filenaam))
            self.database.log_actie('xml_parse', filenaam, bericht, True)
            return

        if filenaam == 'gemeentelijke-indeling.xml':
            try:
                self.processor.processGemeentelijkeIndeling(parsed_xml.getroot(), filenaam)
                self.database.log_actie('xml_processing', filenaam, 'verwerkt OK')
            except (Exception) as e:
                bericht = Log.log.error("fout %s in XML DOM processing, bestand=%s" % (str(e), filenaam))
                self.database.log_actie('xml_processing', filenaam, bericht, True)
        else:
            try:
                # Verwerken parsed xml: de Processor bepaalt of het een extract of een mutatie is
                self.processor.processDOM(parsed_xml.getroot(), filenaam)
                self.database.log_actie('verwerkt', filenaam, 'verwerkt OK')
            except (Exception) as e:
                bericht = Log.log.error("fout %s in XML DOM processing, bestand=%s" % (str(e), filenaam))
                self.database.log_actie('xml_processing', filenaam, bericht, True)

    def process_csv(self, file_resource, filenaam):
        Log.log.info("process_csv: verwerk %s " % filenaam)

        file_object = open(file_resource, "rb")
        csv_reader = csv.reader(file_object, delimiter=';', quoting=csv.QUOTE_NONE)
        self.processor.processCSV(csv_reader, filenaam)
        self.database.log_actie('verwerkt', filenaam, 'verwerkt OK')

    def process_zip(self, file_resource, filenaam):
        Log.log.info("process_zip: verwerk %s " % filenaam)

        zip_file = zipfile.ZipFile(file_resource, "r")

        # Loop door op naam (datum) gesorteerde bestanden (m.n. i.v.m. mutatie-volgorde)
        for naam in sorted(zip_file.namelist(), key=fname_key):
            self.process_file(naam, BytesIO(zip_file.read(naam)))

        self.database.log_actie('verwerkt', filenaam, 'verwerkt OK')
