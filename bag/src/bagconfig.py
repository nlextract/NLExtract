# ------------------------------------------------------------------------------
# Naam:         libBAGconfiguratie.py
# Omschrijving: Generieke functies het lezen van BAG.conf
# Auteur:       Matthijs van der Deijl
#
# Versie:       1.2
# Datum:        24 november 2009
#
# Ministerie van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer
# ------------------------------------------------------------------------------
import sys
import os

from configparser import ConfigParser
from log import Log


class BAGConfig:
    # Singleton: sole static instance of Log to have a single Log object
    config = None

    def __init__(self, args, home_path=None):
        # See if home dir is passed
        if home_path:
            self.bagextract_home = home_path
        else:
            # Derive home dir from script location
            self.bagextract_home = os.path.abspath(
                os.path.join(os.path.realpath(os.path.dirname(sys.argv[0])), os.path.pardir))

        # Default config file
        self.config_file = os.path.realpath(self.bagextract_home + '/extract.conf')

        # Option: overrule config file with command line arg pointing to config file
        if args and args.config:
            self.config_file = args.config

        Log.log.debug("Configuratiebestand is " + str(self.config_file))
        if not os.path.exists(self.config_file):
            Log.log.fatal("kan het configuratiebestand '" + str(self.config_file) + "' niet vinden")

        self.configdict = ConfigParser()
        try:
            self.configdict.read(self.config_file)
        except Exception:
            Log.log.fatal("" + str(self.config_file) + " kan niet worden ingelezen")

        try:
            # Zet parameters uit config bestand
            self.database = self.configdict.defaults()['database']
            self.schema = self.configdict.defaults()['schema']
            self.host = self.configdict.defaults()['host']
            self.user = self.configdict.defaults()['user']
            self.password = self.configdict.defaults()['password']
            # Optional port config with default
            self.port = 5432
            if self.configdict.has_option(None, 'port'):
                self.port = self.configdict.defaults()['port']

        except Exception:
            Log.log.fatal("Configuratiebestand " + str(self.config_file) + " is niet volledig")

        # Assign Singleton (of heeft Python daar namespaces voor?) (Java achtergrond)
        BAGConfig.config = self

        if not args:
            return

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

        except Exception:
            Log.log.fatal(" het overrulen van configuratiebestand " + str(self.config_file) + " via commandline loopt spaak")

    def save(self):
        section = self.configdict.defaults()
        section['database'] = self.database
        section['schema'] = self.schema
        section['host'] = self.host
        section['user'] = self.user
        section['password'] = self.password
        section['port'] = self.port

        with open(self.config_file, 'w') as configfile:  # save
            self.configdict.write(configfile)
