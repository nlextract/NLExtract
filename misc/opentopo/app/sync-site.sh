#!/bin/sh
rsync -alzvx -e ssh  . kadmin@kademo:/var/www/nlextract.nl/app/ot
scp index-m.html kadmin@kademo:/var/www/nlextract.nl/app/index.html




