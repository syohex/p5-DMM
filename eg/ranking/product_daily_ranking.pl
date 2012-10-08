#!perl
use strict;
use warnings;

use lib "../../lib";
use DMM::Ranking::Product;

binmode STDOUT, ":utf8";

my $dvd_daily_ranking = DMM::Ranking::Product->new(media => 'dvd', type => 'daily');
my $download_daily_ranking = DMM::Ranking::Product->new(media => 'download', type => 'daily');

my @dvd_products = $dvd_daily_ranking->ranking(41, 60);
print_products('[Daily DVD Ranking]', @dvd_products);

my @download_products = $download_daily_ranking->ranking(1, 20);
print_products('[Daily Download Ranking]', @download_products);

sub print_products {
    my ($title, @products) = @_;

    print "$title\n";

    my $rank = 1;
    for my $product (@products) {
        printf "[%2d] %s\n", $rank++, $product->title;
    }
}
