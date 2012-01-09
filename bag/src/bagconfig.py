#------------------------------------------------------------------------------
# Naam:         libBAGconfiguratie.py
# Omschrijving: Generieke functies het lezen van BAG.conf
# Auteur:       Matthijs van der Deijl
#
# Versie:       1.2
# Datum:        24 november 2009
#
# Ministerie van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer
#------------------------------------------------------------------------------
import sys
import os

from ConfigParser import ConfigParser

class BAGConfig:
   # Singleton: sole static instance of Log to have a single Log object
    config = None

    def __init__(self, args):
        if not os.path.exists('bag.conf'):
            print "*** FOUT *** Kan configuratiebestand 'bag.conf' niet openen."
            print ""
            #raw_input("Druk <enter> om af te sluiten")
            sys.exit()
            
        configdict = ConfigParser()
        configdict.read('bag.conf')
        try:
            self.database = configdict.defaults()['database']
            self.schema   = configdict.defaults()['schema']
            self.host     = configdict.defaults()['host']
            self.user     = configdict.defaults()['user']
            self.password = configdict.defaults()['password']
            self.port = configdict.defaults()['port']

        except:
            print "*** FOUT *** Inhoud van configuratiebestand 'bag.conf' is niet volledig."
            sys.exit()

        try:
            # Optional overrule from (commandline) args
            if args.database:
                self.database = args.database
            if args.host:
                self.host = args.host
            if args.schema:
                self.schema = args.schema
            # default to public schema
            if not self.schema:
                self.schema = 'public'
            if args.username:
                self.user = args.username
            if args.port:
                self.port = args.port
            if args.no_password:
                # Gebruik geen wachtwoord voor de database verbinding
                self.password = None
            else:
                if args.password:
                    self.password = args.password

            # Assign Singleton
            BAGConfig.config = self
        except:
            print "*** FOUT *** arguments overrule error"
            sys.exit()


