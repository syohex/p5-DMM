package DMM::Ranking::Actress;
use strict;
use warnings;

use 5.010;

use parent qw/DMM::Ranking/;

use Carp ();
use Web::Scraper;
use URI;
use DMM::Actress;
use DMM::Util qw/separate_name/;

sub new {
    my ($class, $media) = @_;

    unless ($media ~~ ["dvd", "download"]) {
        Carp::croak("'media' parameter should be 'dvd' or 'download'");
    }

    bless {
        media => $media,
    }, $class;
}

my %ranking_scraper = (
    dvd => scraper {
        process "table.mg-b20 > tr > td", "ranks[]" => scraper {
            process "div.data > p > a", href => '@href', name => 'TEXT';
        };
    },
);

# Now download HTML structure is similar to DVD one
$ranking_scraper{download} = $ranking_scraper{dvd};

sub ranking {
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

    my $scraper = $ranking_scraper{ $self->{media} };

    my @actresses;
    for my $url ( $self->_ranking_url($min, $max) ) {
        my $res = $scraper->scrape( URI->new($url) );

        for my $rank (@{$res->{ranks}}) {
            my ($id) = $rank->{href} =~ m{id=(\d+)}g;
            my ($name, $aliases_ref) = separate_name($rank->{name});

            $aliases_ref //= [];

            push @actresses, DMM::Actress->new(
                name    => $name,
                aliases => $aliases_ref,
                id      => $rank->{id},
            );
        }
    }

    unless (@actresses) {
        Carp::croak("Can't get any actress information");
    }

    return @actresses[0..($max - $min)];
}

sub _ranking_url {
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

=encoding utf-8

=for stopwords

=head1 NAME

DMM::Ranking::Actress - DMM acttress ranking module

=head1 SYNOPSIS

=head1 DESCRIPTION

DMM::Ranking::Actress is ranking module.
You can get actress ranking or product ranking.

=head1 INTERFACES

=head2 Class Methods

=head3 C<< DMM::Ranking::Actress->new($media) >>

Create and return a new DMM::Ranking::Actress instance.
C<$media> parameter should be 'dvd' or 'download'.

=head2 Instance method

=head3 C<< $ranking->ranking($min=1, $max=100)  >>

Get actresses ranked from C<$min> to C<$max>(C<$max> should be greater than C<$min>).
Each object returned is-a DMM::Actress.

=head1 AUTHOR

Syohei YOSHIDA E<lt>syohex@gmail.comE<gt>

=head1 COPYRIGHT

Copyright 2012 - Syohei YOSHIDA

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
