# -*- coding: utf-8 -*-
#
# Filter that prepares a GFS file which can be used to load with ogr2ogr.
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

log = Util.get_log("orlhandler")


class OrlHandler(Filter):
    """
    This filter checks whether the data file contains openbareruimtelabels. If this is the case, the positions are split
    into different features.
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
        log.info('Init: ORL handler')
        if self.temp_file is None:
            # If no temp_file is present:
            err_s = 'The temp_file needs to be configured'
            log.error(err_s)
            raise ValueError(err_s)

    def exit(self):
        log.info('Exit: ORL handler')

    def invoke(self, packet):
        input_gml = packet.data
        if input_gml is None:
            return packet

        log.info('In OrlHandler.invoke')

        if not os.path.exists(input_gml):
            msg = "The given XML file doesn't exist"
            log.error(msg)
            raise ValueError(msg)

        if not self.checkOrlFile(input_gml):
            return packet

        nsmap = {None: "http://www.opengis.net/citygml/2.0"}

        with etree.xmlfile(self.temp_file) as xf:
            with xf.element('{http://www.opengis.net/citygml/2.0}CityModel', nsmap=nsmap):
                with open(input_gml) as f:
                    context = etree.iterparse(f)
                    for action, elem in context:
                        if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                            # Duplicate openbareruimtelabel
                            self.duplicateOrl(xf, elem)

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

    def checkOrlFile(self, input_gml):
        result = False
        with open(input_gml) as f:
            prevTag = ''
            context = etree.iterparse(f)
            for action, elem in context:
                if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                    if prevTag == '{http://www.geostandaarden.nl/imgeo/2.1}OpenbareRuimteLabel':
                        # We're processing a document with openbareruimtelabels, quit
                        result = True

                    break

                prevTag = elem.tag

            del context

        return result

    def duplicateOrl(self, xf, elem):
        # The element to be written needs to be deepcopied first, otherwise the counts are off somehow...
        out_elem = deepcopy(elem)
        ns = {'imgeo': 'http://www.geostandaarden.nl/imgeo/2.1'}
        count = int(out_elem.xpath('count(//imgeo:positie)', namespaces=ns))

        for i in range(0, count):
            out_elem = deepcopy(elem)

            # Remove all position elements except for the i'th. This is done by first collecting all positions into
            # a list, then remove the position from that list which should be kept, and then remove all other positions
            # from the XML element.
            positions = out_elem.xpath('//imgeo:positie', namespaces=ns)
            del positions[i]
            for pos in positions:
                pos.getparent().remove(pos)

            xf.write(out_elem)
