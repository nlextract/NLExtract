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
from etree import etree, tagVolledigeNS, stripschema
import sys
from osgeo import ogr #apt-get install python-gdal

# Geef de waarde van een textnode in XML
def getText(nodelist):
    rc = ""
    for node in nodelist:
        rc = rc + node.text
    return rc

# TODO: werking van deze functie controleren en vergelijken met origineel

# Geef de waardes van alle elementen met de gegeven tag binnen de XML (parent).
def getValues(parent, tag):
    return [node.text for node in parent.iterfind('./'+tagVolledigeNS(tag, parent.nsmap))]

# Geef de waarde van het eerste element met de gegeven tag binnen de XML (parent). Als er geen eerste
# element gevonden wordt, is het resultaat een lege string.
def getValue(parent, tag):
    values = getValues(parent, tag)
    if len(values) > 0:
        return values[0]
    else:
        # TODO: moet eigenlijk None zijn...
        # ook dan alle if != '' in BAGattribuut classes nalopen..
        return ""

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
        self._waarde = None
        self._parentObj = None

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
    
    # Initialiseer database voor dit type
    def sqlinit(self):
        return ''

    # Attribuut waarde. Deze method kan worden overloaded
    def waarde(self):
        return self._waarde

    # Attribuut waarde voor SQL. Deze method kan worden overloaded
    def waardeSQL(self):
        if self._waarde == '':
            # Voor string kolommen (default) willen we NULL, geen lege string
            return None
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
        # Door een bug in BAG Extract bevat de einddatumTijdvakGeldigheid een fictieve waarde 31-12-2299 in het geval dat
        # deze leeg hoort te zijn. Om dit te omzeilen, controleren we hier de waarde en maken deze zo nodig
        # zelf leeg.
        if self._naam == "einddatumTijdvakGeldigheid" and self._waarde == "2299123100000000":
            self._waarde = None

    # Print informatie over het attribuut op het scherm
    def schrijf(self):
        print "- %-27s: %s" % (self._naam, self._waarde)

#--------------------------------------------------------------------------------------------------------
# Class BAGstringAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een string waarde
#--------------------------------------------------------------------------------------------------------
class BAGstringAttribuut(BAGattribuut):

    # Attribuut waarde. Deze method kan worden overloaded
    def waarde(self):
        if self._waarde == '' or self._waarde is None:
             # Voor string kolommen (default) willen we NULL, geen lege string
             return None

        return self._waarde.replace("\\", "/")

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
        return "DROP TYPE IF EXISTS %s;\nCREATE TYPE %s AS ENUM ('%s');\n" % (self._naam, self._naam, "', '".join(self._lijst))


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
            Log.log.error("Onverwachte boolean waarde: '%s'" % (self._waarde))


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
            # msec = self._waarde[14:16]

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
        self._geometrie = None
        BAGattribuut.__init__(self, -1, naam, tag)

    # Attribuut dimensie
    def dimensie(self):
        return self._dimensie

    # Geef aan dat het attribuut wel/niet geometrie is.
    def isGeometrie(self):
        return True

    # Geometrie validatie
    def isValide(self):
        if self._geometrie:
            return self._geometrie.IsValid()
        else:
            return True

    # Attribuut waarde. Deze method kan worden overloaded
    def waardeSQL(self):
        if self._geometrie is not None:
            # Forceer gespecificeerde coordinaat dimensie
            self._geometrie.SetCoordinateDimension(self._dimensie)
            self._waarde = self._geometrie.ExportToWkt()

        if self._waarde:
            return 'SRID=28992;' + self._waarde
        else:
            return None

        # Attribuut waarde. Deze method kan worden overloaded

    def waardeSQLTpl(self):
        if self._waarde:
            # Voor later: als we geometrie willen valideren, loggen en tegelijk repareren...
            # return 'validateGeometry(\'' + self._parentObj.naam() + '\', ' + str(self._parentObj.identificatie()) +', GeomFromEWKT(%s))'
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

    def isValide(self):
        return True

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self.polygonAttr = None
        point = None
        try:
            xmlGeometrie = xml.find('./'+tagVolledigeNS(self._tag, xml.nsmap))

            if xmlGeometrie is not None:
                gmlNode = xmlGeometrie.find('./'+tagVolledigeNS("gml:Point", xml.nsmap))
                if gmlNode is not None:
                    gmlStr = etree.tostring(gmlNode)
                    self._geometrie = ogr.CreateGeometryFromGML(str(gmlStr))
                else:
                    # Forceer punt uit Polygoon
                    gmlNode = xmlGeometrie.find('./'+tagVolledigeNS("gml:Polygon", xml.nsmap))
                    if gmlNode is not None:
                        gmlStr = etree.tostring(gmlNode)
                        self._geometrie = ogr.CreateGeometryFromGML(str(gmlStr))
                        self._geometrie = self._geometrie.Centroid()
        except:
            Log.log.error("ik kan hier echt geen POINT van maken: %s (en zet dit op 0,0,0)" % str(point.text))
            # self._waarde = "POINT(0 0 0)"

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

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        xmlGeometrie = xml.find('./'+tagVolledigeNS(self._tag, xml.nsmap))
        if xmlGeometrie is not None:
            gmlNode = xmlGeometrie.find('./'+tagVolledigeNS("gml:Polygon", xmlGeometrie.nsmap))
            if gmlNode is not None:
                gmlStr = etree.tostring(gmlNode)
                self._geometrie = ogr.CreateGeometryFromGML(str(gmlStr))

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
        gmlNode = None
        # Attribuut vinden, bijv. bag_LVC:woonplaatsGeometrie
        xmlGeometrie = xml.find('./'+tagVolledigeNS(self._tag, xml.nsmap))
        if xmlGeometrie is not None:
            # Probeer eerst een MultiSurface te vinden
            gmlNode = xmlGeometrie.find('./'+tagVolledigeNS("gml:MultiSurfcae", xml.nsmap))
            if gmlNode is None:
                # Geen MultiSurface: probeer een Polygon te vinden
                gmlNode = xmlGeometrie.find('./'+tagVolledigeNS("gml:Polygon", xml.nsmap))
                if gmlNode is not None:
                    gmlStr = etree.tostring(gmlNode)
                    polygon = ogr.CreateGeometryFromGML(str(gmlStr))
                    self._geometrie = ogr.Geometry(ogr.wkbMultiPolygon)
                    self._geometrie.AddGeometryDirectly(polygon)

            else:
                # MultiSurface
                gmlStr = etree.tostring(gmlNode)
                self._geometrie = ogr.CreateGeometryFromGML(str(gmlStr))

#--------------------------------------------------------------------------------------------------------
# Class         BAGgeometrieValidatie
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat de validatie waarde (true,false) van een geometrie attribuut
#--------------------------------------------------------------------------------------------------------
class BAGgeometrieValidatie(BAGattribuut):
    def __init__(self, naam, naam_geo_attr):
        BAGattribuut.__init__(self, -1, naam, None)

        # Kolom-naam van te valideren geo-attribuut
        self._naam_geo_attr = naam_geo_attr

    def sqltype(self):
        return "BOOLEAN"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = None

    # Bepaal validatie-waarde
    def waardeSQL(self):
        geo_attr = self._parentObj.attribuut(self._naam_geo_attr)
        valid = 'TRUE'
        if geo_attr:
            valid = str(geo_attr.isValide())
        return valid

    # Attribuut soort
    def soort(self):
        return ""


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
        # Waarde is serie, vanwege meerdere voorkomens van attributen in hoofdobjecten
        self._waarde.append(waarde)

    # Geef aan dat het attribuut niet enkelvoudig is (meerdere waardes kan hebben).
    def enkelvoudig(self):
        return False

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        self._waarde = getValues(xml, self.tag())

    # Maak insert SQL voor deze relatie
    def maakInsertSQL(self, append=None):
        # Default is nieuw (append=None) maar kan ook appenden aan bestaande SQL
        if not append:
            self.sql = []
            self.inhoud = []

        for waarde in self._waarde:
            sql = "INSERT INTO " + self.relatieNaam() + " "
            sql += "(identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid,"
            sql += self.naam() + ") VALUES (%s, %s, %s, %s, %s)"
            self.inhoud.append((self._parent.attribuut('identificatie').waardeSQL(),
                                self._parent.attribuut('aanduidingRecordInactief').waardeSQL(),
                                self._parent.attribuut('aanduidingRecordCorrectie').waardeSQL(),
                                self._parent.attribuut('begindatumTijdvakGeldigheid').waardeSQL(),
                                waarde))

            self.sql.append(sql)

    # Maak insert SQL voor deze relatie
    def maakCopySQL(self):
        self.velden = ("identificatie","aanduidingrecordinactief","aanduidingrecordcorrectie","begindatumtijdvakgeldigheid", self.naam())
        self.sql = ""
        for waarde in self._waarde:
            self.sql += self._parent.attribuut('identificatie').waardeSQL() + "~"
            self.sql += self._parent.attribuut('aanduidingRecordInactief').waardeSQL() + "~"
            self.sql += self._parent.attribuut('aanduidingRecordCorrectie').waardeSQL() + "~"
            self.sql += self._parent.attribuut('begindatumTijdvakGeldigheid').waardeSQL() + "~"

            if not waarde:
                waarde = '\\\N'
            self.sql += waarde + "\n"

    # Maak update SQL voor deze relatie
    def maakUpdateSQL(self):
        self.sql = []
        self.inhoud = []

        # Voor relaties hebben we geen unieke keys en er kunnen relaties bijgekomen of weg zijn
        # dus we deleten eerst alle bestaande relaties en voeren de nieuwe
        # in via insert. Helaas maar waar.
        sql = "DELETE FROM " + self.relatieNaam() + " WHERE  "
        sql += "identificatie = %s AND aanduidingrecordinactief = %s AND aanduidingrecordcorrectie = %s AND begindatumtijdvakgeldigheid "


        # Tricky: indien beginDatum (komt in principe niet voor)  leeg moet in WHERE "is NULL" staan
        # want "= NULL" geeft geen resultaat
        # http://stackoverflow.com/questions/4476172/postgresql-select-where-timestamp-is-empty
        beginDatum = self._parent.attribuut('begindatumTijdvakGeldigheid').waardeSQL()
        if beginDatum:
            sql += "= %s"
        else:
            sql += "is %s"

        self.sql.append(sql)
        self.inhoud.append((self._parent.attribuut('identificatie').waardeSQL(),
                             self._parent.attribuut('aanduidingRecordInactief').waardeSQL(),
                             self._parent.attribuut('aanduidingRecordCorrectie').waardeSQL(),
                             beginDatum))

        # Gebruik bestaande INSERT SQL generatie voor de nieuwe relaties en append aan DELETE SQL
        self.maakInsertSQL(True)

    # Print informatie over het attribuut op het scherm
    def schrijf(self):
        first = True
        for waarde in self._waarde:
            if first:
                print "- %-27s: %s" % (self.naam(), waarde)
                first = False
            else:
                print "- %-27s  %s" % ("", waarde)

#--------------------------------------------------------------------------------------------------------
# Class         BAGenumRelatieAttribuut
# Afgeleid van  BAGrelatieAttribuut
# Omschrijving  Bevat een relatie attribuut van type enum.
#--------------------------------------------------------------------------------------------------------
class BAGenumRelatieAttribuut(BAGrelatieAttribuut):
    # Constructor
    def __init__(self, parent, relatieNaam, naam, tag, lijst):
        BAGrelatieAttribuut.__init__(self, parent, relatieNaam, len(lijst), naam, tag)
        self._lijst = lijst
#        self._lengte = len(max(lijst, key=len))
        self._lengte = len(lijst)

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return self._naam

    # Initialiseer database
    def sqlinit(self):
        return "DROP TYPE IF EXISTS %s;\nCREATE TYPE %s AS ENUM ('%s');\n" % (self._naam, self._naam, "', '".join(self._lijst))

