#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-05 00:29:40 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR
mkdir -p results
psql $* << ***
\o results/loc.sql
\qecho BEGIN;
\qecho DELETE FROM loc;
\qecho 'COPY loc (pref, len, beg, fin, op, loc) FROM stdin;'
COPY (SELECT * FROM loc ORDER BY pref, fin, op, loc) TO STDOUT; -- WITH CSV HEADER;
\qecho '\\\\.'
\qecho COMMIT;
***


