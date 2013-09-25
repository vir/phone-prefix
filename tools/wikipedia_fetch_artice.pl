#!/usr/bin/perl -w
#
# (c) vir
#
# Last modified: 2013-09-25 12:51:49 +0400
#

use strict;
use warnings FATAL => 'uninitialized';
use FindBin;
use lib "$FindBin::Bin";
use WikipediaHelper;

my $site = 'en';
$site = shift @ARGV if @ARGV > 1 && $ARGV[0] =~ /^[a-z]{2}$/;

my $wp = new WikipediaHelper($site);
#print $wp->fetch_article_text('List_of_country_calling_codes');
die "Usage: $0 [site] PageName\n" unless @ARGV;
print $wp->fetch_article_text($ARGV[0]);





