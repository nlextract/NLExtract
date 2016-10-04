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

#Add initialization files
ADD init/ /init/

# Replace nginx configuration
RUN cp /init/nginx.conf /etc/nginx/nginx.conf

# Install Python dependencies
RUN chmod +x /init/pip-install.sh
RUN /init/pip-install.sh

# Add BAG-extract, using Git
RUN chmod +x /init/get-bagextract.sh
RUN /init/get-bagextract.sh

# Install BAG-extract webservices
ADD app/ /usr/src/app/

# Copy BAG-extract configuration
COPY config/extract.conf /opt/nlextract/bag/extract.conf

EXPOSE 80

# Add a volume to exchange data
VOLUME /data

# Start all processes
COPY init.sh /
USER root
RUN chmod +x /init.sh
CMD ["/init.sh"]

# BAG database opnieuw initialiseren: python /opt/nlextract/bag/src/bagextract.py -cj
# BAG data laden: python /opt/nlextract/bag/src/bagextract.py -e <pad_naar_bestand>
