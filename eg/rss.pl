#!perl
use strict;
use warnings;

use lib "../lib";
use DMM::RSS;

binmode STDOUT, ":utf8";

my $url = 'http://www.dmm.co.jp/mono/dvd/-/list/=/article=actress/id=1007947/sort=date/rss=create/';
my $rss = DMM::RSS->new($url);

my @products = $rss->parse;
for my $product (@products) {
    printf "Title: %s\n", $product->title;
}
