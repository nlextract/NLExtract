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
# * Transformatie-script (Python): top10-trans.py
# * Opsplits-stylesheet (XSLT): top10-split.xslt

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
# * XSLT-transformatie versnellen. De huidige verise is veel minder snel dan transformatie met XML
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
import ConfigParser
import argparse
import atexit
import glob
import os
import os.path
import shutil
import subprocess
import sys

from time import localtime, strftime

# Constantes
SETTINGS_INI = 'top10-settings.ini'
MAX_SPLIT_FEATURES = 40000

SECTION_OGR_OPTIONS = 'OGROptions'
SECTION_POSTGIS = 'PostGIS'
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
config = None
pg_conn = None

# Exit handlers
def on_exit():
    # Reset password in environment variabele
    # NB: dit lijkt niet nodig te zijn!
    #print 'Huidig PG password:', os.environ['PGPASSWORD']
    #os.environ['PGPASSWORD'] = ''
    #os.environ['PGCLIENTENCODING'] = ''

    return

atexit.register(on_exit)

def execute_cmd(cmd):
    use_shell = True
    if os.name == 'nt':
        use_shell = False
        
    print cmd
    subprocess.call(cmd, shell=use_shell)

def execute_sql(sql):
    if sql is None:
        return

    if not os.path.exists(sql):
        print 'Het opgegeven SQL-script `%s` is niet aangetroffen' % sql
        sys.exit(1)

    cmd = 'psql -f %s %s' % (sql, pg_conn)
    execute_cmd(cmd)

    return


def validate_gml():
    pass


def trans_gml(gml, xsl, dir):
    # Opknippen en transformeren GML-bestand

#    cmd = 'python %s --max_features %d %s %s %s' % (py, MAX_SPLIT_FEATURES, gml, xsl, dir)
#    print cmd
#    execute_cmd(cmd)

    # TODO hernoem de file top10-trans.py andres kunnen we niet importeren
    top10_trans = __import__('top10-trans')
    top10_trans.transform(gml, xsl, dir, MAX_SPLIT_FEATURES)

def get_postgis_setting(setting):
    if config.has_option(SECTION_POSTGIS, setting):
        return config.get(SECTION_POSTGIS, setting)
    else:
        return None


def get_ogr_setting(setting):
    if config.has_option(SECTION_OGR_OPTIONS, setting):
        return config.get(SECTION_OGR_OPTIONS, setting)
    else:
        return None


def load_data(gml, gfs_template, spatial_filter):
    # Kopieer / overschrijf GFS bestand
    file_ext = os.path.splitext(gml)
    shutil.copy(gfs_template, file_ext[0] + '.gfs')

    # Transformeren?
    t_srs = ''
    if get_ogr_setting('OGR_TSRS') != '':
        t_srs = '-t_srs' + get_ogr_setting('OGR_TSRS')

    # PG connectie
    #print get_ogr_setting('OGR_OUT_FORMAT')
    #print get_ogr_setting('OGR_OUT_OPTIONS')
    if get_ogr_setting('OGR_OUT_FORMAT') == FORMAT_POSTGRESQL and get_ogr_setting('OGR_OUT_OPTIONS') is None:
        # Bepaal de connectie string voor PostgreSQL
        ogr_out_options = 'PG:dbname=%s host=%s port=%s user=%s password=%s' % (
        get_postgis_setting('PG_DB'), get_postgis_setting('PG_HOST'), get_postgis_setting('PG_PORT'),
        get_postgis_setting('PG_USER'), os.environ['PGPASSWORD'])
    else:
        # Gebruik de bestaande opties
        ogr_out_options = get_ogr_setting('OGR_OUT_OPTIONS')
    #print ogr_out_options

    # Spatial filter
    ogr_spatial_filter = ''
    if spatial_filter != None:
        ogr_spatial_filter = '-spat %f %f %f %f' % (spatial_filter[0], spatial_filter[1], spatial_filter[2], spatial_filter[3])

    # Voer ogr2ogr uit
    cmd = 'ogr2ogr %s -f %s "%s" %s %s %s -a_srs %s %s -s_srs %s %s %s' % (
    get_ogr_setting('OGR_OVERWRITE_OR_APPEND'),
    get_ogr_setting('OGR_OUT_FORMAT'),
    ogr_out_options,
    get_ogr_setting('OGR_GT'),
    get_ogr_setting('OGR_OPT_MULTIATTR'),
    get_ogr_setting('OGR_LCO'),
    get_ogr_setting('OGR_ASRS'),
    t_srs,
    get_ogr_setting('OGR_SSRS'),
    ogr_spatial_filter,
    gml
    )
    execute_cmd(cmd)


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

    #print 'File list:', file_list

    for file in file_list:
        check_file(list, file)

    return


def check_file(list, file):
    #print 'File to check:', file

    #if not os.path.exists(file):
    #    print 'Het opgegeven GML-bestand of bestandslijst `%s` is niet aangetroffen' % file
    #    sys.exit(1)

    file_ext = os.path.splitext(file)
    ext = file_ext[1].lower()

    if ext == ".gml" or ext == ".xml":
        check_file_version(list, file)

    return


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

def main():
    global config, pg_conn

    SCRIPT_HOME = os.path.realpath(os.path.dirname(sys.argv[0]))
    DEFAULT_SETTINGS_INI = os.path.realpath(os.path.join(SCRIPT_HOME, SETTINGS_INI))

    argparser = argparse.ArgumentParser(description='Verwerk een of meerdere GML-bestanden')
    argparser.add_argument('gml', type=str, help='het GML-bestand of de lijst met GML-bestanden', metavar='GML', nargs='+')
    argparser.add_argument('--dir', type=str, help='lokatie getransformeerde bestanden', dest='dir', required=True)
    argparser.add_argument('--ini', type=str, help='het settings-bestand', dest='settings_ini', default=DEFAULT_SETTINGS_INI)
    argparser.add_argument('--pre', type=str, help='SQL-script vooraf', dest='pre_sql')
    argparser.add_argument('--post', type=str, help='SQL-script achteraf', dest='post_sql')
    argparser.add_argument('--spat', type=float, help='spatial filter', dest='spat', nargs=4, metavar=('xmin', 'ymin', 'xmax', 'ymax'))
    argparser.add_argument('--PG_PASSWORD', type=str, help='wachtwoord voor PostgreSQL', dest='pg_pass')
    args = argparser.parse_args()

    print 'Begintijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

    #print 'GML:', args.gml
    #print 'Ini:', args.settings_ini
    #print 'PG-Password:', args.pg_pass
    #print 'Spatial filter:', args.spat

    ### Controle argumenten
    # Check geldigheid dir
    if not os.path.isdir(args.dir):
        print 'De opgegeven lokatie `%s` is geen geldige directory' % args.dir
        sys.exit(1)

    # Check geldigheid settings file
    if not os.path.isfile(args.settings_ini):
        print 'Op de opgegeven lokatie `%s` is geen INI-bestand aangetroffen' % args.settings_ini
        sys.exit(1)

    ### Uitlezenc onfiguratie
    # Read settings
    config = ConfigParser.SafeConfigParser()
    config.read(args.settings_ini)

    # Zet password in environment variabele
    if not 'PGPASSWORD' in os.environ:
        if args.pg_pass is not None:
            os.environ['PGPASSWORD'] = args.pg_pass
        elif get_postgis_setting('PG_PASSWORD') is not None:
            os.environ['PGPASSWORD'] = get_postgis_setting('PG_PASSWORD')

    # Stel client encoding in
    if get_postgis_setting('PG_CLIENTENCODING') is not None:
        os.environ['PGCLIENTENCODING'] = get_postgis_setting('PG_CLIENTENCODING')

    # Stel string samen voor PostgreSQL connectie op command line
    pg_conn = '-h %s -p %s -U %s -d %s' % (
    get_postgis_setting('PG_HOST'), get_postgis_setting('PG_PORT'),
    get_postgis_setting('PG_USER'), get_postgis_setting('PG_DB'))

    ### Bepalen GML bestanden
    # Stel lijst samen van alle in te lezen GML-bestanden
    list = []
    for file in args.gml:
        evaluate_file(list, file)

    #print 'GML files:', list
    #print len(list)
    if len(list) == 0:
        print 'Er zijn geen GML-bestanden aangetroffen om in te lezen'
        sys.exit(1)

    ### Uitvoering
    # * Scripts vooraf
    execute_sql(args.pre_sql)

    # * Droppen tabellen
    sql = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-drop-tables.sql'))
    execute_sql(sql)

    # * Validatie GML (optioneel)
    validate_gml()

    # * Opsplitsen en transformeren GML
    xsl1_0 = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-split.xsl'))
    xsl1_1_1 = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-split_v1_1_1.xsl'))
#    py = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-trans.py'))
    for tuple in list:
        if tuple[0] == V1_0:
            trans_gml(tuple[1], xsl1_0, args.dir)
        elif tuple[0] == V1_1_1:
            trans_gml(tuple[1], xsl1_1_1, args.dir)

    # * Laden data met OGR
    file_list = glob.glob(os.path.join(args.dir, '*.[gxGX][mM][lL]'))
    gfs_template = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-gfs-template_split.xml'))
    for file in file_list:
        load_data(file, gfs_template, args.spat)

    # * Verwijderen duplicate data
    sql = os.path.realpath(os.path.join(SCRIPT_HOME, 'top10-delete-duplicates.sql'))
    execute_sql(sql)

    # * Scripts achteraf
    execute_sql(args.post_sql)

    # Reset password in environment variabele in exit handler on_exit

    print 'Eindtijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

if __name__ == "__main__":
    main()
