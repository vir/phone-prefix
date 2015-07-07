
CREATE OR REPLACE FUNCTION info(num TEXT) RETURNS TEXT AS $$
	-- Timezone in Postgresql expressed to the WEST from UTC!
	SELECT concat_ws(E'\n', op, loc, loc.reg, 'Временная зона: UTC'||TO_CHAR(tz.tz, 'SGFM99'),
		'Местное время: '||TO_CHAR(CURRENT_TIMESTAMP AT TIME ZONE ('UTC'||TO_CHAR(-tz.tz, 'SGFM99')), 'HH24:MI'))
	FROM loc LEFT JOIN tz
		ON (tz.np = loc.loc AND (loc.reg IS NULL OR loc.reg LIKE '%' || tz.reg OR tz.reg LIKE loc.reg || '%' OR tz.reg = loc.loc))
		OR ((loc.loc LIKE tz.np||' %' OR loc.loc LIKE tz.np||'ая область') AND loc.reg IS NULL)
	WHERE (LENGTH($1) = len AND $1 BETWEEN beg AND fin) OR ($1 LIKE pref || '%') ORDER BY LENGTH(fin) DESC, LENGTH(pref);
$$ LANGUAGE SQL;


