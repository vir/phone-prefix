#!/usr/bin/perl -w
#
# (c) vir
#
# Last modified: 2015-07-06 09:52:26 +0300
#

use utf8;
use strict;
use warnings FATAL => 'uninitialized';
use FindBin;

chdir $FindBin::Bin;
binmode STDOUT, ':utf8';

die unless -d 'tmp';
my @data;

foreach my $f(glob "tmp/*.txt") {
	open F, '<:utf8', $f or die;
	my @lines;
	while(<F>) {
		s/^\s+//s;
		s/\s+$//s;
		s/\&deg;/\x{00B0}/g;
		push @lines, $_;
	}
	close F;
	my %row = @lines;
	($row{id}) = $f =~ /(\d+)/;
	push @data, \%row;
}

my @fields = (
	'id',
	'Населенный пункт:',
	'Регион:',
	'Временная разница с московским временем:',
	'Часовой пояс:',
	'Широта:',
	'Долгота:',
);
foreach my $row(@data) {
	my $sep = '';
	foreach my $key(@fields) {
		if($row->{$key} =~ /^GMT\s*([+-])\s*(\d+)/) {
			print qq{$sep$1$2};
		} elsif($row->{$key} =~ /^(.*\x{00B0}.*?)\s+\(([-+\.\d]+)\)$/) {
			print qq{$sep"$1",$2};
		} elsif($row->{$key} =~ /^\d+$/) {
			print qq{$sep$row->{$key}};
		} else {
			print qq{$sep"$row->{$key}"};
		}
		$sep = ',';
	}
	print "\n";
}

