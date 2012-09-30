package DMM::Actress;
use strict;
use warnings;

use 5.010;
use Carp ();
use URI;
use Web::Scraper;
use utf8;

use Class::Accessor::Lite (
    rw => [ qw/name aliases id birthday bloodtype hometown sign size interest/ ],
);

sub new {
    my ($class, %args) = @_;

    bless {
        %args,
    }, $class;
}

sub rss_url {
    my ($self, $media) = @_;

    unless (defined $media) {
        Carp::croak("Please specified media type: 'dvd' or 'download'");
    }

    unless ($media ~~ ['dvd', 'download']) {
        Carp::croak("Invalid media: $media(should be 'dvd' or 'download')");
    }

    sprintf _rss_url_format($media), $self->{id};
}

sub _rss_url_format {
    my $media = shift;

    my $base = 'http://www.dmm.co.jp';
    my $body = +{
        dvd      => '/mono/dvd/-/list/=/article=actress/id=%d/sort=date/rss=create/',
        download => '/digital/videoa/-/list/=/article=actress/id=%d/rss=create/sort=date/',
    }->{$media};

    return $base . $body;
}

my %profile_table = (
    '生年月日' => 'birthday',
    '血液型'   => 'bloodtype',
    '星座'     => 'sign',
    '出身地'   => 'hometown',
    'サイズ'   => 'size',
    '趣味'     => 'interest',
);

sub collect_profile {
    my $self = shift;

    return if exists $self->{birthday};

    my $url = $self->_info_url;

    my $profile = scraper {
        process 'tr.area-av30 table td', 'items[]' => 'TEXT';
    };

    my $res = $profile->scrape( URI->new($url) );

    my @items = @{$res->{items}};
    while (my ($key, $value) = splice @items, 0, 2) {
        $value = undef if $value =~ m/----/;

        while (my ($jp, $en) = each %profile_table) {
            if ($key =~ m{$jp}) {
                $self->{$en} = $value;
            }
        }
    }
}

sub _info_url {
    my $self = shift;
    sprintf 'http://actress.dmm.co.jp/-/detail/=/actress_id=%d/', $self->{id};
}

1;

__END__
