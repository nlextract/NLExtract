__author__ = "Stefan de Konink"
__date__ = "$Jun 11, 2011 3:46:27 PM$"

"""
 Naam:         bagextract.py
 Omschrijving: Universe starter voor de applicatie, console
 Auteurs:       Stefan de Konink (initial), Just van den Broecke
"""

import argparse #apt-get install python-argparse
import sys

from postgresdb import Database
from logging import Log
from bagfilereader import BAGFileReader
from bagconfig import BAGConfig


class ArgParser(argparse.ArgumentParser):
     def error(self, message):
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
    parser = ArgParser(description='BAG Extract, commandline tool voor het verwerken van BAG bestanden',
        epilog="Configureer de database in BAG.conf of geef de database parameters op")
    parser.add_argument('-c', '--dbinit', action='store_true', help='wist oude tabellen en maakt nieuw tabellen')
    parser.add_argument('-d', '--database', metavar='BAG', help='database naam')
    parser.add_argument('-s', '--schema', metavar='BAG', help='database schema')
    parser.add_argument('-q', '--query', metavar='bestand', help='voer een SQL query uit')
    parser.add_argument('-e', '--extract', metavar='bestand', help='neemt een pad naar een bestand of map en importeert deze in de database')
    parser.add_argument('-H', '--host', metavar='localhost', help='database host')
    parser.add_argument('-U', '--username', metavar='postgres', help='database gebruiker')
    parser.add_argument('-p', '--port', metavar='5432', help='database poort')
    parser.add_argument('-W', '--password', metavar='postgres', help='wachtwoord voor postgres')
    parser.add_argument('-w', '--no-password', action='store_true', help='gebruik geen wachtwoord voor de database verbinding')
    parser.add_argument('-v', '--verbose', action='store_true', help='toon uitgebreide informatie tijdens het verwerken')

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
        database.initialiseer('../db/script/bagdb-1.0.sql')
    elif args.extract:
        # Extracts any data from any source files/dirs/zips/xml/csv etc
        myreader = BAGFileReader(args.extract, args)
        myreader.process()
    elif args.query:
        # Voer willekeurig SQL script uit uit
        database = Database()

        database.file_uitvoeren(args.query)
    else:
        Log.log.warn("niet-ondersteunde optie")

    # Print end time
    Log.log.time("End")
    sys.exit()


if __name__ == "__main__":
    main()
