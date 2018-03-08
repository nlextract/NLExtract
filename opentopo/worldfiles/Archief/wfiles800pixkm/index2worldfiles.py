#!/usr/bin/env python
# OBSOLETE, ZIE ../../src/csv2worldfiles.py

__author__ = 'just'


def get_line_contains(f, s):
    line = ''
    # data section reached?
    while s not in line:
        line = f.readline()
        if not line:
            break

    return line


def gen_worldfile(f_in):
    # Entry format
    # [SheetFile]
    # FileName=d:\Maps\Netherlands\OpenTopo_hires\71E.tif
    # Anchor=0|0|120000|625000
    # Anchor=8000|0|130000|625000
    # Anchor=0|10000|120000|612500
    # Anchor=8000|10000|130000|612500
    # ProjectionAlias=RD
    # RegisteredCoordAlias=RD

    # FileName=d:\Maps\Netherlands\OpenTopo_hires\71E.tif
    fname_str = get_line_contains(f_in, 'FileName')
    blad = fname_str.split('\\')[4].split('.')[0]

    # Then to anchor 0|0
    # Anchor=0|0|120000|625000
    ul_str = get_line_contains(f_in, 'Anchor=0|0|')
    coord_list = ul_str.split('=')[1].split('|')
    ul_x = float(coord_list[2])
    ul_y = float(coord_list[3])

    ul_x = ul_x + 0.625
    ul_y = ul_y - 0.625
    print 'blad: %s x=%f y=%f' % (blad, ul_x, ul_y)

    f_out = open('800-' + blad + '.wld', 'w')
    f_out.write('1.25\n')
    f_out.write('0.0\n')
    f_out.write('0.0\n')
    f_out.write('-1.25\n')
    f_out.write(str(ul_x) + '\n')
    f_out.write(str(ul_y) + '\n')
    f_out.close()


def main():

    f_in = open('index_800pixkm.dat', 'r')

    while get_line_contains(f_in, '[SheetFile]'):
        gen_worldfile(f_in)

    f_in.close()


if __name__ == "__main__":
    main()
