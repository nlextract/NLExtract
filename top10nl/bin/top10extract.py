#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Doel: overzetten van een Top10NL GML-bestand naar een door OGR ondersteund formaat (bijv.
# PostGIS).

# Stappen:
# * Scripts vooraf
# * Droppen tabellen
# * Validatie GML (optioneel)
# * Opsplitsen en transformeren GML
# * Laden data met OGR
# * Verwijderen duplicate data
# * Scripts achteraf

# Dependencies:
# * Settings: settings.ini
# * GFS template: top10-gfs-template_split.xml
# * Transformatie-script (Python): top10trans.py
# * Opsplits-stylesheet (XSLT): top10-split.xsl

# Aanroepen:
# * met 1 GML-bestand
# * met bestandslijst(en) met GML-bestanden
# * met meerdere GML-bestanden via wildcard
# * met directory
# NB: ook als er meerdere bestanden via de command line aangegeven kunnen worden, kunnen deze
# wildcards bevatten. Een bestand wordt als GML-bestand beschouwd, indien deze de extensie GML of
# XML heeft, anders wordt het als een GML-bestandslijst gezien.

# Toepassen settings:
# * Definitie in settings-file
# * Mogelijk om settings te overriden via command-line parameters (alleen voor wachtwoorden)
# * Mogelijk om settings file mee te geven via command-line

# TODO:
# * Locale settings Windows
# * XSLT-transformatie versnellen. De huidige versie is veel minder snel dan transformatie met XML
#   Starlet (die op Windows niet de grootste bladen aankan).
# * Splitsen optioneel maken

# Ideeen:
# * Output naar batch file (bat / sh) -> lost afhankelijk van Python niet op door trans script
# * Meerdere settings overriden via command-line parameters

# GML-versies:
# Een GML-bestand wordt als Top10NL bestand beschouwd wanneer het een van de volgende namespaces
# gebruikt voor een namespace prefix. Dit moet gebeuren binnen de eerste 1000 bytes van het bestand.
# * Top10NL 1.0: http://www.kadaster.nl/top10nl
# * Top10NL 1.1.1: http://www.kadaster.nl/schemas/top10nl/v20120116 (vanaf sept. '12)

# Imports
import argparse
import atexit
import glob
import os
import os.path
import shutil
import subprocess
import sys

from time import localtime, strftime

from settingsprovider import SettingsProvider

# Constantes
SETTINGS_INI = 'top10-settings.ini'
GFS_TEMPLATE = 'top10-gfs-template_split.xml'
MAX_SPLIT_FEATURES = 30000

FORMAT_POSTGRESQL = 'PostgreSQL'
SCRIPT_HOME = ''

GML_HEADER_SIZE = 1000

# Top10NL namespaces
NS_V1_0 = 'http://www.kadaster.nl/top10nl'
NS_V1_1_1 = 'http://www.kadaster.nl/schemas/top10nl/v20120116'

# Top10NL versies (numeriek)
V1_0 = 10000
V1_1_1 = 10101

# Global variables
first_load = True
settings = None

# Exit handlers
def on_exit():
    # Reset password in environment variabele
    # NB: dit lijkt niet nodig te zijn!
    #print 'Huidig PG password:', os.environ['PGPASSWORD']
    #os.environ['PGPASSWORD'] = ''
    #os.environ['PGCLIENTENCODING'] = ''

    return

atexit.register(on_exit)


# Voert het meegegeven commando uit
def execute_cmd(cmd):
    use_shell = True
    if os.name == 'nt':
        use_shell = False

    print cmd
    error_code = subprocess.call(cmd, shell=use_shell)
    if error_code:
        sys.exit("Command failed: %s" % cmd)


# Voert het meegegeven SQL-bestand uit
def execute_sql(sql):
    if sql is None:
        return

    if not os.path.exists(sql):
        print 'Het opgegeven SQL-script `%s` is niet aangetroffen' % sql
        sys.exit(1)

    cmd = "psql -v schema='%s' -f %s %s" % (settings.pg_schema(), sql, settings.pg_conn())
    execute_cmd(cmd)

    return

# Voert het meegegeven SQL-string uit
def execute_sql_str(sql):
    if sql is None:
        return

    cmd = 'psql -c "%s" %s' % (sql, settings.pg_conn())
    execute_cmd(cmd)

    return


# Valideert GML-bestanden volgens de Top10NL schema's
def validate_gml():
    pass


# Transformeert het GML-bestand met de stylesheet en schrijft het resultaat weg
def trans_gml(gml, xsl, dir):

    # Opknippen en transformeren GML-bestand
    trans_path = abspath('top10trans.py')
    cmd = 'python %s --max_features %d %s %s %s' % (trans_path, MAX_SPLIT_FEATURES, gml, xsl, dir)
    execute_cmd(cmd)

    # alternatief:
    # top10_trans = __import__('top10trans')
    # top10_trans.transform(gml, xsl, dir, MAX_SPLIT_FEATURES)


# Laadt de data met OGR2OGR
def load_data(gml):

    global first_load

    # Kopieer / overschrijf GFS bestand
    file_ext = os.path.splitext(gml)
    shutil.copy(settings.gfs_template(), file_ext[0] + '.gfs')

    # Transformeren?
    t_srs = ''
    if settings.ogr_tsrs() != '':
        t_srs = '-t_srs ' + settings.ogr_tsrs()

    # PG connectie
    if settings.ogr_out_format() == FORMAT_POSTGRESQL and settings.ogr_out_options() is None:
        # Bepaal de connectie string voor PostgreSQL
        ogr_out_options = 'PG:dbname=%s host=%s port=%s user=%s active_schema=%s' % (
        settings.pg_db(), settings.pg_host(), settings.pg_port(),
        settings.pg_user(), settings.pg_schema())
    else:
        # Gebruik de bestaande opties
        ogr_out_options = settings.ogr_out_options()

    # Spatial filter
    ogr_spatial_filter = ''
    if settings.spatial_filter() != None:
        ogr_spatial_filter = '-spat %f %f %f %f' % (settings.spatial_filter()[0], settings.spatial_filter()[1], settings.spatial_filter()[2], settings.spatial_filter()[3])

    # Voer ogr2ogr uit
    cmd = 'ogr2ogr %s -f %s "%s" %s %s %s -a_srs %s %s -s_srs %s %s %s' % (
        settings.ogr_overwrite_or_append(),
        settings.ogr_out_format(),
        ogr_out_options,
        settings.ogr_gt(),
        settings.ogr_opt_multiattr(),
        settings.ogr_lco() if first_load else "",
        settings.ogr_asrs(),
        t_srs,
        settings.ogr_ssrs(),
        ogr_spatial_filter,
        gml
    )
    execute_cmd(cmd)

    # Voorkom dat de layer creation options bij de volgende run wordt meegegeven, zodat de
    # waarschuwing dat deze opties genegeerd worden niet langer wordt getoond.
    first_load = False


# Controleert een bestand, bestandslijst of directory en voegt het resultaat met de geldige
# Top10NL-bestanden toe aan de meegegeven lijst
def evaluate_file(list, check):
    if os.path.isfile(check):
        # Controleer of het gevonden bestand een GML-bestand is of een bestandslijst
        file_ext = os.path.splitext(check)
        ext = file_ext[1].lower()
        if ext == ".gml" or ext == ".xml":
            # Behandel opgegeven check-bestand als GML-bestand
            check_file_version(list, check)
            return

        # Behandel opgegeven check-bestand als bestandslijst
        with open(check) as f:
            dirname = os.path.dirname(check)
            for line in f:
                # Het pad is relatief t.o.v. de lijst
                filename = os.path.realpath(os.path.join(dirname, line.rstrip('\r\n')))
                check_file(list, filename)

        return

    if os.path.isdir(check):
        # Behandel opgegeven check-bestand als directory
        file_list = glob.glob(os.path.join(check, '*.[gxGX][mM][lL]'))
    else:
        # Behandel opgegeven check-bestand als bestandslijst
        file_list = glob.glob(check)

    for file in file_list:
        check_file(list, file)

    return


# Controleert of een bestand een geldig Top10NL GML-bestand is
def check_file(list, file):
    file_ext = os.path.splitext(file)
    ext = file_ext[1].lower()

    if ext == ".gml" or ext == ".xml":
        check_file_version(list, file)

    return


# Bepaalt de Top10NL versie van een GML-bestand
def check_file_version(list, file):
    # Controleer of er een Top10NL namespace wordt gebruikt
    f = open(file)
    header = f.read(GML_HEADER_SIZE)
    f.close()

    if header.find(NS_V1_0) != -1:
        # Behandel bestand als Top10NL 1.0-bestand
        if not file in list:
            list.append((V1_0, file))
    elif header.find(NS_V1_1_1) != -1:
        # Behandel bestand als Top10NL 1.1.1-bestand
        if not file in list:
            list.append((V1_1_1, file))

    return


# Maakt een absoluut pad voor een relatief pad (t.o.v. SCRIPT_HOME)
def abspath(relpath):
    return os.path.realpath(os.path.join(SCRIPT_HOME, relpath))


# Verwerkt de data volgens het ETL-principe: extract, transform, load
def process(gml):
    ### Extract fase
    # * Stel lijst samen van alle in te lezen GML-bestanden
    list = []
    for file in gml:
        evaluate_file(list, file)

    if len(list) == 0:
        print 'Er zijn geen GML-bestanden aangetroffen om in te lezen'
        sys.exit(1)

    # * Validatie GML (optioneel)
    validate_gml()

    ### Transform fase
    # * Opsplitsen en transformeren GML
    xsl1_0 = abspath('top10-split.xsl')
    xsl1_1_1 = abspath('top10-split_v1_1_1.xsl')
    for tuple in list:
        if tuple[0] == V1_0:
            trans_gml(tuple[1], xsl1_0, settings.split_dir())
        elif tuple[0] == V1_1_1:
            trans_gml(tuple[1], xsl1_1_1, settings.split_dir())

    ### Load fase

    # * Aanmaken schema (indien niet bestaand en niet public)

    # eerst functie aanmaken
    sql = abspath('top10-create-schema.sql')
    execute_sql(sql)

    # functie uitvoeren met schema naam
    sql = 'SELECT _nlx_createschema(\'%s\')' % (settings.pg_schema())
    execute_sql_str(sql)

    # functie droppen
    sql = 'DROP FUNCTION _nlx_createschema(schemaname VARCHAR)'
    execute_sql_str(sql)

    # * Scripts vooraf
    execute_sql(settings.pre_sql())

    # * Droppen tabellen
    sql = abspath('top10-drop-tables.sql')
    execute_sql(sql)

    # * Laden data met OGR
    file_list = glob.glob(os.path.join(settings.split_dir(), '*.[gxGX][mM][lL]'))
    for file in file_list:
        load_data(file)

    # * Verwijderen duplicate data
    sql = abspath('top10-delete-duplicates.sql')
    execute_sql(sql)

    # * Scripts achteraf
    execute_sql(settings.post_sql())

    # Reset password in environment variabele in exit handler on_exit


def main():
    global SCRIPT_HOME, settings

    # Default-waarden
    SCRIPT_HOME = os.path.dirname(os.path.realpath(sys.argv[0]))
    DEFAULT_SETTINGS_INI = abspath(SETTINGS_INI)
    DEFAULT_GFS_TEMPLATE = abspath(GFS_TEMPLATE)

    # Samenstellen command line parameters
    argparser = argparse.ArgumentParser(description='Verwerk een of meerdere GML-bestanden')
    argparser.add_argument('gml', type=str, help='het GML-bestand of de lijst met GML-bestanden', metavar='GML', nargs='+')
    argparser.add_argument('--dir',   type=str,   help='lokatie getransformeerde bestanden', dest='dir', required=True)
    argparser.add_argument('--ini',   type=str,   help='het settings-bestand (default: %s)' % SETTINGS_INI, dest='settings_ini', default=DEFAULT_SETTINGS_INI)
    argparser.add_argument('--pre',   type=str,   help='SQL-script vooraf', dest='pre_sql')
    argparser.add_argument('--post',  type=str,   help='SQL-script achteraf', dest='post_sql')
    argparser.add_argument('--spat',  type=float, help='spatial filter', dest='spat', nargs=4, metavar=('xmin', 'ymin', 'xmax', 'ymax'))
    argparser.add_argument('--multi', type=str,   help='multi-attributen (default: eerste)', choices=['eerste','meerdere','stringlist','array'], dest='multi', default='eerste')
    argparser.add_argument('--gfs',   type=str,   help='GFS template-bestand (default: %s)' % GFS_TEMPLATE, dest='gfs_template', default=DEFAULT_GFS_TEMPLATE)

    # Database verbindingsparameters
    # NB: geen defaults, deze komen uit de settings file
    argparser.add_argument('--pg_host',     type=str, help='PostgreSQL server host', dest='pg_host')
    argparser.add_argument('--pg_port',     type=int, help='PostgreSQL server poort', dest='pg_port')
    argparser.add_argument('--pg_db',       type=str, help='PostgreSQL database', dest='pg_db')
    argparser.add_argument('--pg_schema',   type=str, help='PostgreSQL schema', dest='pg_schema')
    argparser.add_argument('--pg_user',     type=str, help='PostgreSQL gebruikersnaam', dest='pg_user')
    argparser.add_argument('--pg_password', type=str, help='PostgreSQL wachtwoord', dest='pg_pass')
    args = argparser.parse_args()

    print 'Begintijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

    ### Uitlezen configuratie
    # Lees settings
    settings = SettingsProvider(args)

    # Zet password in environment variabele
    if not 'PGPASSWORD' in os.environ:
        os.environ['PGPASSWORD'] = settings.pg_pass()

    # Stel client encoding in
    if settings.pg_clientencoding() is not None:
        os.environ['PGCLIENTENCODING'] = settings.pg_clientencoding()

    ### Verwerken data
    process(args.gml)

    print 'Eindtijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

if __name__ == "__main__":
    main()
