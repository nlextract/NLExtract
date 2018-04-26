#!/usr/bin/env python
#
# Auteur: Frank Steggink
# Klassedefinitie voor de ThreeDExporter

from abc import ABCMeta, abstractmethod


class ThreeDExporter:
    __metaclass__ = ABCMeta

    # Voegt een gebouw toe aan de exporter
    @abstractmethod
    def addBuilding(self, id, poly, min_height, avg_height):
        pass

    # Exporteert de data die de exporter bevat
    @abstractmethod
    def exportData(self, bbox, crs, centerOnOrigin):
        pass
