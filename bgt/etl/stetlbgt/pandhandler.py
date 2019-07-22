# -*- coding: utf-8 -*-
#
# Filter that deals with Pand objects in BGT GML files.
#
# Author: Frank Steggink

import os

from copy import deepcopy
# We need specifically lxml, because of the incremental XML generation
from lxml import etree
from stetl.component import Config
from stetl.filter import Filter
from stetl.packet import FORMAT
from stetl.util import Util

log = Util.get_log("pandhandler")


class PandHandler(Filter):
    """
    This filter checks whether the data file contains panden. If this is the case, the buildings and nummeraanduidingen
    are split into different features.
    """

    # Start attribute config meta
    # Applying Decorator pattern with the Config class to provide
    # read-only config values from the configured properties.

    @Config(ptype=str, default=None, required=True)
    def temp_file(self):
        """
        Name of the temporary file.
        """
        pass

    # End attribute config meta

    # Constructor
    def __init__(self, configdict, section, consumes=FORMAT.string, produces=FORMAT.string):
        Filter.__init__(self, configdict, section, consumes, produces)

    def init(self):
        log.info('Init: PandHandler')
        if self.temp_file is None:
            # If no temp_file is present:
            err_s = 'The temp_file needs to be configured'
            log.error(err_s)
            raise ValueError(err_s)

    def exit(self):
        log.info('Exit: PandHandler')

    def invoke(self, packet):
        input_gml = packet.data
        if input_gml is None:
            return packet

        log.info('In PandHandler.invoke')

        if not os.path.exists(input_gml):
            msg = "The given XML file doesn't exist"
            log.error(msg)
            raise ValueError(msg)

        if not self.checkPandFile(input_gml):
            return packet

        nsmap = {None: "http://www.opengis.net/citygml/2.0"}

        with etree.xmlfile(self.temp_file) as xf:
            with xf.element('{http://www.opengis.net/citygml/2.0}CityModel', nsmap=nsmap):
                with open(input_gml) as f:
                    context = etree.iterparse(f)
                    for action, elem in context:
                        if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                            # Duplicate pand
                            self.duplicatePand(xf, elem)

                            # Clean up the original element and the node of its previous sibling
                            # (https://www.ibm.com/developerworks/xml/library/x-hiperfparse/)
                            elem.clear()
                            while elem.getprevious() is not None:
                                del elem.getparent()[0]

                    del context

            xf.flush()

        # Delete the old file and rename the new file
        os.remove(packet.data)
        os.rename(self.temp_file, packet.data)

        # Return the original packet, since this contains the name of the GML file which is being loaded
        return packet

    def checkPandFile(self, input_gml):
        result = False
        with open(input_gml) as f:
            prevTag = ''
            context = etree.iterparse(f)
            for action, elem in context:
                if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                    if prevTag == '{http://www.opengis.net/citygml/building/2.0}BuildingPart':
                        # We're processing a document with panden, quit
                        result = True

                    break

                prevTag = elem.tag

            del context

        return result

    def duplicatePand(self, xf, elem):
        # The element to be written needs to be deepcopied first, otherwise the counts are off somehow...
        out_elem = deepcopy(elem)
        ns = {'imgeo': 'http://www.geostandaarden.nl/imgeo/2.1'}
        count = int(out_elem.xpath('count(//imgeo:nummeraanduidingreeks[imgeo:Nummeraanduidingreeks])', namespaces=ns))

        # Write parent Pand object without any Nummeraanduidingreeks
        out_elem = deepcopy(elem)
        positions = out_elem.xpath('//imgeo:nummeraanduidingreeks[imgeo:Nummeraanduidingreeks]', namespaces=ns)
        for pos in positions:
            pos.getparent().remove(pos)
        xf.write(out_elem)

        # Write one instance of Nummeraanduidingreeks per Pand
        for i in range(0, count):
            out_elem = deepcopy(elem)
            out_elem[0].tag = 'BuildingPart_nummeraanduiding'

            # Remove the Pand geometry itself
            buildingSurfaces = out_elem.xpath('//imgeo:geometrie2dGrondvlak', namespaces=ns)
            for buildingSurface in buildingSurfaces:
                buildingSurface.getparent().remove(buildingSurface)

            # Remove all nummeraanduiding elements except for the i'th. This is done by first collecting all
            # nummeraanduidingen into a list, then remove the nummeraanduiding from that list which should be kept,
            # and then remove all other nummeraanduidingen from the XML element.
            positions = out_elem.xpath('//imgeo:nummeraanduidingreeks[imgeo:Nummeraanduidingreeks]', namespaces=ns)
            del positions[i]
            for pos in positions:
                pos.getparent().remove(pos)

            xf.write(out_elem)
