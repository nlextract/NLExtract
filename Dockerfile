FROM ubuntu:18.04

RUN apt-get update

RUN apt-get install python3 python3-pip libpq-dev -y

RUN apt-get install libxml2 libxslt1.1 python3-lxml -y

RUN apt-get install gdal-bin python3-gdal -y
RUN pip3 install psycopg2 configparser