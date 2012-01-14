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
from logging import Log

class BAGConfig:
   # Singleton: sole static instance of Log to have a single Log object
    config = None

    def __init__(self, args):
        # Derive home dir from script location
        self.bagextract_home = os.path.realpath(os.path.dirname(sys.argv[0]) + '/..')

        # Default config file
        config_file = os.path.realpath(self.bagextract_home + '/extract.conf')

        # Option: overrule config file with command line arg pointing to config file
        if args.config:
            config_file = args.config

        Log.log.info("Configuratiebestand is " + str(config_file))
        if not os.path.exists(config_file):
            Log.log.fatal("ik kan het configuratiebestand '" + str(config_file) + "' ech niet vinden.")

        configdict = ConfigParser()
        try:
            configdict.read(config_file)
        except:
            Log.log.fatal("ik kan " + str(config_file) + " wel vinden maar niet inlezen.")

        try:
            # Zet parameters uit config bestand
            self.database = configdict.defaults()['database']
            self.schema   = configdict.defaults()['schema']
            self.host     = configdict.defaults()['host']
            self.user     = configdict.defaults()['user']
            self.password = configdict.defaults()['password']
            self.port = configdict.defaults()['port']

        except:
            Log.log.fatal(" de inhoud van configuratiebestand " + str(config_file) + " is niet volledig.")

        try:
            # Optioneel: overrulen met (commandline) args
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

            # Assign Singleton (of heeft Python daar namespaces voor?) (Java achtergrond)
            BAGConfig.config = self
        except:
            Log.log.fatal(" het overrulen van configuratiebestand " + str(config_file) + " via commandline loopt spaak")


