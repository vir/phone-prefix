#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-05 00:41:02 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR
mkdir -p results
psql $* << ***
\o results/loc.sql
\qecho BEGIN;
\qecho CREATE TABLE IF NOT EXISTS loc(pref TEXT, len SMALLINT, beg TEXT, fin TEXT, op TEXT, loc TEXT);
\qecho DELETE FROM loc;
\qecho 'COPY loc (pref, len, beg, fin, op, loc) FROM stdin;'
COPY (SELECT * FROM loc ORDER BY pref, fin, op, loc) TO STDOUT;
\qecho '\\\\.'
\qecho 'CREATE OR REPLACE FUNCTION loc(num TEXT) RETURNS TEXT AS \\\$\\\$'
\qecho '	SELECT concat_ws(E\'\\\\n\', op, loc) FROM loc WHERE (LENGTH(\\\$1) = len AND \\\$1 BETWEEN beg AND fin) OR (\\\$1 LIKE pref || \'%\') ORDER BY LENGTH(fin) DESC, LENGTH(pref);'
\qecho '\\\$\\\$ LANGUAGE SQL;'
\qecho COMMIT;
***


