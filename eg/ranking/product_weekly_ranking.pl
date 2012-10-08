#!perl
use strict;
use warnings;

use lib "../../lib";
use DMM::Ranking::Product;

binmode STDOUT, ":utf8";

my $dvd_weekly_ranking = DMM::Ranking::Product->new(media => 'dvd', type => 'weekly');
my $download_weekly_ranking = DMM::Ranking::Product->new(media => 'download', type => 'weekly');

my @dvd_products = $dvd_weekly_ranking->ranking(55, 64);
print_products('[Weekly DVD Ranking]', @dvd_products);

my @download_products = $download_weekly_ranking->ranking(81, 90);
print_products('[Weekly Download Ranking]', @download_products);

sub print_products {
    my ($title, @products) = @_;

    print "$title\n";

    my $rank = 1;
    for my $product (@products) {
        printf "[%2d] %s\n", $rank++, $product->title;
    }

    print "\n";
}
