docker build --tag nlextract .
docker exec -i -t postgis /bin/bash -c "createdb --user postgres --owner postgres -T template_postgis -E UTF8 bag"
docker run -v "${PWD}:/app" --network=host nlextract sh /app/bag/bin/bag-extract.sh -c -j -d bag -v
for i in inspireadressen/*.zip; do
    docker run -v "${PWD}:/app" --network=host nlextract python3 /app/bag/src/bagextract.py -e "/app/$i"
    break
done

docker run -v "${PWD}:/app" --network=host nlextract python3 /app/bag/src/bagextract.py -v -q /app/bag/db/script/gemeente-provincie-tabel.sql

# docker exec -i -t postgis /bin/bash -c "psql --user postgres -d bag < /app/bag/db/script/bag-view-actueel-bestaand.sql"
# docker exec -i -t postgis /bin/bash -c "psql --user postgres -d bag < /app/bag/db/script/geocode/geocode-tabellen.sql"

# docker exec -i -t postgis /bin/bash -c "psql --user postgres -d bag < /app/bag/db/script/adres-tabel.sql"
# docker exec -i -t postgis /bin/bash -c "psql --user postgres -d bag < /app/bag/db/script/gemeente-provincie-tabel.sql"
