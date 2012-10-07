use strict;
use warnings;
use Test::More;

use DMM::Ranking::Actress;

subtest 'constructor' => sub {
    my $dvd_ranking = DMM::Ranking::Actress->new('dvd');
    ok $dvd_ranking, 'DVD ranking constructor';
    isa_ok $dvd_ranking, 'DMM::Ranking::Actress';

    my $download_ranking = DMM::Ranking::Actress->new('dvd');
    ok $download_ranking, 'Download ranking constructor';
};

subtest 'dvd ranking' => sub {
    my $dvd_ranking = DMM::Ranking::Actress->new('dvd');
    can_ok $dvd_ranking, 'ranking';

    my @actresses = $dvd_ranking->ranking(41, 60);
    is scalar @actresses, 20, 'actress length';
    isa_ok $actresses[0], 'DMM::Actress';
};

subtest 'download ranking' => sub {
    my $download_ranking = DMM::Ranking::Actress->new('download');

    my @actresses = $download_ranking->ranking(31, 50);
    is scalar @actresses, 20, 'actress length';
    isa_ok $actresses[0], 'DMM::Actress';
};

done_testing;
