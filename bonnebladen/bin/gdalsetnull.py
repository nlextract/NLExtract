#@+leo-ver=5-thin
#@+node:maphew.20100601093031.2394: * @file gdalsetnull.py
#@@language python
#@@tabwidth -4
#@+<<about>>
#@+node:maphew.20100601093031.2403: ** <<about>>> and license
#!/usr/bin/env python
#******************************************************************************
#  $Id: gdalsetnull.py	2008-07-08 maphew $
#
#  Project:  GDAL
#  Purpose:  Simple command line program to set speficied raster value NODATA,
#				 without creating a new raster.
#  Author:   Matt Wilkie, maphew@gmail.com
#
#******************************************************************************
#  Copyright (c) 2000, Frank Warmerdam
#
#  Permission is hereby granted, free of charge, to any person obtaining a
#  copy of this software and associated documentation files (the "Software"),
#  to deal in the Software without restriction, including without limitation
#  the rights to use, copy, modify, merge, publish, distribute, sublicense,
#  and/or sell copies of the Software, and to permit persons to whom the
#  Software is furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included
#  in all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
#  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
#  THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
#  DEALINGS IN THE SOFTWARE.
#******************************************************************************
#@-<<about>>
#@+<<imports>>
#@+node:maphew.20100601093031.2402: ** <<imports>>
import sys
import os.path
try:
    from osgeo import gdal
except ImportError:
    import gdal
#@-<<imports>>
#@+others
#@+node:maphew.20100601093031.2401: ** usage
if len(sys.argv) < 2:
    print "Usage: gdalsetnull.py raster_file null_value {null band2} {null band3} ..."
    sys.exit(1)
#@+node:maphew.20100601093031.2400: ** Main
input = sys.argv[1]
null_value = sys.argv[2]

dataset = gdal.Open( input, gdal.GA_Update )
if dataset is None:
    print 'Unable to open', input, 'for writing'
    sys.exit(1)

for band_num in range(1, dataset.RasterCount+1):
    band = dataset.GetRasterBand(band_num)
    print 'Initial nodata for band %s \t %s'  % (band_num,band.GetNoDataValue() )

    # the 2nd commandline argument is for band#1, arg3 for band2, etc.
    arg_num = band_num + 1
    # optionally set different nodata values for each bands
    if arg_num > 2:
        if sys.argv[arg_num]:
            null_value = sys.argv[band_num]

    # FIXME: handle case where we want to remove nodata altogether (change to 'None')
    band.SetNoDataValue( float(null_value) )

    print 'Output  nodata for band %s \t %s' % (band_num,band.GetNoDataValue() )
#@-others
#@-leo
