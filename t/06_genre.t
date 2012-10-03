use strict;
use warnings;
use Test::More;

use utf8;
use DMM::Genre;

subtest 'constructor' => sub {
    my $genre = DMM::Genre->new( id => 100, name => 'test' );
    ok $genre, 'constructor';
    isa_ok $genre, 'DMM::Genre';
};

subtest 'accessor' => sub {
    my $genre = DMM::Genre->new( id => 200, name => 'test' );
    is $genre->id, 200, "'id' accessor";
    is $genre->name, 'test', "'test' accessor";
};

subtest 'invalid constructor' => sub {
    eval {
        DMM::Genre->new();
    };
    like $@, qr/missing mandatory parameter 'id'/;

    eval {
        DMM::Genre->new(id => 1);
    };
    like $@, qr/missing mandatory parameter 'name'/;
};

subtest 'Collect all genres' => sub {
    my @genres = DMM::Genre->collect_all_genres('dvd');
    my %name = map { $_->name => 1 } @genres;
    ok exists $name{'デビュー作品'}, 'collect genre';
};

subtest 'invalid collect_all_genres' => sub {
    eval {
        my $genre = DMM::Genre->new(id=>1, name=>10);
        $genre->collect_all_genres('dvd');
    };
    like $@, qr/is class method/, 'call as instance method';

    eval {
        DMM::Genre->collect_all_genres();
    };
    like $@, qr/Undefined 'media' parameter/, 'media parameter is undef';

    eval {
        DMM::Genre->collect_all_genres(genre => 'unknown');
    };
    like $@, qr/Invalid media type/, 'invalid media parameter';
};

done_testing;
