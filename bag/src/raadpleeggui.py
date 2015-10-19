# ------------------------------------------------------------------------------
# Naam:         BAGraadpleeg.py
# Omschrijving: Grafisch scherm voor het zoeken en raadplegen van gegevens
# uit de lokale BAG Extract+ database
# Auteur:       Matthijs van der Deijl
# Auteur:       Just van den Broecke - porting naar NLExtract (2015)
#
# Versie:       1.3
#               - Raadpleging via kaart toegevoegd
#               28 december 2009
#
# Versie:       1.2
# Datum:        24 november 2009
#
# Ministerie van Volkshuisvesting, Ruimtelijke Ordening en Milieubeheer
#------------------------------------------------------------------------------
import wx
import wx.richtext as rt
from log import Log
from loggui import LogScherm
from postgresdb import Database
from bagobject import BAGObjectFabriek

#------------------------------------------------------------------------------
# Links op het scherm wordt een aantal uitklapbare panels getoond voor de
# verschillende zoekopties. De class BAGZoekPanel is de basisclass voor deze
# uitklapbare panels.
#------------------------------------------------------------------------------
class BAGZoekPanel(wx.Panel):
    # Constructor
    def __init__(self, raadpleegScherm, titel):
        wx.Panel.__init__(self, raadpleegScherm, -1)
        self.raadpleegScherm = raadpleegScherm
        self.logScherm = raadpleegScherm.logScherm
        self.titel = titel
        self.cp = wx.CollapsiblePane(self, label=titel, style=wx.CP_DEFAULT_STYLE | wx.CP_NO_TLW_RESIZE)
        sizer = wx.BoxSizer(wx.VERTICAL)
        self.SetSizer(sizer)
        sizer.Add(self.cp, 0, wx.RIGHT | wx.LEFT | wx.EXPAND, 5)
        self.Bind(wx.EVT_COLLAPSIBLEPANE_CHANGED, self.toonVerberg, self.cp)
        self.raadpleegScherm.panels.append(self)
        self.raadpleegScherm.toonPanels()
        self.database = Database()

    # Open het panel en toon de inhoud
    def klapOpen(self):
        self.cp.Expand()

    # Wanneen een panel wordt open- of dichtgeklapt, wordt de functie 'toonVerberg' uitgevoerd.
    # Wanneer een panel wordt opengeklapt, moeten de overige panels worden dichtgeklapt.        
    def toonVerberg(self, event=None):
        if self.cp.IsExpanded():
            for panel in self.raadpleegScherm.panels:
                if panel.titel <> self.titel and panel.cp.IsExpanded():
                    panel.cp.Collapse()
        self.raadpleegScherm.toonPanels()


#------------------------------------------------------------------------------
# Uitklapbaar zoekpanel voor het zoeken op identificatie.
#------------------------------------------------------------------------------
class BAGZoekOpIdentificatie(BAGZoekPanel):
    def __init__(self, raadpleegScherm):
        BAGZoekPanel.__init__(self, raadpleegScherm, "Zoek op identificatie")
        self.idLabel = wx.StaticText(self.cp.GetPane(), -1, "Identificatie:", pos=(0, 0))
        self.idText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 15), size=(150, 20))
        self.focus = self.idText
        self.zoekKnop = wx.Button(self.cp.GetPane(), label="Zoek", pos=(80, 110), size=(56, 24))
        self.Bind(wx.EVT_BUTTON, self.zoek, self.zoekKnop)

    # Voer de zoekopdracht uit voor de ingevulde identificatie
    def zoek(self, event=None):
        self.raadpleegScherm.boom.maakLeeg()
        self.raadpleegScherm.kaart.maakLeeg()
        self.logScherm("")
        identificatie = int(self.idText.GetValue())
        obj = BAGObjectFabriek.bof.getBAGObjectBijIdentificatie(identificatie)
        if not obj:
            self.logScherm("Geen geldig BAG-object identificatie")
            return

        sql = obj.maakSelectSQL()
        rows = self.database.select(sql)
        if len(rows) > 0:
            obj.zetWaarden(rows[0])
            self.raadpleegScherm.boom.toonItem(self.raadpleegScherm.boom.voegToe(identificatie))
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())
        else:
            self.logScherm("Geen object van type %s gevonden bij deze gegevens" % obj.objectType())

#------------------------------------------------------------------------------
# Uitklapbaar zoekpanel voor het zoeken op postcode, huisnummer.
#------------------------------------------------------------------------------
class BAGZoekOpPostcode(BAGZoekPanel):
    # Constructor
    def __init__(self, raadpleegScherm):
        BAGZoekPanel.__init__(self, raadpleegScherm, "Zoek op postcode/nr")
        self.postcodeLabel = wx.StaticText(self.cp.GetPane(), -1, "Postcode:", pos=(0, 0))
        self.postcodeText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 15), size=(80, 20))
        self.focus = self.postcodeText
        self.huisnummerLabel = wx.StaticText(self.cp.GetPane(), -1, "Huisnummer:", pos=(0, 40))
        self.huisnummerText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 55), size=(50, 20))
        self.zoekKnop = wx.Button(self.cp.GetPane(), label="Zoek", pos=(80, 110), size=(56, 24))
        self.Bind(wx.EVT_BUTTON, self.zoek, self.zoekKnop)

    # Voer de zoekopdracht uit voor de ingevulde postcode en huisnummer
    def zoek(self, event=None):
        postcode = self.postcodeText.GetValue()
        huisnummer = self.huisnummerText.GetValue()
        sql = "SELECT identificatie"
        sql += "  FROM nummeraanduidingActueelBestaand"
        sql += " WHERE upper(postcode) = '%s'" % postcode.upper()
        sql += "   AND huisnummer      = %s" % huisnummer
        nummeraanduidingen = self.database.select(sql)
        self.raadpleegScherm.boom.maakLeeg()
        self.raadpleegScherm.kaart.maakLeeg()
        self.logScherm("")
        if len(nummeraanduidingen) == 0:
            self.logScherm("Geen nummeraanduiding gevonden bij deze gegevens")
        else:
            for nummeraanduiding in nummeraanduidingen:
                self.raadpleegScherm.boom.voegToe(nummeraanduiding[0])
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())


#------------------------------------------------------------------------------
# Uitklapbaar zoekpanel voor het zoeken op adres (woonplaats, openbare ruimte,
# huisnummer).
#------------------------------------------------------------------------------
class BAGZoekOpAdres(BAGZoekPanel):
    # Constructor
    def __init__(self, raadpleegScherm):
        BAGZoekPanel.__init__(self, raadpleegScherm, "Zoek op adres")
        self.woonplaatsLabel = wx.StaticText(self.cp.GetPane(), -1, "Woonplaats (% is wildcard):", pos=(0, 0))
        self.woonplaatsText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 15), size=(160, 20))
        self.focus = self.woonplaatsText
        self.openbareRuimteLabel = wx.StaticText(self.cp.GetPane(), -1, "Openbare ruimte (% is wildcard):", pos=(0, 40))
        self.openbareRuimteText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 55), size=(160, 20))
        self.huisnummerLabel = wx.StaticText(self.cp.GetPane(), -1, "Huisnummer:", pos=(0, 80))
        self.huisnummerText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 95), size=(50, 20))
        self.zoekKnop = wx.Button(self.cp.GetPane(), label="Zoek", pos=(80, 110), size=(56, 24))
        self.Bind(wx.EVT_BUTTON, self.zoek, self.zoekKnop)

    # Voer de zoekopdracht uit voor de ingevulde woonplaats, openbare ruimte en huisnummer
    def zoek(self, event=None):
        woonplaatsNaam = self.woonplaatsText.GetValue()
        openbareRuimteNaam = self.openbareRuimteText.GetValue()
        huisnummer = self.huisnummerText.GetValue()
        sql = "SELECT nummeraanduidingidentificatie"
        sql += "  FROM adresActueel"
        sql += " WHERE upper(woonplaatsnaam) LIKE     '%s'" % woonplaatsNaam.upper()
        sql += "   AND upper(openbareruimtenaam) LIKE '%s'" % openbareRuimteNaam.upper()
        sql += "   AND huisnummer                    = %s" % huisnummer
        nummeraanduidingen = self.database.select(sql)
        self.raadpleegScherm.boom.maakLeeg()
        self.raadpleegScherm.kaart.maakLeeg()
        self.logScherm("")
        if len(nummeraanduidingen) == 0:
            self.logScherm("Geen nummeraanduiding gevonden bij deze gegevens")
        else:
            for nummeraanduiding in nummeraanduidingen:
                self.raadpleegScherm.boom.voegToe(nummeraanduiding[0])
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())


#------------------------------------------------------------------------------
# Uitklapbaar zoekpanel voor het zoeken op coordinaten.
#------------------------------------------------------------------------------
class BAGZoekOpCoordinaten(BAGZoekPanel):
    # Constructor
    def __init__(self, raadpleegScherm):
        BAGZoekPanel.__init__(self, raadpleegScherm, "Zoek op coordinaten")
        self.xLabel = wx.StaticText(self.cp.GetPane(), -1, "X-coordinaat:", pos=(0, 0))
        self.xText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 15), size=(160, 20))
        self.focus = self.xText
        self.yLabel = wx.StaticText(self.cp.GetPane(), -1, "Y-coordinaat:", pos=(0, 40))
        self.yText = wx.TextCtrl(self.cp.GetPane(), -1, "", pos=(0, 55), size=(160, 20))
        self.zoekKnop = wx.Button(self.cp.GetPane(), label="Zoek", pos=(80, 110), size=(56, 24))
        self.Bind(wx.EVT_BUTTON, self.zoek, self.zoekKnop)

    # Voer de zoekopdracht uit voor de ingevulde coordinaten
    def zoek(self, event=None):
        self.klapOpen()
        self.toonVerberg()
        x = self.xText.GetValue()
        y = self.yText.GetValue()
        if not x.isdigit() or not y.isdigit():
            self.logScherm("Ongeldige coordinaten")
            return

        self.raadpleegScherm.boom.maakLeeg()
        self.logScherm("")

        # Zoek eerst naar een pand op de gegeven locatie
        sql = "SELECT identificatie"
        sql += "  FROM pandactueelbestaand"
        sql += " WHERE geovlak && GeomFromEWKT('SRID=28992;POINT(%s %s 0.0)')" % (x, y)
        panden = self.database.select(sql)
        if len(panden) >= 1:
            for pand in panden:
                self.raadpleegScherm.boom.voegToe(pand[0])
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())
            return

        # Zoek ligplaats
        sql = "SELECT identificatie"
        sql += "  FROM ligplaatsactueelbestaand"
        sql += " WHERE geovlak && GeomFromEWKT('SRID=28992;POINT(%s %s 0.0)')" % (x, y)
        ligplaatsen = self.database.select(sql)
        if len(ligplaatsen) >= 1:
            for ligplaats in ligplaatsen:
                self.raadpleegScherm.boom.voegToe(ligplaats[0])
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())
            return

        # Zoek standplaats
        sql = "SELECT identificatie"
        sql += "  FROM standplaatsactueelbestaand"
        sql += " WHERE geovlak && GeomFromEWKT('SRID=28992;POINT(%s %s 0.0)')" % (x, y)
        standplaatsen = self.database.select(sql)
        if len(standplaatsen) >= 1:
            for standplaats in standplaatsen:
                self.raadpleegScherm.boom.voegToe(standplaats[0])
            self.raadpleegScherm.boom.SelectItem(self.raadpleegScherm.boom.GetFirstVisibleItem())
            return

        self.logScherm("Geen objecten gevonden op deze coordinaten")


#------------------------------------------------------------------------------
# BAGBoom toont de resultaten van een zoekopdracht in een boomstructuur.
# Door items in de boomstructuur te openen, kunnen gerelateerde objecten
# worden geraadpleegd.
#------------------------------------------------------------------------------
class BAGBoom(wx.TreeCtrl):
    # Constructor
    def __init__(self, raadpleegScherm, positie, afmeting):
        wx.TreeCtrl.__init__(self, raadpleegScherm, -1, positie, afmeting,
                             style=wx.TR_DEFAULT_STYLE | wx.TR_HIDE_ROOT | wx.HSCROLL | wx.VSCROLL)
        self.raadpleegScherm = raadpleegScherm
        self.logScherm = raadpleegScherm.logScherm
        self.root = self.AddRoot("Zoekresultaat")
        self.font = wx.Font(8, wx.FONTFAMILY_MODERN, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL)
        self.SetFont(self.font)
        self.plaatjes = wx.ImageList(16, 16)
        self.plaatjeFolder = self.plaatjes.Add(wx.ArtProvider_GetBitmap(wx.ART_FOLDER, wx.ART_OTHER, (16, 16)))
        self.plaatjeFolderOpen = self.plaatjes.Add(wx.ArtProvider_GetBitmap(wx.ART_FILE_OPEN, wx.ART_OTHER, (16, 16)))
        self.SetImageList(self.plaatjes)
        self.Bind(wx.EVT_TREE_ITEM_EXPANDING, self._openItem, self)
        self.Bind(wx.EVT_TREE_SEL_CHANGED, self._toonItem, self)
        self.database = Database()

    # Private functie voor het toevoegen van een item in de boom, onder een gegeven vader
    def _initItem(self, vader, objectType, identificatie, obj=None):
        item = self.AppendItem(vader, "%s %s" % (objectType, identificatie))
        self.SetPyData(item, obj)
        self.SetItemImage(item, self.plaatjeFolder, wx.TreeItemIcon_Normal)
        self.SetItemImage(item, self.plaatjeFolderOpen, wx.TreeItemIcon_Expanded)
        if objectType <> "WPL":
            self.SetItemHasChildren(item, True)
        return item

    # Private functie voor het initialiseren van een object bij een item in de boom.
    # Bij het item in de boom wordt het BAG-object als PyData opgeslagen in de boom.
    # De gerelateerde objecten van dat BAG-object worden toegevoegd aan de boom als
    # child-elementen van het item. 
    def _initObject(self, item):
        if not self.GetPyData(item):
            # Initialiseer het BAG-object
            bagObject = BAGObjectFabriek.bof.getBAGObjectBijIdentificatie(self.GetItemText(item).partition(" ")[2])
            sql = bagObject.maakSelectSQL()
            rows = self.database.select(sql)
            if len(rows) > 0:
                vals = rows[0]
                bagObject.zetWaarden(vals)

            self.SetPyData(item, bagObject)

            if bagObject.objectType() == "OPR":
                self._initItem(item, "WPL", bagObject.attribuut('gerelateerdeWoonplaats').waarde())
            if bagObject.objectType() == "NUM":
                if bagObject.attribuut('gerelateerdeWoonplaats').waarde() <> "":
                    self._initItem(item, "WPL", bagObject.attribuut('gerelateerdeWoonplaats').waarde())
                self._initItem(item, "OPR", bagObject.attribuut('gerelateerdeOpenbareRuimte').waarde())

                ao = bagObject.getAdresseerbaarObject()
                if ao:
                    sql = bagObject.maakSelectAdresseerbaarObjectSQL()
                    ao_rows = self.database.select(sql)
                    if len(ao_rows) > 0 and len(ao_rows[0]) > 0:
                        identificatie = ao_rows[0][0]
                        ao.zetWaarde('identificatie', identificatie)
                        self._initItem(item, ao.objectType(), ao.identificatie())
            if bagObject.objectType() in ["LPL", "SPL", "VBO"]:
                self._initItem(item, "NUM", bagObject.attribuut('hoofdadres').waarde())
                for nevenadres in bagObject.attribuut('nevenadres').waarde():
                    self._initItem(item, "NUM", nevenadres)
            if bagObject.objectType() == "VBO":
                for pand in bagObject.attribuut('gerelateerdPand').waarde():
                    self._initItem(item, "PND", pand)
            if bagObject.objectType() == "PND":
                for vbo in bagObject.getVerblijfsobjecten():
                    self._initItem(item, "VBO", vbo.identificatie())
        return self.GetPyData(item)

    # Private functie voor het openen van een item. Deze functie wordt uitgevoerd wanneer
    # een item in de boom wordt geopend.
    def _openItem(self, event):
        # Bij het sluiten van het scherm wordt ook nog een event EVT_TREE_SEL_CHANGED gegenereerd.
        # Sommige delen van het scherm zijn dan echter al ongeldig geworden. Daarom controleren
        # we eerst of het scherm nog wel getoond (IsShownOnScreen) is.
        if self.raadpleegScherm.IsShownOnScreen():
            item = event.GetItem()
            if item:
                self._initObject(item)

                # Private functie voor het tonen van een item. Deze functie wordt uitgevoerd wanneer

    # een item in de boom wordt geselecteerd.
    def _toonItem(self, event):
        # Bij het sluiten van het scherm wordt ook nog een event EVT_TREE_SEL_CHANGED gegenereerd.
        # Sommige delen van het scherm zijn dan echter al ongeldig geworden. Daarom controleren
        # we eerst of het scherm nog wel getoond (IsShownOnScreen) is.
        if self.raadpleegScherm.IsShownOnScreen():
            item = event.GetItem()
            if item:
                self.toonItem(item)

    # Toon het gegeven item. Eerst wordt het object geinitialiseerd in de boom zodat de
    # gerelateerde objecten zichtbaar worden. Vervolgens wordt het object getoond in de
    # view in het rechterdeel van het scherm.
    def toonItem(self, item):
        bagObject = self._initObject(item)
        self.raadpleegScherm.view.toonObject(bagObject)
        self.raadpleegScherm.kaart.toonGeometrie(bagObject)

    # Maak de hele boom leeg
    def maakLeeg(self):
        self.DeleteAllItems()
        self.root = self.AddRoot("Zoekresultaat")
        self.raadpleegScherm.view.maakLeeg()

    # Voeg een object met de gegeven identificatie toe aan de boom
    def voegToe(self, identificatie):
        bagObject = BAGObjectFabriek.bof.getBAGObjectBijIdentificatie(identificatie)
        if bagObject:
            return self._initItem(self.GetRootItem(), bagObject.objectType(), bagObject.identificatie())
        else:
            return None


#------------------------------------------------------------------------------
# BAGView toont de gegevens van een voorkomen of van de levenscyclus in tekstvorm.
# Hiertoe gebruiken we een RichTextCtrl voor het gebruik van verschillende fonts
# en kleuren.
#------------------------------------------------------------------------------
class BAGView(rt.RichTextCtrl):
    # Constructor
    def __init__(self, raadpleegScherm, positie, afmeting):
        rt.RichTextCtrl.__init__(self, raadpleegScherm, -1, "", positie, afmeting,
                                 style=wx.TE_READONLY | wx.TE_MULTILINE)
        self.raadpleegScherm = raadpleegScherm
        self.bagObject = None
        self.font = wx.Font(8, wx.FONTFAMILY_MODERN, wx.FONTSTYLE_NORMAL, wx.FONTWEIGHT_NORMAL)
        self.SetFont(self.font)
        self.toonLevenscyclusKnop = wx.Button(self, label="Toon levenscyclus",
                                              pos=(10, self.GetSize().GetHeight() - 30))
        self.Bind(wx.EVT_BUTTON, self.toonLevenscyclus, self.toonLevenscyclusKnop)
        self.toonLevenscyclusKnop.Hide()

    # Toon 1 object/voorkomen 
    def toonObject(self, bagObject):
        self.Clear()
        self.bagObject = bagObject

        self.WriteText("--- %s ---\n" % (self.bagObject.naam()))
        self.BeginBold()
        self.WriteText("%s\n" % (self.bagObject.omschrijving()))
        self.EndBold()
        self.WriteText("Attributen:\n")
        for attribuut in self.bagObject.attributen_volgorde:
            if attribuut.enkelvoudig():
                self.WriteText(" - %-27s: %s\n" % (attribuut.naam(), attribuut.waarde()))
            else:
                naam = attribuut.naam()
                for waarde in attribuut.waarde():
                    self.WriteText(" - %-27s: %s\n" % (attribuut.naam(), waarde))
                    naam = ""
        self.toonLevenscyclusKnop.Show(True)
        self.toonLevenscyclusKnop.Raise()
        self.toonLevenscyclusKnop.MoveXY(10, self.GetSize().GetHeight() - 30)

    # Toon de volledige levenscyclus van een object.
    # Eventuele fouten in de levenscyclus worden getoond in rode letters.
    # Bij opvolgende (actieve) voorkomens, worden de attributen die gewijzigd zijn ten
    # opzichte van het voorgaande voorkomen, getoond in blauwe letters.
    def toonLevenscyclus(self, event):
        self.Clear()
        self.WriteText("--- %s ---\n" % (self.bagObject.naam()))
        self.BeginBold()
        self.WriteText("%s\n" % (self.bagObject.omschrijving()))
        self.EndBold()
        levenscyclus = self.bagObject.controleerLevenscyclus(toonResultaat=False)
        if not self.bagObject.levenscyclusCorrect:
            self.BeginTextColour((255, 0, 0))
            self.WriteText("*** Levenscyclus is corrupt; zie opmerkingen bij voorkomens ***\n")
            self.EndTextColour()

        laatsteActieve = -1
        v = 0
        while v < len(levenscyclus):
            datum = levenscyclus[v].begindatumTijdvakGeldigheid.waarde()
            begindatum = "%s%s-%s%s-%s%s%s%s" % (
                datum[6], datum[7], datum[4], datum[5], datum[0], datum[1], datum[2], datum[3])
            datum = levenscyclus[v].einddatumTijdvakGeldigheid.waarde()
            if datum == "":
                einddatum = "..."
            else:
                einddatum = "%s%s-%s%s-%s%s%s%s" % (
                    datum[6], datum[7], datum[4], datum[5], datum[0], datum[1], datum[2], datum[3])
            self.WriteText("-----------------------------------------------------------------\n")
            self.BeginBold()
            self.WriteText("%s. van %s tot %s\n" % (str(v + 1), begindatum, einddatum))
            self.EndBold()
            if levenscyclus[v].opmerking <> "":
                self.BeginTextColour((255, 0, 0))
                self.WriteText("*** %s\n" % (levenscyclus[v].opmerking))
                self.EndTextColour()
            self.WriteText("Attributen:\n")
            a = 0
            while a < len(levenscyclus[v].attributen):
                if levenscyclus[v].attributen[a].enkelvoudig():
                    self.WriteText(" - %-27s: " % (levenscyclus[v].attributen[a].naam()))
                    if laatsteActieve <> -1 and levenscyclus[v].aanduidingRecordInactief.waarde() == "N" and \
                                    levenscyclus[v].attributen[a].waarde() <> levenscyclus[laatsteActieve].attributen[
                                a].waarde():
                        self.BeginTextColour((0, 0, 255))
                        self.WriteText("%s\n" % (levenscyclus[v].attributen[a].waarde()))
                        self.EndTextColour()
                    else:
                        self.WriteText("%s\n" % (levenscyclus[v].attributen[a].waarde()))
                else:
                    naam = levenscyclus[v].attributen[a].naam()
                    for waarde in levenscyclus[v].attributen[a].waarde():
                        self.WriteText(" - %-27s: %s\n" % (levenscyclus[v].attributen[a].naam(), waarde))
                        naam = ""
                a += 1
            if levenscyclus[v].aanduidingRecordInactief.waarde() == "N":
                laatsteActieve = v
            v += 1
        self.toonLevenscyclusKnop.Hide()

    # Maak de view leeg        
    def maakLeeg(self):
        self.Clear()
        self.toonLevenscyclusKnop.Hide()


#------------------------------------------------------------------------------
# BAGKaart toont een kaart met een object en zijn omgeving
#------------------------------------------------------------------------------
class BAGKaart(wx.Panel):
    # Constructor
    def __init__(self, raadpleegScherm, positie, afmeting):
        wx.Panel.__init__(self, raadpleegScherm, -1, positie, afmeting)
        self.raadpleegScherm = raadpleegScherm
        self.logScherm = raadpleegScherm.logScherm
        self.gebruikHuidigeKaart = False
        self.minX = 0.0
        self.minY = 0.0
        self.maxX = 0.0
        self.maxY = 0.0
        self.centerX = 0.0
        self.centerY = 0.0
        self.schaal = 0.0
        self.zoom = 0.5
        self.polygonen = []  # Verzameling van alle polygonen die worden getoond in de kaart
        self.bagObject = None  # Het huidige bagObject dat wordt getoond in de kaart
        self.highlightPolygonen = []  # Polygoon(en) van het huidige bagObject
        self.PNDpolygonen = []  # Lijst van Pand-polygonen
        self.LPLpolygonen = []  # Lijst van Ligplaats-polygonen
        self.SPLpolygonen = []  # Lijst van Standplaats-polygonen
        self.WPLpolygonen = []  # Lijst van Woonplaats-polygonen
        self.NBpolygonen = []  # 'NB' betekent Niet Bestaand, voor bijv. gesloopte panden
        self.coordinaten = wx.TextCtrl(self, -1, "",
                                       pos=(self.GetSize().GetWidth() - 90, self.GetSize().GetHeight() - 20),
                                       size=(90, 20), style=wx.TE_READONLY)
        self.SetBackgroundColour(self.coordinaten.GetBackgroundColour())
        self.Bind(wx.EVT_PAINT, self._tekenKaart)
        # self.Bind(wx.EVT_MOTION, self._beweegCursor)
        self.Bind(wx.EVT_LEFT_DOWN, self._klikOpPunt)
        self.Bind(wx.EVT_LEFT_DCLICK, self._dubbelklikOpPunt)

        self.zoomUitKnop = wx.Button(self, label="-", pos=(self.GetSize().GetWidth() - 20, 0), size=(20, 20))
        self.zoomInKnop = wx.Button(self, label="+", pos=(self.GetSize().GetWidth() - 20, 20), size=(20, 20))
        self.Bind(wx.EVT_BUTTON, self._zoomUit, self.zoomUitKnop)
        self.Bind(wx.EVT_BUTTON, self._zoomIn, self.zoomInKnop)
        self.database = Database()

    # Maak de kaart leeg
    def maakLeeg(self):
        self.minX = 0.0
        self.minY = 0.0
        self.maxX = 0.0
        self.maxY = 0.0
        self.centerX = 0.0
        self.centerY = 0.0
        self.schaal = 0.0
        self.zoom = 0.5
        self.polygonen = []
        self.bagObject = None
        self.highlightPolygonen = []
        self.PNDpolygonen = []
        self.LPLpolygonen = []
        self.SPLpolygonen = []
        self.WPLpolygonen = []
        self.NBpolygonen = []
        self.coordinaten.Clear()
        self.Refresh()

    # Teken de kaart op basis van de polygonen die in de kaart zijn opgeslagen.
    # Deze functie wordt aangeroepen naar een EVT_PAINT event.
    def _tekenKaart(self, event=None):
        dc = wx.PaintDC(self)
        gc = wx.GraphicsContext.Create(dc)

        # Toon woonplaatsen in bruin
        gc.SetPen(wx.Pen("brown", 1))
        for polygoon in self.WPLpolygonen:
            gc.DrawLines(polygoon)

        # Toon niet (meer) bestaand objecten zonder opvulkleur
        gc.SetPen(wx.Pen("grey", 1))
        gc.SetBrush(wx.Brush("grey", wx.CROSSDIAG_HATCH))
        for polygoon in self.NBpolygonen:
            gc.DrawLines(polygoon)

        # Toon panden in blauw
        gc.SetPen(wx.Pen("navy", 1))
        gc.SetBrush(wx.Brush("light grey"))
        for polygoon in self.PNDpolygonen:
            gc.DrawLines(polygoon)

        # Toon ligplaatsen in groen
        gc.SetPen(wx.Pen("pale green", 1))
        gc.SetBrush(wx.Brush("green"))
        for polygoon in self.LPLpolygonen:
            gc.DrawLines(polygoon)

        # Toon standplaatsen in paars
        gc.SetPen(wx.Pen("purple", 1))
        gc.SetBrush(wx.Brush("pink"))
        for polygoon in self.SPLpolygonen:
            gc.DrawLines(polygoon)

        # Het geselecteerde BAG-object wordt vetgedrukt in rood getoond
        gc.SetPen(wx.Pen("red", 2))
        gc.SetBrush(wx.Brush("salmon"))
        for polygoon in self.highlightPolygonen:
            if len(polygoon) == 1:
                # Verblijfsobjecten hebben maar 1 punt in de geometrie. Toon deze als een cirkel
                gc.DrawEllipse(polygoon[0].x, polygoon[0].y, 5, 5)
            else:
                gc.DrawLines(polygoon)

        self.zoomInKnop.Refresh()
        self.zoomUitKnop.Refresh()

    # Toon bij het bewegen van de cursor de coordinaten op de kaart
    def _beweegCursor(self, event):
        self.coordinaten.Clear()
        self.coordinaten.WriteText("%d,%d" % (self.cursorPositieX(), self.cursorPositieY()))

    # Bij een enkele klik op de kaart wordt, zonder de kaart te verschuiven of te veranderen,
    # het object op het aangeklikte punt geselecteerd, gehighlight en getoond in de view.
    # Dit werkt door de coordinaten van het aangeklikte punt in te vullen in de functie voor
    # het zoeken op coordinaten, en deze zoekfunctie uit te voeren. Door hierbij eerst de
    # vlag 'gebruikHuidigeKaart' aan te zetten, wordt voorkomen dat de hele kaart rondom het
    # gevonden object opnieuw wordt opgebouwd.
    def _klikOpPunt(self, event):
        self.coordinaten.Clear()
        self.gebruikHuidigeKaart = True
        self.raadpleegScherm.zoekOpCoordinaten.klapOpen()
        self.raadpleegScherm.zoekOpCoordinaten.xText.Clear()
        self.raadpleegScherm.zoekOpCoordinaten.xText.WriteText(str(int(self.cursorPositieX())))
        self.raadpleegScherm.zoekOpCoordinaten.yText.Clear()
        self.raadpleegScherm.zoekOpCoordinaten.yText.WriteText(str(int(self.cursorPositieY())))
        self.raadpleegScherm.zoekOpCoordinaten.Refresh()
        self.raadpleegScherm.zoekOpCoordinaten.zoek()
        self.gebruikHuidigeKaart = False

    # Bij een dubbelklik op de kaart, wordt het object gezocht op het aangeklikte punt, wordt
    # dit object gecentreerd in de kaart en de kaart rondom dit object opnieuw opgebouwd.
    def _dubbelklikOpPunt(self, event):
        self.coordinaten.Clear()
        self.raadpleegScherm.zoekOpCoordinaten.klapOpen()
        self.raadpleegScherm.zoekOpCoordinaten.xText.Clear()
        self.raadpleegScherm.zoekOpCoordinaten.xText.WriteText(str(int(self.cursorPositieX())))
        self.raadpleegScherm.zoekOpCoordinaten.yText.Clear()
        self.raadpleegScherm.zoekOpCoordinaten.yText.WriteText(str(int(self.cursorPositieY())))
        self.raadpleegScherm.zoekOpCoordinaten.Refresh()
        self.raadpleegScherm.zoekOpCoordinaten.zoek()

    # Zoom in op de kaart door de zoomfactor te halveren
    def _zoomIn(self, event):
        self.zoom = self.zoom / 2.0
        self.toonGeometrie(self.bagObject)

    # Zoom uit op de kaart door de zoomfactor te verdubbelen
    def _zoomUit(self, event):
        self.zoom = self.zoom * 2.0
        self.toonGeometrie(self.bagObject)

    # Reken de X-coordinaat om naar een positie op de kaart op het scherm.
    def schermCoordinaatX(self, x):
        return self.GetSize().GetWidth() / 2 + (x - self.centerX) / self.schaal

    # Reken de Y-coordinaat om naar een positie op de kaart op het scherm.
    def schermCoordinaatY(self, y):
        return (self.GetSize().GetHeight() / 2 + (y - self.centerY) / self.schaal) * -1 + self.GetSize().GetHeight()

    # Geef de X-coordinaat op de kaart die overeenkomt met de cursor positie.
    def cursorPositieX(self):
        return self.centerX + (
                                  wx.GetMousePosition().x - self.GetScreenPosition().x - self.GetSize().GetWidth() / 2) * self.schaal

    # Geef de Y-coordinaat op de kaart die overeenkomt met de cursor positie.
    def cursorPositieY(self):
        return self.centerY + (((
                                    wx.GetMousePosition().y - self.GetScreenPosition().y - self.GetSize().GetHeight()) * -1) - self.GetSize().GetHeight() / 2) * self.schaal

    # Toon van een gevonden BAG-object de geometrie in de kaart, tezamen met de geometrieen van
    # omliggende objecten.
    def toonGeometrie(self, bagObject):
        if bagObject.objectType() == "WPL":
            return
        return

        # Initialiseer eerst het huidige, geselecteerde BAG object en stop de geometrie hiervan in de verzameling
        # highlightPolygonen.
        self.bagObject = bagObject
        self.highlightPolygonen = []

        if self.bagObject.objectType() == "NUM":
            # In geval van een nummeraanduiding, wordt het adresseerbare object bij de nummeraanduiding gebruikt
            # als uitgangspunt voor weergave op de kaart.
            self.bagObject = self.bagObject.getAdresseerbaarObject()

        if self.bagObject.objectType() in ["PND", "LPL", "SPL", "VBO"]:
            # Lees de geometrie uit het bagObject en stel de BAGpolygoon samen als een lijst van
            # coordinatenparen.
            geometrie = self.bagObject.geometrie().waarde()
            if geometrie[:7].upper() == "POLYGON" or geometrie[:5].upper() == "POINT":
                polygoon = []
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                if geometrie[:5].upper() == "POINT":
                    geometrie = geometrie[5:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                for punt in geometrie.lstrip().rstrip().split(','):
                    coordinaten = punt.lstrip().rstrip().split(' ')
                    polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                self.highlightPolygonen.append(polygoon)
                self.polygonen.append(polygoon)

        if self.bagObject.objectType() == "OPR":
            # In geval van een openbare ruimte, wordt de verzameling gevuld met geometrieen van de adresseerbare objecten
            # met een hoofdadres aan de openbare ruimte.
            sql = "SELECT vbo.verblijfsobjectgeometrie "
            sql += "  FROM verblijfsobjectActueel vbo"
            sql += "     , nummeraanduidingActueel num"
            sql += " WHERE num.gerelateerdeopenbareruimte = " + str(self.bagObject.identificatie())
            sql += "   AND vbo.hoofdadres = num.identificatie"
            verblijfsobjecten = self.database.select(sql)
            for verblijfsobject in verblijfsobjecten:
                geometrie = verblijfsobject[0]
                if geometrie[:5].upper() == "POINT":
                    geometrie = geometrie[5:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    self.highlightPolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Zoek de ligplaatsen aan de openbare ruimte
            sql = "SELECT lpl.ligplaatsgeometrie "
            sql += "  FROM ligplaatsActueel lpl"
            sql += "     , nummeraanduidingActueel num"
            sql += " WHERE num.gerelateerdeopenbareruimte = " + str(self.bagObject.identificatie())
            sql += "   AND lpl.hoofdadres = num.identificatie"
            ligplaatsen = self.database.select(sql)
            for ligplaats in ligplaatsen:
                geometrie = ligplaats[0]
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    self.highlightPolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Zoek de standplaatsen aan de openbare ruimte
            sql = "SELECT spl.standplaatsgeometrie "
            sql += "  FROM standplaatsActueel spl"
            sql += "     , nummeraanduidingActueel num"
            sql += " WHERE num.gerelateerdeopenbareruimte = " + str(self.bagObject.identificatie())
            sql += "   AND spl.hoofdadres = num.identificatie"
            standplaatsen = self.database.select(sql)
            for standplaats in standplaatsen:
                geometrie = standplaats[0]
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    self.highlightPolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

        if self.gebruikHuidigeKaart:
            # Gebruik de huidige kaart zonder te verschuiven. Alleen het geselecteerde BAG-object(en) wordt opnieuw getekend.
            # Reken de XY-coordinaten in de polygoon om naar punten in het scherm.
            for polygoon in self.highlightPolygonen:
                for punt in polygoon:
                    punt.x = self.schermCoordinaatX(punt.x)
                    punt.y = self.schermCoordinaatY(punt.y)
        else:
            # Bouw een nieuwe kaart op rondom het geselecteerde object
            self.minX = 999999.0
            self.minY = 999999.0
            self.maxX = 0.0
            self.maxY = 0.0
            self.schaal = self.zoom
            self.polygonen = []
            for polygoon in self.highlightPolygonen:
                self.polygonen.append(polygoon)
            self.PNDpolygonen = []
            self.LPLpolygonen = []
            self.SPLpolygonen = []
            self.WPLpolygonen = []
            self.NBpolygonen = []

            # Bepaal de uiterste hoekpunten van de rechthoek waarin de BAGpolygoon past.
            for polygoon in self.highlightPolygonen:
                for punt in polygoon:
                    self.minX = min(self.minX, punt.x)
                    self.minY = min(self.minY, punt.y)
                    self.maxX = max(self.maxX, punt.x)
                    self.maxY = max(self.maxY, punt.y)

            self.centerX = (self.minX + self.maxX) / 2.0
            self.centerY = (self.minY + self.maxY) / 2.0

            # Bepaal de rechthoek rondom het object waarin naar omliggende objecten wordt gezocht.
            lX = self.minX - 600 * self.schaal
            lY = self.minY - 400 * self.schaal
            rX = self.maxX + 600 * self.schaal
            rY = self.maxY + 400 * self.schaal
            rechthoek = "POLYGON((%f %f 0.0, %f %f 0.0, %f %f 0.0, %f %f 0.0, %f %f 0.0))" % (
                lX, lY, rX, lY, rX, rY, lX, rY, lX, lY)

            # Zoek panden in de omgeving                
            sql = "SELECT pandgeometrie, pandstatus"
            sql += "  FROM pandActueel"
            sql += " WHERE geometrie && GeomFromEWKT('SRID=28992;" + rechthoek + "')"
            panden = self.database.select(sql)
            for pand in panden:
                geometrie = pand[0]
                status = pand[1]
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    if status.upper() in ["BOUWVERGUNNING VERLEEND", "NIET GEREALISEERD PAND", "PAND GESLOOPT"]:
                        self.NBpolygonen.append(polygoon)
                    else:
                        self.PNDpolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Zoek ligplaatsen in de omgeving
            sql = "SELECT ligplaatsgeometrie, ligplaatsstatus"
            sql += "  FROM ligplaatsActueel"
            sql += " WHERE geometrie && GeomFromEWKT('SRID=28992;" + rechthoek + "')"
            ligplaatsen = self.database.select(sql)
            for ligplaats in ligplaatsen:
                geometrie = ligplaats[0]
                status = ligplaats[1]
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    if status.upper() == "LIGPLAATS INGETROKKEN":
                        self.NBpolygonen.append(polygoon)
                    else:
                        self.LPLpolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Zoek standplaatsen in de omgeving
            sql = "SELECT standplaatsgeometrie, standplaatsstatus"
            sql += "  FROM standplaatsActueel"
            sql += " WHERE geometrie && GeomFromEWKT('SRID=28992;" + rechthoek + "')"
            standplaatsen = self.database.select(sql)
            for standplaats in standplaatsen:
                geometrie = standplaats[0]
                status = standplaats[1]
                if geometrie[:7].upper() == "POLYGON":
                    geometrie = geometrie[7:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    if status.upper() == "STANDPLAATS INGETROKKEN":
                        self.NBpolygonen.append(polygoon)
                    else:
                        self.SPLpolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Zoek woonplaatsen in de omgeving
            sql = "SELECT woonplaatsgeometrie"
            sql += "  FROM woonplaatsActueel"
            sql += " WHERE geometrie && GeomFromEWKT('SRID=28992;" + rechthoek + "')"
            woonplaatsen = self.database.select(sql)
            for woonplaats in woonplaatsen:
                geometrie = woonplaats[0]
                if geometrie[:12].upper() == "MULTIPOLYGON":
                    geometrie = geometrie[12:].replace('(', ' ').replace(')', ' ').lstrip().rstrip()
                    polygoon = []
                    for punt in geometrie.lstrip().rstrip().split(','):
                        coordinaten = punt.lstrip().rstrip().split(' ')
                        polygoon.append(wx.Point2D(float(coordinaten[0]), float(coordinaten[1])))
                    self.WPLpolygonen.append(polygoon)
                    self.polygonen.append(polygoon)

            # Reken de XY-coordinaten in de polygoon om naar punten in het scherm
            for polygoon in self.polygonen:
                for punt in polygoon:
                    punt.x = self.schermCoordinaatX(punt.x)
                    punt.y = self.schermCoordinaatY(punt.y)

        # Refresh genereert een EVT_PAINT event, waarna de polygonen op de kaart getekend worden.
        self.Refresh()


        #------------------------------------------------------------------------------


# BAGRaadpleeg toont een scherm voor het zoeken en raadplegen van BAG-objecten.
#------------------------------------------------------------------------------
class BAGRaadpleeg(wx.Dialog):
    # Constructor
    def __init__(self, parent):
        wx.Dialog.__init__(self, parent, -1, 'Raadpleeg NLExtract-BAG database', size=(1000, 800))

        self.sluitKnop = wx.Button(self, label="Sluit", pos=(5, 745))
        self.Bind(wx.EVT_BUTTON, self.sluit, self.sluitKnop)

        self.text_ctrl = wx.TextCtrl(self, -1, "", pos=(100, 740), size=(800, 30),
                                     style=wx.TE_READONLY | wx.TE_MULTILINE)
        self.text_ctrl.SetBackgroundColour(self.sluitKnop.GetBackgroundColour())
        self.logScherm = LogScherm(self.text_ctrl)
        Log.log.set_output(self.logScherm)
        self.logScherm.start()

        self.panels = []
        self.zoekOpAdres = BAGZoekOpAdres(self)
        self.zoekOpPostcode = BAGZoekOpPostcode(self)
        self.zoekOpCoordinaten = BAGZoekOpCoordinaten(self)
        self.zoekOpIdentificatie = BAGZoekOpIdentificatie(self)
        self.zoekOpAdres.klapOpen()
        self.toonPanels()

        self.boom = BAGBoom(self, positie=(190, 0), afmeting=(310, 340))
        self.view = BAGView(self, positie=(500, 0), afmeting=(490, 730))
        self.kaart = BAGKaart(self, positie=(5, 340), afmeting=(495, 400))
        self.logScherm("Gereed")

    # Zet de verschillende in/uitklapbare zoekpanels onder elkaar op de juiste plek
    def toonPanels(self):
        y = 5
        for panel in self.panels:
            panel.Move((0, y))
            if panel.cp.IsExpanded():
                panel.SetSize((180, 180))
                panel.focus.SetFocus()
                y += 181
            else:
                panel.SetSize((180, 30))
                y += 31
            panel.Layout()

    # Sluit het scherm
    def sluit(self, event):
        self.Close()
