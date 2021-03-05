# ETL for BAG v2

De ETL voor BAG v2 is volledig met Stetl opgezet. 

De Stetl opzet is uitgebreider als bij de andere basis-registraties als BGT en BRK.
Heeft alles te maken met BAG model en met name de BAG Extract brondata levering. 
De voornaamste kenmerken daarvan zijn:

* "Custom XML" met GML Namespaces. BAG is geen GML!
* reflecteert genormaliseerd data model (aparte Openbareruimte bestanden etc)
* bestanden zijn genest in .zip files, voor gemeenten tot 3 levels (zip in zip in zip)!
 
Toch was er geen custom Python nodig: de BAG v2 wordt geheel verwerkt met Stetl.
De belangrijkste functies die via Stetl worden aangewend:

* [GDAL LVBAG Driver](https://gdal.org/drivers/vector/lvbag.html) (GDAL v3.2.2 of hoger nodig)
* [GDAL VSI](https://gdal.org/user/virtual_file_systems.html) Zip handlers voor geneste .zip files
* XSLT voor "niet-BAG-model" XML-bestanden zoals Woonplaats-Gemeenten en Leverings
* CSV input naar Postgres output voor CBS Gemeenten en Provincies

## No Docker

Kan wel maar is hoge versie GDAL nodig, minimaal 3.2.2.

```
# Will use options/default.args
# Totaal NL - Override input file
./etl.sh -a bag_input_file=~/project/nlextract/data/BAG-2.0/BAGNLDL-08112020.zip

# Will use options/default.args
# Gemeente - Override input file and file extension - needs full zipfile unpack because of GDAL bug
./etl.sh -a schema=doesburg -a bag_file_ext=xml -a temp_file_path_prepend= -a bag_input_file=~/project/nlextract/data/BAG-2.0/BAGGEM0221L-Doesburg-15092020.zip

```

## Test with Docker

```
# pre: setup a PostGIS DB on your localhost with name bagv2 and postgres postgres credentials
 
# Build Docker Image
cd ../..
./build-docker.sh
cd -

# With small testdata set, etl.sh can accept Stetl-based -a options
docker run --rm --name nlextract nlextract/nlextract:latest bagv2/etl/etl.sh 
echo "SELECT * FROM test.verblijfsobject" | psql bagv2
echo "\d+ test.verblijfsobject" | psql bagv2;   

# Download a BAG XML file from https://extracten.bag.kadaster.nl/lvbag/extracten
# We Docker Volume-map that file to the default testfile named
# /nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip 

# Single Municipality (Gemeente)
# Override default schema and force XML processing for Gemeente Leveringen (needed, see GDAL bug):
docker run --name nlextract --rm -v $(pwd)/test/BAGGEM0221L-15022021.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract/nlextract:latest bagv2/etl/etl.sh -a schema=doesburg -a bag_file_ext=xml -a temp_file_path_prepend= 

# Entire Netherlands
docker run --name nlextract --rm -v /Users/just/project/nlextract/data/BAG-2.0/BAGNLDL-08112020.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract/nlextract:latest bagv2/etl/etl.sh

# Stopping a process
docker stop nlextract

```
   