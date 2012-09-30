#!perl
use strict;
use warnings;

use lib "../lib";
use DMM::Ranking;

binmode STDOUT, ":utf8";

my $dvd_ranking = DMM::Ranking->new('dvd');
my $download_ranking = DMM::Ranking->new('download');

my @actresses;
my ($min, $max) = (41, 60);
@actresses = $dvd_ranking->actress_ranking($min, $max);

my $rank = $min;
for my $actress (@actresses) {
    printf "[%2d] %s", $rank++, $actress->name;
    if (@{$actress->aliases}) {
        my @aliases = @{ $actress->aliases };
        print "(@aliases)";
    }

    print "\n";
}
