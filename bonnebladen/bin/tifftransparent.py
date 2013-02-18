from osgeo import gdal

input = '/Users/just/geodata/bonne/tiff/b025-1931.tif'
dataset = gdal.Open(input, gdal.GA_Update)  # open the raster for writing

# http://gis.stackexchange.com/questions/25064/gdal-convert-specific-rgb-geotiff-color-to-transparent
# 1 corresponds to Red channel, 2 for Green, 3 for Blue
R = dataset.GetRasterBand(1)
# G = dataset.GetRasterBand(2)
# B = dataset.GetRasterBand(3)

print 'Initial nodata values (RGB):\t', R.GetNoDataValue()

