try:
    from lxml import etree

    print("running with lxml.etree")
except ImportError:
    try:
        # Python 2.5
        import xml.etree.cElementTree as etree

        print("running with cElementTree on Python 2.5+")
    except ImportError:
        try:
            # Python 2.5
            import xml.etree.ElementTree as etree

            print("running with ElementTree on Python 2.5+")
        except ImportError:
            try:
                # normal cElementTree install
                import cElementTree as etree

                print("running with cElementTree")
            except ImportError:
                try:
                    # normal ElementTree install
                    import elementtree.ElementTree as etree

                    print("running with ElementTree")
                except ImportError:
                    print("Failed to import ElementTree from any known place")


def stripschema(tag):
    return tag.split('}')[-1]


def tagVolledigeNS(old, nsmap):
    tags = []
    for tag in old.split('/'):
        sep = tag.split(':')
        tags.append('{%s}%s' % (nsmap[sep[0]], sep[1]))
    return '/'.join(tags)

# http://wiki.tei-c.org/index.php/Remove-Namespaces.xsl
xslt_strip_ns = '''<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="xml" indent="no"/>

<xsl:template match="/|comment()|processing-instruction()">
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
</xsl:template>

<xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@*|node()"/>
    </xsl:element>
</xsl:template>

<xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
</xsl:template>
</xsl:stylesheet>
'''

xslt_doc = False

# Haal alle Namespaces recursief uit een node
# Handig om bijv. XPath expressies los te laten
def stripNS(node):
    global xslt_doc, xslt_strip_ns
    if not xslt_doc:
        xslt_doc = etree.fromstring(xslt_strip_ns)

    transform = etree.XSLT(xslt_doc)
    return transform(node)
