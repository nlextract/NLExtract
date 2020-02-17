__author__ = "Stefan de Konink"
__date__ = "$Jun 11, 2011 3:46:27 PM$"

"""
 Naam:         bagextract.py
 Omschrijving: Universe starter voor de applicatie, console
 Auteurs:       Stefan de Konink (initial), Just van den Broecke
"""

import argparse  # apt-get install python-argparse
import sys
import os
from postgresdb import Database
from log import Log
from bagconfig import BAGConfig


class ArgParser(argparse.ArgumentParser):
    def error(self, message):
        print(message)
        self.print_help()
        sys.exit(2)


# {{{ http://code.activestate.com/recipes/541096/ (r1)
def confirm(prompt=None, resp=False):
    """prompt voor ja of nee reactie.

    'resp' bevat de default waarde wanneer een gebruiker een ENTER geeft

    >>> confirm(prompt='Create Directory?', resp=True)
    Create Directory? [y]|n:
    True
    >>> confirm(prompt='Create Directory?', resp=False)
    Create Directory? [n]|y:
    False
    >>> confirm(prompt='Create Directory?', resp=False)
    Create Directory? [n]|y: y
    True

    """

    if prompt is None:
        prompt = 'Bevestig'

    if resp:
        prompt = '%s ([%s]/%s): ' % (prompt, 'J', 'n')
    else:
        prompt = '%s ([%s]/%s): ' % (prompt, 'N', 'j')

    while True:
        ans = input(prompt)
        if not ans:
            return resp
        if ans not in ['j', 'J', 'n', 'N']:
            print('Geef j of n.')
            continue
        if ans == 'j' or ans == 'J':
            return True
        if ans == 'n' or ans == 'N':
            return False
# end of http://code.activestate.com/recipes/541096/ }}}


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
    parser.add_argument('-j', '--ja', action='store_true', help='bevestig alle prompts')
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

    if args.dbinit:
        if args.ja or confirm('Waarschuwing! met dit commando worden database tabellen opnieuw aangemaakt. Doorgaan?', False):
            # Print start time
            Log.log.time("Start")
            # Dumps all tables and recreates them
            db_script = os.path.realpath(BAGConfig.config.bagextract_home + '/db/script/bag-db.sql')
            Log.log.info("alle database tabellen weggooien en opnieuw aanmaken...")
            try:
                database.initialiseer(db_script)
            except Exception:
                Log.log.fatal("Kan geen verbinding maken met de database")
                sys.exit()
            Log.log.info("Initieele data (bijv. gemeenten/provincies) inlezen...")
            from bagfilereader import BAGFileReader
            # from bagobject import VerblijfsObjectPand, AdresseerbaarObjectNevenAdres, VerblijfsObjectGebruiksdoel, Woonplaats, OpenbareRuimte, Nummeraanduiding, Ligplaats, Standplaats, Verblijfsobject, Pand
            myreader = BAGFileReader(BAGConfig.config.bagextract_home + '/db/data')
            myreader.process()
            Log.log.info("Post processing en views aanmaken...")
            db_script = os.path.realpath(BAGConfig.config.bagextract_home + '/db/script/bag-gemeentecode-postprocess.sql')
            database.file_uitvoeren(db_script)
            db_script = os.path.realpath(BAGConfig.config.bagextract_home + '/db/script/bag-view-actueel-bestaand.sql')
            database.file_uitvoeren(db_script)
            # Print end time
            Log.log.time("End")
        else:
            exit()

    elif args.dbinitcode:
        # Print start time
        Log.log.time("Start")
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
            print(bagObject.maakTabel())
        # Print end time
        Log.log.time("End")

    elif args.extract:
        from bagfilereader import BAGFileReader
        from bagobject import VerblijfsObjectPand, AdresseerbaarObjectNevenAdres, VerblijfsObjectGebruiksdoel, Woonplaats, OpenbareRuimte, Nummeraanduiding, Ligplaats, Standplaats, Verblijfsobject, Pand
        # Print start time
        Log.log.time("Start")
        # Extracts any data from any source files/dirs/zips/xml/csv etc
        Database().log_actie('start_extract', args.extract)
        myreader = BAGFileReader(args.extract)
        myreader.process()
        Database().log_actie('stop_extract', args.extract)
        # Print end time
        Log.log.time("End")

    elif args.query:
        # Print start time
        Log.log.time("Start")
        # Voer willekeurig SQL script uit uit
        Database().log_actie('start_query', args.query)
        database = Database()

        database.file_uitvoeren(args.query)
        Database().log_actie('stop_query', args.query)
        # Print end time
        Log.log.time("End")

    else:
        parser.error("Command line parameters niet herkend")
    sys.exit()


if __name__ == "__main__":
    main()
