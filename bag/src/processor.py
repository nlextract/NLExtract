__author__ = "Milo van der Linden"
__date__ = "$Jun 14, 2011 11:11:01 AM$"

"""
 Naam:         processor.py
 Omschrijving: Processing van parsed BAG DOM en CSV objecten

 Auteur:       Milo van der Linden Just van den Broecke

 Versie:       1.0
               - basis versie
 Datum:        22 december 2011


 OpenGeoGroep.nl
"""

from bagobject import BAGObjectFabriek
from bestuurlijkobject import BestuurlijkObjectFabriek
from postgresdb import Database
from logging import Log

class Processor:
    # TODO:
    # Ben tot hier gekomen met etree. node.localName kent alleen een representatief
    # in de vorm van element.tag
    # Maar hier zitten de namespaces in:
    #
    # print xml.getroot().tag
    #   {http://www.kadaster.nl/schemas/bag-verstrekkingen/extract-deelbestand-lvc/v20090901}BAG-Extract-Deelbestand-LVC
    #
    # Deze moeten of gestript worden, of de functie die dit automatisch doet moet worden gevonden.

    def __init__(self, args):
        self.args = args
        self.database = Database()

    def processCSV(self, csvreader):
        objecten = []
        cols = csvreader.next()
        for record in csvreader:
            if record[0]:
                object = BestuurlijkObjectFabriek(cols, record)
                if object:
                    objecten.append(object)
                else:
                    Log.log.warn("Geen object gevonden voor " + str(record))

        # Verwerk het bestand, lees gemeente_woonplaatsen in de database
        Log.log.info("Insert objectCount=" + str(len(objecten)))
        self.database.verbind()
        self.database.connection.set_client_encoding('LATIN1')
        for object in objecten:
            object.insert()
            self.database.uitvoeren(object.sql, object.valuelist)
        self.database.connection.commit()

    def processDOM(self, node):
        self.bagObjecten = []
        mode = None
        if node.localName == 'BAG-Extract-Deelbestand-LVC':
            mode = 'Nieuw'
            #firstchild moet zijn 'antwoord'
            for childNode in node.childNodes:
                if childNode.localName == 'antwoord':
                    # Antwoord bevat twee childs: vraag en producten
                    antwoord = childNode
                    for child in antwoord.childNodes:
                        if child.localName == "vraag":
                            # TODO: Is het een idee om vraag als object ook af te
                            # handelen en op te slaan
                            vraag = child
                        elif child.localName == "producten":
                            producten = child
                            Log.log.startTimer("objCreate")
                            for productnode in producten.childNodes:
                                if productnode.localName == 'LVC-product' and productnode.childNodes:
                                    self.bagObjecten = BAGObjectFabriek.bof.BAGObjectArrayBijXML(productnode.childNodes)
                            Log.log.endTimer("objCreate - objs=" + str(len(self.bagObjecten)))

        elif node.localName == 'BAG-Mutaties-Deelbestand-LVC':
            mode = 'Mutatie'
            #firstchild moet zijn 'antwoord'
            for childNode in node.childNodes:
                if childNode.localName == 'antwoord':
                    # Antwoord bevat twee childs: vraag en producten
                    antwoord = childNode
                    for child in antwoord.childNodes:
                        if child.localName == "producten":
                            producten = child
                            Log.log.startTimer("objCreate")
                            for productnode in producten.childNodes:
                                if productnode.localName == 'Mutatie-product' and productnode.childNodes:
                                    origineelObj = None
                                    nieuwObj = None
                                    for mutatienode in productnode.childNodes:
                                        if mutatienode.localName == 'Nieuw':
                                            # Log.log.info("Nieuw Object")
                                            self.bagObjecten.extend(
                                                BAGObjectFabriek.bof.BAGObjectArrayBijXML(mutatienode.childNodes))
                                        elif mutatienode.localName == 'Origineel':
                                            objs = BAGObjectFabriek.bof.BAGObjectArrayBijXML(mutatienode.childNodes)
                                            if len(objs) > 0:
                                                origineelObj = objs[0]
                                        elif mutatienode.localName == 'Wijziging':
                                            objs = BAGObjectFabriek.bof.BAGObjectArrayBijXML(mutatienode.childNodes)

                                            if len(objs) > 0:
                                                nieuwObj = objs[0]
                                                if nieuwObj and origineelObj:
                                                    nieuwObj.origineelObj = origineelObj
                                                    self.bagObjecten.append(nieuwObj)
                                                    # Log.log.info("Wijziging Object")
                                                    origineelObj = None
                                                    nieuwObj = None

                            Log.log.endTimer("objCreate - objs=" + str(len(self.bagObjecten)))

        Log.log.startTimer("dbStart mode = " + mode)
        self.database.verbind()
        rels = 0
        wijzigingen = 0
        for bagObject in self.bagObjecten:
            if bagObject.origineelObj:
                # Mutatie: wijziging
                bagObject.maakUpdateSQL()
                wijzigingen += 1
            else:
                # Mutatie: nieuw object
                bagObject.maakInsertSQL()

            self.database.uitvoeren(bagObject.sql, bagObject.inhoud)
            for relatie in bagObject.relaties:
                i = 0
                for sql in relatie.sql:
                    self.database.uitvoeren(sql, relatie.inhoud[i])
                    i += 1
                    rels += 1

        self.database.connection.commit()
        Log.log.endTimer("dbEnd - nieuw=" + str(len(self.bagObjecten) - wijzigingen) + " gewijzigd=" + str(wijzigingen) + " rels=" + str(rels))
        Log.log.info("------")


