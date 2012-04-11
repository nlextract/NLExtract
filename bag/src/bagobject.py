__author__ = "Just van den Broecke"
__date__ = "Dec 21, 2011 3:46:27 PM$"

"""
 Naam:         BAGObject.py
 Omschrijving: Classes voor BAG-objecten

 Per BAG-objecttype (woonplaats, openbareruimte, nummeraanduiding,
 ligplaats, standplaats, verblijfsobject, pand) is er een aparte class.
 De BAGObject classes zijn pure data classes. Functionaliteit mbt
 lezen/schrijven database zijn elders gedefinieerd.

 Deze classes zijn een vereenvoudiging van de originele classes in libbagextract.py.

 De BAG-objecttype-classes zijn afgeleid van de basisclass BAGObject.
 Hierin is een BAG-object een verzameling van BAG-attributen met elk
 hun eigen eigenschappen.

 Auteur:       Just van den Broecke (Matthijs van der Deijl libbagextract.py origineel)

 Versie:       1.0
               - basis versie
 Datum:        21 december 2011


 OpenGeoGroep.nl
"""

from bagattribuut import *
from logging import Log
from etree import stripschema

#--------------------------------------------------------------------------------------------------------
# Class         BAGObject
# Omschrijving  Basisclass voor de 7 types BAG-objecten. Deze class bevat de generieke attributen die
#               in al deze types BAG-objecten voorkomen.
#--------------------------------------------------------------------------------------------------------
class BAGObject:
    # Constructor
    def __init__(self, tag="", naam="", objectType=""):
        self.attributen = {}
        self.attributen_volgorde = []
        self.voegToe(BAGnumeriekAttribuut(16, "identificatie", "bag_LVC:identificatie"))
        self.voegToe(BAGbooleanAttribuut("aanduidingRecordInactief", "bag_LVC:aanduidingRecordInactief"))
        self.voegToe(BAGintegerAttribuut("aanduidingRecordCorrectie","bag_LVC:aanduidingRecordCorrectie"))
        self.voegToe(BAGbooleanAttribuut("officieel", "bag_LVC:officieel"))
        self.voegToe(BAGbooleanAttribuut("inOnderzoek", "bag_LVC:inOnderzoek"))
        self.voegToe(BAGdatetimeAttribuut("begindatumTijdvakGeldigheid","bag_LVC:tijdvakgeldigheid/bagtype:begindatumTijdvakGeldigheid"))
        self.voegToe(BAGdatetimeAttribuut("einddatumTijdvakGeldigheid","bag_LVC:tijdvakgeldigheid/bagtype:einddatumTijdvakGeldigheid"))
        self.voegToe(BAGstringAttribuut(20, "documentnummer", "bag_LVC:bron/bagtype:documentnummer"))
        self.voegToe(BAGdateAttribuut("documentdatum", "bag_LVC:bron/bagtype:documentdatum"))

        self.relaties = []

        self.origineelObj = None
        self._tag = tag
        self._naam = naam
        self._objectType = objectType

   # Geef de XML-tag bij het type BAG-object.
    def voegToe(self, attribuut):
        attribuut._parentObj = self
        self.attributen[attribuut.naam()] = attribuut
        self.attributen_volgorde.append(attribuut)

    # Geef de XML-tag bij het type BAG-object.
    def tag(self):
        return self._tag

    # Geef unieke identificatie (nummer) van BAG-object.
    def identificatie(self):
        attr = self.attribuut('identificatie')
        # Sanity check
        if not attr:
            return -1
        return attr._waarde

    # Geef de naam bij het type BAG-object.
    def naam(self):
        return self._naam

    # Geef het objecttype bij het type BAG-object.
    def objectType(self):
        return self._objectType

    # Geef aan of het object een geometrie heeft.
    # Deze method kan worden overloaded in de afgeleide classes
    def heeftGeometrie(self):
        return False

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        for attribuut in self.attributen_volgorde:
            attribuut.leesUitXML(xml)

        for relatie in self.relaties:
            relatie.leesUitXML(xml)

    # Retourneer het attribuut met de gegeven naam
    def attribuut(self, naam):
        return self.attributen[naam]

    # Print informatie over het object op het scherm
    def schrijf(self):
        print "*** %s ***" % (self.naam())
        for attribuut in self.attributen_volgorde:
            attribuut.schrijf()
        for relatie in self.relaties:
             relatie.schrijf()

    # Genereer SQL voor een COPY.
    def maakCopySQL(self, buffer):
        velden = []
        i = 0
        for attribuut in self.attributen_volgorde:

            velden.append(attribuut.naam())
            w = attribuut.waardeSQL()
            if not w:
                w = '\\\N'

            # if attribuut.naam() == 'geom_valid':
            #   w = repr(False)

            if i > 0:
                buffer.write("~")
                # print("~")
            buffer.write(w)
            # print(w)
            i += 1

        self.velden = velden
        buffer.write("\n")
        # print("\n")

        # Optioneel: relatie objecten
        for relatie in self.relaties:
            relatie.maakCopySQL()

    # Genereer SQL voor een INSERT (als prepared statement).
    def maakInsertSQL(self):
        velden = ""
        waardes = ""
        self.inhoud = []
        for attribuut in self.attributen_volgorde:
            if velden != "":
                velden += ","
                waardes += ","

            velden += attribuut.naam()
            waardes += attribuut.waardeSQLTpl()
            self.inhoud.append(attribuut.waardeSQL())

        self.sql = "INSERT INTO " + self.naam() + " (" + velden + ") VALUES (" + waardes + ")"

        # Optioneel: relatie objecten
        for relatie in self.relaties:
            relatie.maakInsertSQL()

    # Genereer SQL voor een UPDATE (als prepared statement).
    def maakUpdateSQL(self):
        nameVals = ""
        self.inhoud = []
        for attribuut in self.attributen_volgorde:
            if nameVals != "":
                nameVals += ","

            nameVals += attribuut.naam() + ' = ' + attribuut.waardeSQLTpl()
            self.inhoud.append(attribuut.waardeSQL())

        # UPDATE weather SET temp_lo = temp_lo+1, temp_hi = temp_lo+15, prcp = DEFAULT
        # WHERE city = 'San Francisco' AND date = '2003-07-03';
        # Unieke key is combined (identificatie,aanduidingRecordInactief,aanduidingrecordcorrectie,einddatumTijdvakGeldigheid)
        where = "WHERE identificatie = %s AND aanduidingrecordinactief = %s AND aanduidingrecordcorrectie = %s AND einddatumTijdvakGeldigheid "
        eindDatum = self.origineelObj.attribuut('einddatumTijdvakGeldigheid').waardeSQL()

        # Tricky: indien eindDatum leeg moet in WHERE "is NULL" staan
        # want "= NULL" geeft geen resultaat
        # http://stackoverflow.com/questions/4476172/postgresql-select-where-timestamp-is-empty
        if eindDatum:
            where += "= %s"
        else:
            where += "is %s"

        self.inhoud.extend((self.origineelObj.attribuut('identificatie').waardeSQL(),
                             self.origineelObj.attribuut('aanduidingRecordInactief').waardeSQL(),
                             self.origineelObj.attribuut('aanduidingRecordCorrectie').waardeSQL(),
                             eindDatum))

        self.sql = "UPDATE " + self.naam() + " SET " + nameVals + " " + where

        # Optioneel: relatie objecten
        for relatie in self.relaties:
            relatie.maakUpdateSQL()
    
    # Genereer SQL voor (DROP) en CREATE TABLE
    def maakTabel(self):
        sqlinit = ""
        sql = "CREATE TABLE " + self.naam() + " (\n  gid SERIAL,\n  "
        attributen = []
        for attribuut in self.attributen_volgorde:
            sqlinit += attribuut.sqlinit()

            if attribuut.enkelvoudig() and not attribuut.isGeometrie():
                attributen.append(attribuut.naam() + " " + attribuut.sqltype())

        sql += ",\n  ".join(attributen) + "\n)"

        if self.heeftGeometrie():
            sql += " WITH (OIDS=true);\n"

            for attribuut in self.attributen_volgorde:
                if attribuut.isGeometrie():
                    sql += "SELECT AddGeometryColumn('public', '%s', '%s', 28992, '%s', %s);\n" % \
                        (self.naam().lower(), attribuut.naam(), attribuut.soort(), attribuut.dimensie())
        else:
            sql += ";\n"

        return "DROP TABLE IF EXISTS " + self.naam() + " CASCADE;\n" + sqlinit + sql + "\n"

#--------------------------------------------------------------------------------------------------------
# Class         Woonplaats
# Afgeleid van  BAGObject
# Omschrijving  Class voor het BAG-objecttype Woonplaats.
#--------------------------------------------------------------------------------------------------------
class Woonplaats(BAGObject):
    woonplaatsStatusTypes = ['Woonplaats aangewezen', 'Woonplaats ingetrokken']
    def __init__(self):
        BAGObject.__init__(self, "bag_LVC:Woonplaats", "woonplaats", "WPL")
        self.voegToe(BAGstringAttribuut(80, "woonplaatsNaam", "bag_LVC:woonplaatsNaam"))
        self.voegToe(BAGenumAttribuut(Woonplaats.woonplaatsStatusTypes, "woonplaatsStatus", "bag_LVC:woonplaatsStatus"))
        self.voegToe(BAGmultiPolygoon(2, "geovlak", "bag_LVC:woonplaatsGeometrie"))
        self.voegToe(BAGgeometrieValidatie("geom_valid", "geovlak"))

    def heeftGeometrie(self):
        return True

#--------------------------------------------------------------------------------------------------------
# Class         OpenbareRuimte
# Afgeleid van  BAGObject
# Omschrijving  Class voor het BAG-objecttype OpenbareRuimte.
#--------------------------------------------------------------------------------------------------------
class OpenbareRuimte(BAGObject):
    openbareRuimteTypes = ['Weg','Water', 'Spoorbaan', 'Terrein', 'Kunstwerk', 'Landschappelijk gebied', 'Administratief gebied']
    openbareRuimteStatusTypes = ['Naamgeving uitgegeven', 'Naamgeving ingetrokken']
    def __init__(self):
        BAGObject.__init__(self, "bag_LVC:OpenbareRuimte", "openbareruimte", "OPR")
        self.voegToe(BAGstringAttribuut(80, "openbareRuimteNaam", "bag_LVC:openbareRuimteNaam"))
        self.voegToe(BAGenumAttribuut(OpenbareRuimte.openbareRuimteStatusTypes, "openbareRuimteStatus", "bag_LVC:openbareruimteStatus"))
        self.voegToe(BAGenumAttribuut(OpenbareRuimte.openbareRuimteTypes, "openbareRuimteType","bag_LVC:openbareRuimteType"))
        self.voegToe(BAGnumeriekAttribuut(16, "gerelateerdeWoonplaats",
                                                   "bag_LVC:gerelateerdeWoonplaats/bag_LVC:identificatie"))
        self.voegToe(BAGattribuut(80, "verkorteOpenbareRuimteNaam",
                                                       "nen5825:VerkorteOpenbareruimteNaam"))

#--------------------------------------------------------------------------------------------------------
# Class         Nummeraanduiding
# Afgeleid van  BAGObject
# Omschrijving  Class voor het BAG-objecttype Nummeraanduiding.
#--------------------------------------------------------------------------------------------------------
class Nummeraanduiding(BAGObject):
    nummeraanduidingStatusTypes = ['Naamgeving uitgegeven', 'Naamgeving ingetrokken']
    verblijfsobjectTypes = ['Verblijfsobject', 'Standplaats', 'Ligplaats']
    def __init__(self):
        BAGObject.__init__(self, "bag_LVC:Nummeraanduiding", "nummeraanduiding", "NUM")
        self.voegToe(BAGnumeriekAttribuut(5, "huisnummer", "bag_LVC:huisnummer"))
        self.voegToe(BAGattribuut(1, "huisletter", "bag_LVC:huisletter"))
        self.voegToe(BAGattribuut(4, "huisnummertoevoeging", "bag_LVC:huisnummertoevoeging"))
        self.voegToe(BAGattribuut(6, "postcode", "bag_LVC:postcode"))
        self.voegToe(BAGenumAttribuut(Nummeraanduiding.nummeraanduidingStatusTypes, "nummeraanduidingStatus",
                                        "bag_LVC:nummeraanduidingStatus"))
        self.voegToe(BAGenumAttribuut(Nummeraanduiding.verblijfsobjectTypes, "typeAdresseerbaarObject",
                                        "bag_LVC:typeAdresseerbaarObject"))
        self.voegToe(BAGnumeriekAttribuut(16, "gerelateerdeOpenbareRuimte",
                                                   "bag_LVC:gerelateerdeOpenbareRuimte/bag_LVC:identificatie"))
        self.voegToe(BAGnumeriekAttribuut(16, "gerelateerdeWoonplaats",
                                                   "bag_LVC:gerelateerdeWoonplaats/bag_LVC:identificatie"))

#--------------------------------------------------------------------------------------------------------
# Class         BAGadresseerbaarObject
# Afgeleid van  BAGObject
# Omschrijving  Basisclass voor de adresseerbare objecten ligplaats, standplaats en verblijfsobject.
#               Deze class definieert het hoofdadres en de nevenadressen.
#--------------------------------------------------------------------------------------------------------
class BAGadresseerbaarObject(BAGObject):
    def __init__(self, tag, naam, objectType):
        BAGObject.__init__(self, tag, naam, objectType)
        self.voegToe(BAGnumeriekAttribuut(16, "hoofdadres",
                                       "bag_LVC:gerelateerdeAdressen/bag_LVC:hoofdadres/bag_LVC:identificatie"))
        self.relaties.append(BAGrelatieAttribuut(self, "adresseerbaarobjectnevenadres",
                                              16, "nevenadres",
                                              "bag_LVC:gerelateerdeAdressen/bag_LVC:nevenadres/bag_LVC:identificatie"))

#--------------------------------------------------------------------------------------------------------
# Class         Ligplaats
# Afgeleid van  BAGadresseerbaarObject
# Omschrijving  Class voor het BAG-objecttype Ligplaats.
#--------------------------------------------------------------------------------------------------------
class Ligplaats(BAGadresseerbaarObject):
    ligplaatsStatusTypes = ['Plaats aangewezen', 'Plaats ingetrokken']
    def __init__(self):
        BAGadresseerbaarObject.__init__(self, "bag_LVC:Ligplaats", "ligplaats", "LIG")
        self.voegToe(BAGenumAttribuut(Ligplaats.ligplaatsStatusTypes, "ligplaatsStatus", "bag_LVC:ligplaatsStatus"))
        self.voegToe(BAGpolygoon(3, "geovlak", "bag_LVC:ligplaatsGeometrie"))
        self.voegToe(BAGgeometrieValidatie("geom_valid", "geovlak"))

    def heeftGeometrie(self):
        return True

#--------------------------------------------------------------------------------------------------------
# Class         Standplaats
# Afgeleid van  BAGadresseerbaarObject
# Omschrijving  Class voor het BAG-objecttype Standplaats.
#--------------------------------------------------------------------------------------------------------
class Standplaats(BAGadresseerbaarObject):
    standplaatsStatusTypes = ['Plaats aangewezen', 'Plaats ingetrokken']
    def __init__(self):
        BAGadresseerbaarObject.__init__(self, "bag_LVC:Standplaats", "standplaats", "STA")
        self.voegToe(BAGenumAttribuut(Standplaats.standplaatsStatusTypes, "standplaatsStatus", "bag_LVC:standplaatsStatus"))
        self.voegToe(BAGpolygoon(3, "geovlak", "bag_LVC:standplaatsGeometrie"))
        self.voegToe(BAGgeometrieValidatie("geom_valid", "geovlak"))

    def heeftGeometrie(self):
        return True

#--------------------------------------------------------------------------------------------------------
# Class         Verblijfsobject
# Afgeleid van  BAGadresseerbaarObject
# Omschrijving  Class voor het BAG-objecttype Verblijfsobject.
#--------------------------------------------------------------------------------------------------------
class Verblijfsobject(BAGadresseerbaarObject):
    statusEnum = ['Verblijfsobject gevormd',
                  'Niet gerealiseerd verblijfsobject',
                  'Verblijfsobject in gebruik (niet ingemeten)',
                  'Verblijfsobject in gebruik',
                  'Verblijfsobject ingetrokken',
                  'Verblijfsobject buiten gebruik']
    gebruiksdoelEnum = ['woonfunctie','bijeenkomstfunctie',
                        'celfunctie','gezondheidszorgfunctie',
                        'industriefunctie','kantoorfunctie',
                        'logiesfunctie','onderwijsfunctie',
                        'sportfunctie','winkelfunctie','overige gebruiksfunctie']
    def __init__(self):

        BAGadresseerbaarObject.__init__(self, "bag_LVC:Verblijfsobject", "verblijfsobject", "VBO")
        self.voegToe(BAGenumAttribuut(Verblijfsobject.statusEnum,"verblijfsobjectStatus",
                                        "bag_LVC:verblijfsobjectStatus"))
        self.voegToe(BAGnumeriekAttribuut(6, "oppervlakteVerblijfsobject",
                                        "bag_LVC:oppervlakteVerblijfsobject"))
        # Het eerste gerelateerde pand (in principe kunnen er meer zijn, zie relatie)
        # self.voegToe(BAGnumeriekAttribuut(16, "gerelateerdPand1", "bag_LVC:gerelateerdPand/bag_LVC:identificatie"))
        # Het eerste verblijfsdoel  (in principe kunnen er meer zijn, zie relatie)
        # self.voegToe(BAGnumeriekAttribuut(50, "gebruiksdoelVerblijfsobject1", "bag_LVC:gebruiksdoelVerblijfsobject"))
        self.voegToe(BAGpoint(3, "geopunt", "bag_LVC:verblijfsobjectGeometrie"))
        self.voegToe(BAGpolygoon(3, "geovlak", "bag_LVC:verblijfsobjectGeometrie"))
        self.voegToe(BAGgeometrieValidatie("geom_valid", "geovlak"))

        self.relaties.append(BAGenumRelatieAttribuut(self, "verblijfsobjectgebruiksdoel",
                                                               "gebruiksdoelVerblijfsobject",
                                                               "bag_LVC:gebruiksdoelVerblijfsobject", Verblijfsobject.gebruiksdoelEnum))
        self.relaties.append(BAGrelatieAttribuut(self, "verblijfsobjectpand",
                                                   16, "gerelateerdPand",
                                                   "bag_LVC:gerelateerdPand/bag_LVC:identificatie"))

    def heeftGeometrie(self):
        return True

#--------------------------------------------------------------------------------------------------------
# Class         Pand
# Afgeleid van  BAGObject
# Omschrijving  Class voor het BAG-objecttype Pand.
#--------------------------------------------------------------------------------------------------------
class Pand(BAGObject):
    statusEnum = ['Bouwvergunning verleend',
                  'Niet gerealiseerd pand',
                  'Bouw gestart',
                  'Pand in gebruik (niet ingemeten)',
                  'Pand in gebruik',
                  'Sloopvergunning verleend',
                  'Pand gesloopt',
                  'Pand buiten gebruik']
    def __init__(self):
        BAGObject.__init__(self, "bag_LVC:Pand", "pand", "PND")
        self.voegToe(BAGenumAttribuut(Pand.statusEnum, "pandStatus", "bag_LVC:pandstatus"))
        self.voegToe(BAGnumeriekAttribuut(4, "bouwjaar", "bag_LVC:bouwjaar"))
        self.voegToe(BAGpolygoon(3, "geovlak", "bag_LVC:pandGeometrie"))
        self.voegToe(BAGgeometrieValidatie("geom_valid", "geovlak"))

    def heeftGeometrie(self):
        return True


# An extremely simple Singleton Factory for BAGObjects
class BAGObjectFabriek:
    # Singleton: sole static instance of BAGObjectFabriek to have a single BAGObjectFabriek object
    bof = None

    def __init__(self):
        # Singleton: sole instance of Log o have a single Log object
        BAGObjectFabriek.bof = self

    #--------------------------------------------------------------------------------------------------------
    # Geef een BAGObject van het juiste type bij het gegeven type.
    #--------------------------------------------------------------------------------------------------------
    def getBAGObjectBijType(self, objectType):
        if objectType.upper() == "WPL":
            return Woonplaats()
        if objectType.upper() == "OPR":
            return OpenbareRuimte()
        if objectType.upper() == "NUM":
            return Nummeraanduiding()
        if objectType.upper() == "LIG":
            return Ligplaats()
        if objectType.upper() == "STA":
            return Standplaats()
        if objectType.upper() == "VBO":
            return Verblijfsobject()
        if objectType.upper() == "PND":
            return Pand()
        return None

    #--------------------------------------------------------------------------------------------------------
    # Geef een BAGObject van het juiste type bij de gegeven identificatie.
    # Het type wordt afgeleid uit de identificatie.
    #--------------------------------------------------------------------------------------------------------
    def getBAGObjectBijIdentificatie(self, identificatie):
        obj = None
        if len(identificatie) == 4:
            obj = Woonplaats()
        elif identificatie[4:6] == "30":
            obj = OpenbareRuimte()
        elif identificatie[4:6] == "20":
            obj = Nummeraanduiding()
        elif identificatie[4:6] == "02":
            obj = Ligplaats()
        elif identificatie[4:6] == "03":
            obj = Standplaats()
        elif identificatie[4:6] == "01":
            obj = Verblijfsobject()
        elif identificatie[4:6] == "10":
            obj = Pand()
        if obj:
            obj.identificatie.setWaarde(identificatie)
        return obj


    # Creeer een BAGObject uit een DOM node
    def BAGObjectBijXML(self, node):
        if stripschema(node.tag) == 'Ligplaats':
            bagObject = Ligplaats()
        elif stripschema(node.tag) == 'Woonplaats':
            bagObject = Woonplaats()
        elif stripschema(node.tag) == 'Verblijfsobject':
            bagObject = Verblijfsobject()
        elif stripschema(node.tag) == 'OpenbareRuimte':
            bagObject = OpenbareRuimte()
        elif stripschema(node.tag) == 'Nummeraanduiding':
            bagObject = Nummeraanduiding()
        elif stripschema(node.tag) == 'Standplaats':
            bagObject = Standplaats()
        elif stripschema(node.tag) == 'Pand':
            bagObject = Pand()
        else:
            return

        bagObject.leesUitXML(node)
        return bagObject

    # Creeer een array van BAGObjecten uit DOM nodeList
    def BAGObjectArrayBijXML(self, nodeList):
        bagObjecten = []
        for node in nodeList:
            bagObject = self.BAGObjectBijXML(node)
            if bagObject:
                bagObjecten.append(bagObject)

        return bagObjecten

#--------------------------------------------------------------------------------------------------------
# Class         BAGRelatie
# Omschrijving  Relatie van BAG naar BAG object
#--------------------------------------------------------------------------------------------------------
class BAGRelatie(BAGObject):
    # Constructor
    def __init__(self, tag="", naam="", objectType=""):
        self.attributen = {}
        self.attributen_volgorde = []
        self.voegToe(BAGnumeriekAttribuut(16, "identificatie", "bag_LVC:identificatie"))
        self.voegToe(BAGbooleanAttribuut("aanduidingRecordInactief", "bag_LVC:aanduidingRecordInactief"))
        self.voegToe(BAGintegerAttribuut("aanduidingRecordCorrectie","bag_LVC:aanduidingRecordCorrectie"))
        self.voegToe(BAGdatetimeAttribuut("begindatumTijdvakGeldigheid","bag_LVC:tijdvakgeldigheid/bagtype:begindatumTijdvakGeldigheid"))

        self.relaties = [] 

        self.origineelObj = None
        self._tag = tag
        self._naam = naam
        self._objectType = objectType

#--------------------------------------------------------------------------------------------------------
# Class         VerblijfsObjectPand
# Omschrijving  Relatie van Verblijfsobject naar Pand
#--------------------------------------------------------------------------------------------------------
class VerblijfsObjectPand(BAGRelatie):
    def __init__(self):
        BAGRelatie.__init__(self, "", "verblijfsobjectpand", "")
        self.voegToe(BAGnumeriekAttribuut(16, "gerelateerdpand", "bag_LVC:gerelateerdPand"))

#--------------------------------------------------------------------------------------------------------
# Class         AdresseerbaarObjectNevenAdres
# Omschrijving  Relatie van Verblijfsobject naar Nevenadres
#--------------------------------------------------------------------------------------------------------
class AdresseerbaarObjectNevenAdres(BAGRelatie):
    def __init__(self):
        BAGRelatie.__init__(self, "", "adresseerbaarobjectnevenadres", "")
        self.voegToe(BAGnumeriekAttribuut(16, "nevenadres", "bag_LVC:nevenadres"))

#--------------------------------------------------------------------------------------------------------
# Class         VerblijfsObjectGebruiksdoel 
# Omschrijving  Relatie van Verblijfsobject naar Gebruiksdoelen
#--------------------------------------------------------------------------------------------------------
class VerblijfsObjectGebruiksdoel(BAGRelatie):
    def __init__(self):
        BAGRelatie.__init__(self, "", "verblijfsobjectgebruiksdoel", "")
        self.voegToe(BAGenumAttribuut(Verblijfsobject.gebruiksdoelEnum, "gebruiksdoelverblijfsobject", "bag_LVC:gebruiksdoelVerblijfsobject"))


BAGObjectFabriek()
