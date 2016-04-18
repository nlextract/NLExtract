#!/bin/bash
#
# Excecute in git dir!
#

ts=`date +%Y%H%d-%H%M`
id="nlextract-${ts}"
target="${id}.tar.gz"
# rm ${target}
git clone  --recursive https://github.com/opengeogroep/NLExtract.git ${id}

excludes="--exclude=.git --exclude=externals/stetl/.git --exclude=bag/build --exclude=bag/dist --exclude=bgt/data --exclude=bgt/doc --exclude=bonnebladen --exclude=3d --exclude=ahn2 --exclude=opentopo --exclude=tools --exclude=top10nl/test --exclude=top10nl/doc"
tar -zcvf ${target}  ${excludes} ${id}

