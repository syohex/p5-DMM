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

subtest 'invalid constructor' => sub {
    eval {
        DMM::Ranking::Product->new();
    };
    like $@, qr/missing mandatory parameter 'type'/, 'not specified type media parameter';

    eval {
        DMM::Ranking::Product->new(type => 'daily');
    };
    like $@, qr/missing mandatory parameter 'media'/, 'not specified media parameter';

    eval {
        DMM::Ranking::Product->new(type => 'daily', media => 'dummy');
    };
    like $@, qr/Invalid media/, 'invalid media parameter';

    eval {
        DMM::Ranking::Product->new(type => 'dummy', media => 'dvd');
    };
    like $@, qr/Invalid type/, 'invalid type parameter';
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

subtest 'weekly dvd ranking' => sub {
    my $weekly_dvd = DMM::Ranking::Product->new(type => 'weekly', media => 'dvd');
    my @products = $weekly_dvd->ranking(50, 70);
    is scalar @products,  21, 'number of products';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

subtest 'weekly download ranking' => sub {
    my $weekly_download = DMM::Ranking::Product->new(type => 'weekly', media => 'download');
    my @products = $weekly_download->ranking(10, 20);
    is scalar @products,  11, 'number of products';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

subtest 'monthly dvd ranking' => sub {
    my $monthly_dvd = DMM::Ranking::Product->new(type => 'monthly', media => 'dvd');
    my @products = $monthly_dvd->ranking(50, 70);
    is scalar @products,  21, 'number of products';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

subtest 'monthly download ranking' => sub {
    my $monthly_download = DMM::Ranking::Product->new(type => 'monthly', media => 'download');
    my @products = $monthly_download->ranking(10, 20);
    is scalar @products,  11, 'number of products';
    is ref $products[0], 'DMM::Product', 'class of products returned';
};

done_testing;
