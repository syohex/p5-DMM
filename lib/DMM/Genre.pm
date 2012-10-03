package DMM::Genre;
use strict;
use warnings;

use 5.010;

use Carp ();
use URI;
use Web::Scraper;

use Class::Accessor::Lite (
    rw => [qw/id name/],
);

sub new {
    my ($class, %args) = @_;

    for my $key (qw/id name/) {
        unless (exists $args{$key}) {
            Carp::croak("missing mandatory parameter '$key'");
        }
    }

    bless {
        %args,
    }, $class;
}

sub collect_all_genres {
    my ($class, $media) = @_;

    if (ref $class) {
        Carp::croak("'collect_all_genere' is class method" );
    }

    unless (defined $media) {
        Carp::croak("Undefined 'media' parameter");
    }

    my $m = lc $media;
    unless ($m eq 'dvd' || $m eq 'download') {
        Carp::croak("Invalid media type '$media'");
    }

    my $url = +{
        dvd      => 'http://www.dmm.co.jp/mono/dvd/-/genre/',
        download => 'http://www.dmm.co.jp/digital/videoa/-/genre/',
    }->{$m};

    my $genre = scraper {
        process 'div.sect01 > table > tr > td', 'genres[]' => scraper {
            process 'a', 'name' => 'TEXT', 'href' => '@href';
        };
    };

    my $res = $genre->scrape( URI->new($url) );

    my @genres;
    for my $g ( @{$res->{genres}} ) {
        next unless $g->{href};

        my $id = do {
            $g->{href} =~ m{id=(\d+)};
            $1
        };

        push @genres, DMM::Genre->new(
            id   => $id,
            name => $g->{name},
        );
    }

    return @genres;
}

1;

__END__
