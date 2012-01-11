__author__ = "Just van den Broecke"
__date__ = "Jan 9, 2012 3:46:27 PM$"

"""
 Naam:         bagattribuut.py
 Omschrijving: Attributen voor BAG-objecten

 Auteur:       Just van den Broecke (Matthijs van der Deijl libbagextract.py origineel)

 Versie:       1.0
               - basis versie
 Datum:        9 januari 2012

 OpenGeoGroep.nl
"""
from logging import Log

# Geef de waarde van een textnode in XML
def getText(nodelist):
    rc = ""
    for node in nodelist:
        if node.nodeType == node.TEXT_NODE:
            rc = rc + node.data
    return rc

# Geef de waardes van alle elementen met de gegeven tag binnen de XML (parent).
# De tag kan een samengestelde tag zijn opgebouwd uit verschillende niveaus gescheiden door een '/'.
def getValues(parent, tag):
    data = []
    # Splits de tag bij het eerste voorkomen van '/' met behulp van de partition-functie
    #
    # tags = tag.partition("/")  werkt alleen voor Python 2.5 en hoger en sommige
    # omgevingen (PDOK) hebben helaas nog Python 2.4.3
    # Splits in max 2 elementen, bijv.  ['bag_LVC:gerelateerdeAdressen', 'bag_LVC:nevenadres/bag_LVC:identificatie']
    tags = tag.split("/", 1)
    # print str(tags)
    for node in parent.getElementsByTagName(tags[0]):
        # getElementsByTagName geeft alle elementen met die tag die ergens onder de parent hangen.
        # We gebruiken hier echter alleen die elementen die rechtstreeks onder de parent hangen.
        # Immers als we op zoek zijn naar de identificatie van een verblijfsobject dan willen we niet de
        # identificaties van gerelateerde objecten van dat verblijfsobject hebben.
        # Daarom controleren we dat de tag van de parent van de gevonden node, gelijk is aan de tag van de parent
        if node.parentNode.tagName == parent.tagName:
            if len(tags) == 1:
                # Leaf : 1 enkele node
                data.append(getText(node.childNodes))

            elif len(tags) > 1:
                # Meerdere nodes: recurse met remainder
                data.extend(getValues(node, tags[1]))
    return data

# Geef de waarde van het eerste element met de gegeven tag binnen de XML (parent). Als er geen eerste
# element gevonden wordt, is het resultaat een lege string.
def getValue(parent, tag):
    values = getValues(parent, tag)
    if len(values) > 0:
        return values[0]
    else:
        return ""

# Geef de eerste node met de tag name of return None
def getNodeByTagName(node, tag):
    resultNode = None
    try:
         resultNode = node.getElementsByTagName(tag)[0]
    except:
        resultNode = None

    return resultNode



#--------------------------------------------------------------------------------------------------------
# Class         BAGattribuut
# Omschrijving  Bevat binnen een BAGobject 1 attribuut met zijn waarde
# Bevat         - tag
#               - naam
#               - waarde
#--------------------------------------------------------------------------------------------------------
class BAGattribuut:
    # Constructor
    def __init__(self, lengte, naam, tag):
        self._lengte = lengte
        self._naam = naam
        self._tag = tag
        self._waarde = ""

    # Attribuut lengte
    def lengte(self):
        return self._lengte

    # Attribuut naam
    def naam(self):
        return self._naam

    # Attribuut tag
    def tag(self):
        return self._tag

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return "VARCHAR(%d)" % self._lengte

    # Attribuut waarde. Deze method kan worden overloaded
    def waarde(self):
        return self._waarde

    # Attribuut waarde voor SQL. Deze method kan worden overloaded
    def waardeSQL(self):
        return self.waarde()

    # Attribuut waarde voor SQL template. Deze method kan worden overloaded
    def waardeSQLTpl(self):
        return '%s'

    # Wijzig de waarde.
    def setWaarde(self, waarde):
        self._waarde = waarde

    # Geef aan dat het attribuut enkelvoudig is (maar 1 waarde heeft). Deze method kan worden overloaded.
    def enkelvoudig(self):
        return True

    # Geef aan dat het attribuut wel/niet geometrie is.
    def isGeometrie(self):
        return False

    # Initialiseer database
    def sqlinit(self):
        return ''

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValue(xml, self._tag)
        # Door een bug in BAG Extract bevat de einddatum een fictieve waarde 31-12-2299 in het geval dat
        # deze leeg hoort te zijn. Om dit te omzeilen, controleren we hier de waarde en maken deze zo nodig
        # zelf leeg.
        if self._naam == "einddatum" and self._waarde == "2299123100000000":
            self._waarde = None

    # Print informatie over het attribuut op het scherm
    def schrijf(self):
        print "- %-27s: %s" % (self._naam, self._waarde)

#--------------------------------------------------------------------------------------------------------
# Class         BAGenumAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een of meerdere waarden binnen een restrictie
#--------------------------------------------------------------------------------------------------------
class BAGenumAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, lijst, naam, tag):
        self._lijst = lijst
#        self._lengte = len(max(lijst, key=len))
        self._lengte = len(lijst)
        self._naam = naam
        self._tag = tag
        self._waarde = ""

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return self._naam

    # Initialiseer database
    def sqlinit(self):
        return "CREATE TYPE %s AS ENUM ('%s')" % (self._naam, "', '".join(self._lijst))


class BAGnumeriekAttribuut(BAGattribuut):
    """
     Class         BAGnumeriekAttribuut
     Afgeleid van  BAGattribuut
     Omschrijving  Bevat een numerieke waarde
    """

    # Attribuut waarde voor SQL. Deze method kan worden overloaded
    def waardeSQL(self):
        if self._waarde != '':
            return self._waarde
        else:
            return None

    def sqltype(self):
        """
         Attribuut sqltype. Deze method kan worden overloaded
        """
        return "NUMERIC(%d)" % (self._lengte)


#--------------------------------------------------------------------------------------------------------
# Class BAGintegerAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een numerieke waarde
#--------------------------------------------------------------------------------------------------------
class BAGintegerAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, naam, tag):
        self._naam = naam
        self._tag = tag
        self._waarde = None

    def waardeSQL(self):
        if self._waarde != '':
            return self._waarde
        else:
            return None

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return "INTEGER"


#--------------------------------------------------------------------------------------------------------
# Class BAGdatumAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een waarheid attribuut
#--------------------------------------------------------------------------------------------------------
class BAGbooleanAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, naam, tag):
        self._naam = naam
        self._tag = tag
        self._waarde = None

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return "BOOLEAN"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValue(xml, self._tag)
        if self._waarde == 'N':
            self._waarde = 'FALSE'
        elif self._waarde == 'J':
            self._waarde = 'TRUE'
        elif self._waarde == '':
            self._waarde = None
        else:
            print 'Onverwacht: %s'%(self._waarde)


#--------------------------------------------------------------------------------------------------------
# Class BAGdatetimeAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een waarheid attribuut
#--------------------------------------------------------------------------------------------------------
class BAGdatetimeAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, naam, tag):
        self._naam = naam
        self._tag = tag
        self._waarde = None

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return "TIMESTAMP WITHOUT TIME ZONE"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValue(xml, self._tag)
        if self._waarde != '':
            jaar = self._waarde[0:4]
            maand = self._waarde[4:6]
            dag = self._waarde[6:8]
            uur = self._waarde[8:10]
            minuut = self._waarde[10:12]
            seconden = self._waarde[12:14]
            msec = self._waarde[14:16]

            # 1999-01-08 04:05:06
            # http://www.postgresql.org/docs/8.3/static/datatype-datetime.html
            if jaar != '2299':
                self._waarde = '%s%s%s %s%s%s'%(jaar, maand, dag, uur, minuut, seconden)
            else:
                self._waarde = None
        else:
            self._waarde = None



#--------------------------------------------------------------------------------------------------------
# Class BAGdateAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een datum (jaar) attribuut
#--------------------------------------------------------------------------------------------------------
class BAGdateAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, naam, tag):
        self._naam = naam
        self._tag = tag
        self._waarde = None

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return "DATE"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValue(xml, self._tag)
        if self._waarde == '':
            jaar = self._waarde[0:4]

            if jaar == '2299':
                self._waarde = None
        else:
            self._waarde = None


#--------------------------------------------------------------------------------------------------------
# Class         BAGgeoAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een geometrie attribuut
#--------------------------------------------------------------------------------------------------------
class BAGgeoAttribuut(BAGattribuut):
    def __init__(self, dimensie, naam, tag):
        self._dimensie = dimensie
        BAGattribuut.__init__(self, -1, naam, tag)

    # Attribuut dimensie
    def dimensie(self):
        return self._dimensie

    # Geef aan dat het attribuut wel/niet geometrie is.

    def isGeometrie(self):
        return True

    # Attribuut waarde. Deze method kan worden overloaded
    def waardeSQL(self):
        if self._waarde:
            return 'SRID=28992;' + self._waarde
        else:
            return None

        # Attribuut waarde. Deze method kan worden overloaded

    def waardeSQLTpl(self):
        if self._waarde:
            return 'GeomFromEWKT(%s)'
        else:
            return '%s'

    # Attribuut soort
    def soort(self):
        return ""

#--------------------------------------------------------------------------------------------------------
# Class         BAGpoint
# Afgeleid van  BAGgeoAttribuut
# Omschrijving  Bevat een Puntgeometrie attribuut (geometrie van een verblijfsobject)
#--------------------------------------------------------------------------------------------------------
class BAGpoint(BAGgeoAttribuut):
    # Attribuut soort
    def soort(self):
        return "POINT"

    def waardeSQL(self):
        if self._waarde and not self.polygonAttr:
            return 'SRID=28992;' + self._waarde
        elif self.polygonAttr:
            return self.polygonAttr.waardeSQL()

    def waardeSQLTpl(self):
        if not self.polygonAttr:
            return 'GeomFromEWKT(%s)'
        else:
            return "ST_Force_3D(ST_Centroid(GeomFromEWKT(%s)))"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self.polygonAttr = None
        point = None
        try:
            pos = ""
            teller = 0
            geometrie = getNodeByTagName(xml, self._tag)
            point = getNodeByTagName(geometrie, "gml:Point")
            if point:
                for na in point.getElementsByTagName("gml:pos"):
                    teller += 1
                    pos = pos + na.firstChild.nodeValue + ","

                if teller > 0:
                    pos = pos[:-1]
                self._waarde = "POINT(" + pos + ")"
            else:
                # Polygoon (wordt later omgezet naar punt)
                polygon = getNodeByTagName(geometrie, "gml:Polygon")
                if polygon:
                    self.polygonAttr = BAGpolygoon(3, self._naam, self._tag)
                    self.polygonAttr.leesUitXML(xml)

        except:
            Log.log.error("Error constructing geom POINT from " + str(point))
            self._waarde = "POINT(0 0 0)"

#--------------------------------------------------------------------------------------------------------
# Class         BAGpolygoon
# Afgeleid van  BAGgeoAttribuut
# Omschrijving  Bevat een Polygoongeometrie attribuut (pand, ligplaats, standplaats of woonplaats)
#               De dimensie (2D of 3D) is variabel.
#--------------------------------------------------------------------------------------------------------
class BAGpolygoon(BAGgeoAttribuut):

    # Attribuut soort
    def soort(self):
        return "POLYGON"

    # Converteer een posList uit de XML-string naar een WKT-string. De XML-string bevat een opsomming
    # van coordinaten waarbij alle coordinaten en punten zijn gescheiden door een spatie. In de WKT-string
    # worden de punten gescheiden door een komma en de coordinaten van een punt gescheiden door een spatie.
    def _leesXMLposList(self, xml):
        wktPosList = ""
        puntTeller = 0
        for xmlPosList in xml.getElementsByTagName("gml:posList"):
            for coordinaat in xmlPosList.firstChild.nodeValue.split(" "):
                if not coordinaat or not coordinaat.strip():
                    continue
                puntTeller += 1
                if puntTeller > self.dimensie():
                    wktPosList += ","
                    puntTeller = 1
                wktPosList += " " + coordinaat
        return wktPosList

    # Converteer een polygoon uit de XML-string naar een WKT-string.
    # Een polygoon bestaat uit een buitenring en 0 of meerdere binnenringen (gaten).
    def _leesXMLpolygoon(self, xmlPolygoon):
        xmlExterior = xmlPolygoon.getElementsByTagName("gml:exterior")[0]
        wktExterior = "(" + self._leesXMLposList(xmlExterior) + ")"

        wktInteriors = ""
        for xmlInterior in xmlPolygoon.getElementsByTagName("gml:interior"):
            wktInteriors += ",(" + self._leesXMLposList(xmlInterior) + ")"

        return "(" + wktExterior + wktInteriors + ")"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        xmlGeometrie = xml.getElementsByTagName(self._tag)[0]
        xmlPolygoon = getNodeByTagName(xmlGeometrie, "gml:Polygon")
        if xmlPolygoon:
            self._waarde = "POLYGON" + self._leesXMLpolygoon(xmlPolygoon)

#--------------------------------------------------------------------------------------------------------
# Class         BAGmultiPolygoon
# Afgeleid van  BAGpolygoon
# Omschrijving  Bevat een MultiPolygoongeometrie attribuut (woonplaats)
#--------------------------------------------------------------------------------------------------------
class BAGmultiPolygoon(BAGpolygoon):
    # Attribuut soort
    def soort(self):
        return "MULTIPOLYGON"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        wktGeometrie = ""
        xmlGeometrie = xml.getElementsByTagName(self._tag)[0]
        for xmlPolygoon in xmlGeometrie.getElementsByTagName("gml:Polygon"):
            if wktGeometrie <> "":
                wktGeometrie += ","
            wktGeometrie += self._leesXMLpolygoon(xmlPolygoon)
        self._waarde = "MULTIPOLYGON(" + wktGeometrie + ")"

#--------------------------------------------------------------------------------------------------------
# Class         BAGpolygoonOfpunt
# Afgeleid van  BAGgeoAttribuut
# Omschrijving  Bevat of een Polygoongeometrie of een punt geometrie
#               De dimensie (2D of 3D) is variabel.
#--------------------------------------------------------------------------------------------------------
class BAGpolygoonOfpunt(BAGgeoAttribuut):
    # Constructor
    def __init__(self, parent, naam, tag):
        self._parent = parent
        BAGgeoAttribuut.__init__(self, 0, naam, tag)

           # Attribuut waarde. Deze method kan worden overloaded
    def waardeSQL(self):
        return  self._geoattr.waardeSQL()

    # Attribuut waarde. Deze method kan worden overloaded
    def waardeSQLTpl(self):
        if self._geoattr.soort() == "POLYGON" and self._naam == "geopunt":
            return 'ST_Centroid(GeomFromEWKT(%s))'

        return self._geoattr.waardeSQLTpl()

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        xmlGeometrie = getNodeByTagName(xml, self._tag)
        geometrie = getNodeByTagName(xmlGeometrie, "gml:Point")
        if geometrie:
            self._geoattr = BAGpoint(3, self._naam, self._tag)
        else:
            geometrie = getNodeByTagName(xml, "gml:Polygon")
            if geometrie:
                self._geoattr = BAGpolygoon(3, self._naam, self._tag)

        if not self._geoattr:
            Log.log.error("Geen punt of vlak geometrie gevonden")
            return

        self._geoattr.leesUitXML(xml)



#--------------------------------------------------------------------------------------------------------
# Class         BAGrelatieAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een attribuut dat meer dan 1 waarde kan hebben.
#--------------------------------------------------------------------------------------------------------
class BAGrelatieAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, parent, relatieNaam, lengte, naam, tag):
        BAGattribuut.__init__(self, lengte, naam, tag)
        # BAGObject waar dit multivalued attribuut bijhoort
        self._parent = parent
        self._relatieNaam = relatieNaam
        self._waarde = []

    # Attribuut relatienaam
    def relatieNaam(self):
        return self._relatieNaam

    # Attribuut waarde. Deze waarde overload de waarde in de basisclass
    def waarde(self):
        return self._waarde

    # Wijzig de waarde.
    def setWaarde(self, waarde):
        self._waarde.append(waarde)

    # Geef aan dat het attribuut niet enkelvoudig is (meerdere waardes kan hebben).
    def enkelvoudig(self):
        return False

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValues(xml, self.tag())

    # VMaak insert SQL voor deze relatie
    def maakInsertSQL(self):
        self.sql = []
        self.inhoud = []
        for waarde in self._waarde:
            sql = "INSERT INTO " + self.relatieNaam() + " "
            sql += "(identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatum,"
            sql += self.naam() + ") VALUES (%s, %s, %s, %s, %s)"
            self.inhoud.append((self._parent.attribuut('identificatie').waarde(),
                                self._parent.attribuut('aanduidingRecordInactief').waarde(),
                                self._parent.attribuut('aanduidingRecordCorrectie').waarde(),
                                self._parent.attribuut('begindatum').waarde(),
                                waarde))

            self.sql.append(sql)

    # Print informatie over het attribuut op het scherm
    def schrijf(self):
        first = True
        for waarde in self._waarde:
            if first:
                print "- %-27s: %s" % (self.naam(), waarde)
                first = False
            else:
                print "- %-27s  %s" % ("", waarde)
