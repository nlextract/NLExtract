docker run -v ${PWD}/postgres:/var/lib/postgresql/data -e POSTGRES_PASSWORD=postgres -p 5432:5432 -v "${PWD}:/app" --name postgis mdillon/postgis
