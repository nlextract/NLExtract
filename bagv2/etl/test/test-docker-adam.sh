ADAM_ZIP="/Users/just/project/nlextract/data/BAG-2.0/BAGGEM0363L-15022021.zip"

docker run --name nlextract --rm -v ${ADAM_ZIP}:/nlx/bagv2/etl/test/data/lv/BAGNLDL-15092020-small.zip nlextract/nlextract:latest bagv2/etl/etl.sh -a schema=amsterdam
docker run --name nlextract --rm nlextract/nlextract:latest bagv2/etl/adres.sh -a schema=amsterdam
