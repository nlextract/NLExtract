FROM ghcr.io/osgeo/gdal:ubuntu-small-3.9.1

LABEL maintainer="Just van den Broecke <justb4@gmail.com>"

# ARGS
ARG TIMEZONE="Europe/Amsterdam"
ARG POSTGRES_VERSION="11"

# ENV settings
ENV TZ=${TIMEZONE} \
   DEBIAN_FRONTEND="noninteractive" \
   DEB_PACKAGES="wget unzip zip postgresql-client-${POSTGRES_VERSION} openssh-client python3-lxml python3-psycopg2 python3-deprecated python3-openpyxl python3-xlrd tzdata" \
   APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE="DontWarn"

# https://www.ubuntuupdates.org/ppa/postgresql?dist=focal-pgdg need PG client version 10
# old: 	curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - 
# https://www.ubuntuupdates.org/ppa/postgresql?
# or use ARGS for other versions
RUN \
	apt-get update && apt-get --no-install-recommends install -y gnupg ca-certificates \
    && curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null \
	&& sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ noble-pgdg main" >> /etc/apt/sources.list.d/postgresql.list' \
	&& apt-get -y update \
	&& apt-get --no-install-recommends install -y ${DEB_PACKAGES} \
	&& cp /usr/share/zoneinfo/${TZ} /etc/localtime \
	&& dpkg-reconfigure --frontend=noninteractive tzdata

# Add Source Code under /nlx and make it working dir
ADD . /nlx
WORKDIR /nlx

# Run examples
# Default with testdata
# docker run --rm nlextract/nlextract:latest bagv2/etl/etl.sh
