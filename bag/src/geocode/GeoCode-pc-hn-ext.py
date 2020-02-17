import os
import io
import csv
#import time
import codecs
import psycopg2
from psycopg2.extensions import AsIs
from decimal import Decimal

#set default args as -h , if no args:
if len(sys.argv) == 1: sys.argv[1:] = ["-h"]

if sys.argv[1] == "-h":
    print('Usage: '+os.path.basename(sys.argv[0])+' <input file name> <input adres name>')
    print('Input format: postcode;huisnummer;toevoeging;<extra data columns>')
    print('Input File format: signed UTF-8 (With BOM), can be changed by editing this script @ line 32')
    print('The <extra data columns> are added to the signed UTF-8 output file after the BAG data columns')
    print('<input adres name> to rename the \'Input adres\' column. \'Input\' is replaced with the given name')
    print('Example: GeoCode-pc-hn-ext.py Postcodelijst-KPN.csv KANVAS  to geocode the KPN KANVAS list')
    sys.exit(0)

InputFile = sys.argv[1].rstrip('.csv')+'.csv'
print('InputFile =', InputFile)

# Input CSV with postcode;huisnummer;toevoeging;<extra data columns>
# encoding = utf-8-sig, utf8, ISO-8859-1, windows-1252
SIDFile = codecs.open(InputFile, 'r', encoding='utf-8-sig') # open input file
SIDReader = csv.reader(SIDFile,delimiter=';')

# Output file name
OutputFile = InputFile.rstrip('.csv')+'-geocoded.csv'
print('OutputFile =', OutputFile)

if len(sys.argv)>2:
    InAdres = sys.argv[2]+' adres'
else:
    InAdres = 'Input adres'
print('Input adres name =', InAdres)

header=next(SIDReader) # Read first line
ncol=len(header) # Count columns
#print('Number of columns = ', ncol)
#print('Header = ', header)

if ncol<3:
    print('Only', ncol, 'columns in input file! Minimum is: postcode;huisnummer;toevoeging')
    sys.exit(2)
else:
    print('Adding', (ncol-3), 'columns to output file')

SID = list(SIDReader)
rowcount = 0
uid = 1
row_count = sum(1 for row in SID) #Count rows
#print('Number of rows = ', row_count)

# Column Selection from database
SEL = "nummeraanduiding, adresseerbaarobject, pandid, pandstatus, pandbouwjaar, openbareruimtenaam, postcode, huisnummer, huisletter, huisnummertoevoeging, woonplaatsnaam, gemeentenaam, provincienaam, verblijfsobjectgebruiksdoel, oppervlakteverblijfsobject, verblijfsobjectstatus, typeadresseerbaarobject, nevenadres, st_x(ST_transform(geopunt, 4326)), st_y(ST_transform(geopunt, 4326)), st_x(geopunt), st_y(geopunt)"

# Open database connection
conn = psycopg2.connect(database="bag", user="kademo", password="kademo", host="127.0.0.1", port="5432")
cur = conn.cursor()

# Write CSV header
with io.open(OutputFile, 'a', encoding='utf-8-sig') as logfile:
    logfile.write(u"UID;%s;nummeraanduiding;adresseerbaarobject;pandid;pandstatus;pandbouwjaar;openbareruimtenaam;postcode;huisnummer;huisletter;huisnummertoevoeging;woonplaatsnaam;gemeentenaam;provincienaam;verblijfsobjectgebruiksdoel;oppervlakteverblijfsobject;verblijfsobjectstatus;typeadresseerbaarobject;nevenadres;lon;lat;rd_x;rd_y;Dubbeling" % InAdres)
    for item in header[3:]: #add input header minus first 3 columns
        logfile.write(u";%s" % item)
    logfile.write(u"\n")
    logfile.flush()
    logfile.close()

for row in SID:
    # Convert PC to uppercase
    pc = row[0].upper()
    hn = row[1]
    tv = row[2]
    ht = ''
    req = pc+" "+hn+" "+tv
    req = req.strip()
    mult = ''

    #print('Requested Postcode =', req)
    print('Progress = ', ((uid*100)/row_count), '%\r',)
    rowcount += 1

    if pc == '':
        print('Line',rowcount+1,'without Postcode found! skipping!\n')
        uid += 1
        continue

# split toevoeging into huisletter and huisnummertoevoeging
    if len(row[2]) == 1:
        if row[2].isalpha():
            hl = row[2]
            ht = ''
        else:
            hl = ''
            ht = row[2]
    else:
        ht = row[2]
        hl = ''

    #print('Postcode =', pc, "huisnummer", hn, "toevoeging", tv, "gesplitst in huisletter", hl, " en huisnummertoevoeging", ht)


    if hl == "" and ht == "":
        #print("PC+HN")
        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND huisnummertoevoeging IS NULL AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1],))
    elif hl == "":
        #print("PC+HN+ht")
        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND LOWER(huisnummertoevoeging) = LOWER(%s) AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1], ht,))
    elif ht == "":
        #print("PC+HN+HL")
        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND LOWER(huisletter) = LOWER(%s) AND huisnummertoevoeging IS NULL AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1], hl,))
    else:
        #print("PC+HN+HL+ht")
        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND LOWER(huisletter) = LOWER(%s) AND LOWER(huisnummertoevoeging) = LOWER(%s) AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1], hl, ht,))

    rows = cur.fetchall()

    if cur.rowcount < 1 and not hl == '':
        #print("No location found Trying PC+HN+(hl as ht)")
        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND LOWER(huisnummertoevoeging) = LOWER(%s) AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1], hl,))
        rows = cur.fetchall()

#    if cur.rowcount < 1 :
#        #print("No location found Trying PC+HN only")
#        cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND huisnummertoevoeging IS NULL AND left(verblijfsobjectstatus, 26) = 'Verblijfsobject in gebruik'", (AsIs(SEL), row[0], row[1],))
#        rows = cur.fetchall()

    if cur.rowcount < 1 :
        #print("No location found, trying not existing VBO!\n")


        if hl == "" and ht == "":
            #print("PC+HN")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND huisnummertoevoeging IS NULL", (AsIs(SEL), row[0], row[1],))
        elif hl == "":
            #print("PC+HN+ht")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND LOWER(huisnummertoevoeging) = LOWER(%s)", (AsIs(SEL), row[0], row[1], ht,))
        elif ht == "":
            #print("PC+HN+HL")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND LOWER(huisletter) = LOWER(%s) AND huisnummertoevoeging IS NULL", (AsIs(SEL), row[0], row[1], hl,))
        else:
            #print("PC+HN+HL+ht")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND LOWER(huisletter) = LOWER(%s) AND LOWER(huisnummertoevoeging) = LOWER(%s)", (AsIs(SEL), row[0], row[1], hl, ht,))
    
        rows = cur.fetchall()
    
        if cur.rowcount < 1 and not hl == '':
            #print("No location found Trying PC+HN+(hl as ht)")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND LOWER(huisnummertoevoeging) = LOWER(%s)", (AsIs(SEL), row[0], row[1], hl,))
            rows = cur.fetchall()
    
        if cur.rowcount < 1 :
            #print("No location found Trying PC+HN only")
            cur.execute("SELECT %s FROM geo_adres_full WHERE postcode = %s AND huisnummer = %s AND huisletter IS NULL AND huisnummertoevoeging IS NULL", (AsIs(SEL), row[0], row[1],))
            rows = cur.fetchall()
    
    #print("number of location(s)", cur.rowcount, "\n")

    if cur.rowcount < 1 :
        #print("No location found!\n")
        with io.open(OutputFile, 'a', encoding='utf-8-sig') as logfile:
            logfile.write(u"%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s" % (uid,req,'','','','','','Actueel BAG adres onbekend','','','','','','','','','','','','',0,0,0,0,mult))
            for item in range(ncol-3):
                logfile.write(u";%s" % row[3+item])
            logfile.write(u"\n")
            logfile.flush()
            logfile.close()
        uid += 1
        continue

    mult = ''
    if cur.rowcount > 1 :
        row_count += (cur.rowcount-1)
        mult = str(cur.rowcount)+' VBO\'s op 1 adres'
        #print("More than one object found in BAG database!")
        #print('Requested Postcode =', pc, "huisnummer", hn, "huisnummertoevoeging", tv, "\n")
    else:
        mult = ''

    for brow in rows:
        nummeraanduiding = brow[0]
        adresseerbaarobject =  brow[1]
        pandid =  brow[2]
        pandstatus =  brow[3]
        pandbouwjaar =  brow[4]
        openbareruimtenaam = brow[5].decode('utf-8')
        postcode = brow[6]
        huisnummer = brow[7]
        huisletter = {None:''}.get(brow[8],brow[8])
        huisnummertoevoeging =  {None:''}.get(brow[9],brow[9])
        woonplaatsnaam = brow[10]
        gemeentenaam = brow[11]
        provincienaam = brow[12]
        verblijfsobjectgebruiksdoel = brow[13]
        oppervlakteverblijfsobject = brow[14]
        verblijfsobjectstatus = brow[15]
        typeadresseerbaarobject = brow[16]
        nevenadres = brow[17]
        lon = "{:.14f}".format(Decimal(brow[18])).rstrip('0').rstrip('.').replace(".",",")
        lat = "{:.14f}".format(Decimal(brow[19])).rstrip('0').rstrip('.').replace(".",",")
        rd_x = "{:.3f}".format(Decimal(brow[20])).rstrip('0').rstrip('.').replace(".",",")
        rd_y = "{:.3f}".format(Decimal(brow[21])).rstrip('0').rstrip('.').replace(".",",")

        #print("nummeraanduiding = ", nummeraanduiding)
        #print("adresseerbaarobject = ", adresseerbaarobject)
        #print("pandid = ", pandid)
        #print("pandstatus = ", pandstatus)
        #print("pandbouwjaar = ", pandbouwjaar)
        #print("openbareruimtenaam = ", openbareruimtenaam)
        #print("postcode = ", postcode)
        #print("huisnummer = ", huisnummer)
        #print("huisletter = ", huisletter)
        #print("huisnummertoevoeging = ", huisnummertoevoeging)
        #print("woonplaatsnaam = ", woonplaatsnaam)
        #print("gemeentenaam = ", gemeentenaam)
        #print("provincienaam = ", provincienaam)
        #print("verblijfsobjectgebruiksdoel = ", verblijfsobjectgebruiksdoel)
        #print("oppervlakteverblijfsobject = ", oppervlakteverblijfsobject)
        #print("lon = ", lon)
        #print("lat = ", lat)
        #print("rd_x = ", rd_x)
        #print("rd_y = ", rd_y, "\n")

        with io.open(OutputFile, 'a', encoding='utf-8-sig') as logfile:
            logfile.write(u"%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s;%s" % (uid,req,nummeraanduiding,adresseerbaarobject,pandid,pandstatus,pandbouwjaar,openbareruimtenaam,postcode,huisnummer,huisletter,huisnummertoevoeging,woonplaatsnaam,gemeentenaam,provincienaam,verblijfsobjectgebruiksdoel,oppervlakteverblijfsobject,verblijfsobjectstatus,typeadresseerbaarobject,nevenadres,lon,lat,rd_x,rd_y,mult))
            for item in range(ncol-3):
                logfile.write(u";%s" % row[3+item])
            logfile.write(u"\n")
            logfile.flush()
            logfile.close()
        uid += 1
conn.close()
