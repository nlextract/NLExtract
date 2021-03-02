FROM osgeo/gdal:ubuntu-small-latest

LABEL maintainer="Just van den Broecke <justb4@gmail.com>"

# ARGS
ARG TIMEZONE="Europe/Amsterdam"

# ENV settings
ENV TZ=${TIMEZONE} \
   DEBIAN_FRONTEND="noninteractive" \
   DEB_PACKAGES="python3-lxml python3-psycopg2 python3-deprecated"

RUN \
	apt-get update \
	&& apt-get --no-install-recommends install -y ${DEB_PACKAGES} \
	&& cp /usr/share/zoneinfo/${TZ} /etc/localtime \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# Add Source Code under /nlx and make it working dir
ADD . /nlx
WORKDIR /nlx

# Run examples
# Default with testdata
# docker run --rm nlextract/nlextract:latest bagv2/etl/etl.sh
