#!perl
use strict;
use warnings;

use lib "../lib";
use DMM::Ranking::Actress;

binmode STDOUT, ":utf8";

my $dvd_ranking = DMM::Ranking::Actress->new('dvd');

my @actresses;
my ($min, $max) = (41, 60);
@actresses = $dvd_ranking->ranking($min, $max);

my $rank = $min;
for my $actress (@actresses) {
    printf "[%2d] %s", $rank++, $actress->name;
    if (@{$actress->aliases}) {
        my @aliases = @{ $actress->aliases };
        print "(@aliases)";
    }

    print "\n";
}
