#!perl
use strict;
use warnings;

use lib "../lib";
use DMM::Ranking;

binmode STDOUT, ":utf8";

my $dvd_ranking = DMM::Ranking->new('dvd');
my $download_ranking = DMM::Ranking->new('download');

my @actresses;
@actresses = $dvd_ranking->actress_ranking(41, 60);

my $rank = 11;
for my $actress (@actresses) {
    printf "[%2d] %s", $rank++, $actress->name;
    if (@{$actress->aliases}) {
        my @aliases = @{ $actress->aliases };
        print "(@aliases)";
    }

    print "\n";
}
