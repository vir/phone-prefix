#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-05 00:19:41 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR

psql $* << ***
\o results/loc.sql
\qecho BEGIN;
\qecho DELETE FROM loc;
\qecho 'COPY loc (pref, len, beg, fin, op, loc) FROM stdin;'
COPY (SELECT * FROM loc ORDER BY pref, fin) TO STDOUT; -- WITH CSV HEADER;
\qecho '\\\\.'
\qecho COMMIT;
***


