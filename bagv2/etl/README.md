# ETL for BAG v2


## Test with Docker

```
# pre: setup a PostGIS DB on your localhost with name bagv2 and postgres postgres credentials
 
# Build Docker Image
cd ../..
./build-docker.sh
cd -

# With small testdata set, etl.sh can accept Stetl-based -a options
docker run --rm --name nlextract nlextract:latest bagv2/etl/etl.sh 
echo "SELECT * FROM test.verblijfsobject" | psql bagv2
echo "\d+ test.verblijfsobject" | psql bagv2;   

# Download a BAG XML file from https://extracten.bag.kadaster.nl/lvbag/extracten
# We Docker Volume-map that file to the default testfile named
# /nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip 

# Single Municipality (Gemeente)
docker run --name nlextract --rm -v $(pwd)/test/BAGGEM0221L-15022021.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract:latest bagv2/etl/etl.sh

# Override default schema:
docker run --name nlextract --rm -v $(pwd)/test/BAGGEM0221L-15022021.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract:latest bagv2/etl/etl.sh -a schema=doesburg

# Entire Netherlands
docker run --name nlextract --rm -v /Users/just/project/nlextract/data/BAG-2.0/BAGNLDL-08112020.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract:latest bagv2/etl/etl.sh

# Stopping a process
docker stop nlextract

```
   