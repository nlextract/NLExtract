__author__ = "Matthijs van der Deijl"
__date__ = "$Dec 09, 2009 00:00:01 AM$"

"""
 Naam:         postgresdb.py
 Omschrijving: Generieke functies voor databasegebruik binnen BAG Extract+
 Auteur:       Milo van der Linden, Just van den Broecke, Matthijs van der Deijl (originele versie)

 Versie:       1.0
               - Deze database klasse is vanaf heden specifiek voor postgres/postgis
 Datum:        29 dec 2011
"""

import psycopg2
from logging import Log
from bagconfig import BAGConfig

class Database:
    def __init__(self):
        # Lees de configuratie uit globaal BAGConfig object
        self.config = BAGConfig.config

    def initialiseer(self, bestand):
        Log.log.info('Probeer te verbinden...')
        self.verbind(True)

        Log.log.info('database script uitvoeren...')
        try:
            script = open(bestand, 'r').read()
            self.cursor.execute(script)
            self.connection.commit()
            Log.log.info('script is uitgevoerd')
        except psycopg2.DatabaseError, e:
            Log.log.fatal("ik krijg deze fout '%s' uit het bestand '%s'" % (str(e), str(bestand)))

    def verbind(self, initdb=False):
        try:
            self.connection = psycopg2.connect("dbname='%s' user='%s' host='%s' password='%s'" % (self.config.database,
                                                                                                  self.config.user,
                                                                                                  self.config.host,
                                                                                                 self.config.password))
            self.cursor = self.connection.cursor()

            if initdb:
                self.maak_schema()

            self.zet_schema()
            Log.log.info("verbonden met de database %s" % (self.config.database))
        except Exception, e:
            Log.log.fatal("ik kan geen verbinding maken met database '%s'" % (self.config.database))

    def maak_schema(self):
        # Public schema: no further action required
        if self.config.schema != 'public':
            # A specific schema is required create it and set the search path
            self.uitvoeren('''DROP SCHEMA IF EXISTS %s CASCADE;''' % self.config.schema)
            self.uitvoeren('''CREATE SCHEMA %s;''' % self.config.schema)
            self.connection.commit()

    def zet_schema(self):
        # Non-public schema set search path
        if self.config.schema != 'public':
            # Always set search path to our schema
            self.uitvoeren('SET search_path TO %s,public' % self.config.schema)
            self.connection.commit()

    def uitvoeren(self, sql, parameters=None):
        try:
            if parameters:
                self.cursor.execute(sql, parameters)
            else:
                self.cursor.execute(sql)

            # Log.log.debug(self.cursor.statusmessage)
        except (Exception), e:
            Log.log.error("fout %s voor query: %s met parameters %s" % (str(e), str(sql), str(parameters))  )
            return self.cursor.rowcount

    def file_uitvoeren(self, sqlfile):
        try:
            Log.log.info("SQL van file = %s uitvoeren..." % sqlfile)
            self.verbind()
            f = open(sqlfile, 'r')
            sql = f.read()
            self.uitvoeren(sql)
            self.connection.commit()
            f.close()
            Log.log.info("SQL uitgevoerd OK")
        except (Exception), e:
            Log.log.fatal("ik kan dit script niet uitvoeren vanwege deze fout: %s" % (str(e)))
