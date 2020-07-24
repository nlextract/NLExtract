# -*- coding: utf-8 -*-
#
# Filter that extracts subfeatures from BGT or BGT-derived CityGML files.
#
# Author: Frank Steggink (original)
# Author: Just van den Broecke - make more robust, handle non-CityGML files (BRK e.g.)
#

import os

from copy import deepcopy
# We need specifically lxml, no fallback, because of the incremental XML generation
from lxml import etree
from stetl.component import Config
from stetl.filter import Filter
from stetl.packet import FORMAT
from stetl.util import Util

log = Util.get_log("subfeaturehandler")


class SubFeatureHandler(Filter):
    """
    This Filter checks whether the data file contains the given parent features. If this is the case, each parent feature
    and its subfeatures are extracted and split into individual features and written to a new CityGML file.
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

    @Config(ptype=str, default=None, required=True)
    def parent_tag_ns(self):
        """
        Namespace of parent feature.
        """
        pass

    @Config(ptype=str, default=None, required=True)
    def parent_tag_name(self):
        """
        Tag name of parent feature.
        """
        pass

    @Config(ptype=str, default=None, required=True)
    def namespace_mapping(self):
        """
        Namespace mapping to be used for XPath queries.
        """
        pass

    @Config(ptype=str, default=None, required=True)
    def child_feature_xpath(self):
        """
        Child feature XPath.
        """
        pass

    @Config(ptype=bool, default=True, required=False)
    def keep_parent_feature(self):
        """
        Keep parent feature.
        """
        pass

    @Config(ptype=str, default=None, required=False)
    def child_feature_alt_tag_name(self):
        """
        Alternative tag name of child feature
        """
        pass

    @Config(ptype=str, default=None, required=False)
    def parent_feature_geom_name(self):
        """
        Parent feature geometry name.
        """
        pass

    # End attribute config meta

    # Constructor
    def __init__(self, configdict, section, consumes=FORMAT.string, produces=FORMAT.string):
        Filter.__init__(self, configdict, section, consumes, produces)

    def init(self):
        log.info('init() for %s' % self.child_feature_xpath)
        self.namespace_mapping_parsed = {nsp.split(':', 1)[0]: nsp.split(':', 1)[1] for nsp in self.namespace_mapping.split()}

    def exit(self):
        log.info('exit()')

    def invoke(self, packet):
        log.info('invoke() for %s' % self.child_feature_xpath)

        # packet.data contains GML file path
        input_gml = packet.data
        if input_gml is None:
            return packet

        if not os.path.exists(input_gml):
            msg = "input GML file %s does not exist" % input_gml
            log.error(msg)
            raise ValueError(msg)

        if not self.checkGmlFile(input_gml):
            log.info('skipping GML file for subfeat=%s' % self.child_feature_xpath)
            return packet

        nsmap = {None: "http://www.opengis.net/citygml/2.0"}

        try:
            with etree.xmlfile(self.temp_file) as xf:
                with xf.element('{http://www.opengis.net/citygml/2.0}CityModel', nsmap=nsmap):
                    with open(input_gml, 'rb') as f:
                        context = etree.iterparse(f)
                        for action, elem in context:
                            if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                                # Duplicate feature and subfeatures
                                self.duplicateFeature(xf, elem)

                                # Clean up the original element and the node of its previous sibling
                                # (https://www.ibm.com/developerworks/xml/library/x-hiperfparse/)
                                elem.clear()
                                while elem.getprevious() is not None:
                                    del elem.getparent()[0]

                        del context

                xf.flush()

        except etree.SerialisationError:
            # When writing large (> 2.1 GB) XML files, the return code, which is the number of bytes written,
            # is being cast to a signed 32 bit integer. Libxml, the underlying library used by lxml, interprets
            # this as an error. However, the XML file is written correctly.
            # This error occurs not only in xmlfile.flush(), but also in xmlfile.__exit__
            pass

        # Check if the resulting file can be opened successfully
        with open(self.temp_file, 'rb') as f:
            context = etree.iterparse(f, tag='{http://www.opengis.net/citygml/2.0}cityObjectMember')
            for _, elem in context:
                elem.clear(keep_tail=True)
            del context

        log.info('Temporary XML file was written successfully')

        # Delete the old file and rename the new file
        os.remove(packet.data)
        os.rename(self.temp_file, packet.data)

        # Return the original packet, since this contains the name of the GML file which is being loaded
        return packet

    # Check GML file for occurrence of target CityObjectMember/<parentTag>
    def checkGmlFile(self, input_gml):
        result = False
        parentTag = '{%s}%s' % (self.parent_tag_ns, self.parent_tag_name)
        try:
            with open(input_gml, 'rb') as f:
                prevTag = ''
                actions = ['start', 'end']
                context = etree.iterparse(f, events=actions)
                check_doc_tag = True
                for action, elem in context:
                    if action == 'start' and check_doc_tag and 'citygml' not in elem.tag:
                        # Document is not even CityGML!
                        log.info('checkGmlFile: skipping, not a CityGML file tag=%s' % elem.tag)
                        break

                    check_doc_tag = False

                    if action == 'end' and elem.tag == '{http://www.opengis.net/citygml/2.0}cityObjectMember':
                        if prevTag == parentTag:
                            # Found target parent feature: success
                            log.info('checkGmlFile: found parentTag %s' % parentTag)
                            result = True

                        # Assuming all cityObjectMembers are of same FeatureType!
                        break

                    prevTag = elem.tag

                del context
        except Exception as e:
            log.error('checkGmlFile: unexpected exception: %s' + str(e))

        return result

    def duplicateFeature(self, xf, elem):
        # The element to be written needs to be deepcopied first, otherwise the counts are off somehow...
        out_elem = deepcopy(elem)
        ns = self.namespace_mapping_parsed
        xpath = '//%s' % self.child_feature_xpath
        count = int(out_elem.xpath('count(//%s)' % self.child_feature_xpath, namespaces=ns))

        if self.keep_parent_feature:
            # Write parent feature object without any child features
            out_elem = deepcopy(elem)
            positions = out_elem.xpath('//%s' % self.child_feature_xpath, namespaces=ns)
            for pos in positions:
                pos.getparent().remove(pos)
            xf.write(out_elem)

        # Write one instance of subfeature per parent feature
        for i in range(0, count):
            out_elem = deepcopy(elem)
            if self.child_feature_alt_tag_name is not None:
                out_elem[0].tag = self.child_feature_alt_tag_name

            if self.parent_feature_geom_name is not None:
                # Remove the geometry of the parent feature
                parentGeoms = out_elem.xpath('//%s' % self.parent_feature_geom_name, namespaces=ns)
                for parentGeom in parentGeoms:
                    parentGeom.getparent().remove(parentGeom)

            # Remove all child feature elements except for the i'th. This is done by first collecting all
            # child features into a list, then remove the child feature from that list which should be kept,
            # and then remove all other child features from the XML element.
            positions = out_elem.xpath('//%s' % self.child_feature_xpath, namespaces=ns)
            del positions[i]
            for pos in positions:
                pos.getparent().remove(pos)

            xf.write(out_elem)
