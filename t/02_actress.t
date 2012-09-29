use strict;
use warnings;
use Test::More;

use DMM::Actress;
use utf8;

binmode STDOUT, ':utf8';
binmode STDERR, ':utf8';

subtest 'constructor' => sub {
    my $actress = DMM::Actress->new;
    ok $actress, 'constructor';
    isa_ok $actress, 'DMM::Actress';
};

subtest 'accessor' => sub {
    my %param = (
        name      => 'test_name',
        id        => '1000',
        birthday  => '2012/07/10',
        bloodtype => 'O',
        sign      => 'cancer',
        hometown  => 'Aomori',
        interest  => 'fishing',
    );

    my $actress = DMM::Actress->new(%param);

    for my $key (keys %param) {
        is $actress->$key, $param{$key}, "'$key' accessor";
    }
};

subtest 'RSS URL' => sub {
    my $actress = DMM::Actress->new(
        id => '1000',
    );

    can_ok $actress, 'rss_url';

    my $rss_url = $actress->rss_url('dvd');
    my $expected = 'http://www.dmm.co.jp/mono/dvd/-/list/=/article=actress/id=1000/sort=date/rss=create/';
    is $rss_url, $expected, 'DVD RSS URL';

    $rss_url = $actress->rss_url('download');
    $expected = 'http://www.dmm.co.jp/digital/videoa/-/list/=/article=actress/id=1000/rss=create/sort=date/';
    is $rss_url, $expected, 'Download RSS URL';
};

subtest 'invalid RSS URL' => sub {
    my $actress = DMM::Actress->new;
    eval {
        $actress->rss_url;
    };
    like $@, qr/Please specified media type/, 'undef media parameter';

    eval {
        $actress->rss_url('unknown');
    };
    like $@, qr/Invalid media: unknown/, 'invalid media parameter';
};

subtest 'Collect actress profile' => sub {
    my $actress = DMM::Actress->new( id => 1010133 ); # Haruki Satou

    can_ok $actress, 'collect_profile';
    $actress->collect_profile;

    is $actress->birthday, '1991年12月1日', 'birthday';
    ok !(defined $actress->bloodtype), 'bloodtype';
    is $actress->sign, 'いて座', 'sign';
    ok !(defined $actress->hometown), 'hometown';
    is $actress->interest, 'カラオケ、お菓子作り', 'interest';
};

done_testing;
