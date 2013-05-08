#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Doel: het voorzien van instellingen aan de Top10extract-programmatuur.

import ConfigParser
import os.path

SECTION_OGR_OPTIONS = 'OGROptions'
SECTION_POSTGIS = 'PostGIS'

DEFAULT_PG_HOST = 'localhost'
DEFAULT_PG_PORT = 5432
DEFAULT_PG_DB = 'top10nl'
DEFAULT_PG_SCHEMA = 'public'

class SettingsProvider:

    def __init__(self, args):
        self._args = args
        
        ### Controle argumenten
        # Check geldigheid dir
        if not os.path.isdir(args.dir):
            print 'De opgegeven lokatie `%s` is geen geldige directory' % args.dir
            sys.exit(1)

        # Check geldigheid settings file
        if not os.path.isfile(args.settings_ini):
            print 'Op de opgegeven lokatie `%s` is geen INI-bestand aangetroffen' % args.settings_ini
            sys.exit(1)
        
        # Check geldigheid gfs template
        if not os.path.isfile(args.gfs_template):
            print 'Op de opgegeven lokatie `%s` is geen GFS template-bestand aangetroffen' % args.gfs_template
            sys.exit(1)

        # Lees settings
        self._config = ConfigParser.SafeConfigParser()
        self._config.read(args.settings_ini)

    def _get_postgis_setting(self, setting):
        if self._config.has_option(SECTION_POSTGIS, setting):
            return self._config.get(SECTION_POSTGIS, setting)
        else:
            return None

    def _get_ogr_setting(self, setting):
        if self._config.has_option(SECTION_OGR_OPTIONS, setting):
            return self._config.get(SECTION_OGR_OPTIONS, setting)
        else:
            return None
    
    def split_dir(self):
        # cmd
        return self._args.dir
    
    def settings_ini(self):
        # cmd
        return self._args.settings_ini
    
    def pre_sql(self):
        # cmd
        return self._args.pre_sql
    
    def post_sql(self):
        # cmd
        return self._args.post_sql
    
    def spatial_filter(self):
        # cmd
        return self._args.spat
    
    def _multi(self):
        # cmd
        return self._args.multi
    
    def gfs_template(self):
        # cmd
        return self._args.gfs_template
        
    def pg_host(self):
        # cmd, ini
        if self._args.pg_host is not None:
            return self._args.pg_host
        elif self._get_postgis_setting('PG_HOST') is not None:
            return self._get_postgis_setting('PG_HOST')
        else:
            return DEFAULT_PG_HOST
    
    def pg_port(self):
        # cmd, ini
        if self._args.pg_port is not None:
            return self._args.pg_port
        elif self._get_postgis_setting('PG_PORT') is not None:
            return self._get_postgis_setting('PG_PORT')
        else:
            return DEFAULT_PG_PORT
    
    def pg_db(self):
        # cmd, ini
        if self._args.pg_db is not None:
            return self._args.pg_db
        elif self._get_postgis_setting('PG_DB') is not None:
            return self._get_postgis_setting('PG_DB')
        else:
            return DEFAULT_PG_DB
    
    def pg_schema(self):
        # cmd, ini
        if self._args.pg_schema is not None:
            return self._args.pg_schema
        elif self._get_postgis_setting('PG_SCHEMA') is not None:
            return self._get_postgis_setting('PG_SCHEMA')
        else:
            return DEFAULT_PG_SCHEMA
    
    def pg_user(self):
        # cmd, ini
        if self._args.pg_user is not None:
            return self._args.pg_user
        else:
            return self._get_postgis_setting('PG_USER')
    
    def pg_pass(self):
        # cmd, ini
        if self._args.pg_pass is not None:
            return self._args.pg_pass
        else:
            return self._get_postgis_setting('PG_PASSWORD')
    
    def pg_conn(self):
        return '-h %s -p %s -U %s -d %s' % (self.pg_host(), self.pg_port(), self.pg_user(), self.pg_db())
    
    def pg_clientencoding(self):
        # ini
        return self._get_postgis_setting('PG_CLIENTENCODING')
    
    def ogr_ssrs(self):
        # ini
        return self._get_ogr_setting('OGR_SSRS')
    
    def ogr_asrs(self):
        # ini
        return self._get_ogr_setting('OGR_ASRS')
    
    def ogr_tsrs(self):
        # ini
        return self._get_ogr_setting('OGR_TSRS')
    
    def ogr_out_format(self):
        # ini (+ cmd)
        return self._get_ogr_setting('OGR_OUT_FORMAT')
        
    def ogr_out_options(self):
        # ini
        return self._get_ogr_setting('OGR_OUT_OPTIONS')
    
    def ogr_lco(self):
        # ini
        return self._get_ogr_setting('OGR_LCO')
    
    def ogr_overwrite_or_append(self):
        # ini
        return self._get_ogr_setting('OGR_OVERWRITE_OR_APPEND')
    
    def ogr_gt(self):
        # ini
        return self._get_ogr_setting('OGR_GT')
    
    def ogr_opt_multiattr(self):
        if self._multi() == 'eerste':
            return '-splitlistfields -maxsubfields 1'
        elif self._multi() == 'meerdere':
            return '-splitlistfields'
        elif self._multi() == 'stringlist':
            return '-fieldTypeToString StringList'
        elif self._multi() == 'array':
            return ''
