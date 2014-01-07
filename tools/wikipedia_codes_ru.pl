#!/usr/bin/perl -w
#
# (c) vir
#
# Last modified: 2014-01-07 09:09:25 +0400
#

use utf8;
use strict;
use warnings FATAL => 'uninitialized';
use FindBin;
use lib "$FindBin::Bin";
use WikipediaHelper;

binmode STDOUT, ':utf8';
my $wp = new WikipediaHelper('ru');
my $t = $wp->fetch_article_text('Список_телефонных_кодов_стран');
$t =~ s#^.*== Детализация ==##s;
$t =~ s#\s==[\w\s]+==\s.*$##s;
$t =~ s#\s=== Зона 0 ===\s.*$##s;

#print "$t\n";
my($znum, $zname, $cname);
foreach(split /\n/s, $t) {
	s/\s*$//s;
	s/\'\'\'//sg;
	s/\'\'//sg;
	s/&lt;ref&gt;.*?&lt;\/ref&gt;//sg;

	$cname = '' if /^\s*\*\s+/;

	if(/^===.*Зона\s+(\d+)\s+—\s+([\w\s,-]+)/)
	{
#		print "@@ z $1 = $_\n";
		$znum = $1;
		$zname = strip_format($2);
		$cname = '';
		add_code('+'.$znum, '', $zname);
	} elsif(/^\s*\*\s*\[\[([^\|\]]+)\]\]/) {
		$cname = $1;
	} elsif(/^\s*\*\*+\s*\[\[(?:([^\|\]]+)\|)?([^\]]+)\]\].*?—\s+(.*?)(?:\s+\(.*?\)\s*)?$/) { # for USA
		my $wp = $1 || $2;
		my $n = strip_format($2);
		foreach my $c(split /,\s*/, strip_spaces($3)) {
			add_code(strip_spaces("+$znum$c"), $wp, $n, $cname);
		}
	} elsif(/^\s*\*\s*(\d+)\s+[—-]\s+\[\[(?:([^\|\]]+)\|)?([^\]]+)\]\]/) {
		next if $3 eq 'не назначен';
		$cname = $3;
		add_code('+'.strip_spaces($1), $2 || $3, strip_format($3));
	} elsif(/^\s*\*\*\s*(\d+\s+\d+)\s+[—-]\s+\[\[(?:([^\|\]]+)\|)?([^\]]+)\]\]/) { # for '40 xxx'
		add_code('+'.strip_spaces($1), $2 || $3, strip_format($3), $cname);
	} elsif(/^\s*\*\s*(\d+)\s+—\s+(.+)/) { # no href
		next if $2 =~/^(?:не назначен|снят|принадлежал|зарезервирован|свободен|использовался)/;
		add_code('+'.$1, '', strip_format($2));
	} else {
		print "XXX $_\n";
	}
}

sub strip_spaces
{
	my($t) = @_;
	$t =~ s#\s+##sg;
	return $t;
}

sub strip_format
{
	my($t) = @_;
	$t =~ s/\&amp;ndash;/-/sg;
	$t =~ s/{{flag\|([^\}]+)}}/$1/sg;
	$t =~ s/\[\[([^\]]+)\]\]/$1/sg;
	$t =~ s/\[\[[^\|\]]+\|([^\]]+)\]\]/$1/sg;
	$t =~ s/{{cite.*?}}//sg;
	$t =~ s/\(.*?\)//sg;
	$t =~ s/\&lt;/</sg; $t =~ s/\&gt;/>/sg; $t =~ s/\&amp;/&/sg; $t =~ s/\&quot;/"/sg;
	$t =~ s/<ref.*?<\/ref>//sg;
	$t =~ s/^\W*//s;
	$t =~ s/\W*$//s;
	$t =~ s/\s+/ /sg;
	return $t;
}

sub add_code
{
	my($code, $wp, $descr, $country) = @_;
	$descr .= " ($country)" if $country;
	print "$code|$wp|$descr\n";
}





