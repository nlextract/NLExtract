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
try:
    import psycopg2
except ImportError:
    raise

from log import Log
from bagconfig import BAGConfig


class Database:
    def __init__(self):
        # Lees de configuratie uit globaal BAGConfig object
        self.config = BAGConfig.config
        self.connection = None

    def initialiseer(self, bestand):
        Log.log.info('Probeer te verbinden...')
        self.verbind(True)

        Log.log.info('database script uitvoeren...')
        try:
            script = open(bestand, 'r').read()
            self.cursor.execute(script)
            self.commit(True)
            Log.log.info('script is uitgevoerd')
        except psycopg2.DatabaseError as e:
            Log.log.fatal("ik krijg deze fout '%s' uit het bestand '%s'" % (str(e), str(bestand)))

    def verbind(self, initdb=False):
        if self.connection and self.connection.closed == 0:
            Log.log.debug("reusing db connection")
            return

        try:
            # Connect using configured parameters
            self.connection = psycopg2.connect(
                database=self.config.database,
                user=self.config.user,
                host=self.config.host,
                port=self.config.port,
                password=self.config.password)

            self.cursor = self.connection.cursor()

            if initdb:
                self.maak_schema()

            self.zet_schema()
            self.zet_tijdzone()
            Log.log.debug("verbonden met de database '%s', schema '%s', connId=%d" % (self.config.database, self.config.schema, self.connection.fileno()))
        except Exception as e:
            raise (e)

    def maak_schema(self):
        # Public schema: no further action required
        if self.config.schema != 'public':
            # A specific schema is required create it and set the search path
            self.uitvoeren('''DROP SCHEMA IF EXISTS %s CASCADE;''' % self.config.schema)
            self.uitvoeren('''CREATE SCHEMA %s;''' % self.config.schema)
            self.commit()

    def zet_schema(self):
        # Non-public schema set search path
        if self.config.schema != 'public':
            # Always set search path to our schema
            self.uitvoeren('SET search_path TO %s,public' % self.config.schema)
            # self.connection.close()

    def zet_tijdzone(self, tijdzone='Europe/Amsterdam'):
        self.uitvoeren("SET time zone '%s'" % tijdzone)

    def has_log_actie(self, actie, bestand="n.v.t", error=False):
        sql = "SELECT * FROM nlx_bag_log WHERE bestand = %s AND actie = %s AND error = %s"
        parameters = (bestand, actie, error)
        return self.tx_uitvoeren(sql, parameters)

    def log_actie(self, actie, bestand="n.v.t", bericht='geen', error=False):
        sql = "INSERT INTO nlx_bag_log(actie, bestand, error, bericht) VALUES (%s, %s, %s, %s)"
        parameters = (actie, bestand, error, bericht)
        self.tx_uitvoeren(sql, parameters)

    def log_meta(self, sleutel, waarde, replace=True):
        if replace:
            sql = "DELETE FROM nlx_bag_info WHERE sleutel = '%s'" % sleutel
            self.tx_uitvoeren(sql)

        sql = "INSERT INTO nlx_bag_info(sleutel, waarde) VALUES (%s, %s)"
        parameters = (sleutel, waarde)
        self.tx_uitvoeren(sql, parameters)

    def uitvoeren(self, sql, parameters=None):
        try:
            if parameters:
                self.cursor.execute(sql, parameters)
            else:
                self.cursor.execute(sql)

            # Log.log.debug(self.cursor.statusmessage)
        except Exception as e:
            Log.log.error("fout %s voor query: %s met parameters %s" % (str(e), str(sql), str(parameters)))
            self.log_actie("uitvoeren_db", "n.v.t", "fout=%s" % str(e), True)
            raise

        return self.cursor.rowcount

    def select(self, sql):
        self.verbind()
        try:
            self.cursor.execute(sql)
            rows = self.cursor.fetchall()
            self.connection.commit()
            return rows
        except (psycopg2.Error,) as foutmelding:
            Log.log.error("*** FOUT *** Kan SQL-statement '%s' niet uitvoeren:\n %s" % (sql, foutmelding))
            return []

    def file_uitvoeren(self, sqlfile):
        self.e = None
        try:
            Log.log.info("SQL van file = %s uitvoeren..." % sqlfile)
            self.verbind()
            f = open(sqlfile, 'r')
            sql = f.read()
            self.uitvoeren(sql)
            self.commit(True)
            f.close()
            Log.log.info("SQL uitgevoerd OK")
        except Exception as e:
            self.e = e
            self.log_actie("uitvoeren_db_file", "n.v.t", "fout=%s" % str(e), True)
            Log.log.fatal("ik kan dit script niet uitvoeren vanwege deze fout: %s" % (str(e)))

    def tx_uitvoeren(self, sql, parameters=None):
        self.e = None
        try:
            self.verbind()
            self.uitvoeren(sql, parameters)
            self.commit()

            # Log.log.debug(self.cursor.statusmessage)
        except Exception as e:
            self.e = e
            Log.log.error("fout %s voor tx_uitvoeren: %s met parameters %s" % (str(e), str(sql), str(parameters)))
            self.close()

        return self.cursor.rowcount

    def commit(self, close=False):
        try:
            self.connection.commit()
            Log.log.debug("database commit ok connId=%d" % self.connection.fileno())
        except Exception as e:
            self.e = e
            Log.log.error("fout in commit aktie: %s" % str(e))
        finally:
            if close:
                self.close()

    def close(self):
        try:
            connId = self.connection.fileno()
            self.connection.close()
            Log.log.debug("database connectie %d gesloten" % connId)
        except Exception as e:
            Log.log.error("fout in close aktie: %s" % str(e))
        finally:
            self.cursor = None
            self.connection = None
