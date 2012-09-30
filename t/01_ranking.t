use strict;
use warnings;
use Test::More;

use DMM::Ranking;

use 5.010;

sub is_contained {
    my ($array_ref, $elem) = @_;
    return $elem ~~ $array_ref;
}

subtest 'constructor' => sub {
    my $ranking = DMM::Ranking->new('dvd');
    ok $ranking, 'constructor';
    isa_ok $ranking, 'DMM::Ranking';
};

subtest 'invalid constructor' => sub {
    eval {
        DMM::Ranking->new('invalid');
    };
    like $@, qr/should be 'dvd' or 'download'/, 'invalid constructor parameter';
};

subtest 'dvd actress ranking urls' => sub {
    my $dvd_ranking = DMM::Ranking->new('dvd');

    my @urls = $dvd_ranking->_actress_ranking_url(1, 100);
    my $expected = 'http://www.dmm.co.jp/mono/dvd/-/ranking/=/term=monthly/mode=actress/rank=1_20/';
    ok is_contained(\@urls, $expected), 'dvd ranking url';
};

subtest 'download actress ranking urls' => sub {
    my $download_ranking = DMM::Ranking->new('download');

    my @urls = $download_ranking->_actress_ranking_url(1, 100);
    my $expected = 'http://www.dmm.co.jp/digital/videoa/-/ranking_all/=/type=actress/page=1/';
    ok is_contained(\@urls, $expected), 'download ranking url';
};

subtest 'specified min and max' => sub {
    my $ranking = DMM::Ranking->new('dvd');

    my @urls = $ranking->_actress_ranking_url(1, 1);
    is( (scalar @urls), 1, 'min and max is same' );

    @urls = $ranking->_actress_ranking_url(1, 20);
    is( (scalar @urls), 1, '1 page' );

    @urls = $ranking->_actress_ranking_url(1, 21);
    is( (scalar @urls), 2, '2 page(1)' );

    @urls = $ranking->_actress_ranking_url(40, 41);
    is( (scalar @urls), 2, '2 page(2)' );

    like $urls[0], qr/21_40/, 'page of 2';
    like $urls[1], qr/41_60/, 'page of 3';
};

subtest 'invalid actress ranking url' => sub {
    my $ranking = DMM::Ranking->new('dvd');

    eval {
        $ranking->actress_ranking(0, 100);
    };
    like $@, qr/'min' should be greater than/, 'invalid min parameter';

    eval {
        $ranking->actress_ranking(1, 101);
    };
    like $@, qr/'max' should be less than/, 'invalid max parameter';

    eval {
        $ranking->actress_ranking(50, 49);
    };
    like $@, qr/'min' should be greater than 'max'/, 'min > max';

};

subtest 'actress ranking and return DMM::Actress objects' => sub {
    my $ranking = DMM::Ranking->new('dvd');
    my @actresses = $ranking->actress_ranking(41, 60);

    is scalar @actresses, 20, 'number of objects returned';
    isa_ok $actresses[0], 'DMM::Actress';
};

done_testing;
