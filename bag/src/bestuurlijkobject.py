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

    def __init__(self, record):
        # TODO: De csv is niet volledig gevuld, controleer of een record wel het minimaal aantal objecten bevat.
        # Woonplaats;Woonplaats code;Ingangsdatum WPL;Einddatum WPL;Gemeente;Gemeente code;
        # Ingangsdatum nieuwe gemeente;Aansluitdatum;Bijzonderheden;Nieuwe code Gemeente;
        # Gemeente beeindigd per;Behandeld;        Laatste WPL code:;3513

        # Per 24 jan 2012 is de CSV header geworden:
        # Woonplaats;Woonplaats code;Ingangsdatum WPL;Einddatum WPL
        #     ;Gemeente;Gemeente code;Ingangsdatum nieuwe gemeente;Gemeente beeindigd per
        # (8 kolommen)
        # Dirty! Dit kan vast makkelijker, mijn python tekortkoming blijkt hier ;-)
        emptylist = [None, None, None, None, None, None, None, None]
        record.extend(emptylist)
        # Stel de lengte van het record object in op 12
        if record[0]:
            # print(record)
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
            self.einddatum_gemeente = getDate(record[7])
            # self.aansluitdatum_gemeente = getDate(record[7])
            # self.bijzonderheden = record[8]
            # self.gemeentecode_nieuw = getNumber(record[9])
            # self.behandeld = record[11]

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
            einddatum_gemeente)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"""
        self.valuelist = (self.woonplaatsnaam, self.woonplaatscode, self.begindatum_woonplaats,
                          self.einddatum_woonplaats, self.gemeentenaam, self.gemeentecode, self.begindatum_gemeente,
                          self.einddatum_gemeente)


# Creeer een BestuurlijkObject uit een CSV header+record
def BestuurlijkObjectFabriek(cols, record):
    bestuurlijkOBject = None
    if cols[0] == 'Woonplaats':
        bestuurlijkOBject = GemeenteWoonplaats(record)

    return bestuurlijkOBject


class GemeentelijkeIndeling(BestuurlijkObject):
    """
    Verrijking: GemeentelijkeIndeling
    """

    def __init__(self, obj):
        # XML schema:
        # <gemeentelijke_indeling
        #     xmlns="http://nlextract.nl" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        #     xsi:schemaLocation="http://nlextract.nl gemeentelijke-indeling.xsd">
        #   ...
        #   <indeling jaar="2016">
        #     ...
        #     <provincie code="27" naam="Noord-Holland">
        #       <gemeente code="358" naam="Aalsmeer" begindatum="1970-01-01" />
        #       ...
        #       <gemeente code="381" naam="Bussum" begindatum="1970-01-01" einddatum="2016-01-01" />
        #       ...
        #       <gemeente code="1942" naam="Gooise Meren" begindatum="2016-01-01" />
        #     </provincie>
        #     ...
        #   </indeling>
        #   ...
        # </gemeentelijke_indeling>
        #
        # DB schema:
        # provinciecode numberic(4, 0)
        # provincienaam character varying(80)
        # gemeentecode  numberic(4, 0)
        # gemeentenaam  character varying(80)
        # begindatum    timestamp without time zone
        # einddatum     timestamp without time zone

        self.naam = 'provincie_gemeente'
        self.provinciecode = obj['provinciecode']
        self.provincienaam = obj['provincienaam']
        self.gemeentecode = obj['gemeentecode']
        self.gemeentenaam = obj['gemeentenaam']
        self.begindatum = obj['begindatum']
        self.einddatum = obj['einddatum']

    def __repr__(self):
        return "<ProvincieGemeente('%s', '%s', '%s', '%s', '%s', '%s', '%s')>" % (
            self.naam, self.provinciecode, self.provincienaam, self.gemeentecode, self.gemeentenaam, self.begindatum, self.einddatum)

    def exists(self):
        self.sql = """SELECT gid
                        FROM provincie_gemeente
                       WHERE provinciecode = %s
                         AND gemeentecode = %s
                       LIMIT 1"""
        self.valuelist = (self.provinciecode, self.gemeentecode)

    def unchanged(self):
        and_einddatum = ' AND einddatum IS NULL'
        valuelist = [self.provinciecode, self.provincienaam, self.gemeentecode, self.gemeentenaam, self.begindatum]

        if self.einddatum:
            and_einddatum = ' AND einddatum = %s'
            valuelist.append(self.einddatum)

        self.sql = """SELECT gid
                        FROM provincie_gemeente
                       WHERE provinciecode = %s
                         AND provincienaam = %s
                         AND gemeentecode = %s
                         AND gemeentenaam = %s
                         AND begindatum = %s"""
        self.sql += and_einddatum
        self.sql += ' LIMIT 1'
        self.valuelist = valuelist

    def update(self):
        self.sql = """UPDATE provincie_gemeente
                         SET provincienaam = %s,
                             gemeentenaam = %s,
                             begindatum = %s,
                             einddatum = %s
                       WHERE provinciecode = %s
                         AND gemeentecode = %s"""
        self.valuelist = (self.provincienaam, self.gemeentenaam, self.begindatum, self.einddatum, self.provinciecode, self.gemeentecode)

    def insert(self):
        self.sql = """INSERT INTO provincie_gemeente (
                                  provinciecode,
                                  provincienaam,
                                  gemeentecode,
                                  gemeentenaam,
                                  begindatum,
                                  einddatum)
                           VALUES (%s, %s, %s, %s, %s, %s)"""
        self.valuelist = (self.provinciecode, self.provincienaam, self.gemeentecode, self.gemeentenaam, self.begindatum, self.einddatum)


def GemeentelijkeIndelingFabriek(obj):
    bestuurlijkObject = None
    if obj:
        bestuurlijkObject = GemeentelijkeIndeling(obj)

    return bestuurlijkObject
