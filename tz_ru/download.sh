#!/bin/sh
#
# (c) vir
#
# Last modified: 2015-07-06 06:25:01 +0300
#


GET http://www.timezone.ru/index.php | iconv -f cp1251 | grep 'href="/suncalc.php?tid=' > index
perl -ne 'm#<a href="/suncalc.php\?tid=(\d+)" class="list" title="(.*?)">(.*?)</a># && print qq{$1,"$3","$2"\n};' index > cities.csv

IDS=`cut -d , -f 1 cities.csv`

rm -rf tmp
mkdir tmp

for ID in $IDS
do
	GET http://www.timezone.ru/suncalc.php?tid=${ID} | iconv -f cp1251 > tmp/city${ID}.html
	perl -ne 'if(/Географические координаты/ .. /Солнечный калькулято/) { next unless /<td>/; s/^\s*//s; s/<.*?>//sg; print; }' tmp/city${ID}.html > tmp/city${ID}.txt
	sleep $((ID%10))
done



