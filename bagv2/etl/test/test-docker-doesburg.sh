docker run --name nlextract --rm -v $(pwd)/BAGGEM0221L-15022021.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract/nlextract:latest bagv2/etl/etl.sh -a schema=doesburg
