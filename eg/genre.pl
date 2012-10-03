#!perl
use strict;
use warnings;

use lib "../lib";
use DMM::Genre;

binmode STDOUT, ":utf8";

my @genres = DMM::Genre->collect_all_genres('dvd');
printf "id=%d, name=%s\n", $_->id, $_->name for @genres;
