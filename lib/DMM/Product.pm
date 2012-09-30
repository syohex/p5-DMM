package DMM::Product;
use strict;
use warnings;

use Carp ();
use DateTime;
use utf8;
use LWP::UserAgent;
use Web::Scraper;

use Class::Accessor::Lite (
    ro => [qw/title link image package description id
              release_date minutes actresses director series maker label genre/],
);

my $_ua = LWP::UserAgent->new;

sub new {
    my ($class, %args) = @_;

    for my $key (qw/link/) {
        unless (exists $args{$key}) {
            Carp::croak("missing mandatory parameter '$key'");
        }
    }

    my $id = do {
        if ($args{link} =~ m{id=(\d+)}) {
            $1;
        } else {
            Carp::croak("Invalid link: link should have 'id' parameter");
        }
    };

    bless {
        id => $id,
        %args,
    }, $class;
}

sub create_from_id {
    my ($class, %args) = @_;

    for my $key (qw/id media/) {
        unless (exists $args{$key}) {
            Carp::croak("missing mandatory parameter '$key'");
        }
    }

    my $self = bless { id => $args{id} }, $class;
    $self->set_information($args{media});
    $self
}

sub set_information {
    my ($self, $media) = @_;

    if ($media eq 'dvd') {
        $self->_parse_dvd;
    }
}

sub _product_url {
    my ($self, $media) = @_;

    my %format = (
        dvd => 'http://www.dmm.co.jp/mono/dvd/-/detail/=/cid=%s/',
    );

    sprintf $format{$media}, $self->{id};
}

sub _get_content_ref {
    my $url = shift;

    my $res = $_ua->get($url);
    unless ($res->is_success) {
        Carp::croak("Can't download '$url'");
    }

    return \$res->decoded_content;
}

sub _parse_dvd {
    my $self = shift;

    my $url = $self->{link} || $self->_product_url('dvd');
    my $content_ref = _get_content_ref($url);

    my @info;
    while ($$content_ref =~ m{<td \s width="100%">(.+?)</td>}gxms) {
        push @info, $1;
    }

    my $product_info = scraper {
        process q{//meta[contains(@property, 'og:title')}, title => '@content';
        process q{//meta[contains(@property, 'og:url')},   link  => '@content';
        process q{//meta[contains(@property, 'og:image')}, image => '@content';
        process q{//meta[contains(@property, 'og:description')}, description => '@content';
    };

    my $res = $product_info->scrape( $$content_ref );
    $self->{title} = $res->{title};
    $self->{link}  = $res->{link};
    $self->{image} = $res->{image};

    (my $package = $res->{image}) =~ s{ps\.jpg}{pl\.jpg};
    $self->{package} = $package;
    $self->{description} = $res->{description};

    $self->{release_date} = _parse_date($info[0]);
    $self->{minutes}      = _parse_minutes($info[1]);
    $self->{actresses}    = _extract_a_tag($info[2]);
    $self->{director}     = _extract_a_tag($info[3]);
    $self->{series}       = _extract_a_tag($info[4]);
    $self->{maker}        = _extract_a_tag($info[5]);
    $self->{label}        = _extract_a_tag($info[6]);
    $self->{genre}        = _extract_a_tag($info[7]);
}

sub _parse_date {
    my $date_str = shift;

    my ($year, $month, $day) = split /\//, $date_str;
    $month =~ s{^0}{};

    DateTime->new( year => $year, month => $month, day => $day);
}

sub _parse_minutes {
    my $minutes_str = shift;

    $minutes_str =~ s{分$}{};
    $minutes_str;
}

sub _extract_a_tag {
    my $str = shift;

    my @texts;
    while ($str =~ m{<a[^>]+>([^<]+)</a>}gxms) {
        push @texts, $1;
    }

    if (scalar @texts == 0 && $str =~ m{----}) {
        return;
    }

    return (scalar @texts == 1) ? $texts[0] : [ @texts ];
}

1;

__END__
