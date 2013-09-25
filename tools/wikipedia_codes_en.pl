#!/usr/bin/perl -w
#
# (c) vir
#
# Last modified: 2013-09-25 15:47:07 +0400
#

use strict;
use warnings FATAL => 'uninitialized';
use FindBin;
use lib "$FindBin::Bin";
use WikipediaHelper;

binmode STDOUT, ':utf8';

my $wp = new WikipediaHelper('en');
my $t = $wp->fetch_article_text('List_of_country_calling_codes');
$t =~ s#^.*==Ordered by code==##s;
$t =~ s#\s==[\w\s]+==\s.*$##s;
foreach(split /\n/s, $t) {
	s/\s*$//s;
	s/\'\'\'//sg;
	s/\'\'//sg;
	if(/^\s*\*+\[\[([^\|\]]+)\|([^\]]+)\]\](.*)/) {
		add_code(strip_spaces($2), $1, strip_format($3));
#	} elsif(/^\s*\*+\[\[([^\]+)\]\] \&amp;ndash; {{flag\|([\w\s]+)}}\s*$/) {
#		add_code(strip_spaces($1), $1, strip_format($2));
	} elsif(/^\s*\*+\[\[([^\]]+)\]\] \&amp;ndash; {{flag\|([^}]+)}}(.*)/) {
		add_code(strip_spaces($1), $1, strip_format($2.$3));
	} elsif(/^\s*\*+\[\[([^\]]+)\]\] \&amp;ndash; (.*)/) {
		add_code(strip_spaces($1), $1, strip_format($2));
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
	my($code, $wp, $descr) = @_;
	if($code =~ /^(.*?)\//s) {
		my $c = $1;
		my $len = length($c);
		add_code($c, $wp, $descr);
		$code =~ s#^[^/]*##;
		while($code =~ s#^/([^/]+)##s) {
			add_code(substr($c, 0, $len - length($1)).$1, $wp, $descr);
		}
		return;
	}
	print "$code|$wp|$descr\n";
}





