use strict;
use warnings;
use Test::More;

use DMM::Ranking::Product;

subtest 'constructor' => sub {
    my $daily_dvd = DMM::Ranking::Product->new(type => 'daily', media => 'dvd');
    ok $daily_dvd, 'daily dvd instance';
    isa_ok $daily_dvd, 'DMM::Ranking::Product';

    my $daily_download = DMM::Ranking::Product->new(type => 'daily', media => 'download');
    ok $daily_download, 'daily download instance';
};

subtest 'daily dvd ranking' => sub {
    my $daily_dvd = DMM::Ranking::Product->new(type => 'daily', media => 'dvd');
    my @products = $daily_dvd->ranking(50, 70);
    is scalar @products,  21, 'number of products';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

subtest 'daily download ranking' => sub {
    my $daily_download = DMM::Ranking::Product->new(type => 'daily', media => 'download');
    my @products = $daily_download->ranking();
    is scalar @products,  20, 'number of products(limit is 20)';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

done_testing;
