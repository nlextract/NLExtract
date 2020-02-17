__author__ = "Just van den Broecke"
__date__ = "Jan 9, 2012 3:46:27 PM$"

"""
 Naam:         bagattribuut.py
 Omschrijving: Attributen voor BAG-objecten

 Auteur:       Just van den Broecke (Matthijs van der Deijl libbagextract.py origineel)

 Datum:        9 mei 2012

 OpenGeoGroep.nl
"""
from log import Log
from etree import etree, tagVolledigeNS

import sys

try:
    from osgeo import ogr  # apt-get install python3-gdal
except ImportError:
    print("FATAAL: GDAL Python bindings zijn niet beschikbaar, installeer bijv met 'apt-get install python3-gdal'")
    sys.exit(-1)


# Geef de waarde van een textnode in XML
def getText(nodelist):
    rc = ""
    for node in nodelist:
        rc = rc + node.text
    return rc

# TODO: werking van deze functie controleren en vergelijken met origineel


# Geef de waardes van alle elementen met de gegeven tag binnen de XML (parent).
def getValues(parent, tag):
    return [node.text for node in parent.iterfind('./' + tagVolledigeNS(tag, parent.nsmap))]


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


# --------------------------------------------------------------------------------------------------------
# Class         BAGattribuut
# Omschrijving  Bevat binnen een BAGobject 1 attribuut met zijn waarde
# Bevat         - tag
#               - naam
#               - waarde
# --------------------------------------------------------------------------------------------------------
class BAGattribuut:
    # Constructor
    def __init__(self, lengte, naam, tag):
        self._lengte = lengte
        self._naam = naam
        self._tag = tag
        self._waarde = None
        self._parentObj = None
        # default attr is singlevalued
        self._relatieNaam = None

    # Attribuut lengte
    def lengte(self):
        return self._lengte

    # Attribuut naam
    def naam(self):
        return self._naam

    # Attribuut enkel/of meervoudig (via relatie)
    def enkelvoudig(self):
        return self._relatieNaam is None

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
        print("- %-27s: %s" % (self._naam, self._waarde))


# --------------------------------------------------------------------------------------------------------
# Class BAGstringAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een string waarde
# --------------------------------------------------------------------------------------------------------
class BAGstringAttribuut(BAGattribuut):
    # Nodig om allerlei nare characters te verwijderen die bijv COPY
    # kunnen beinvloeden
    #    inputChars = "\\\n~"
    #    outputChars = "/ ."
    # from string import maketrans  # Required to call maketrans function.
    # translatieTabel = maketrans(inputChars, outputChars)
    # Geeft problemen met niet-ASCII range unicode chars!!
    # dus voorlopig even handmatig

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        waarde = getValue(xml, self._tag)
        if waarde == '':
            # Voor string kolommen (default) willen we NULL, geen lege string
            waarde = None
        if waarde is not None:
            # print("voor:" + self._waarde)
            waarde = waarde.strip()
            # Kan voorkomen dat strings langer zijn in BAG
            # ondanks restrictie vanuit BAG XSD model
            waarde = waarde[:self._lengte]

            #            try:
            # self._waarde =  self._waarde.translate(BAGstringAttribuut.translatieTabel)

            # Zie boven: voorlopig even de \ \n en ~ handmatig vervangen. Komt af en toe   voor.
            # Niet fraai maar werkt.
            for char in waarde:
                if char == '\\':
                    waarde = waarde.replace('\\', '/')
                else:
                    if char == '\n':
                        waarde = waarde.replace('\n', ' ')
                    else:
                        if char == '~':
                            waarde = waarde.replace('~', '.')

        # Toekennen aan object
        self._waarde = waarde


#
#            except:
#                Log.log.warn("Fout in translate: waarde=%s tag=%s id=%s type=%s" %
#                    (self._waarde, self._naam, self._parentObj.objectType(), self._parentObj.identificatie()) )

# --------------------------------------------------------------------------------------------------------
# Class         BAGenumAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een of meerdere waarden binnen een restrictie
# --------------------------------------------------------------------------------------------------------
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
        return "DROP TYPE IF EXISTS %s;\nCREATE TYPE %s AS ENUM ('%s');\n" % (
            self._naam, self._naam, "', '".join(self._lijst))


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


# --------------------------------------------------------------------------------------------------------
# Class BAGintegerAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een numerieke waarde
# --------------------------------------------------------------------------------------------------------
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


# --------------------------------------------------------------------------------------------------------
# Class BAGdatumAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een waarheid attribuut
# --------------------------------------------------------------------------------------------------------
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


# --------------------------------------------------------------------------------------------------------
# Class BAGdatetimeAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een DatumTijd attribuut
#         <xs:simpleType name="DatumTijd">
#                <xs:annotation>
#                    <xs:documentation>formaat JJJJMMDDUUMMSSmm</xs:documentation>
#                </xs:annotation>
#                <xs:restriction base="xs:token">
#                    <xs:minLength value="8"/>
#                    <xs:maxLength value="16"/>
#                    <xs:pattern value="[0-2][0-9][0-9][0-9][0-1][0-9][0-3][0-9][0-2][0-9][0-5][0-9][0-5][0-9][0-9][0-9]"/>
#                </xs:restriction>
#            </xs:simpleType>
#
# --------------------------------------------------------------------------------------------------------
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
            length = len(self._waarde)
            jaar = self._waarde[0:4]
            maand = self._waarde[4:6]
            dag = self._waarde[6:8]

            uur = minuut = seconden = secfract = '00'
            if length > 8:
                uur = self._waarde[8:10]
                minuut = self._waarde[10:12]
                seconden = self._waarde[12:14]
                if length >= 16:
                    # 17.nov.2013: JvdB, deze werd voorheen nooit meegenomen
                    # Laatste twee zijn 100e-en van seconden, ISO8601 gebruikt fracties van seconden
                    # dus komt overeen (ISO 8601 en BAG gebruiken geen milliseconden!!)
                    # Zie ook: http://en.wikipedia.org/wiki/ISO_8601
                    secfract = self._waarde[14:16]
            # 1999-01-08 04:05:06.78 (ISO8601 notatie)
            # http://www.postgresql.org/docs/8.3/static/datatype-datetime.html
            if jaar != '2299':
                # conversie naar ISO8601 notatie,
                self._waarde = '%s-%s-%s %s:%s:%s.%s' % (jaar, maand, dag, uur, minuut, seconden, secfract)
            else:
                self._waarde = None
        else:
            self._waarde = None


# --------------------------------------------------------------------------------------------------------
# Class BAGdateAttribuut
# Afgeleid van BAGattribuut
# Omschrijving Bevat een datum (jaar) attribuut
# --------------------------------------------------------------------------------------------------------
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
        if self._waarde != '':
            jaar = self._waarde[0:4]

            if jaar == '2299':
                self._waarde = None
        else:
            self._waarde = None


# --------------------------------------------------------------------------------------------------------
# Class         BAGgeoAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een geometrie attribuut
# --------------------------------------------------------------------------------------------------------
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

    #  Wijzig de waarde.
    def setWaarde(self, waarde):
        self._waarde = waarde
        if self._waarde is not None:
            self._geometrie = ogr.CreateGeometryFromWkt(self._waarde)

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


# --------------------------------------------------------------------------------------------------------
# Class         BAGpoint
# Afgeleid van  BAGgeoAttribuut
# Omschrijving  Bevat een Puntgeometrie attribuut (geometrie van een verblijfsobject)
# --------------------------------------------------------------------------------------------------------
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
            xmlGeometrie = xml.find('./' + tagVolledigeNS(self._tag, xml.nsmap))

            if xmlGeometrie is not None:
                gmlNode = xmlGeometrie.find('./' + tagVolledigeNS("gml:Point", xml.nsmap))
                if gmlNode is not None:
                    gmlStr = etree.tostring(gmlNode)
                    self._geometrie = ogr.CreateGeometryFromGML(gmlStr.decode())
                else:
                    # Forceer punt uit Polygoon
                    gmlNode = xmlGeometrie.find('./' + tagVolledigeNS("gml:Polygon", xml.nsmap))
                    if gmlNode is not None:
                        gmlStr = etree.tostring(gmlNode)
                        self._geometrie = ogr.CreateGeometryFromGML(gmlStr.decode())
                        self._geometrie = self._geometrie.Centroid()
        except Exception:
            Log.log.error("ik kan hier echt geen POINT van maken: %s (en zet dit op 0,0,0)" % str(point.text))
            # self._waarde = "POINT(0 0 0)"


# --------------------------------------------------------------------------------------------------------
# Class         BAGpolygoon
# Afgeleid van  BAGgeoAttribuut
# Omschrijving  Bevat een Polygoongeometrie attribuut (pand, ligplaats, standplaats of woonplaats)
#               De dimensie (2D of 3D) is variabel.
# --------------------------------------------------------------------------------------------------------
class BAGpolygoon(BAGgeoAttribuut):
    # Attribuut soort
    def soort(self):
        return "POLYGON"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        xmlGeometrie = xml.find('./' + tagVolledigeNS(self._tag, xml.nsmap))
        if xmlGeometrie is not None:
            gmlNode = xmlGeometrie.find('./' + tagVolledigeNS("gml:Polygon", xmlGeometrie.nsmap))
            if gmlNode is not None:
                gmlStr = etree.tostring(gmlNode)
                self._geometrie = ogr.CreateGeometryFromGML(gmlStr.decode())


# --------------------------------------------------------------------------------------------------------
# Class         BAGmultiPolygoon
# Afgeleid van  BAGpolygoon
# Omschrijving  Bevat een MultiPolygoongeometrie attribuut (woonplaats)
# --------------------------------------------------------------------------------------------------------
class BAGmultiPolygoon(BAGpolygoon):
    # Attribuut soort
    def soort(self):
        return "MULTIPOLYGON"

    # Initialisatie vanuit XML
    def leesUitXML(self, xml):
        gmlNode = None
        # Attribuut vinden, bijv. bag_LVC:woonplaatsGeometrie
        xmlGeometrie = xml.find('./' + tagVolledigeNS(self._tag, xml.nsmap))
        if xmlGeometrie is not None:
            # Probeer eerst een MultiSurface te vinden
            gmlNode = xmlGeometrie.find('./' + tagVolledigeNS("gml:MultiSurface", xml.nsmap))
            if gmlNode is None:
                # Geen MultiSurface: probeer een Polygon te vinden
                gmlNode = xmlGeometrie.find('./' + tagVolledigeNS("gml:Polygon", xml.nsmap))
                if gmlNode is not None:
                    gmlStr = etree.tostring(gmlNode)
                    polygon = ogr.CreateGeometryFromGML(gmlStr.decode())
                    self._geometrie = ogr.Geometry(ogr.wkbMultiPolygon)
                    self._geometrie.AddGeometryDirectly(polygon)

            else:
                # MultiSurface
                gmlStr = etree.tostring(gmlNode)
                self._geometrie = ogr.CreateGeometryFromGML(gmlStr.decode())
                if self._geometrie is None:
                    Log.log.warn("Null MultiSurface in BAGmultiPolygoon: tag=%s parent=%s" % (
                        self._tag, self._parentObj.identificatie()))

        if self._geometrie is None:
            Log.log.warn("Null geometrie in BAGmultiPolygoon: tag=%s identificatie=%s" % (
                self._tag, self._parentObj.identificatie()))


# --------------------------------------------------------------------------------------------------------
# Class         BAGgeometrieValidatie
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat de validatie waarde (true,false) van een geometrie attribuut
# --------------------------------------------------------------------------------------------------------
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


# --------------------------------------------------------------------------------------------------------
# Class         BAGrelatieAttribuut
# Afgeleid van  BAGattribuut
# Omschrijving  Bevat een attribuut dat meer dan 1 waarde kan hebben.
# --------------------------------------------------------------------------------------------------------
class BAGrelatieAttribuut(BAGattribuut):
    # Constructor
    def __init__(self, parent, relatieNaam, lengte, naam, tag, extraAttributes):
        BAGattribuut.__init__(self, lengte, naam, tag)
        # BAGObject waar dit multivalued attribuut bijhoort
        self._parent = parent
        self._relatieNaam = relatieNaam
        self._waarde = []
        # Extra te kopieren attributen van het parent-object
        self._extraAttributes = extraAttributes

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
            sql += "(identificatie,aanduidingrecordinactief,aanduidingrecordcorrectie,begindatumtijdvakgeldigheid,einddatumtijdvakgeldigheid,"
            sql += ",".join(self._extraAttributes) + ","
            # Fix issue #199: het aantal toe te voegen waarden moet worden uitgebreid met het aantal
            # waarden in self._extraAttributes.
            sql += self.naam() + ") VALUES (%s, %s, %s, %s, %s"
            sql += ", %s" * len(self._extraAttributes) + ", %s)"

            inhoud = [self._parent.attribuut('identificatie').waardeSQL(),
                      self._parent.attribuut('aanduidingRecordInactief').waardeSQL(),
                      self._parent.attribuut('aanduidingRecordCorrectie').waardeSQL(),
                      self._parent.attribuut('begindatumTijdvakGeldigheid').waardeSQL(),
                      self._parent.attribuut('einddatumTijdvakGeldigheid').waardeSQL()]
            for attr in self._extraAttributes:
                if self._parent.heeftAttribuut(attr):
                    inhoud.append(self._parent.attribuut(attr).waardeSQL())
                else:
                    inhoud.append('')
            inhoud.append(waarde)
            self.inhoud.append(tuple(inhoud))

            self.sql.append(sql)

    # Maak insert SQL voor deze relatie
    def maakCopySQL(self):
        velden = ["identificatie", "aanduidingrecordinactief", "aanduidingrecordcorrectie", "begindatumtijdvakgeldigheid",
                  "einddatumtijdvakgeldigheid"]
        velden += self._extraAttributes
        velden.append(self.naam())
        self.velden = tuple(velden)

        self.sql = ""
        for waarde in self._waarde:
            self.sql += self._parent.attribuut('identificatie').waardeSQL() + "~"
            self.sql += self._parent.attribuut('aanduidingRecordInactief').waardeSQL() + "~"
            self.sql += self._parent.attribuut('aanduidingRecordCorrectie').waardeSQL() + "~"
            self.sql += self._parent.attribuut('begindatumTijdvakGeldigheid').waardeSQL() + "~"

            # Einddatum kan leeg zijn : TODO vang dit op in waardeSQL()
            einddatumWaardeSQL = self._parent.attribuut('einddatumTijdvakGeldigheid').waardeSQL()
            if not einddatumWaardeSQL or einddatumWaardeSQL is '':
                einddatumWaardeSQL = r'\N'
            self.sql += einddatumWaardeSQL + "~"

            for attr in self._extraAttributes:
                # Ook de extra attributen kunnen leeg zijn
                if self._parent.heeftAttribuut(attr):
                    attrWaarde = self._parent.attribuut(attr).waardeSQL()
                else:
                    attrWaarde = ''

                if not attrWaarde or attrWaarde is '':
                    attrWaarde = r'\N'
                self.sql += attrWaarde + "~"

            if not waarde:
                waarde = r'\N'
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
                print("- %-27s: %s" % (self.naam(), waarde))
                first = False
            else:
                print("- %-27s  %s" % ("", waarde))


# --------------------------------------------------------------------------------------------------------
# Class         BAGenumRelatieAttribuut
# Afgeleid van  BAGrelatieAttribuut
# Omschrijving  Bevat een relatie attribuut van type enum.
# --------------------------------------------------------------------------------------------------------
class BAGenumRelatieAttribuut(BAGrelatieAttribuut):
    # Constructor
    def __init__(self, parent, relatieNaam, naam, tag, extraAttributes, lijst):
        BAGrelatieAttribuut.__init__(self, parent, relatieNaam, len(lijst), naam, tag, extraAttributes)
        self._lijst = lijst
        #        self._lengte = len(max(lijst, key=len))
        self._lengte = len(lijst)

    # Attribuut sqltype. Deze method kan worden overloaded
    def sqltype(self):
        return self._naam

    # Initialiseer database
    def sqlinit(self):
        return "DROP TYPE IF EXISTS %s;\nCREATE TYPE %s AS ENUM ('%s');\n" % (
            self._naam, self._naam, "', '".join(self._lijst))
