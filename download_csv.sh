#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-03 18:11:28 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR

rm -rf cache
mkdir cache
cd cache

$DIR/tools/wikipedia_codes_ru.pl | grep -v 'XXX' > codes_ru.csv
$DIR/tools/areas/get_ru.sh

cd ..


