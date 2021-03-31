from osgeo import gdal
from lxml import etree
import sys

# Testen Vsi lezen en parsen principe. Zie Stetl Filter
# stetl.filters.formatconverter.FormatConverter waar dit gerealiseerd is.
#
# Example:
# python vsiread.py /vsizip/{/vsizip/{BAGGEM0221L-15022021.zip}/GEM-WPL-RELATIE-15022021.zip}/GEM-WPL-RELATIE-15022021-000001.xml

def log(msg):
    print('LOG:' + msg)
    
def read_file(filename):
    vsifile = gdal.VSIFOpenL(filename,'r')
    log('opened: ' + str(vsifile))
    gdal.VSIFSeekL(vsifile, 0, 2)
    vsileng = gdal.VSIFTellL(vsifile)
    log('filesize={}'.format(vsileng))
    gdal.VSIFSeekL(vsifile, 0, 0)
    s = gdal.VSIFReadL(1, vsileng, vsifile)
    root = etree.fromstring(s)
    log(root.tag)
    elms = root.xpath('//gwr:GemeenteWoonplaatsRelatie',
        namespaces={'gwr': 'www.kadaster.nl/schemas/lvbag/gem-wpl-rel/gwr-producten-lvc/v20200601'})
    log(str(len(elms)))

def main():
    read_file(sys.argv[1])

if __name__ == "__main__":
    main()
