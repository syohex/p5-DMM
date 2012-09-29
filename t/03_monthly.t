use strict;
use warnings;
use Test::More;

use DMM::Monthly;

subtest 'channels' => sub {
    can_ok('DMM::Monthly', 'channels');

    my @monthly_channels = DMM::Monthly::channels();

    ok(('sod' ~~ @monthly_channels), 'sod channel is contained');
    ok(('moodyz' ~~ @monthly_channels), 'moodyz is contained');
};

subtest 'rss_url' => sub {
    can_ok('DMM::Monthly', 'rss_url');

    my $rss1 = DMM::Monthly::rss_url('kmp');
    my $expected = 'http://www.dmm.co.jp/monthly/kmp/-/list/=/rss=create/sort=date/';
    is $rss1, $expected, 'kmp channel rss url';

    my $rss2 = DMM::Monthly::rss_url('dream');
    $expected = 'http://www.dmm.co.jp/monthly/dream/-/list/=/shop=downloadtv/sort=date/rss=create/';
    is $rss2, $expected, 'dream downloadtv rss url, this is special channel';
};

subtest 'all_rss_url' => sub {
    can_ok('DMM::Monthly', 'all_rss_url');

    my $expected1 = 'http://www.dmm.co.jp/monthly/playgirl/-/list/=/rss=create/sort=date/';
    my $expected2 = 'http://www.dmm.co.jp/monthly/dream/-/list/=/shop=downloadtv/sort=date/rss=create/';
    my @urls = DMM::Monthly::all_rss_url;

    ok(($expected1 ~~ @urls), 'playgirl channel is contained in all rss');
    ok(($expected2 ~~ @urls), 'dream downloadtv channel is contained in all rss');
};

done_testing;
