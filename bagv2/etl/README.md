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

## Geen Docker

Kan wel maar is hoge versie GDAL nodig, minimaal 3.2.2.

```
# Will use options/default.args
# Totaal NL - Override input file
./etl.sh -a bag_input_file=~/project/nlextract/data/BAG-2.0/BAGNLDL-08112020.zip

# Will use options/default.args
# Gemeente - Override input file and file extension - needs full zipfile unpack because of GDAL bug
 ./etl.sh -a schema=doesburg -a bag_input_file=test/BAGGEM0221L-15022021.zip
 
```

## Met Docker

Zie in aktie op Asciinema: https://asciinema.org/a/405701.

```
# pre: setup a PostGIS DB on your localhost with name bagv2 and postgres postgres credentials
 
# Build Docker Image - Optional, better or get the Image from DockerHub
# See https://hub.docker.com/repository/docker/nlextract/nlextract/
cd ../..
./build-docker.sh
cd -

# Get the Docker Image from Docker Hub
docker pull nlextract/nlextract:latest

# Case 1: Run without args: default small internal testdata set to test basic setup
# etl.sh can accept Stetl-based -a options
docker run --rm --name nlextract nlextract/nlextract:latest bagv2/etl/etl.sh 
echo "SELECT * FROM test.verblijfsobject" | psql bagv2
echo "\d+ test.verblijfsobject" | psql bagv2;   

# Case 2: single Municipality

# Create local work dir
mkdir work 

# Download a BAG XML file from https://extracten.bag.kadaster.nl/lvbag/extracten
# For example Doesburg (code 0221 march 2021): BAGGEM0221L-15032021.zip
curl -o work/bag.zip  https://extracten.bag.kadaster.nl/lvbag/extracten/Gemeente%20LVC/0221/BAGGEM0221L-15032021.zip

# Single Municipality (Gemeente)
# Override default PG schema and default input file via Docker Volume mapping and Stetl -a options:
docker run --name nlextract --rm -v $(pwd)/work:/work nlextract/nlextract:latest bagv2/etl/etl.sh -a schema=doesburg -a bag_input_file=/work/bag.zip

# Test result
echo "select count(gid) from doesburg.pand" | psql bagv2
# count 
# -------
#  13390
# (1 row)

# Case 3: Entire Netherlands (march 2021)
curl -o work/bag.zip  https://extracten.bag.kadaster.nl/lvbag/extracten/Nederland%20LVC/BAGNLDL-08032021.zip
docker run --name nlextract --rm -v $(pwd)/work:/work nlextract/nlextract:latest bagv2/etl/etl.sh -a bag_input_file=/work/bag.zip

# Stopping a process
docker stop nlextract

```

## Troubleshooting
### Process killed for macOS users
Als het process wordt gekilled tijdens het uitvoeren van `docker run --name nlextract --rm -v $(pwd)/work:/work nlextract/nlextract:latest bagv2/etl/etl.sh -a bag_input_file=/work/bag.zip`, kan het zijn dat Docker niet genoeg werkgeheugen tot zijn beschikking heeft. Als je Docker for Mac/Desktop gebruikt kan je meer gewerkgeheugen (RAM) toekennen in Preferences/Resources. Overweeg bijvoorbeeld 8GB. 
