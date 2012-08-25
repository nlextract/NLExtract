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
# * met bestand met GML-bestanden
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
# * GML-bestanden in bestandslijst zijn relatief tov bestandslijst
# * Lees root element wannabe-GML-bestanden om te bepalen of ze door moeten gaan
# * Locale settings Windows
# * Ondersteuning Top10NL 1.1.1
# * XSLT-transformatie versnellen. De huidige verise is veel minder snel dan transformatie met XML
#   Starlet (die op Windows niet de grootste bladen aankan).
# * Splitsen optioneel maken
# * Met Top10NL 1.1.1 kan heel Nederland in een keer geleverd worden. Het moet mogelijk zijn om een
#   bounding box aan te geven om het te importeren gebied te beperken.

# Ideeen:
# * Output naar batch file (bat / sh) -> lost afhankelijk van Python niet op door trans script
# * Meerdere settings overriden via command-line parameters

# GML-versies:
# * Top10NL 1.0
# * Top10NL 1.1.1 (vanaf sept. '12)

# Imports
import ConfigParser
import argparse
import atexit
import glob
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

def execute_sql(sql):
	if sql is None:
		return
		
	if not os.path.exists(sql):
		print 'Het opgegeven SQL-script `%s` is niet aangetroffen' % sql
		sys.exit(1)
	
	cmd = 'psql -f %s %s' % (sql, pg_conn)
	subprocess.call(cmd)
	
	return

def validate_gml():
	pass
	
def trans_gml(gml, dir):
	# Opknippen en transformeren GML-bestand
	cmd = 'python top10-trans.py --max_features %d %s top10-split.xsl %s' % (MAX_SPLIT_FEATURES, gml, dir)
	print cmd
	subprocess.call(cmd)
	
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
	
def load_data(gml):
	# Kopieer / overschrijf GFS bestand
	file_ext = os.path.splitext(gml)
	shutil.copy('top10-gfs-template_split.xml', file_ext[0] + '.gfs')

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
	
	# Voer ogr2ogr uit
	cmd = 'ogr2ogr %s -f %s "%s" %s %s %s -a_srs %s %s -s_srs %s %s' % (
		get_ogr_setting('OGR_OVERWRITE_OR_APPEND'),
		get_ogr_setting('OGR_OUT_FORMAT'),
		ogr_out_options,
		get_ogr_setting('OGR_GT'),
		get_ogr_setting('OGR_OPT_MULTIATTR'),
		get_ogr_setting('OGR_LCO'),
		get_ogr_setting('OGR_ASRS'),
		t_srs,
		get_ogr_setting('OGR_SSRS'),
		gml
		)
	print cmd
	subprocess.call(cmd)
	
def evaluate_file(list, check):
	if os.path.isfile(check):
		# Controleer of het gevonden bestand een GML-bestand is of een bestandslijst
		file_ext = os.path.splitext(check)
		ext = file_ext[1].lower()
		if ext == ".gml" or ext == ".xml":
			# Behandel opgegeven check-bestand als GML-bestand
			if not check in list:
				list.append(check)
			return
			
		# Behandel opgegeven check-bestand als bestandslijst
		with open(check) as f:
			for line in f:
				# TODO: pad is relatief t.o.v. lijst!
				check_file(list, line)

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
	#	print 'Het opgegeven GML-bestand of bestandslijst `%s` is niet aangetroffen' % file
	#	sys.exit(1)

	file_ext = os.path.splitext(file)
	ext = file_ext[1].lower()
	
	if ext == ".gml" or ext == ".xml":
		# Behandel bestand als GML-bestand
		if not file in list:
			list.append(file)

	return

def main():
	global config, pg_conn

	argparser = argparse.ArgumentParser(description='Verwerk een of meerdere GML-bestanden')
	argparser.add_argument('gml', type=str, help='het GML-bestand of de lijst met GML-bestanden', metavar='GML', nargs='+')
	argparser.add_argument('--dir', type=str, help='lokatie getransformeerde bestanden', dest='dir', required=True)
	argparser.add_argument('--ini', type=str, help='het settings-bestand', dest='settings_ini', default=SETTINGS_INI)
	argparser.add_argument('--pre', type=str, help='SQL-script vooraf', dest='pre_sql')
	argparser.add_argument('--post', type=str, help='SQL-script achteraf', dest='post_sql')
	argparser.add_argument('--PG_PASSWORD', type=str, help='wachtwoord voor PostgreSQL', dest='pg_pass')
	args = argparser.parse_args()
	
	print 'Begintijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

	#print 'GML:', args.gml
	#print 'Ini:', args.settings_ini
	#print 'PG-Password:', args.pg_pass
	
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
	config = ConfigParser.SafeConfigParser(allow_no_value=True)
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
	execute_sql('top10-drop-tables.sql')

	# * Validatie GML (optioneel)
	validate_gml()
	
	# * Opsplitsen en transformeren GML
	for file in list:
		trans_gml(file, args.dir)
		
	# * Laden data met OGR
	file_list = glob.glob(os.path.join(args.dir, '*.[gxGX][mM][lL]'))
	for file in file_list:
		load_data(file)
	
	# * Verwijderen duplicate data
	execute_sql('top10-delete-duplicates.sql')
	
	# * Scripts achteraf
	execute_sql(args.post_sql)
	
	# Reset password in environment variabele in exit handler on_exit

	print 'Eindtijd top10-extract:', strftime('%a, %d %b %Y %H:%M:%S', localtime())

if __name__ == "__main__":
	main()
