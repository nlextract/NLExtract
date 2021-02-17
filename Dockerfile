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
RUN rm -rf .git externals/stetl/.git externals/stetl/examples

# Run examples
# docker run --rm nlextract:latest /nlx/bagv2/etl/etl.sh
# docker run --rm nlextract:latest /nlx/bagv2/etl/etl.sh options/docker.args
# docker run --rm -v $(pwd):/work -w /work nlextract:latest /nlx/bagv2/etl/etl.sh
# docker run --rm -v /Users/just/project/nlextract/data/BAG-2.0/BAGNLDL-08112020.zip:/nlx/bagv2/etl/test/data/lv/BAGNLDL-08112020-small.zip nlextract:latest /nlx/bagv2/etl/etl.sh options/docker.args
