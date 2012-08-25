Readme Top10NL verwerkingsscripts
=================================

Deze scripts zijn ontwikkeld en getest op Windows 7 met Python 2.7.2.

Let op: wanneer je Windows gebruikt en je wilt op de command line met PostgreSQL connecten, gebruik
chcp 1252. Onder Windows kunnen de meegeleverde SQL-scripts mogelijk niet werken voor de tabellen
overigreli�f, vanwege de 'e' met trema.

Dependencies
------------
* GDAL 1.9.1: http://www.gdal.org/index.html
* lxml: http://lxml.de/installation.html

Aanroep
-------
usage: top10-extract.py [-h] [--ini SETTINGS_INI] --dir DIR [--pre PRE_SQL]
                        [--post POST_SQL] [--PG_PASSWORD PG_PASS]
                        GML [GML ...]

Verwerk een of meerdere GML-bestanden

positional arguments:
  GML                   het GML-bestand of de lijst met GML-bestanden

optional arguments:
  -h, --help            show this help message and exit
  --ini SETTINGS_INI    het settings-bestand
  --dir DIR             lokatie getransformeerde bestanden
  --pre PRE_SQL         SQL-script vooraf
  --post POST_SQL       SQL-script achteraf
  --PG_PASSWORD PG_PASS
                        wachtwoord voor PostgreSQL

Het GML-bestand of de GML-bestanden kunnen op meerdere manieren worden meegegeven:
* met 1 GML-bestand
* met bestand met GML-bestanden
* met meerdere GML-bestanden via wildcard
* met directory
NB: ook als er meerdere bestanden via de command line aangegeven kunnen worden, kunnen deze
wildcards bevatten. Een bestand wordt als GML-bestand beschouwd, indien deze de extensie GML of
XML heeft, anders wordt het als een GML-bestandslijst gezien.

Toepassen settings:
* Definitie in settings-file (top10-settings.ini)
* Mogelijk om settings te overriden via command-line parameters (alleen voor wachtwoorden)
* Mogelijk om settings file mee te geven via command-line
