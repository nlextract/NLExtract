#!/bin/bash

# Sparse checkout is used, since only BAG-extract is needed. Also, a revert to a known working version takes place,
# and the GIT history is discarded as well. This image isn't intended to act as a NLExtract development environment.

# Pull the sources
cd /opt
git init nlextract
cd /opt/nlextract
git remote add origin https://github.com/nlextract/NLExtract.git
git config core.sparsecheckout true
echo "bag/*" >> .git/info/sparse-checkout
git pull origin master

# Revert to situation of Sept. 1, 2016
git reset --hard cb3a294 --

# History is not needed, so remove it
rm -rf .git


