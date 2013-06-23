.. _instalwinusbgis:


*************************************
NLExtract op Windows met Portable GIS
*************************************


Dit is een Windows (7) install voor NLExtract gebruikmakend van `Portable GIS<http://www.archaeogeek.com/portable-gis.html>`_.
Uitgevoerd door Just van den Broecke, op een Asus netbook met Windows 7.
Zowel voor BAG als Top10NL Extract.

NB Just werkt normaal op Mac/Linux en is geen ervaren Windows gebruiker...

Inleiding
=========

De installatie van NLExtract onder Windows blijkt soms lastig te zijn, vooral wanneer
niet al een werkende installatie van Python en gerelateerde bibliotheken en tools als PostgreSQL
aanwezig zijn. Hieronder volgt een installatie beschrijving waarbij gebruik gemaakt wordt
van Portable GIS, http://www.archaeogeek.com/portable-gis.html, een installer die de
meeste relevante Open Source GIS applicaties en bibliotheken bundelt.  Portable GIS is ontwikkeld door
`Jo Cook <http://www.archaeogeek.com/>`_. Zij zit tevens in board van OSGeo.org en OSGeo UK.

*The philosophy behind Portable GIS was to provide beginners with a ready-installed
and configured stack of open source GIS tools that would run in Windows without
the need for emulation or a live cd. By taking out the often difficult installation
and configuration, I hope to make it easier for beginners to get started with open source GIS,
so they are not put off before it gets interesting and fun.
Not only that, but having a fully self-contained GIS system may prove useful in a number
of real-life situations.*

Portable GIS is sowieso erg handig om te hebben en te gebruiken.

Installatie
===========

Uitgevoerd met Portable GIS v3.1 van 3 dec 2012 en NLExtract GitHub versie op 23 juni 2013.
Het Windows systeem was kaal: nog geen Python en andere GIS-tools aanwezig.

Portable GIS
------------

- download .exe via http://www.archaeogeek.com/portable-gis.html, plm 500 MB uitgepakt is het 1.5 GB, dus zorg dat je voldoende ruimte hebt
- klik de ``portablegis_setup_v3.exe``, installeer op default plek ``C:\usbgis``
- het Portable GIS control paneel vind je in ``C:\portablegis.exe``. Hiermee kun je bijv. PostgreSQL starten/stoppen.
- uitpakken en installeren kan redelijk lang duren....
- Python configureren door de Environment Variable ``Path`` uit te breiden. Zie ook: http://www.itechtalk.com/thread3595.html
- Doe ``Edit System Variable`` voor Path en voeg de string ``;C:\usbgis\apps\python27\App`` aan einde toe
- open een DOS/Command window en typ ```python``. Als het goed is opent de Python interpreter.
- sluit Python af met ``ctrl-Z return``

Psycopg2
--------

Dit is de Python PostgreSQL driver. Deze zit niet in Portable GIS dus dient apart geinstalleerd te worden.

- download v2.5 voor Python 2.7 hier http://www.stickpeople.com/projects/python/win-psycopg/index.html
- installeren
- installer zal klagen dat ie Python 2.7 niet kan vinden. Bij mij kon ik ook niet de Python install-directory opgeven.
- uiteindelijk de Windows Registry geedit door de volgende key toe te voegen via ``regedit`` (standaard Windows):

Deze key ::

    [HKEY_LOCAL_MACHINE\SOFTWARE\Python\PythonCore\2.7]
    "InstallPath"="C:\usbgis\apps\Python27\App"

- daarna ging install goed, daarna kan evt registry key worden weggegooid

PostgreSQL/PostGIS
------------------

Zijn installed via Portable GIS, we moeten alleen deze starten en lege DBs aanmaken.

- Starten: in Portable GIS Control Panel (PGCP): ga naar ``Server Modules`` en start PostgreSQL Database Server, Status wordt dan ``ON``
- DBs aanmaken: ga in PGCP naar ``Desktop Modules`` en start ``PGAdmin III``
- PostgreSQL op poort 5433. Dat is onhandig, verander dit naar de default 5432:
- in PGAdmin III open de file postgresql.conf via 'File...' menu. Deze file staat in ``C:\usbgis\apps\postgresql\PGDATA`` en verander de poort naar 5432
- herstart PostgreSQL via PGCP
- verbind met de server vanuit PGAdmin III via File | Add Server...
- noem de server bijv. "Local", IP adress 127.0.0.1 en user/paswoord 'pgis' en 'pgis'

Maak database aan voor BAG:

- maak een nieuwe user/role 'postgres' met paswoord 'postgres' aan en geef alle rechten
- in PGAdmin III onder Servers/Local op ``Databases`` rechter-muistoets 'New Database...`
- vul in Name : ``bag``, Owner : ``postgres``, Encoding zo laten (zou eigenlijk UTF-8 moeten zijn...), template: ``template_postgis``
- we hebben als het goed is een lege DB 'bag' met 2 tabellen van PostGIS, ``geometry_columns`` en ``spatial_ref_sys``.

Maak database aan voor Top10NL:

- maak een nieuwe user/role 'top10nl' met paswoord 'top10nl' aan en geef alle rechten
- in PGAdmin III onder Servers/Local op ``Databases`` rechter-muistoets 'New Database...`
- vul in Name : ``top10nl``, Owner : ``top10nl``, Encoding zo laten (zou eigenlijk UTF-8 moeten zijn...), template: ``template_postgis``
- we hebben als het goed is een lege DB 'top10nl' met 2 tabellen van PostGIS, ``geometry_columns`` en ``spatial_ref_sys``.

NLExtract
---------

- download NLExtract .zip via https://github.com/opengeogroep/NLExtract/archive/master.zip
- uitgepakt in directory ``C:\Users\just\project\nlextract\git``

Test basis installatie, eerst BAG Extract ::

   cd C:\Users\just\project\nlextract\git\bag\src
   python bagextract.py -h

   python bagextract.py --dbinit

   # als je krijgt melding dat ie geen verbinding kan maken met DB, verander evt in extract.conf 'localhost' naar 127.0.0.1

Als dit gewerkt heeft, zou je 17 tabellen in de DB bag hebben, in ``public`` schema.

Test data laden voor BAG ::

    cd ..\test
    python ..\src\bagextract.py -v -e data

Als je geen foutmeldingen hebt, kun je ook in PGAdmin III zien dat er records toegevoegd zijn bijv. tabel verblijfsobject.

Vervolgens Top10NL Extract testen ::

   cd C:\Users\just\project\nlextract\git\top10nl\test
   top10-test.cmd

Mogelijk foutmeldingen:

- dat ``psql`` niet gevonden kan worden vanuit ``subprocess.py``. We moeten ``psql`` aan het Path environment variable toevoegen, net als eerder Python. Voeg aan Path toe:  ``C:\usbgis\apps\postgresql\bin``.
- altijd Command DOS prompt herstarten na verandering Path environment var.
- Uiteraard dient de database 'top10nl' met zelfde owner naam gemaakt te zijn (zie boven).
- melding over ``pg_hba.conf``. Verander localhost naar 127.0.0.1 in config ``..\bin\top10-settings.ini``
- melding over ogr2ogr fout: voeg GDAL binaries toe aan Path: ``;C:\usbgis\apps\ms4w\tools\gdal-ogr``
- voeg GDAL DLL toe aan Path: ``;C:\usbgis\apps\ms4w\Apache\cgi-bin``
- zet GDAL_DATA environment (User) variabele:  ``C:\usbgis\apps\ms4w\gdaldata``
- werken met schema's werkt niet haal ``--pg_schema test`` weg uit ``top10-test.cmd``


















