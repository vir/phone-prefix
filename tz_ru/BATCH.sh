#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-06 14:39:11 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR

#./download.sh
./parse.pl > timezones.csv


cat > tz.sql << ***
CREATE TABLE IF NOT EXISTS tz(id INTEGER, np TEXT, reg TEXT, msktz INTEGER, tz INTEGER, latdms TEXT, lat FLOAT, londms TEXT, lon FLOAT);
DELETE FROM tz;
\copy tz FROM STDIN (FORMAT CSV, DELIMITER ',', ENCODING 'UTF-8');
***
cat timezones.csv >> tz.sql
echo '\.' >> tz.sql




