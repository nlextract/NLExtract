docker run -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v "${PWD}:/app" -v "${PWD}/postgres:/var/lib/postgresql/data" --name postgis -t -d mdillon/postgis
