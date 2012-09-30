use strict;
use warnings;
use Test::More;

use DMM::Product;
use utf8;

subtest 'constructor' => sub {
    my $product = DMM::Product->new( link => 'id=10' );
    ok $product, 'constructor';
    isa_ok $product, 'DMM::Product';
};

subtest 'accessor' => sub {
    my %params = (
        title        => 'title',
        link         => '/id=1000/',
        image        => 'a.jpg',
        package      => 'b.jpg',
        description  => 'too sexy',
        id           => '10',
        release_date => '2012/09/10',
        minutes      => '200',
        actresses    => [qw/actressA actressB/],
        director     => 'dirA',
        series       => 'a',
        maker        => 'makerA',
        label        => 'labelA',
        genre        => [qw/genreA genreB/],
    );

    my $product = DMM::Product->new(%params);
    for my $key ( keys %params ) {
        is $product->$key, $params{$key}, "accessor '$key'";
    }
};

subtest 'collect from id' => sub {
    diag("'Infomation of http://www.dmm.co.jp/mono/dvd/-/detail/=/cid=53dv1434/'");
    my $product = DMM::Product->create_from_id(id => '53dv1434', media => 'dvd');

    is $product->title, '新人×アリスJAPAN 巨乳美白パーフェクトボディ 知花メイサ', 'title is set';
    is $product->minutes, 120, 'minutes is set';
    ok $product->link, 'link is set';
    ok $product->description, 'description is set';
};

done_testing;
