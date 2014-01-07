
CREATE TEMP TABLE c(ac TEXT, beg TEXT, fin TEXT, num INTEGER, op TEXT, loc TEXT);
\copy c FROM 'Kody_ABC-3kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER);
\copy c FROM 'Kody_ABC-4kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER);
\copy c FROM 'Kody_ABC-8kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER);
\copy c FROM 'Kody_DEF-9kh.csv' (FORMAT CSV, DELIMITER ';', ENCODING 'Windows-1251', HEADER);

