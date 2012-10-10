__author__ = "Stefan de Konink"
__date__ = "$Jun 11, 2011 3:46:27 PM$"

"""
 Naam:         bagextract.py
 Omschrijving: Universe starter voor de applicatie, console
 Auteurs:       Stefan de Konink (initial), Just van den Broecke
"""

import argparse #apt-get install python-argparse
import sys
import os
from postgresdb import Database
from log import Log
from bagfilereader import BAGFileReader
from bagconfig import BAGConfig
from bagobject import VerblijfsObjectPand, AdresseerbaarObjectNevenAdres, VerblijfsObjectGebruiksdoel, Woonplaats, OpenbareRuimte, Nummeraanduiding, Ligplaats, Standplaats, Verblijfsobject, Pand

# Nodig om output naar console/file van strings goed te krijgen
# http://www.saltycrane.com/blog/2008/11/python-unicodeencodeerror-ascii-codec-cant-encode-character/
# anders bijv. deze fout: 'ascii' codec can't encode character u'\xbf' in position 42: ordinal not in range(128)
reload(sys)
sys.setdefaultencoding( "utf-8" )

class ArgParser(argparse.ArgumentParser):
     def error(self, message):
        print message
        self.print_help()
        sys.exit(2)

def main():
    """
    Voorbeelden: 
        1. Initialiseer een database:
            python bagextract.py -H localhost -d bag -U postgres -W postgres -c

        2. Importeer een extract in de database:
            python bagextract.py -H localhost -d bag -U postgres -W postgres -e 9999STA01052011-000002.xml

            of

            python bagextract.py -H localhost -d bag -U postgres -W postgres -e 9999STA01052011.zip

            Importeer gemeente_woonplaats informatie van het kadaster http://www.kadaster.nl/bag/docs/BAG_Overzicht_aangesloten_gemeenten.zip

            python bagextract.py -H localhost -d bag -U postgres -W postgres -e BAG_Overzicht_aangesloten_gemeenten.zip

        Theoretisch is het mogelijk de hele bag in te lezen vanuit de "hoofd" zip, maar dit is nog niet getest op
        geheugen-problemen.

    """
    parser = ArgParser(description='bag-extract, commandline tool voor het extraheren en inlezen van BAG bestanden',
        epilog="Configureer de database in extract.conf of geef eigen versie van extract.conf via -f of geef parameters via commando regel expliciet op")
    parser.add_argument('-c', '--dbinit', action='store_true', help='verwijdert (DROP TABLE) alle tabellen en maakt (CREATE TABLE) nieuwe tabellen aan')
    parser.add_argument('-d', '--database', metavar='<naam>', help='geef naam van de database')
    parser.add_argument('-s', '--schema', metavar='<naam>', help='geef naam van het database schema')
    parser.add_argument('-f', '--config', metavar='<bestand>', help='gebruik dit configuratiebestand i.p.v. extract.conf')
    parser.add_argument('-q', '--query', metavar='<bestand>', help='voer database bewerkingen uit met opgegeven SQL bestand')
    parser.add_argument('-e', '--extract', metavar='<naam>', help='importeert of muteert de database met gegeven BAG-bestand of -directory')
    parser.add_argument('-H', '--host', metavar='<hostnaam of -adres>', help='verbind met de database op deze host')
    parser.add_argument('-U', '--username', metavar='<naam>', help='verbind met database met deze gebruikersnaam')
    parser.add_argument('-p', '--port', metavar='<poort>', help='verbind met database naar deze poort')
    parser.add_argument('-W', '--password', metavar='<paswoord>', help='gebruikt dit wachtwoord voor database gebruiker')
    parser.add_argument('-w', '--no-password', action='store_true', help='gebruik geen wachtwoord voor de database verbinding')
    parser.add_argument('-v', '--verbose', action='store_true', help='toon uitgebreide informatie tijdens het verwerken')
    parser.add_argument('-D', '--dbinitcode', action='store_true', help='createert een lijst met statements om het DB script aan te passen')

    # Initialiseer
    args = parser.parse_args()
    # Initialize singleton Log object so we can use one global instance
    Log(args)

    # Init globale configuratie
    BAGConfig(args)

    # Database
    database = Database()

    # Print start time
    Log.log.time("Start")

    if args.dbinit:
        # Dumps all tables and recreates them
        db_script = os.path.realpath(BAGConfig.config.bagextract_home + '/db/script/bag-db.sql')
        Log.log.info("alle database tabellen weggooien en opnieuw aanmaken...")
        database.initialiseer(db_script)

        Log.log.info("Initieele data (bijv. gemeenten/provincies) inlezen...")
        myreader = BAGFileReader(BAGConfig.config.bagextract_home + '/db/data')
        myreader.process()

        Log.log.info("Views aanmaken...")
        db_script = os.path.realpath(BAGConfig.config.bagextract_home + '/db/script/bag-view-actueel-bestaand.sql')
        database.file_uitvoeren(db_script)
    elif args.dbinitcode:
        # Creates the insert statements from the code, and prints them
        bagObjecten = []
        bagObjecten.append(VerblijfsObjectPand())
        bagObjecten.append(AdresseerbaarObjectNevenAdres())
        bagObjecten.append(VerblijfsObjectGebruiksdoel())

        bagObjecten.append(Woonplaats())
        bagObjecten.append(OpenbareRuimte())
        bagObjecten.append(Nummeraanduiding())
        bagObjecten.append(Ligplaats())
        bagObjecten.append(Standplaats())
        bagObjecten.append(Verblijfsobject())
        bagObjecten.append(Pand())

        for bagObject in bagObjecten:
            print bagObject.maakTabel()

    elif args.extract:
        # Extracts any data from any source files/dirs/zips/xml/csv etc
        Database().log_actie('start_extract', args.extract)
        myreader = BAGFileReader(args.extract)
        myreader.process()
        Database().log_actie('stop_extract', args.extract)
    elif args.query:
        # Voer willekeurig SQL script uit uit
        Database().log_actie('start_query', args.query)
        database = Database()

        database.file_uitvoeren(args.query)
        Database().log_actie('stop_query', args.query)
    else:
        Log.log.fatal("je geeft een niet-ondersteunde optie. Tip: probeer -h optie")

    # Print end time
    Log.log.time("End")
    sys.exit()


if __name__ == "__main__":
    main()
