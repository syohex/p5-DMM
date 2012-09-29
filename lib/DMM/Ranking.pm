package DMM::Ranking;
use strict;
use warnings;

use 5.010;

use Carp ();
use Web::Scraper;
use URI;

sub new {
    my ($class, $media) = @_;

    unless ($media ~~ ["dvd", "download"]) {
        Carp::croak("'media' parameter should be 'dvd' or 'download'");
    }

    bless {
        media => $media,
    }, $class;
}

my %scraper = (
    dvd => scraper {
        process "table.mg-b20 > tr > td", "ranks[]" => scraper {
            process "div.data > p > a", href => '@href', name => 'TEXT';
        },
    },
);

# Now download HTML structure is similar to DVD one
$scraper{download} = $scraper{dvd};

sub actress_ranking {
    my ($self, $min, $max) = @_;

    unless ($min >= 1) {
        Carp::croak("'min' should be greater than equal '1'");
    }

    unless ($max <= 100) {
        Carp::croak("'max' should be less than equal '100'");
    }

    if ($min > $max) {
        Carp::croak("'min' should be greater than 'max'");
    }

    $min //= 1;
    $max //= 100;

    my $scraper = $scraper{ $self->{media} };
    for my $url ( $self->_actress_ranking_url($min, $max) ) {
        my $res = $scraper->scrape( URI->new($url) );

        for my $rank (@{$res->{ranks}}) {
            my ($id) = $rank->{href} =~ m{id=(\d+)}g;
        }
    }
}

sub _actress_ranking_url {
    my ($self, $min, $max) = @_;
    my $base = 'http://www.dmm.co.jp';

    my ($min_page, $max_page) = map { ($_ - 1) / 20 } ($min, $max);

    my @urls;
    given ($self->{media}) {
        when ('dvd') {
            my $format = "${base}/mono/dvd/-/ranking/=/term=monthly/mode=actress/rank=%s/";
            push @urls, map {
                sprintf $format, $_;
            } qw/1_20 21_40 41_60 61_80 81_100/;
        }
        when ('download') {
            my $format = "${base}/digital/videoa/-/ranking_all/=/type=actress/page=%d/";
            push @urls, map {
                sprintf $format, $_;
            } 1..5;
        }
    }

    return @urls[$min_page..$max_page];
}

1;

__END__
