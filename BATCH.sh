#!/bin/sh -e
#
# (c) vir
#
# Last modified: 2015-07-05 00:25:12 +0300
#

if [ -z "$*" ]
then
	echo "Usage: $0 [other_psql_opts] database"
	exit 1
fi

DIR=$(dirname $(readlink -f "$0"))
cd $DIR

./download_csv.sh $*
./load_database.sh $*
./dump_database.sh $*


