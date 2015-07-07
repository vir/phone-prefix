#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-06 11:24:34 +0300
#

DIR=$(dirname $(readlink -f "$0"))
cd $DIR

C=$DIR/cache

for f in Kody_ABC-3kh.csv Kody_ABC-4kh.csv Kody_ABC-8kh.csv Kody_DEF-9kh.csv
do
	perl -i -nle 's/\&quot;/"/sg; print unless /^\s*$/s' $C/$f
done

psql $* << ***

-- \i load_wpr.sql
CREATE TEMP TABLE wpr(pr TEXT, wplink TEXT, loc TEXT);
\copy wpr FROM '$C/codes_ru.csv' (FORMAT CSV, DELIMITER '|', ENCODING 'UTF-8', HEADER);

-- \i areas/load_ru.sql
CREATE TEMP TABLE c(ac TEXT, beg TEXT, fin TEXT, num INTEGER, op TEXT, loc TEXT);
\copy c FROM '$C/Kody_ABC-3kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER, QUOTE '@');
\copy c FROM '$C/Kody_ABC-4kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER, QUOTE '@');
\copy c FROM '$C/Kody_ABC-8kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER, QUOTE '@');
\copy c FROM '$C/Kody_DEF-9kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER, QUOTE '@');

-- latest updates
UPDATE c SET loc = REGEXP_REPLACE(loc, ' - ', '-', 'g');
ALTER TABLE c ADD reg TEXT;
UPDATE c SET reg = REGEXP_REPLACE(loc, '(.*?)\s*\|\s*(.*)', '\2'), loc = REGEXP_REPLACE(loc, '^(.*?)\s*\|\s*(.*)$', '\1') WHERE loc LIKE '%|%';

-- \i prc.sql
BEGIN;

CREATE TABLE IF NOT EXISTS loc(pref TEXT, len SMALLINT, beg TEXT, fin TEXT, op TEXT, loc TEXT, reg TEXT);
DELETE FROM loc;
INSERT INTO loc(len, beg, fin, op, loc, reg) SELECT 2 + LENGTH(ac) + LENGTH(fin), '+7' || ac || beg, '+7' || ac || fin, op, loc, reg FROM c;
INSERT INTO loc(pref, loc) SELECT pr, loc FROM wpr;

CREATE OR REPLACE FUNCTION loc(num TEXT) RETURNS TEXT AS \$\$
	SELECT concat_ws(E'\n', op, loc, reg) FROM loc WHERE (LENGTH(\$1) = len AND \$1 BETWEEN beg AND fin) OR (\$1 LIKE pref || '%') ORDER BY LENGTH(fin) DESC, LENGTH(pref);
\$\$ LANGUAGE SQL;

COMMIT;

***


