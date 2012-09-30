use strict;
use warnings;
use Test::More;

use DMM::RSS;

subtest 'constructor' => sub {
    my $rss = DMM::RSS->new('url');
    ok $rss, 'constructor';
    isa_ok $rss, 'DMM::RSS';
};

subtest 'parse rss' => sub {
    my $url = 'http://www.dmm.co.jp/mono/dvd/-/list/=/article=actress/id=1007947/sort=date/rss=create/';
    my $rss = DMM::RSS->new($url);
    can_ok $rss, 'parse';

    my ($product) = $rss->parse;
    ok $product, 'parse and extract product information';
    isa_ok $product, 'DMM::Product';

    ok $product->title, 'product title';
    ok $product->link,  'product link';
    ok $product->package, 'product package';
    ok $product->description, 'product description',
};

done_testing;
