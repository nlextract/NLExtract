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

pushd ${id}
# Take only relevant dirs from checked out GH sources
# Remove dirs not to be included
excludes="*.sh .git externals/stetl/.git externals/stetl/examples 3d ahn2 bag/build bag/dist bgt/data bgt/doc bgt/style bonnebladen brk/dkk opentopo tools top10nl/test top10nl/doc"
/bin/rm -rf ${excludes}

# Make .sh files executable
find . -name *.sh | xargs chmod +x
popd

# create archives .tar.gz and .zip
tar -zcvf ${target} ${id}

target="${id}.zip"
zip -r ${target} ${id}
