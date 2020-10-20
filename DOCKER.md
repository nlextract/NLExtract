# NLExtract Docker

## Create Postgis database container
```
docker run -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v "${PWD}:/app" -v "${PWD}/postgres:/var/lib/postgresql/data" --name postgis -t -d mdillon/postgis
```


## Build NLExtract Docker image
Build the NLExtract Docker image:
```
docker build --tag nlextract .
```

Create `bag` database:
```
docker exec -i -t postgis /bin/bash -c "createdb --user postgres --owner postgres -T template_postgis -E UTF8 bag"
```

Initialise the `bag` database with tables:
```
docker run -v "${PWD}:/app" --network=host nlextract sh /app/bag/bin/bag-extract.sh -c -j -d bag -v
```

## Download files from PDOK
Download all files:
```
curl -O http://geodata.nationaalgeoregister.nl/inspireadressen/extract/inspireadressen.zip
unzip inspireadressen.zip -d inspireadressen
```

Import all XML files into the Postgis database:
```
for i in inspireadressen/*.zip; do
    docker run -v "${PWD}:/app" --network=host nlextract python3 /app/bag/src/bagextract.py -e "/app/$i"
done
```

Run the `gemeente-provincie-tabel.sql` script on the Postgis database:
```
docker run -v "${PWD}:/app" --network=host nlextract python3 /app/bag/src/bagextract.py -v -q /app/bag/db/script/gemeente-provincie-tabel.sql
```

Join tables to the `adres` table:
```
docker exec -i -t postgis /bin/bash -c "psql --user postgres -d bag < /app/bag/db/script/adres-tabel.sql"
```
