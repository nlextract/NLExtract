#!/bin/bash
#
# Make a distribution: check out from Git (including Stetl) and create .tar.gs
#

# provide version via commandline: if none given, use datetime
version=$1
if [ -z "$version" ]; then
	version=`date +%Y%H%d-%H%M`
fi

id="nlextract-${version}"
target="${id}.tar.gz"

/bin/rm -f ${target} > /dev/null 2>&1

# get clone from git into version dir
git clone  --recursive https://github.com/nlextract/NLExtract.git ${id}

# create documentation
pushd ${id}/doc
make html
/bin/rm -f make.bat Makefile
/bin/rm -rf source
mv build/html/* .
/bin/rm -rf build
popd

# Take only relevant dirs
excludes="--exclude=.git --exclude=externals/stetl/.git  --exclude=3d --exclude=ahn2 --exclude=bag/build --exclude=bag/dist --exclude=bgt/data --exclude=bgt/doc --exclude=bonnebladen --exclude=opentopo --exclude=tools --exclude=top10nl/test --exclude=top10nl/doc"

# create archive
tar -zcvf ${target} ${excludes} ${id}

# target="${id}.zip"
# zip -9 -r ${excludes} ${target} ${id}
