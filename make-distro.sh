#!/bin/bash
#
# Make a distribution: check out from Git (including Stetl) and create .tar.gz and .zip.
#

function usage() {
	echo "Usage: $0 versie [GitHub branch]"
	echo "bijv: $0 1.4.1 master"
	exit 1
}

# At least version needed
VERSION=${1}
BRANCH=${2:-master}

[[ -z ${VERSION} ]] && usage

# Vars
DISTRO_NAME="nlextract-${VERSION}"
DISTRO_TAR_GZ="${DISTRO_NAME}.tar.gz"
DISTRO_ZIP="${DISTRO_NAME}.zip"

# Clean existing version resources
/bin/rm -rf ${DISTRO_NAME} ${DISTRO_TAR_GZ} ${DISTRO_ZIP} > /dev/null 2>&1

# Get clone from git of BRANCH into VERSION dir
git clone -b ${BRANCH} --single-branch --recursive https://github.com/nlextract/NLExtract.git ${DISTRO_NAME}

# Create documentation
pushd ${DISTRO_NAME}/doc
make html
/bin/rm -rf source make.bat Makefile
mv build/html/* .
/bin/rm -rf build
popd

# Prepare distro files

# Take only relevant dirs from checked out GH sources
# Remove dirs not to be included
pushd ${DISTRO_NAME}
excludes="*.sh .git .gitignore .gitmodules .flake8 externals/stetl/.git externals/stetl/.gitignore bag/build bag/dist bgt/data bgt/doc bgt/style brk/info brt/top10nl/doc brt/top10nl/style"
/bin/rm -rf ${excludes} > /dev/null 2>&1

# Make .sh files executable
find . -name *.sh | xargs chmod +x
popd

# create archives .tar.gz and .zip
tar -zcvf ${DISTRO_TAR_GZ} ${DISTRO_NAME}
zip -r ${DISTRO_ZIP} ${DISTRO_NAME}

echo "ALL DONE: ${DISTRO_TAR_GZ} and ${DISTRO_ZIP}"
