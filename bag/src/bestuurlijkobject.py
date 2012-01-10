__author__ = "Just van den Broecke"
__date__ = "Dec 25, 2011 3:46:27 PM$"

"""
 Naam:         BestuurlijkObject.py
 Omschrijving: Classes voor Bestuurlijke objecten

 De BAG bevat geen bestuurlijke objecten, zoals gemeenten en provincies.
 Daarom verrijken we de BAG met additionele bestuurlijke data. Deze is te verkrijegn via Kadaster
 en CBS.


 De BestuurlijkObject classes zijn afgeleid van de basisclass BestuurlijkObject.

 Auteur:       Just van den Broecke (Milo van der Linden origineel)

 Versie:       1.0
               - basis versie
 Datum:        25 december 2011


 OpenGeoGroep.nl
"""

import datetime
import time

def getDate(node):
    """
    Maak een datum object van een XML datum/tijd
    BAG Datum/tijd is in het formaat JJJJMMDDUUMMSSmm
    Deze functie genereert een datum van de BAG:DatumTijd
    """
    if type(node) == str:
        # Momenteel alleen voor de gemeente_woonplaats csv
        _text = node
        if len(_text) > 0:
            if len(_text) == 10:
                return datetime.datetime(*time.strptime(_text, "%d-%m-%Y")[0:6])
            elif len(_text) == 8:
                return datetime.datetime(*time.strptime(_text, "%Y%m%d")[0:6])
        else:
            return None


def getNumber(node):
    """
    Maak een nummer of None uit node
    """
    if type(node) == str:
        # Momenteel alleen voor de gemeente_woonplaats csv
        if len(node) != 0:
            return node
    return None

class BestuurlijkObject:
    def __init__(self):
        self.id = None


class GemeenteWoonplaats(BestuurlijkObject):
    """
    Klasse Gemeente
    """

    def __init__(self,record):
        # TODO: De csv is niet volledig gevuld, controleer of een record wel het minimaal aantal objecten bevat.
        # Woonplaats;Woonplaats code;Ingangsdatum WPL;Einddatum WPL;Gemeente;Gemeente code;
        # Ingangsdatum nieuwe gemeente;Aansluitdatum;Bijzonderheden;Nieuwe code Gemeente;
        # Gemeente beeindigd per;Behandeld;        Laatste WPL code:;3513

        # Dirty! Dit kan vast makkelijker, mijn python tekortkoming blijkt hier ;-)
        emptylist = [None,None,None,None,None,None,None,None,None,None,None,None]
        record.extend(emptylist)
        # Stel de lengte van het record object in op 12
        if record[0]:
            #print record
            self.tag = "gem_LVC:GemeenteWoonplaats"
            self.naam = "gemeente_woonplaats"
            self.type = 'G_W'
            self.woonplaatsnaam = record[0]
            self.woonplaatscode = getNumber(record[1])
            self.begindatum_woonplaats = getDate(record[2])
            self.einddatum_woonplaats = getDate(record[3])
            self.gemeentenaam = record[4]
            self.gemeentecode = getNumber(record[5])
            self.begindatum_gemeente = getDate(record[6])
            self.aansluitdatum_gemeente = getDate(record[7])
            self.bijzonderheden = record[8]
            self.gemeentecode_nieuw = getNumber(record[9])
            self.einddatum_gemeente = getDate(record[10])
            self.behandeld = record[11]

    def __repr__(self):
       return "<GemeenteWoonplaats('%s','%s', '%s')>" % (self.naam, self.gemeentecode, self.woonplaatscode)

    def insert(self):
        self.sql = """INSERT INTO gemeente_woonplaats (
            woonplaatsnaam,
            woonplaatscode,
            begindatum_woonplaats,
            einddatum_woonplaats,
            gemeentenaam,
            gemeentecode,
            begindatum_gemeente,
            aansluitdatum_gemeente,
            bijzonderheden,
            gemeentecode_nieuw,
            einddatum_gemeente,
            behandeld)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"""
        self.valuelist = (self.woonplaatsnaam, self.woonplaatscode, self.begindatum_woonplaats,
            self.einddatum_woonplaats,self.gemeentenaam, self.gemeentecode, self.begindatum_gemeente,
            self.aansluitdatum_gemeente, self.bijzonderheden, self.gemeentecode_nieuw, self.einddatum_gemeente,
            self.behandeld)

class GemeenteProvincie(BestuurlijkObject):
    """
    Verrijking: GemeenteProvincie
    """

    def __init__(self,record):
        # CSV schema:
        # Gemcode;Gemcodel;provcode;provcodel
        # 0003;Appingedam;20;Groningen
        #
        # alle records zijn gevuld, geen lege velden
        # In 2012: 415 gemeenten
        #
        # DB schema:
        # gemeentecode character varying(4),
	    # gemeentenaam character varying(80),
	    # provinciecode character varying(4),
	    # provincienaam character varying(80),
        #
        self.naam = 'gemeente_provincie'
        self.gemeentecode = getNumber(record[0])
        self.gemeentenaam = record[1]
        self.provinciecode = getNumber(record[2])
        self.provincienaam = record[3]

    def __repr__(self):
       return "<GemeenteProvincie('%s','%s', '%s')>" % (self.naam, self.gemeentenaam, self.provincienaam)

    def insert(self):
        self.sql = """INSERT INTO gemeente_provincie (
            gemeentecode,
            gemeentenaam,
            provinciecode,
            provincienaam)
            VALUES (%s, %s, %s, %s)"""
        self.valuelist = (self.gemeentecode, self.gemeentenaam, self.provinciecode,self.provincienaam)

# Creeer een BestuurlijkObject uit een CSV header+record
def BestuurlijkObjectFabriek(cols, record):
    bestuurlijkOBject = None
    if cols[0] == 'Woonplaats':
        bestuurlijkOBject = GemeenteWoonplaats(record)
    elif cols[1] == 'Gemcodel':
        bestuurlijkOBject = GemeenteProvincie(record)

    return bestuurlijkOBject
