# ------------------------------------------------------------------------------
# Naam:         BAGextract+.py
# Omschrijving: Hoofdmodule van de NLExtract-BAG tools.
# Auteur:       Matthijs van der Deijl
# Auteur:       Just van den Broecke - porting naar NLExtract (2015)
#
# Versie:       1.8
#               - Controle en waarschuwing bij inladen GML-extract toegevoegd.
#               13 oktober 2011
#
# Versie:       1.7
#               - objecttype LPL vervangen door LIG
#               - objecttype SPL vervangen door STA
#               - Controle op levenscyclus in verwerking mutaties uitgeschakeld wegens ongedefinieerde
#                 volgorde in wijziging bestaand voorkomen en opvoer niet voorkomen.
#               11 maart 2011
#
# Versie:       1.5
#               - Bug (objectType not defined) gefixt in verwerking mutatiebestanden
#               9 septembver 2010
#
# Versie:       1.3
#               - Verwerking mutatiebestanden robuuster gemaakt voor geval van lege Mutatie-producten
#               - GeomFromText vervangen door GeomFromEWKT
#                 (dit voorkomt Warnings in de database logging)
#               - Controle op database toegevoegd voorafgaand aan het laden van extract of mutatiebestand
#               - Foutafhandeling verbeterd
# Datum:        28 december 2009
#
# Versie:       1.2
#               - Grafische user interface toegevoegd
# Datum:        24 november 2009
#
# Ministerie van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer
#------------------------------------------------------------------------------
import wx
import wx.lib.newevent as NE
import wx.grid
import threading

from configeditorgui import ConfigEditorPanel
from processor import Processor
from postgresdb import Database
from bagfilereader import BAGFileReader
from raadpleeggui import BAGRaadpleeg
from loggui import LogScherm, AsyncLogScherm
from bagconfig import *
from log import Log

NLExtractBAGVersie = "1.0.5"
NLExtractBAGDatum = "oktober 2015"

# Define local events
# http://wxpython.org/Phoenix/docs/html/lib.newevent.html
LocalEvent, EVT_LOCAL = NE.NewCommandEvent()
EVT_ID_MENU_ENABLE = wx.NewId()
EVT_ID_MENU_DISABLE = wx.NewId()

# Generic Local worker thread that dis/enables main menu
class WorkerThread(threading.Thread):
    def __init__(self, app, worker):
        threading.Thread.__init__(self)
        self.app = app
        self.worker = worker
        self.app.asyncLogScherm.start()
        Log.log.set_output(self.app.asyncLogScherm)

    def run(self):
        try:
            # Disable menu
            wx.PostEvent(self.app, LocalEvent(EVT_ID_MENU_DISABLE))

            # Do the work
            self.worker()
        finally:
            # Enable menu again
            wx.PostEvent(self.app, LocalEvent(EVT_ID_MENU_ENABLE))
            Log.log.set_output(self.app.logScherm)


#------------------------------------------------------------------------------
# BAGExtractGUI toont het hoofdscherm van de NLExtract-BAG tool
#------------------------------------------------------------------------------    
class BAGExtractGUI(wx.Frame):
    # Constructor
    # Maakt het logscherm voor het tonen van de voortgang en resultaten van diverse acties en
    # initialiseert de menu's van waaruit alle functies worden aangeroepen.
    def __init__(self, app):
        wx.Frame.__init__(self, None, -1, 'NLExtract-BAG', size=(1000, 500))

        Log()
        self.app = app
        self.hoofdScherm()
        # Init globale configuratie
        BAGConfig(None)
        self.database = Database()

    #------------------------------------------------------------------------------
    # Laat hoofdscherm zien
    #------------------------------------------------------------------------------
    def hoofdScherm(self):

        self.CenterOnScreen()
        self.CreateStatusBar()

        self.menuBalk = wx.MenuBar()

        menu1 = wx.Menu()

        # menu1.Append(101, "&Unzip bestand", "Pakt een gedownload BAG-extract of -mutatiebestand uit in de 'extractdirectory'")
        menu1.Append(101, "Laad BAGExtract &Directory",
                     "Laadt een map (bijv uitgepakte .zip) met BAG Extract bestanden in de database")
        menu1.Append(102, "Laad BAGExtract &Bestand (.zip .xml)",
                     "Laadt een enkel BAG-extractbestand (.zip, .xml) in de database")
        menu1.AppendSeparator()
        menu1.Append(103, "&Edit configuratie", "Edit configuratie instellingen")
        menu1.AppendSeparator()
        menu1.Append(104, "&Afsluiten", "Sluit NLExtract-BAG af")
        self.menuBalk.Append(menu1, "&Bestand")

        menu2 = wx.Menu()
        menu2.Append(201, "&Initialiseer database", "Maakt database gereed (en leeg) voor gebruik van NLExtract-BAG")
        menu1.AppendSeparator()
        menu2.Append(202, "&Raadpleeg database", "Zoekt en toont de gegevens van een BAG-object")
        menu2.Append(203, "&Toon logging", "Toont de logging in de database")
        self.menuBalk.Append(menu2, "&Database")

        menu3 = wx.Menu()
        menu3.Append(301, "&Over NLExtract-BAG", "Informatie over NLExtract-BAG")
        self.menuBalk.Append(menu3, "&Info")

        self.SetMenuBar(self.menuBalk)

        # self.Bind(wx.EVT_MENU, self.bestandUnzipExtract,          id=101)
        self.Bind(wx.EVT_MENU, self.bestandLaadExtractDir, id=101)
        self.Bind(wx.EVT_MENU, self.bestandLaadExtractBestand, id=102)
        self.Bind(wx.EVT_MENU, self.bestandEditConfiguratie, id=103)
        self.Bind(wx.EVT_MENU, self.bestandSluitBAGExtractplus, id=104)

        self.Bind(wx.EVT_MENU, self.databaseInitialiseer, id=201)
        self.Bind(wx.EVT_MENU, self.databaseRaadpleeg, id=202)
        self.Bind(wx.EVT_MENU, self.databaseToonLogging, id=203)

        self.Bind(wx.EVT_MENU, self.infoBAGExtractGUI, id=301)

        self.text_ctrl = wx.TextCtrl(self, -1,
                                     "== Welkom bij NLExtract voor BAG ==\n\nGebruik het hoofdmenu voor alle akties.\n\n",
                                     style=wx.TE_READONLY | wx.TE_MULTILINE)
        self.font = wx.Font(16, wx.FONTFAMILY_MODERN, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL)
        self.text_ctrl.SetFont(self.font)
        self.logScherm = LogScherm(self.text_ctrl)
        self.asyncLogScherm = AsyncLogScherm(self.text_ctrl)
        Log.log.set_output(self.logScherm)
        self.Bind(EVT_LOCAL, self.onEnableMenu, id=EVT_ID_MENU_ENABLE)
        self.Bind(EVT_LOCAL, self.onDisableMenu, id=EVT_ID_MENU_DISABLE)
        self.Show(True)

    def onEnableMenu(self, evt):
        self.enableMenu(True)

    def onDisableMenu(self, evt):
        self.enableMenu(False)

    def enableMenu(self, enabled=True):
        count = self.menuBalk.GetMenuCount()
        for i in range(count):
            self.menuBalk.EnableTop(i, enabled)

    #------------------------------------------------------------------------------
    # Pak een extract of mutatiebestand uit.
    #------------------------------------------------------------------------------    
    def bestandUnzipExtract(self, event):
        fileDialoog = wx.FileDialog(self,
                                    "Selecteer bestand",
                                    BAGConfig.config.download,
                                    "",
                                    "*.zip",
                                    wx.OPEN | wx.CHANGE_DIR)
        if fileDialoog.ShowModal() == wx.ID_OK:
            log.start(self, database, "Uitpakken extract bestand", fileDialoog.GetPath())
            log("Unzip " + fileDialoog.GetPath())
            log(" naar " + BAGConfig.config.extract)
            log("")
            if not unzip_file_into_dir(fileDialoog.GetPath(), BAGConfig.config.extract):
                log("Uitpakken mislukt")
            log("")
            log.sluit()

    #------------------------------------------------------------------------------
    # Laad een BAG Extract bestand in de database.
    #------------------------------------------------------------------------------
    def bestandLaadExtractDir(self, event):
        dialoog = wx.DirDialog(self,
                               "Selecteer directory met BAG Extract bestanden",
                               BAGConfig.config.bagextract_home,
                               wx.OPEN | wx.DD_DIR_MUST_EXIST)

        if dialoog.ShowModal() == wx.ID_OK:
            self.bestandLaadExtractBestandOfDir(dialoog.GetPath())

    #------------------------------------------------------------------------------
    # Laadt een BAG Extract bestand in de database.
    #------------------------------------------------------------------------------    
    def bestandLaadExtractBestand(self, event):
        # for obj in bagObjecten:
        #     if not obj.controleerTabel():
        #         dialoog = wx.MessageDialog(self,
        #                                    "1 of meerdere tabellen ontbreken in de database. Initialiseer eerst de database (zie database-menu).",
        #                                    "",
        #                                    wx.OK|wx.ICON_EXCLAMATION)
        #         dialoog.ShowModal()
        #         return

        dialoog = wx.FileDialog(self,
                                "Selecteer een BAG levering (.zip) of bestand (.xml)",
                                BAGConfig.config.bagextract_home,
                                "",
                                "*.*",
                                wx.OPEN | wx.DD_DIR_MUST_EXIST)

        if dialoog.ShowModal() == wx.ID_OK:
            self.bestandLaadExtractBestandOfDir(dialoog.GetPath())

    #------------------------------------------------------------------------------
    # Laadt een BAG Extract bestand in de database.
    #------------------------------------------------------------------------------
    def bestandLaadExtractBestandOfDir(self, file_or_dir_path):

        def worker():
            # Print start time
            Log.log.time("Start")
            # Extracts any data from any source files/dirs/zips/xml/csv etc
            Database().log_actie('start_extract', file_or_dir_path)
            reader = BAGFileReader(file_or_dir_path)
            reader.process()
            Database().log_actie('stop_extract', file_or_dir_path)
            # Print end time
            Log.log.time("End")

        WorkerThread(self, worker).start()

    #------------------------------------------------------------------------------
    # Toon configuratiegegevens uit BAG.conf.
    #------------------------------------------------------------------------------    
    def bestandEditConfiguratie(self, event):
        editor = ConfigEditorPanel(self)
        editor.ShowModal()
        Log.log.set_output(self.logScherm)

        # info = wx.AboutDialogInfo()
        # info.Name = "Configuratie settings"
        # info.Version = NLExtractBAGVersie
        # info.Description  = "Configuratie Gegevens \n\n"
        # info.Description += " Configuratie bestand:    \n"
        # info.Description += BAGConfig.config.config_file + "\n\n"
        # info.Description += " Databasegegevens:    \n"
        # info.Description += "- Database = " + BAGConfig.config.database +" \n"
        # info.Description += "- Schema = " + BAGConfig.config.schema +" \n"
        # info.Description += "- Host = " + BAGConfig.config.host +" \n"
        # info.Description += "- User = " + BAGConfig.config.user +" \n"
        # info.Description += "- Password = " + BAGConfig.config.password +" \n"
        # info.Description += "\n"
        # wx.AboutBox(info)

    #------------------------------------------------------------------------------    
    # Sluit de applicatie.
    #------------------------------------------------------------------------------    
    def bestandSluitBAGExtractplus(self, event):
        self.Close()

    #------------------------------------------------------------------------------    
    # Initialiseer de NLExtract-BAG database. Eerst vragen we of de gebruiker echt
    # wil dat de eventuele huidige inhoud van de database wordt gewist.
    #------------------------------------------------------------------------------    
    def databaseInitialiseer(self, event):
        dialoog = wx.MessageDialog(self,
                                   "WAARSCHUWING: Deze actie verwijdert de gehele huidige inhoud van de database '%s' in schema '%s'. Wilt u doorgaan?" % (BAGConfig.config.database, BAGConfig.config.schema),
                                   "",
                                   wx.YES_NO | wx.ICON_QUESTION)

        if dialoog.ShowModal() == wx.ID_YES:
            # Do in separate thread
            WorkerThread(self, Processor().dbInit).start()

    #------------------------------------------------------------------------------
    # Start het databaseRaadpleeg scherm voor het zoeken en raadplegen van BAG objecten.
    #------------------------------------------------------------------------------
    def databaseRaadpleeg(self, event):
        raadpleeg = BAGRaadpleeg(self)
        raadpleeg.ShowModal()
        Log.log.set_output(self.logScherm)

    #------------------------------------------------------------------------------
    # Toon de logging van uitgevoerde NLExtract-BAG acties in de database
    #------------------------------------------------------------------------------    
    def databaseToonLogging(self, event):
        class LogGridPanel(wx.Dialog):
            def __init__(self, parent):
                wx.Dialog.__init__(self, parent, -1, 'Logging', size=(900, 600))

                database = Database()
                rows = database.select('SELECT * FROM nlx_bag_log')

                table = wx.grid.Grid(self)
                table.CreateGrid(len(rows), 5)
                table.HideRowLabels()
                table.SetColLabelValue(0, "Tijd")
                table.SetColSize(0, 150)
                table.SetColLabelValue(1, "Actie")
                table.SetColSize(1, 140)
                table.SetColLabelValue(2, "Bestand")
                table.SetColSize(2, 340)
                table.SetColLabelValue(3, "Bericht")
                table.SetColSize(3, 160)
                table.SetColLabelValue(4, "Error")
                table.SetColSize(4, 80)

                index = 0
                for log_rec in rows:
                    # Skip overvloed logging
                    if 'INFO' in log_rec[4]:
                        continue

                    table.SetCellValue(index, 0, str(log_rec[1]).split('.')[0])
                    table.SetCellValue(index, 1, str(log_rec[2]))
                    table.SetCellValue(index, 2, str(log_rec[3]))
                    table.SetCellValue(index, 3, str(log_rec[4]))
                    table.SetCellValue(index, 4, str(log_rec[5]))
                    index += 1

        logPanel = LogGridPanel(self)
        logPanel.ShowModal()

    #------------------------------------------------------------------------------    
    # Toon informatie over de NLExtract-BAG applicatie 
    #------------------------------------------------------------------------------    
    def infoBAGExtractGUI(self, event):
        info = wx.AboutDialogInfo()
        info.Name = "NLExtract-BAG"
        info.Version = NLExtractBAGVersie
        info.Description = "NLExtract-BAG is een set hulpmiddelen voor het maken   \n"
        info.Description += "en vullen van een lokale BAG-database.                \n"
        info.Description += "Deze database wordt gevuld met gegevens uit de BAG    \n"
        info.Description += "(Basisregisratie Adressen en Gebouwen). Deze gegevens \n"
        info.Description += "worden vanuit de Landelijke Voorziening van de BAG    \n"
        info.Description += "of PDOK geleverd door de dienst 'BAG Extract'.                \n"
        info.Description += "Dit extract en de daaropvolgende mutatiebestanden     \n"
        info.Description += "kunnen worden ingeladen in de database, waarna deze   \n"
        info.Description += "gegevens lokaal beschikbaar zijn voor raadplegen      \n"
        info.Description += "en voor het vergelijken met eigen gegevens.           \n"
        info.Description += "\n"
        info.Copyright = "BAGExtract+ werd oorspronkelijk (2009) ontwikkeld door VROM. \n"
        info.Copyright += "Deze versie is vervolgens aangepast binnen het NLExtract \n"
        info.Copyright += "project (2011) als commandline versie. De GUI is in 2015 toegevoegd.\n"
        info.WebSite = ("http://nlextract.nl", "NLExtract Project")
        wx.AboutBox(info)

# App opbrengen
app = wx.App(0)

BAGExtractGUI(app)
app.MainLoop()
