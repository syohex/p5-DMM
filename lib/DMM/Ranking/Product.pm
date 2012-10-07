package DMM::Ranking::Product;
use strict;
use warnings;

use 5.010;
use parent qw/DMM::Ranking/;

use Carp;
use Web::Scraper;

use DMM::Product;

sub new {
    my ($class, %args) = @_;

    for my $key (qw/type media/) {
        unless (exists $args{$key}) {
            Carp::croak("missing mandatory parameter '$key'");
        }
    }

    my $media = delete $args{media};
    unless ($media ~~ [qw/dvd download/]) {
        Carp::croak("Invalid media '$media'");
    }

    my $type = delete $args{type};
    unless ($type ~~ [qw/daily weekly monthly/]) {
        Carp::croak("Invalid type '$type'");
    }

    bless {
        media => $media,
        type  => $type,
    }, $class;
}

my %ranking_scraper = (
    dvd => {
        daily => scraper {
            process "table.mg-b20 > tr > td", "ranks[]" => scraper {
                process "div.data > p > a", href => '@href', name => 'TEXT';
            };
        },
    },
);
$ranking_scraper{download}->{daily} = $ranking_scraper{dvd}->{daily};

sub ranking {
    my ($self, $min, $max) = @_;

    if ($self->{type} eq 'daily' && $self->{media} eq 'download') {
        $min = 1;
        $max = 20;
    }

    unless ($min >= 1) {
        Carp::croak("'min' should be greater than equal '1'");
    }

    unless ($max <= 100) {
        Carp::croak("'max' should be less than equal '100'");
    }

    if ($min > $max) {
        Carp::croak("'min' should be greater than 'max'");
    }

    # XXX Weekly, Monthly genre ranking, is this stable ??

    my $scraper = $ranking_scraper{ $self->{media} }->{ $self->{type} };

    my @products;
    for my $url ( $self->_ranking_url($min, $max) ) {
        my $res = $scraper->scrape( URI->new($url) );

        for my $rank (@{$res->{ranks}}) {
            push @products, DMM::Product->new(
                link  => $rank->{href},
                title => $rank->{name},
            );
        }
    }

    unless (@products) {
        Carp::croak("Can't get any product information");
    }

    return @products[0..($max-$min)];
}

my %url_ = (
    daily_sale => \&_daily_sale_url,
    weekly_sale => \&_weekly_sale_url,
);

sub _ranking_url {
    my ($self, $min, $max) = @_;

    my ($min_page, $max_page) = map { ($_ - 1) / 20 } ($min, $max);

    my @urls;
    given ($self->{type}) {
        when ('daily') {
            @urls = $self->_daily_sale_url;
        }
        when ('weekly') {
        }
        when ('monthly') {
        }
    }

    return @urls[$min_page..$max_page];
}

sub _daily_sale_url {
    my $self = shift;
    my $media = $self->{media};

    my $base = +{
        dvd      => 'http://www.dmm.co.jp/mono/dvd/-/ranking/=/term=daily/rank=%s/',
        download => 'http://www.dmm.co.jp/digital/videoa/-/ranking_all/=/term=daily/',
    }->{ $media };

    # DMM provides download daily ranking only 1 page
    return $base if $media eq 'download';

    my $page_units = +{
        dvd => [qw/1_20 21_40 41_60 61_80 81_100/],
    }->{$media};

    return map { sprintf $base, $_ } @{$page_units};
}

sub _weekly_sale_url {
    my $media = shift;

}

1;

__END__
