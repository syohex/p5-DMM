package DMM::Monthly;
use strict;
use warnings;

use 5.010;

use parent qw/Exporter/;
use Carp ();

our @EXPORT_OK = qw/channels all_rss_url rss_url/;

my @channels = qw/
    playgirl avstation dream s1 moodyz sod prestige kmp
    momotaroubb alice crystal hmp waap jukujo mania
    paradisetv shirouto nikkatsu animech
/;

sub channels {
    @channels;
}

sub all_rss_url {
    map { _rss_url($_) } @channels;
}

sub rss_url {
    my $channel = shift;

    unless (defined $channel) {
        Carp::croak("'channel' argument is not defined");
    }

    unless ($channel ~~ @channels) {
        Carp::croak("Invalid channel '$channel'");
    }

    _rss_url($channel);
}

sub _rss_url {
    my $channel = shift;

    if ($channel eq 'dream') {
        return "http://www.dmm.co.jp/monthly/dream/-/list/=/shop=downloadtv/sort=date/rss=create/";
    } else {
        return sprintf "http://www.dmm.co.jp/monthly/%s/-/list/=/rss=create/sort=date/", $channel;
    }
}

1;

__END__
