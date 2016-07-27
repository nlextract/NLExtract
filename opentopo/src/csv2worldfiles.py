#!/usr/bin/env python
#
# Generate a directory of worldfiles from a CSV file
# See http://en.wikipedia.org/wiki/World_file for Wolrdfiles
# The CSV files have been generated and adapted from the
# master file: ../doc/opentoponl_bladen.ods made by Frank Steggink.
# Each line in the CSV contains georeference data of the raster image
# For example
# "Blad","MinX","MinY","MaxX","MaxY","Width","Height",,"ResX","ResY"
# "400-32W.tif",140000,450000,160000,475000,8000,10000,,2.5,2.5
#
# These values are sufficient to generate a Worldfile to be used for
# georeferencing each Tiff. See http://en.wikipedia.org/wiki/World_file
# for the World file format.
#
# Gotcha's
# 1. coordinates in Dutch RD/EPSG:28992 have their y descending towards the south
# 2. the upper left corner is thus MinX, MaxY
# 3. pixel size and UL corner adaption:
#    the upper left corner needs to be in the middle of the upper left pixel
#    so right in the middle of a square of ResX, ResY size
#    the original UL needs to be adapted with a 0.5 pixel size in X and -0.5 in Y
#
# See also https://github.com/nlextract/NLExtract/issues/123
# Example:
#  Upper left coord (from CSV):
#  130000,625000
#  Resolutie:
#  1000m/800pix=1.25m/pix
#  1 pixel=1.25m
#  Halve pixel: 0.625m
#
# Dan wordt worldfile entry:
# 1.25       # pixel size in the x-direction in map units/pixel
# 0.0        # rotation about y-axis
# 0.0        # rotation about x-axis
# -1.25      # pixel size in the y-direction in map units
# 130000.625 # x-coordinate of the center of the upper left pixel
# 624999.375 # y-coordinate of the center of the upper left pixel
#
# Author: Just van den Broecke
# v1 - okt 6, 2014 - first version
#
import sys
import os
import csv


def read_csv(file_path):
    """
   Parse CSV file into record (dict) array.
   NB raw version: CSV needs to have first line with fieldnames.
   Taken from Stetl fileinput.CsvFileInput
   
   """
    # Init CSV reader
    print('Open CSV file: %s', file_path)
    file_p = open(file_path)

    csv_reader = csv.DictReader(file_p)
    csv_arr = []
    try:
        next_record = csv_reader.next()
        while True:
            csv_arr.append(next_record)
            next_record = csv_reader.next()
    
        print("CSV row nr %d read: %s" % (csv_reader.line_num - 1, next_record))
    except Exception, e:
        file_p.close()
    
    return csv_arr


def rnd_float(num):
    return round(num, 6)


# Single worldfile line, must have CRLF line ending
def make_line(num):
    return str(num) + '\r\n'


def make_worldfile(record, out_dir):
    # Record fields
    # "Blad","MinX","MinY","MaxX","MaxY","Width","Height",,"ResX","ResY"
    # "400-32W.tif",140000,450000,160000,475000,8000,10000,,2.5,2.5
    print('Maak worldfile rec=%s reso=%s', record)

    tif_name = record['Blad']
    blad_name = tif_name.split('.')[0]

    ul_x = rnd_float(float(record['MinX']))
    ul_y = rnd_float(float(record['MaxY']))
    pixel_size_x = float(record['ResX'])
    pixel_size_y = float(record['ResY'])

    # UL x, y moet in midden pixel size
    ul_x += rnd_float(pixel_size_x/2)
    ul_y -= rnd_float(pixel_size_y/2)

    out_file = out_dir + os.path.sep + blad_name + '.wld'
    print 'out_file=%s blad: %s x=%f y=%f' % (out_file, blad_name, ul_x, ul_y)

    # Wegschrijven naar worldfile
    f_out = open(out_file, 'w')
    f_out.write(make_line(pixel_size_x))
    f_out.write(make_line(0.0))
    f_out.write(make_line(0.0))
    f_out.write(make_line(-pixel_size_y))
    f_out.write(make_line(ul_x))
    f_out.write(make_line(ul_y))
    f_out.close()


def main():
    csv_file = sys.argv[1]
    out_dir = sys.argv[2]

    # Get al records from CSV, each record is a dict()
    records = read_csv(csv_file)

    # generate worldfile for each record
    for record in records:
        make_worldfile(record, out_dir)

if __name__ == "__main__":
    main()