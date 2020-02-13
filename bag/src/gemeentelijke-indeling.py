# vim: set fileencoding=UTF-8 :
#
# Update gemeentelijke-indeling.xml with CBS spreadsheet data for next year.
#
# Required dependencies (Debian/Ubuntu):
#
#  python3-xlrd python3-lxml
#
# Required dependencies (PyPi):
#
#  xlrd lxml
#
# Copyright (C) 2016, Bas Couwenberg <sebastic@xs4all.nl>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

"""
 Naam:         gemeentelijke-indeling.py
 Omschrijving: Commandline applicatie voor gemeentelijke-indeling.xml aanpassingen.
 Auteurs:      Stefan de Konink (initial), Just van den Broecke (bagextract.py),
               Bas Couwenberg (gemeentelijke-indeling.py)
"""

import argparse
import sys
import os
import re
import copy
import datetime
import xlrd
from collections import defaultdict
from etree import etree, stripschema


class ArgParser(argparse.ArgumentParser):
    def error(self, message):
        print(message)
        print("")
        show_help()
        sys.exit(2)


def hash():
    return defaultdict(hash)


def parse_gemeentelijke_indeling(args):
    if not os.access(args.input, os.R_OK):
        if args.verbose:
            print("Error: Cannot read file: " + args.input)
        return

    if args.verbose:
        print("Parsing XML file: " + args.input)

    try:
        # XML doc parsen naar etree object
        parsed_xml = etree.parse(args.input)
    except (Exception) as e:
        print("Error: Failed to parse file: %s (%s)" % (args.input, str(e)))
        return

    gemeentelijke_indeling = hash()

    root = parsed_xml.getroot()

    if stripschema(root.tag) == 'gemeentelijke_indeling':
        if len(root.attrib):
            gemeentelijke_indeling['attributes'] = root.attrib

        if len(root.nsmap):
            gemeentelijke_indeling['nsmap'] = root.nsmap

        for indelingNode in root:
            if stripschema(indelingNode.tag) == 'indeling':
                jaar = indelingNode.get('jaar')

                indeling = hash()

                indeling['attributes']['jaar'] = jaar

                for provincieNode in indelingNode:
                    if stripschema(provincieNode.tag) == 'provincie':
                        provinciecode = provincieNode.get('code')
                        provincienaam = provincieNode.get('naam')

                        provincie = hash()

                        provincie['attributes']['code'] = provinciecode
                        provincie['attributes']['naam'] = provincienaam

                        for gemeenteNode in provincieNode:
                            if stripschema(gemeenteNode.tag) == 'gemeente':
                                gemeentecode = gemeenteNode.get('code')
                                gemeentenaam = gemeenteNode.get('naam')
                                begindatum = gemeenteNode.get('begindatum')
                                einddatum = gemeenteNode.get('einddatum')

                                gemeente = hash()

                                gemeente['attributes']['code'] = gemeentecode
                                gemeente['attributes']['naam'] = gemeentenaam
                                gemeente['attributes']['begindatum'] = begindatum
                                gemeente['attributes']['einddatum'] = einddatum

                                provincie['gemeente'][gemeentecode] = gemeente

                        indeling['provincie'][provinciecode] = provincie

                gemeentelijke_indeling['indeling'][jaar] = indeling

    return gemeentelijke_indeling


def write_gemeentelijke_indeling(args, gemeentelijke_indeling):
    if args.verbose:
        print("Building XML structure...")

    if 'nsmap' in gemeentelijke_indeling:
        root = etree.Element("gemeentelijke_indeling", nsmap=gemeentelijke_indeling['nsmap'])
    else:
        root = etree.Element("gemeentelijke_indeling")

    doc = etree.ElementTree(root)

    for attribute in gemeentelijke_indeling['attributes']:
        root.set(attribute, gemeentelijke_indeling['attributes'][attribute])

    for jaar in sorted(gemeentelijke_indeling['indeling'], key=int):
        indeling = etree.Element("indeling")

        attributes = ['jaar']
        for attribute in attributes:
            indeling.set(attribute, gemeentelijke_indeling['indeling'][jaar]['attributes'][attribute])

        for provinciecode in sorted(gemeentelijke_indeling['indeling'][jaar]['provincie'], key=int):
            provincie = etree.Element("provincie")

            attributes = ['code', 'naam']
            for attribute in attributes:
                provincie.set(attribute, gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['attributes'][attribute])

            for gemeentecode in sorted(gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'], key=int):
                gemeente = etree.Element("gemeente")

                attributes = ['code', 'naam', 'begindatum', 'einddatum']
                for attribute in attributes:
                    if (attribute in gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes'] and
                            gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes'][attribute] is not None):
                        gemeente.set(attribute, gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes'][attribute])

                    provincie.append(gemeente)

            indeling.append(provincie)

        root.append(indeling)

    if args.dry_run:
        if args.verbose:
            print("Not saving file: %s (DRY-RUN)" % args.output)

        print(etree.tostring(doc, pretty_print=True, xml_declaration=True, encoding='UTF-8').decode())
    else:
        if args.verbose:
            print("Saving file: %s" % args.output)

        doc.write(args.output, pretty_print=True, xml_declaration=True, encoding='UTF-8')


def end_gemeente(args, gemeentelijke_indeling, provincie_map):
    gemeentecode = strip_leading_zeros(args.code)
    einddatum = args.date

    jaar = get_last_year(gemeentelijke_indeling)

    provinciecode = strip_leading_zeros(args.prov)
    provincienaam = args.prov

    if not re.search("^\d+$", args.prov) and args.prov in provincie_map['name2code']:
        provinciecode = provincie_map['name2code'][args.prov]
        provincienaam = provincie_map['code2name'][provinciecode]

    if (jaar in gemeentelijke_indeling['indeling'] and
            provinciecode in gemeentelijke_indeling['indeling'][jaar]['provincie'] and
            gemeentecode in gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente']):
        gemeentenaam = gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['naam']
        begindatum = gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['begindatum']

        if args.verbose:
            print("Setting einddatum for gemeente %s (%s) [%s/%s] in provincie %s (%s)" % (
                gemeentenaam, gemeentecode, begindatum, einddatum, provincienaam, provinciecode))

        gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['einddatum'] = einddatum

    return gemeentelijke_indeling


def add_gemeente(args, gemeentelijke_indeling, provincie_map):
    gemeentecode = strip_leading_zeros(args.code)
    gemeentenaam = args.name
    begindatum = args.date

    jaar = get_last_year(gemeentelijke_indeling)

    provinciecode = strip_leading_zeros(args.prov)
    provincienaam = args.prov

    if not re.search("^\d+$", args.prov) and args.prov in provincie_map['name2code']:
        provinciecode = provincie_map['name2code'][args.prov]
        provincienaam = provincie_map['code2name'][provinciecode]

    if (jaar in gemeentelijke_indeling['indeling'] and
            provinciecode in gemeentelijke_indeling['indeling'][jaar]['provincie'] and
            gemeentecode not in gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente']):
        gemeente = hash()

        gemeente['attributes'] = {
            'code': gemeentecode,
            'naam': gemeentenaam,
            'begindatum': begindatum,
        }

        if args.verbose:
            print("Adding gemeente %s (%s) [%s] to provincie %s (%s)" % (gemeentenaam, gemeentecode, begindatum, provincienaam, provinciecode))

        gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['gemeente'][gemeentecode] = gemeente

    return gemeentelijke_indeling


def parse_cbs_data(args):
    if not os.access(args.file, os.R_OK):
        if args.verbose:
            print("Error: Cannot read CBS data file: " + args.file)
        return

    if args.verbose:
        print("Parsing XLS file: %s" % args.file)

    workbook = xlrd.open_workbook(args.file)

    cbs_data = hash()

    for sheet_name in workbook.sheet_names():
        sheet = workbook.sheet_by_name(sheet_name)

        value = sheet.cell_value(0, 0)

        if not value:
            if args.verbose:
                print("Warning: No value in cell 0,0, skipping worksheet: %s" % sheet_name)

            continue

        header = []
        for i in range(0, sheet.ncols):
            value = sheet.cell_value(0, i)

            header.append(value)

        column = {}

        # Gemeentecode    Gemeentenaam    Provincienaam    Provinciecode
        if (header[0] == 'Gemeentecode' and
                header[1] == 'Gemeentenaam' and
                header[2] == 'Provincienaam' and
                header[3] == 'Provinciecode'):
            column = {
                'gemeentecode': 0,
                'gemeentenaam': 1,
                'provincienaam': 2,
                'provinciecode': 3,
            }

        # Gemeentecode    Provinciecode    Gemeentenaam    Provincienaam
        elif (header[0] == 'Gemeentecode' and
              header[1] == 'Provinciecode' and
              header[2] == 'Gemeentenaam' and
              header[3] == 'Provincienaam'):
            column = {
                'gemeentecode': 0,
                'provinciecode': 1,
                'gemeentenaam': 2,
                'provincienaam': 3,
            }

        # prov_Gemcode    provcode    Gemcodel    provcodel
        elif (header[0] == 'prov_Gemcode' and
              header[1] == 'provcode' and
              header[2] == 'Gemcodel' and
              header[3] == 'provcodel'):
            column = {
                'gemeentecode': 0,
                'provinciecode': 1,
                'gemeentenaam': 2,
                'provincienaam': 3,
            }

        # Gemcode    provcode    Gemcodel    provcodel
        elif (header[0] == 'Gemcode' and
              header[1] == 'provcode' and
              header[2] == 'Gemcodel' and
              header[3] == 'provcodel'):
            column = {
                'gemeentecode': 0,
                'provinciecode': 1,
                'gemeentenaam': 2,
                'provincienaam': 3,
            }

        # Gemcode    Gemcodel    provcode    provcodel
        elif (header[0] == 'Gemcode' and
              header[1] == 'Gemcodel' and
              header[2] == 'provcode' and
              header[3] == 'provcodel'):
            column = {
                'gemeentecode': 0,
                'gemeentenaam': 1,
                'provinciecode': 2,
                'provincienaam': 3,
            }

        # Gemeentecode    GemeentecodeGM    Gemeentenaam    Provinciecode    ProvinciecodePV    Provincienaam
        elif (header[0] == 'Gemeentecode' and
              header[1] == 'GemeentecodeGM' and
              header[2] == 'Gemeentenaam' and
              header[3] == 'Provinciecode' and
              header[4] == 'ProvinciecodePV' and
              header[5] == 'Provincienaam'):
            column = {
                'gemeentecode': 0,
                'gemeentecodegm': 1,
                'gemeentenaam': 2,
                'provinciecode': 3,
                'provinciecodepv': 4,
                'provincienaam': 5,
            }

        # Unsupported format
        else:
            if args.verbose:
                order = ""

                i = 0
                for col in header:
                    if i > 0:
                        print(" | ")

                    print(col)

                    i += 1

                print("Error: Unsupported header order: %s" % order)

            return

        for row in range(1, sheet.nrows):
            record = {}

            columns = ['gemeentecode', 'gemeentenaam', 'provinciecode', 'provincienaam']
            for key in columns:
                value = sheet.cell_value(row, column[key])

                record[key] = value

            if ('gemeentecode' not in record and
                    'gemeentenaam' not in record and
                    'provinciecode' not in record and
                    'provincienaam' not in record):
                if args.verbose:
                    print("Empty row, stoppping here.")
                break

            if 'gemeentecode' not in record:
                if args.verbose:
                    print("Empty 'gemeentecode' column (%s), stoppping here." % column['gemeentecode'])
                break
            if 'gemeentenaam' not in record:
                if args.verbose:
                    print("Empty 'gemeentenaam' column (%s), stoppping here." % column['gemeentenaam'])
                break
            if 'provinciecode' not in record:
                if args.verbose:
                    print("Empty 'provinciecode' column (%s), stoppping here." % column['provinciecode'])
                break
            if 'provincienaam' not in record:
                if args.verbose:
                    print("Empty 'provincienaam' column (%s), stoppping here." % column['provincienaam'])
                break

            columns = ['gemeentecode', 'provinciecode']
            for key in columns:
                record[key] = strip_leading_zeros(record[key])

            cbs_data[record['provinciecode']][record['gemeentecode']] = record

        break

    return cbs_data


def add_cbs_data(args, gemeentelijke_indeling, cbs_data):
    prev = get_last_year(gemeentelijke_indeling)
    jaar = str(int(prev) + 1)

    if args.verbose:
        print("Adding indeling for %s" % jaar)

    indeling = copy.deepcopy(gemeentelijke_indeling['indeling'][prev])

    indeling['attributes']['jaar'] = jaar

    for provinciecode in sorted(cbs_data, key=int):
        provincienaam = indeling['provincie'][provinciecode]['attributes']['naam']

        for gemeentecode in sorted(indeling['provincie'][provinciecode]['gemeente'], key=int):
            gemeentenaam = indeling['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['naam']
            begindatum = indeling['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['begindatum']
            einddatum = indeling['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['einddatum']

            # Remove municipalities that ended in the previous year
            if einddatum is not None:
                compare = compare_datum_and_year(args, einddatum, jaar)
                if compare == -1:
                    if args.verbose:
                        print("Removing gemeente %s (%s) [%s|%s] from provincie %s (%s)" % (gemeentenaam, gemeentecode, begindatum, einddatum, provincienaam, provinciecode))

                    del indeling['provincie'][provinciecode]['gemeente'][gemeentecode]

            # Add einddatum attribute to municipalities that ended this year
            elif gemeentecode not in cbs_data[provinciecode]:
                einddatum = jaar + "-01-01"

                if args.verbose:
                    print("Setting einddatum for gemeente %s (%s) [%s|%s] in provincie %s (%s)" % (gemeentenaam, gemeentecode, begindatum, einddatum, provincienaam, provinciecode))

                indeling['provincie'][provinciecode]['gemeente'][gemeentecode]['attributes']['einddatum'] = einddatum

        for gemeentecode in sorted(cbs_data[provinciecode], key=int):
            # Add municipalities created this year
            if gemeentecode not in indeling['provincie'][provinciecode]['gemeente']:
                gemeentenaam = cbs_data[provinciecode][gemeentecode]['gemeentenaam']
                begindatum = jaar + "-01-01"

                if args.verbose:
                    print("Adding gemeente %s (%s) [%s] to provincie %s (%s)" % (gemeentenaam, gemeentecode, begindatum, provincienaam, provinciecode))

                gemeente = hash()

                gemeente['attributes'] = {
                    'code': gemeentecode,
                    'naam': gemeentenaam,
                    'begindatum': begindatum,
                }

                indeling['provincie'][provinciecode]['gemeente'][gemeentecode] = gemeente

    gemeentelijke_indeling['indeling'][jaar] = indeling

    return gemeentelijke_indeling


def compare_datum_and_year(args, datum, year):
    match = re.match("^(\d{4})-(\d{2})-(\d{2})$", datum)
    if match:
        datum_year = match.group(1)
        datum_month = match.group(2)
        datum_day = match.group(3)

        date1 = datetime.date(int(datum_year), int(datum_month), int(datum_day))
    else:
        if args.verbose:
            print("Error: Cannot parse datum: datum" % datum)

        return

    date2 = datetime.date(int(year), 1, 1)

    if date1 < date2:
        return -1
    elif date1 > date2:
        return 1
    elif date1 == date2:
        return 0
    else:
        return


def strip_leading_zeros(string):
    return re.sub("^0+", "", string)


def get_last_year(gemeentelijke_indeling):
    for key in sorted(gemeentelijke_indeling['indeling'], key=int):
        jaar = key

    return jaar


def get_provincie_map(args, gemeentelijke_indeling):
    provincie_map = hash()

    jaar = get_last_year(gemeentelijke_indeling)

    for provinciecode in sorted(gemeentelijke_indeling['indeling'][jaar]['provincie'], key=int):
        provincienaam = gemeentelijke_indeling['indeling'][jaar]['provincie'][provinciecode]['attributes']['naam']

        provincie_map['code2name'][provinciecode] = provincienaam
        provincie_map['name2code'][provincienaam] = provinciecode

    return provincie_map


def display_provincie_map(args, provincie_map):
    longest = {}
    columns = ['code', 'name']

    for column in columns:
        longest[column] = len(column)

    for code in sorted(provincie_map['code2name'], key=int):
        name = provincie_map['code2name'][code]

        length = {
            'code': len(code),
            'name': len(name),
        }

        for column in columns:
            if length[column] > longest[column]:
                longest[column] = length[column]

    box_top = "┌"
    box_middle = "├"
    box_bottom = "└"

    header = "│"

    i = 0
    for column in columns:
        box_top += "─" + ("─" * longest[column]) + "─"
        box_middle += "─" + ("─" * longest[column]) + "─"
        box_bottom += "─" + ("─" * longest[column]) + "─"

        header += " " + column.title() + (" " * (longest[column] - len(column))) + " "

        if i < (len(columns) - 1):
            box_top += "┬"
            box_middle += "┼"
            box_bottom += "┴"

            header += "│"

        i += 1

    box_top += "┐ ┌"
    box_middle += "┤ ├"
    box_bottom += "┘ └"

    header += "│ │"

    i = 0
    for column in sorted(columns, reverse=True):
        box_top += "─" + ("─" * longest[column]) + "─"
        box_middle += "─" + ("─" * longest[column]) + "─"
        box_bottom += "─" + ("─" * longest[column]) + "─"

        header += " " + column.title() + (" " * (longest[column] - len(column))) + " "

        if i < (len(columns) - 1):
            box_top += "┬"
            box_middle += "┼"
            box_bottom += "┴"

            header += "│"

        i += 1

    box_top += "┐"
    box_middle += "┤"
    box_bottom += "┘"

    header += "│"

    print(box_top)
    print(header)
    print(box_middle)

    code2name_rows = []

    for code in sorted(provincie_map['code2name'], key=int):
        name = provincie_map['code2name'][code]

        row = ""

        row += "│ "
        row += " " * (longest['code'] - len(code))
        row += code
        row += " │ "
        row += name
        row += " " * (longest['name'] - len(name))
        row += " │"

        code2name_rows.append(row)

    name2code_rows = []

    for name in sorted(provincie_map['name2code']):
        code = provincie_map['name2code'][name]

        row = ""

        row += "│ "
        row += name
        row += " " * (longest['name'] - len(name))
        row += " │ "
        row += code
        row += " " * (longest['code'] - len(code))
        row += " │"

        name2code_rows.append(row)

    i = 0
    for row in code2name_rows:
        print(code2name_rows[i] + " " + name2code_rows[i])

        if i < (len(code2name_rows) - 1):
            print(box_middle)

        i += 1

    print(box_bottom)


def show_help():
    print("Usage: " + os.path.basename(__file__) + " <ACTION> -i <PATH> [-o <PATH>] [OPTIONS]")
    print("")
    print("Actions:")
    print("--add-cbs-data          Add CBS spreadsheet data for next year")
    print("                        Requires option: --file")
    print("--end-gemeente          Set einddatum attribute for gemeente")
    print("                        Requires option: --code, --date, --prov")
    print("--add-gemeente          Create new gemeente element")
    print("                        Requires option: --code, --name, --date, --prov")
    print("--provincie-map         Display provicie map (code & name)")
    print("")
    print("Options:")
    print("-i, --input <PATH>      Path to gemeentelijke-indeling XML file to read")
    print("-o, --output <PATH>     Path to gemeentelijke-indeling XML file to write")
    print("-f, --file <PATH>       Path to CBS Excel spreadsheet to process")
    print("")
    print("-C, --code <NUMBER>     Numerical gemeentecode")
    print("-N, --name <STRING>     Alphanumerical gemeentenaam")
    print("-D, --date <DATE>       Date in YYYY-MM-DD format")
    print("-P, --prov <NAME|CODE>  Parent provincie of gemeente")
    print("")
    print("-n, --dry-run           Don't overwrite the file, display instead")
    print("-d, --debug             Enable debug output")
    print("-v, --verbose           Enable verbose output")
    print("-h, --help              Display this usage information")


def main():
    """
    Voorbeelden:

        1. Beëindig de oude gemeente in de meest recente indeling:
           $ python gemeentelijke-indeling.py --end-gemeente \
                                              --code 1921 \
                                              --date 2015-07-01 \
                                              --prov Friesland \
                                              --input bag/db/data/gemeentelijke-indeling.xml \
                                              --verbose

        2. Voeg de nieuwe gemeente toe aan de meest recente indeling
           $ python gemeentelijke-indeling.py --add-gemeente \
                                              --code 1940 \
                                              --name "De Fryske Marren" \
                                              --date 2015-07-01 \
                                              --prov Friesland \
                                              --input bag/db/data/gemeentelijke-indeling.xml \
                                              --verbose

        3. Voeg de gemeentelijke indeling voor 2016 toe
           $ python gemeentelijke-indeling.py --add-cbs-data \
                                              --file bag/db/data/oud/gemeentenalfabetisch2016.xls \
                                              --input bag/db/data/gemeentelijke-indeling.xml \
                                              --verbose
    """
    parser = ArgParser(usage=os.path.basename(__file__) + ' <ACTION> -i <PATH> [-o <PATH>] [OPTIONS]', add_help=False)

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--add-cbs-data', action='store_true', help='Add CBS spreadsheet data for next year (Requires option: --file)')
    group.add_argument('--end-gemeente', action='store_true', help='Set einddatum attribute for gemeente (Requires option: --code, --date, --prov)')
    group.add_argument('--add-gemeente', action='store_true', help='Create new gemeente element (Requires option: --code, --name, --date, --prov)')
    group.add_argument('--provincie-map', action='store_true', help='Display provicie map (code & name)')

    parser.add_argument('-i', '--input', metavar='<PATH>', help='Path to gemeentelijke-indeling XML file to read', required=True)
    parser.add_argument('-o', '--output', metavar='<PATH>', help='Path to gemeentelijke-indeling XML file to write')
    parser.add_argument('-f', '--file', metavar='<PATH>', help='Path to CBS Excel spreadsheet to process')

    parser.add_argument('-C', '--code', metavar='<NUMBER>', help='Numerical gemeentecode')
    parser.add_argument('-N', '--name', metavar='<STRING>', help='Alphanumerical gemeentenaam')
    parser.add_argument('-D', '--date', metavar='<DATE>', help='Date in YYYY-MM-DD format')
    parser.add_argument('-P', '--prov', metavar='<NAME|CODE>', help='Parent provincie of gemeente')

    parser.add_argument('-n', '--dry-run', action='store_true', help='Don\'t overwrite the file, display instead')
    parser.add_argument('-d', '--debug', action='store_true', help='Enable debug output')
    parser.add_argument('-v', '--verbose', action='store_true', help='Enable verbose output')
    parser.add_argument('-h', '--help', action='store_true', help='Display this usage information')

    args = parser.parse_args()

    if args.help:
        show_help()
        sys.exit(1)

    # Required options
    if args.add_cbs_data and not args.file:
        parser.error('Missing required option: --file')

    if args.end_gemeente and not args.prov:
        parser.error('Missing required option: --prov')
    elif args.end_gemeente and not args.code:
        parser.error('Missing required option: --code')
    elif args.end_gemeente and not args.date:
        parser.error('Missing required option: --date')

    if args.add_gemeente and not args.prov:
        parser.error('Missing required option: --prov')
    elif args.add_gemeente and not args.code:
        parser.error('Missing required option: --code')
    elif args.add_gemeente and not args.name:
        parser.error('Missing required option: --name')
    elif args.add_gemeente and not args.date:
        parser.error('Missing required option: --date')

    # Sanity checks
    if args.date and not re.search("^\d{4}-\d{2}-\d{2}$", args.date):
        parser.error('Invalid date format, use YYYY-MM-DD')

    # Use the same file for input and output by default
    if not args.output:
        args.output = args.input

    gemeentelijke_indeling = parse_gemeentelijke_indeling(args)

    provincie_map = get_provincie_map(args, gemeentelijke_indeling)

    if args.provincie_map:
        display_provincie_map(args, provincie_map)
        sys.exit(0)
    elif args.end_gemeente:
        gemeentelijke_indeling = end_gemeente(args, gemeentelijke_indeling, provincie_map)
    elif args.add_gemeente:
        gemeentelijke_indeling = add_gemeente(args, gemeentelijke_indeling, provincie_map)
    elif args.add_cbs_data:
        cbs_data = parse_cbs_data(args)

        gemeentelijke_indeling = add_cbs_data(args, gemeentelijke_indeling, cbs_data)
    else:
        parser.error("Unsupported option")

    write_gemeentelijke_indeling(args, gemeentelijke_indeling)

    sys.exit()


if __name__ == "__main__":
    main()
