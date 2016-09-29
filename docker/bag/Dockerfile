FROM python:2.7

MAINTAINER Frank Steggink / NLExtract <frank@steggink.it>

# Set Dutch timezone: it is assumed that most users of BAG-extract will be executed from the Netherlands
ENV TZ Europe/Amsterdam

# Enable ls colors/aliases
RUN sed -i '9 s/^# //' ~/.bashrc
RUN sed -i '11,13 s/^# //' ~/.bashrc

# Install utilities
RUN apt-get update

# Install GDAL development libraries
RUN apt-get install -y libgdal-dev
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal

# Install nginx
RUN apt-get install -y nginx-full

# Add BAG-extract, using Git
COPY get-bagextract.sh /
RUN /get-bagextract.sh

# Install Python dependencies and BAG-extract webservices
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

ADD app/ /usr/src/app/

# Copy BAG-extract configuration
COPY extract.conf /opt/nlextract/bag/extract.conf

# Replace nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

# Add a volume to exchange data
VOLUME /data

# Start all processes
COPY init.sh /
USER root
CMD ["/init.sh"]
  
# BAG database opnieuw initialiseren: python /opt/nlextract/bag/src/bagextract.py -cj
# BAG data laden: python /opt/nlextract/bag/src/bagextract.py -e <pad_naar_bestand>
